import 'package:strathclean/services/auth_service.dart';

/// Domain-facing auth data access; hides service implementation details.
class AuthRepository {
  AuthRepository(this._authService);

  final AuthService _authService;

  Future<bool> login(String username, String password) {
    return _authService.authenticate(username, password);
  }
}
