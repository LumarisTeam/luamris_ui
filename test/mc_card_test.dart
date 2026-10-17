import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

void main() {
  testWidgets('margin wraps the card from the outside', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: McCard.elevated(
            margin: const EdgeInsets.all(12),
            padding: EdgeInsets.zero,
            child: const Text('卡片'),
          ),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Padding && widget.padding == const EdgeInsets.all(12),
      ),
      findsOneWidget,
    );
    expect(find.text('卡片'), findsOneWidget);
  });

  testWidgets('tap handling still works with a margin', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: McCard.elevated(
            margin: const EdgeInsets.all(8),
            onPressed: () => tapped = true,
            child: const Text('点我'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('点我'));
    expect(tapped, isTrue);
  });
}
