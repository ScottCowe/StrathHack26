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

  Future<
      List<
          ({
            int id,
            String? room,
            String? description,
            String tag,
            String priority,
            bool resolved,
            String? image,
            String? loggedBy,
          })>> listIssues({bool includeCleaning = true}) async {
    final rows = await _sql.query(
      'select issues.id, cleans.room, issues.description, issues.tag, '
      'issues.priority, issues.resolved, issues.image, users.username as logged_by '
      'from issues '
      'left join cleans on cleans.id = issues.clean_id '
      'left join users on users.id = cleans.cleaned_by '
      'where issues.resolved = false '
      '${includeCleaning ? '' : "and issues.tag <> 'cleaners' "}'
      'order by issues.id',
    );
    return [
      for (final row in rows)
        (
          id: (row['id'] as num).toInt(),
          room: row['room'] as String?,
          description: row['description'] as String?,
          tag: row['tag'] as String,
          priority: row['priority'] as String,
          resolved: row['resolved'] == true,
          image: row['image'] as String?,
          loggedBy: row['logged_by'] as String?,
        ),
    ];
  }

  Future<void> saveIssue({
    required int id,
    String? description,
    required String tag,
    required String priority,
    required String? image,
    required bool resolved,
  }) {
    return _sql.query(
      'update issues set description = \$1, tag = \$2, priority = \$3, image = \$4, resolved = \$5 where id = \$5',
      [description, tag, priority, image, resolved, id],
    );
  }

  Future<void> deleteIssue(int id) {
    return _sql.query('delete from issues where id = \$1', [id]);
  }

  Future<
      List<
          ({
            String room,
            String cleaner,
            DateTime cleanTime,
            String? previousIssue,
            String? unresolved,
          })>> pendingAudits() async {
    final rows = await _sql.query(
      'select c.room, u.username as cleaner, c.clean_time, '
      '(select i.description from issues i '
      'join cleans older on older.id = i.clean_id '
      'where older.room = c.room and i.resolved = true '
      'and i.description is not null '
      'order by older.clean_time desc, i.id desc limit 1) as previous_issue, '
      '(select string_agg(i.description, \', \' order by i.id) from issues i '
      'join cleans older on older.id = i.clean_id '
      'where older.room = c.room and i.resolved = false '
      'and i.description is not null) as unresolved '
      'from cleans c '
      'join users u on u.id = c.cleaned_by '
      'where c.audited = false and c.clean_time = ('
      'select max(latest.clean_time) from cleans latest where latest.room = c.room'
      ') order by random() limit 5',
    );
    return [
      for (final row in rows)
        (
          room: row['room'] as String,
          cleaner: row['cleaner'] as String,
          cleanTime: DateTime.fromMillisecondsSinceEpoch(
            (row['clean_time'] as num).toInt(),
            isUtc: true,
          ).toLocal(),
          previousIssue: row['previous_issue'] as String?,
          unresolved: row['unresolved'] as String?,
        ),
    ];
  }

  Future<void> logIssueForRoom({
    required String room,
    required String? description,
    required String tag,
    required String priority,
    required String? image,
  }) async {
    final cleans = await _sql.query(
      'select id from cleans where room = \$1 order by clean_time desc limit 1',
      [room],
    );
    if (cleans.isEmpty) {
      throw StateError('This room has not been cleaned');
    }
    await logIssue(
      cleanId: (cleans.first['id'] as num).toInt(),
      description: description,
      tag: tag,
      priority: priority,
      image: image
    );
  }

  Future<void> logIssue({
    required int cleanId,
    required String? description,
    required String tag,
    required String priority,
    required String? image
  }) {
    return _sql.query(
      'insert into issues (clean_id, description, tag, priority, image) values (\$1, \$2, \$3, \$4, \$5)',
      [cleanId, description, tag, priority, image],
    );
  }
}
