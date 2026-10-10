import 'package:flutter/material.dart';

import 'package:strathclean/models/roles.dart';
import 'package:strathclean/models/user.dart';
import 'package:strathclean/repositories/auth_repository.dart';
import 'package:strathclean/services/room_service.dart';
import 'package:strathclean/view/add_room_view.dart';
import 'package:strathclean/view/audit_view.dart';
import 'package:strathclean/view/home_view.dart';
import 'package:strathclean/view/login_view.dart';
import 'package:strathclean/viewmodel/login_view_model.dart';

class StrathCleanApp extends StatelessWidget {
  const StrathCleanApp({
    super.key,
    required this.authRepository,
    required this.roomService,
  });

  final AuthRepository authRepository;
  final RoomService roomService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(
              viewModel: LoginViewModel(authRepository),
            ),
        '/home': (context) {
          final user =
              ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null) {
            return LoginView(viewModel: LoginViewModel(authRepository));
          }
          return HomeView(user: user);
        },
        '/audit': (context) {
          final user =
              ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null || user.role != Role.supervisor) {
            return const Scaffold(
              body: Center(child: Text('Audit is for supervisors only')),
            );
          }
          return const AuditView();
        },
        '/log-clean': (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null || user.role != Role.cleaner) {
            return const Scaffold(
              body: Center(child: Text('Logging cleans is for cleaners only')),
            );
          }
          return const AuditView(title: 'Log cleans');
        },
        '/add-room': (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null || user.role != Role.supervisor) {
            return const Scaffold(
              body: Center(child: Text('Adding rooms is for supervisors only')),
            );
          }
          return AddRoomView(roomService: roomService);
        },
      },
    );
  }
}
