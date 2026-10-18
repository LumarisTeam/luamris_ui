import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

void main() {
  testWidgets('dialog text does not inherit the fallback underline style', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showMcConfirmDialog(
                context: context,
                title: '标题',
                message: '内容',
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    for (final rich in tester.widgetList<RichText>(find.byType(RichText))) {
      expect(rich.text.style?.decoration, isNot(TextDecoration.underline));
    }
  });

  testWidgets('bottom sheet text does not inherit the fallback underline', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showMcBottomSheet<void>(
                context: context,
                builder: (_) => const Text('sheet 内容'),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final sheetText = tester.widget<RichText>(
      find.descendant(
        of: find.text('sheet 内容'),
        matching: find.byType(RichText),
      ),
    );
    expect(sheetText.text.style?.decoration, isNot(TextDecoration.underline));
  });
}
