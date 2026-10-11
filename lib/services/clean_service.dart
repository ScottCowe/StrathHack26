import 'package:strathclean/services/sql_client.dart';

class CleanService {
  CleanService(this._sql);

  final SqlClient _sql;

  Future<int> _userId(String username) async {
    final rows = await _sql.query(
      'select id from users where username = \$1',
      [username],
    );
    if (rows.isEmpty) {
      throw StateError('Signed-in user was not found');
    }
    return (rows.first['id'] as num).toInt();
  }

  Future<void> logClean({
    required String username,
    required String room,
  }) async {
    final userId = await _userId(username);
    await _sql.query(
      'insert into cleans (cleaned_by, room, audited, clean_time) values (\$1, \$2, false, \$3)',
      [userId, room, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<void> logAudit({
    required String username,
    required String room,
  }) async {
    final userId = await _userId(username);
    final cleans = await _sql.query(
      'select id from cleans where room = \$1 order by clean_time desc limit 1',
      [room],
    );
    if (cleans.isEmpty) {
      throw StateError('This room has not been cleaned');
    }

    final cleanId = (cleans.first['id'] as num).toInt();
    await _sql.query(
      'update cleans set audited = true, audited_by = \$1, audit_time = \$2 where id = \$3',
      [userId, DateTime.now().millisecondsSinceEpoch, cleanId],
    );
  }
}
