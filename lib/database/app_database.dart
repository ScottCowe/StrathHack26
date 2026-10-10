import 'package:drift/drift.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart' as pg;

part 'app_database.g.dart';

@DriftDatabase(tables: [Users, Rooms, Cleans, Issues])
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
  );

  static QueryExecutor _open() {
    return PgDatabase(
      endpoint: pg.Endpoint(
        host: dotenv.get('DB_HOST'),
        port: 5432,
        database: dotenv.get('DB_NAME'),
        username: dotenv.get('DB_USER'),
        password: dotenv.get('DB_PASSWORD'),
      ),
      settings: const pg.ConnectionSettings(
        sslMode: pg.SslMode.require,
      ),
    );
  }
}

enum UserRole { cleaner, supervisor}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get role => textEnum<UserRole>()();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
}

class Rooms extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get lastCleaned => dateTime().nullable()();
  TextColumn get notes=> text().nullable()();
  TextColumn get kml => text().nullable()();
}

class Cleans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cleanedBy => integer().references(Users, #id)();
  IntColumn get auditedBy => integer().references(Users, #id).nullable()();
  IntColumn get room => integer().references(Rooms, #id)();
  BoolColumn get audited => boolean()();
  DateTimeColumn get auditTime => dateTime().nullable()();
  DateTimeColumn get cleanTime => dateTime()();
}

enum TagName {cleaners, external}
enum Priority {low, medium, high}

class Issues extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cleanId => integer().references(Cleans, #id)();
  BlobColumn get image => blob().nullable()();
  TextColumn get description=> text().nullable()();
  TextColumn get tag => textEnum<TagName>()();
  //needs coords perhaps
  TextColumn get priority => textEnum<Priority>()();
}