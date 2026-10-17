import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('Example app renders home page', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());

    // The home page title and section cards should be visible.
    expect(find.text('Luamris UI'), findsOneWidget);
    expect(find.text('按钮 McButton'), findsOneWidget);
    expect(find.text('卡片 McCard'), findsOneWidget);
  });
}
