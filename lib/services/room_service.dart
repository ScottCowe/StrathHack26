import 'package:strathclean/services/sql_client.dart';

class RoomService {
  RoomService(this._sql);

  final SqlClient _sql;

  Future<void> addRoom({required String name, String? notes}) {
    return _sql.query(
      'insert into rooms (name, notes) values (\$1, \$2)',
      [name, notes],
    );
  }
}
