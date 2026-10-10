import 'package:flutter/foundation.dart';
import 'package:strathclean/models/user.dart';

import 'package:strathclean/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel(this._authRepository);

  final AuthRepository _authRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<User?> submitLogin(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await _authRepository.login(username, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
