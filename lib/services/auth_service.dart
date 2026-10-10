import 'package:strathclean/models/roles.dart';
import 'package:strathclean/models/user.dart';

/// Low-level authentication operations (API, local storage, etc.).
class AuthService {
  Future<User?> authenticate(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final correct = username.isNotEmpty && password.isNotEmpty;
    if(correct){
      return User(username: username, role: Role.cleaner);
    } else {
      return null;
    }
  }
}
