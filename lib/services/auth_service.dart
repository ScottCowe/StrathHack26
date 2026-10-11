import 'package:strathclean/models/roles.dart';
import 'package:strathclean/models/user.dart';
import 'package:strathclean/services/sql_client.dart';

/// Low-level authentication operations (API, local storage, etc.).
class AuthService {
  AuthService(this._sql);

  final SqlClient _sql;

  Future<({User? user, String? error})> authenticate(
    String username,
    String password,
  ) async {
    final rows = await _sql.query(
      'select password_hash, role from users where username = \$1',
      [username],
    );
    if (rows.isEmpty) {
      return (user: null, error: 'User not found');
    }

    final row = rows.first;
    if (row['password_hash'] != password) {
      return (
        user: null,
        error: 'Password is incorrect',
      );
    }

    return (
      user: User(
        username: username,
        role: Role.values.byName(row['role'] as String),
      ),
      error: null,
    );
  }
}
