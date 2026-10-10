import 'package:flutter/material.dart';

import 'package:strathclean/repositories/auth_repository.dart';
import 'package:strathclean/view/home_view.dart';
import 'package:strathclean/view/login_view.dart';
import 'package:strathclean/viewmodel/login_view_model.dart';

class StrathCleanApp extends StatelessWidget {
  const StrathCleanApp({super.key, required this.authRepository});

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(
              viewModel: LoginViewModel(authRepository),
            ),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
