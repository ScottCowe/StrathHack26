import 'package:flutter/material.dart';

import 'package:strathclean/app.dart';
import 'package:strathclean/repositories/auth_repository.dart';
import 'package:strathclean/services/auth_service.dart';

void main() {
  final authRepository = AuthRepository(AuthService());

  runApp(StrathCleanApp(authRepository: authRepository));
}
