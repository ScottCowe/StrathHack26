import 'package:flutter_test/flutter_test.dart';

import 'package:strathclean/app.dart';
import 'package:strathclean/repositories/auth_repository.dart';
import 'package:strathclean/services/auth_service.dart';
import 'package:strathclean/services/sql_client.dart';

void main() {
  testWidgets('Home screen shows app title', (WidgetTester tester) async {
    final authRepository = AuthRepository(AuthService(SqlClient()));

    await tester.pumpWidget(StrathCleanApp(authRepository: authRepository));

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Submit'), findsOneWidget);
  });
}
