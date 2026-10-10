/// Low-level authentication operations (API, local storage, etc.).
class AuthService {
  Future<bool> authenticate(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return username.isNotEmpty && password.isNotEmpty;
  }
}
