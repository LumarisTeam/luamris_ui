import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

void main() {
  testWidgets('renders a title without a back button at the root', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(appBar: McAppBar(title: '标题')),
      ),
    );

    expect(find.text('标题'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsNothing);
  });

  testWidgets('shows a back button and pops the route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Scaffold(appBar: McAppBar(title: '详情')),
                ),
              ),
              child: const Text('push'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('push'));
    await tester.pumpAndSettle();

    final back = find.byIcon(Icons.arrow_back);
    expect(back, findsOneWidget);

    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(find.text('详情'), findsNothing);
  });

  testWidgets('renders a custom title widget', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(appBar: McAppBar(titleWidget: Text('自定义'))),
      ),
    );

    expect(find.text('自定义'), findsOneWidget);
  });
}
