import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:strathclean/database/app_database.dart';

/// Local HTTP bridge so the Flutter web build can use Postgres.
/// The browser cannot open port 5432; this process can.
const proxyPort = 8081;

Future<void> main() async {
  final env = _loadEnv(File('.env'));
  final database = AppDatabase(env);
  await database.customSelect('SELECT 1').get();

  final handler = const Pipeline()
      .addMiddleware(_cors())
      .addMiddleware(logRequests())
      .addHandler((request) => _handle(database, request));

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    proxyPort,
  );
  stdout.writeln(
    'Database proxy ready at http://${server.address.host}:${server.port}',
  );
}

Map<String, String> _loadEnv(File file) {
  if (!file.existsSync()) {
    throw StateError('No .env file in ${Directory.current.path}');
  }

  final env = <String, String>{};
  for (final line in file.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      continue;
    }
    final separator = trimmed.indexOf('=');
    if (separator <= 0) {
      continue;
    }
    env[trimmed.substring(0, separator).trim()] = trimmed
        .substring(separator + 1)
        .trim();
  }
  return env;
}

Middleware _cors() {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
  };

  return (Handler inner) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: headers);
      }
      final response = await inner(request);
      return response.change(headers: headers);
    };
  };
}

Future<Response> _handle(AppDatabase database, Request request) async {
  if (request.method == 'GET' && request.url.path == 'health') {
    return Response.ok('ok');
  }
  if (request.method != 'POST') {
    return Response(405, body: 'POST a JSON body {"sql": "...", "args": []}');
  }

  try {
    final payload = jsonDecode(await request.readAsString());
    if (payload is! Map || payload['sql'] is! String) {
      return Response(
        400,
        body: jsonEncode({'error': 'Expected {"sql": "...", "args": []}'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final sql = payload['sql'] as String;
    final args = payload['args'] is List
        ? List<Object?>.from(payload['args'] as List)
        : <Object?>[];

    if (sql.trimLeft().toLowerCase().startsWith('select')) {
      final rows = await database
          .customSelect(
            sql,
            variables: [for (final arg in args) _variable(arg)],
          )
          .get();
      return Response.ok(
        jsonEncode([
          for (final row in rows)
            row.data.map((key, value) => MapEntry(key, _jsonSafe(value))),
        ]),
        headers: {'content-type': 'application/json'},
      );
    }

    await database.customStatement(sql, args);
    return Response.ok('ok');
  } catch (error) {
    return Response.internalServerError(
      body: jsonEncode({'error': error.toString()}),
      headers: {'content-type': 'application/json'},
    );
  }
}

Variable<Object> _variable(Object? value) {
  return switch (value) {
    null => Variable<Object>(null),
    final String text => Variable<String>(text),
    final int number => Variable<int>(number),
    final double number => Variable<double>(number),
    final bool flag => Variable<bool>(flag),
    _ => throw ArgumentError('Unsupported SQL argument (${value.runtimeType})'),
  };
}

Object? _jsonSafe(Object? value) {
  return switch (value) {
    null || num() || String() || bool() => value,
    DateTime date => date.toIso8601String(),
    List<int> bytes => base64Encode(bytes),
    _ => value.toString(),
  };
}
