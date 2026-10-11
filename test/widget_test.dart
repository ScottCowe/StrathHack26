import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:strathclean/app.dart';
import 'package:strathclean/models/roles.dart';
import 'package:strathclean/models/user.dart';
import 'package:strathclean/repositories/auth_repository.dart';
import 'package:strathclean/services/auth_service.dart';
import 'package:strathclean/services/clean_service.dart';
import 'package:strathclean/services/room_service.dart';
import 'package:strathclean/services/sql_client.dart';
import 'package:strathclean/view/add_room_view.dart';
import 'package:strathclean/view/home_view.dart';

void main() {
  testWidgets('Home screen shows app title', (WidgetTester tester) async {
    final sql = SqlClient();
    final authRepository = AuthRepository(AuthService(sql));

    await tester.pumpWidget(
      StrathCleanApp(
        authRepository: authRepository,
        roomService: RoomService(sql),
        cleanService: CleanService(sql),
      ),
    );

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });

  testWidgets('Supervisor can open the add room form', (tester) async {
    final user = User(username: 'sam', role: Role.supervisor);

    await tester.pumpWidget(
      MaterialApp(
        home: HomeView(
          user: user,
          cleanService: CleanService(SqlClient()),
        ),
        routes: {
          '/add-room': (context) => AddRoomView(
                roomService: RoomService(SqlClient()),
              ),
        },
      ),
    );

    await tester.tap(find.text('Add new room'));
    await tester.pumpAndSettle();

    expect(find.text('Room name'), findsOneWidget);
    expect(find.text('Notes'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });
}
