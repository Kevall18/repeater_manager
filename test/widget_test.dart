import 'package:flutter_test/flutter_test.dart';

import 'package:repeater_manager/app/app.dart';

void main() {
  testWidgets('app renders the login shell', (WidgetTester tester) async {
    await tester.pumpWidget(const App(useTestAuth: true));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Create a new account'), findsOneWidget);
  });
}
