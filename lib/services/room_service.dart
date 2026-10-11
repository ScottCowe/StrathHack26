import 'package:strathclean/services/sql_client.dart';

class RoomService {
  RoomService(this._sql);

  final SqlClient _sql;

  Future<List<({String name, DateTime? cleanTime})>> listRooms() async {
    final rows = await _sql.query(
      'select rooms.name, max(cleans.clean_time) as clean_time '
      'from rooms '
      'left join cleans on cleans.room = rooms.name '
      'group by rooms.name '
      'order by rooms.name',
    );
    return [
      for (final row in rows)
        (
          name: row['name'] as String,
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

  Future<void> addRoom({required String name, String? notes}) {
    return _sql.query(
      'insert into rooms (name, notes) values (\$1, \$2)',
      [name, notes],
    );
  }
}
