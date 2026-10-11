import 'package:strathclean/services/sql_client.dart';

class RoomService {
  RoomService(this._sql);

  final SqlClient _sql;

  Future<List<({String name, String? notes, DateTime? cleanTime})>>
  listRooms() async {
    final rows = await _sql.query(
      'select rooms.name, rooms.notes, max(cleans.clean_time) as clean_time '
      'from rooms '
      'left join cleans on cleans.room = rooms.name '
      'group by rooms.name, rooms.notes '
      'order by rooms.name',
    );
    return [
      for (final row in rows)
        (
          name: row['name'] as String,
          notes: row['notes'] as String?,
          cleanTime: switch (row['clean_time']) {
            final num millis => DateTime.fromMillisecondsSinceEpoch(
                millis.toInt(),
                isUtc: true,
              ).toLocal(),
            _ => null,
          },
        ),
    ];
  }

  Future<void> saveRoom({
    required String name,
    required String newName,
    String? notes,
  }) {
    return _sql.query(
      'update rooms set name = \$1, notes = \$2 where name = \$3',
      [newName, notes, name],
    );
  }

  Future<void> deleteRoom(String name) {
    return _sql.query('delete from rooms where name = \$1', [name]);
  }

  Future<void> addRoom({required String name, String? notes}) {
    return _sql.query(
      'insert into rooms (name, notes) values (\$1, \$2)',
      [name, notes],
    );
  }
}
