import 'package:flutter/material.dart';

import 'package:strathclean/app.dart';
import 'package:strathclean/database/app_database.dart';
import 'package:strathclean/repositories/auth_repository.dart';
import 'package:strathclean/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  final authRepository = AuthRepository(AuthService());
  runApp(StrathCleanApp(authRepository: authRepository));

  final database = AppDatabase();
  await database.customSelect('SELECT 1').get();
}
