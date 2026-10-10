import 'package:flutter_test/flutter_test.dart';

import 'package:strathclean/app.dart';
import 'package:strathclean/repositories/auth_repository.dart';
import 'package:strathclean/services/auth_service.dart';

void main() {
  testWidgets('Home screen shows app title', (WidgetTester tester) async {
    final authRepository = AuthRepository(AuthService());

    await tester.pumpWidget(StrathCleanApp(authRepository: authRepository));

    expect(find.text('Strath Clean'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
