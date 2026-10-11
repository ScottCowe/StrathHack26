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

  Future<int> logClean({
    required String username,
    required String room,
  }) async {
    final userId = await _userId(username);
    final now = DateTime.now().millisecondsSinceEpoch;
    await _sql.query(
      'insert into cleans (cleaned_by, room, audited, clean_time) values (\$1, \$2, false, \$3)',
      [userId, room, now],
    );
    final rows = await _sql.query(
      'select id from cleans where cleaned_by = \$1 and room = \$2 and clean_time = \$3 order by id desc limit 1',
      [userId, room, now],
    );
    if (rows.isEmpty) {
      throw StateError('Clean was not saved');
    }
    return (rows.first['id'] as num).toInt();
  }

  Future<int> logAudit({
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
    return cleanId;
  }

  Future<void> logIssue({
    required int cleanId,
    required String? description,
    required String tag,
  }) {
    return _sql.query(
      'insert into issues (clean_id, description, tag, priority) values (\$1, \$2, \$3, \$4)',
      [cleanId, description, tag, 'low'],
    );
  }
}
