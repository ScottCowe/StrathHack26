import 'dart:convert';

import 'package:http/http.dart' as http;

/// Talks to the local database proxy started by `run_web.sh`.
class SqlClient {
  SqlClient({this.baseUrl = 'http://127.0.0.1:8081'});

  final String baseUrl;

  Future<List<Map<String, dynamic>>> query(
    String sql, [
    List<Object?> args = const [],
  ]) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'sql': sql, 'args': args}),
    );

    if (response.statusCode != 200) {
      throw StateError(
        'Database proxy returned ${response.statusCode}: ${response.body}',
      );
    }
    if (response.body == 'ok') {
      return const [];
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw StateError('Database proxy returned an unexpected response');
    }
    return [for (final row in decoded) Map<String, dynamic>.from(row as Map)];
  }
}
