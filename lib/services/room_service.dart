import 'package:strathclean/services/sql_client.dart';

class RoomService {
  RoomService(this._sql);

  final SqlClient _sql;

  Future<
    List<
      ({
        String name,
        String? notes,
        String? building,
        String? floor,
        String? kml,
        DateTime? cleanTime,
      })
    >
  >
  listRooms() async {
    final rows = await _sql.query(
      'select rooms.name, rooms.notes, rooms.building, rooms.floor, rooms.kml, '
      'max(cleans.clean_time) as clean_time '
      'from rooms '
      'left join cleans on cleans.room = rooms.name '
      'group by rooms.name, rooms.notes, rooms.building, rooms.floor, rooms.kml '
      'order by rooms.name',
    );
    return [
      for (final row in rows)
        (
          name: row['name'] as String,
          notes: row['notes'] as String?,
          building: row['building'] as String?,
          floor: row['floor'] as String?,
          kml: row['kml'] as String?,
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
    String? building,
    String? floor,
    String? kml,
  }) {
    return _sql.query(
      'update rooms set name = \$1, notes = \$2, building = \$3, floor = \$4, '
      'kml = \$5 where name = \$6',
      [newName, notes, building, floor, kml, name],
    );
  }

  Future<void> deleteRoom(String name) {
    return _sql.query('delete from rooms where name = \$1', [name]);
  }

  Future<void> addRoom({
    required String name,
    String? notes,
    String? building,
    String? floor,
    String? kml,
  }) {
    return _sql.query(
      'insert into rooms (name, notes, building, floor, kml) '
      'values (\$1, \$2, \$3, \$4, \$5)',
      [name, notes, building, floor, kml],
    );
  }
}
