import 'package:flutter_test/flutter_test.dart';

import 'package:repeater_manager/app/app.dart';

void main() {
  testWidgets('app renders the home shell', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Repeater Manager'), findsWidgets);
    expect(find.text('Foundation is ready'), findsOneWidget);
    expect(find.text('Responsive shell'), findsOneWidget);
  });
}
