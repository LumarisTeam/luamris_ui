import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Example app renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());

    // The home page title should be visible.
    expect(find.text('Luamris UI'), findsOneWidget);
    expect(find.text('Apple 风格 Flutter UI 组件库'), findsOneWidget);
  });
}
