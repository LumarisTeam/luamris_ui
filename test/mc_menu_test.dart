import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

void main() {
  testWidgets('opens and selects an item', (tester) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              McMenu<String>(
                items: const [
                  McMenuItem(value: 'edit', label: '编辑'),
                  McMenuItem(value: 'delete', label: '删除', isDestructive: true),
                ],
                onSelected: (value) => selected = value,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_circle));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();

    expect(selected, 'delete');
  });

  testWidgets('destructive items use the danger color', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: McMenu<String>(
            items: const [
              McMenuItem(value: 'delete', label: '删除', isDestructive: true),
            ],
            onSelected: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_circle));
    await tester.pumpAndSettle();

    final text = tester.widget<Text>(find.text('删除'));
    expect(text.style?.color, McColors.light.destructive);
  });

  testWidgets('disabled items do not fire onSelected', (tester) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: McMenu<String>(
            items: const [
              McMenuItem(value: 'edit', label: '编辑', enabled: false),
            ],
            onSelected: (value) => selected = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_circle));
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑'));
    await tester.pumpAndSettle();

    expect(selected, isNull);
  });
}
