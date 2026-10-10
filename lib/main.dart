import 'package:flutter/material.dart';

import 'package:strathclean/app.dart';
import 'package:strathclean/repositories/auth_repository.dart';
import 'package:strathclean/services/auth_service.dart';
import 'package:strathclean/services/room_service.dart';
import 'package:strathclean/services/sql_client.dart';

void main() {
  final sql = SqlClient();
  final authRepository = AuthRepository(AuthService(sql));

  runApp(
    StrathCleanApp(
      authRepository: authRepository,
      roomService: RoomService(sql),
    ),
  );
}
