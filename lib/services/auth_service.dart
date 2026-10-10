import 'package:strathclean/services/sql_client.dart';

/// Low-level authentication operations (API, local storage, etc.).
class AuthService {
  AuthService(this._sql);

  final SqlClient _sql;

  Future<bool> authenticate(String username, String password) async {
    final rows = await _sql.query(
      'select password_hash from users where username = ?',
      [username],
    );
    if (rows.isEmpty) {
      return false;
    }
    return rows.first['password_hash'] == password;
  }
}
