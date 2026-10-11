import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:strathclean/models/roles.dart';
import 'package:strathclean/models/user.dart';
import 'package:strathclean/repositories/auth_repository.dart';
import 'package:strathclean/services/clean_service.dart';
import 'package:strathclean/services/room_service.dart';
import 'package:strathclean/view/add_room_view.dart';
import 'package:strathclean/view/audit_view.dart';
import 'package:strathclean/view/home_view.dart';
import 'package:strathclean/view/issues_view.dart';
import 'package:strathclean/view/login_view.dart';
import 'package:strathclean/view/rooms_view.dart';
import 'package:strathclean/view/take_image_view.dart';
import 'package:strathclean/viewmodel/login_view_model.dart';

class StrathCleanApp extends StatelessWidget {
  const StrathCleanApp({
    super.key,
    required this.authRepository,
    required this.roomService,
    required this.cleanService,
  });

  final AuthRepository authRepository;
  final RoomService roomService;
  final CleanService cleanService;




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ),
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
          return HomeView(user: user, cleanService: cleanService);
        },
        '/audit': (context) {
          final user =
              ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null || user.role != Role.supervisor) {
            return const Scaffold(
              body: Center(child: Text('Audit is for supervisors only')),
            );
          }
          return AuditView(user: user, cleanService: cleanService);
        },
        '/log-clean': (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null || user.role != Role.cleaner) {
            return const Scaffold(
              body: Center(child: Text('Logging cleans is for cleaners only')),
            );
          }
          return AuditView(
            title: 'Log cleans',
            logsClean: true,
            user: user,
            cleanService: cleanService,
          );
        },
        '/log-issue': (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null) {
            return LoginView(viewModel: LoginViewModel(authRepository));
          }
          return AuditView(
            title: 'Log issue',
            logsIssue: true,
            user: user,
            cleanService: cleanService,
          );
        },
        '/rooms': (context) => RoomsView(roomService: roomService),
        '/manage-rooms': (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null || user.role != Role.supervisor) {
            return const Scaffold(
              body: Center(child: Text('Managing rooms is for supervisors only')),
            );
          }
          return RoomsView(
            roomService: roomService,
            canEdit: true,
            user: user,
          );
        },
        '/issues': (context) => IssuesView(cleanService: cleanService),
        '/manage-issues': (context) {
          final user = ModalRoute.of(context)?.settings.arguments as User?;
          if (user == null || user.role != Role.supervisor) {
            return const Scaffold(
              body: Center(
                child: Text('Managing issues is for supervisors only'),
              ),
            );
          }
          return IssuesView(cleanService: cleanService, canEdit: true);
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
        '/take-picture': (context) {
            return TakePictureScreen();
        },
      },
    );
  }
}
