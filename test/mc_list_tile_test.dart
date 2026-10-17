import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

Widget _harness(Widget child) {
  return CupertinoApp(
    builder: (context, c) =>
        McThemeData.wrap(colors: McColors.light, child: c!),
    home: CupertinoPageScaffold(
      child: Center(child: SizedBox(width: 340, child: child)),
    ),
  );
}

void main() {
  testWidgets('renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      _harness(const McListTile(title: Text('标题'), subtitle: Text('副标题'))),
    );

    expect(find.text('标题'), findsOneWidget);
    expect(find.text('副标题'), findsOneWidget);
  });

  testWidgets('showChevron renders a trailing chevron', (tester) async {
    await tester.pumpWidget(
      _harness(const McListTile(title: Text('标题'), showChevron: true)),
    );

    expect(find.byIcon(CupertinoIcons.chevron_right), findsOneWidget);
  });

  testWidgets('selected uses the selection fill', (tester) async {
    await tester.pumpWidget(
      _harness(const McListTile(title: Text('标题'), selected: true)),
    );

    final selected = find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is ShapeDecoration &&
          (widget.decoration as ShapeDecoration).color ==
              McColors.light.selectionFill,
    );
    expect(selected, findsOneWidget);
  });

  testWidgets('custom selected background color wins', (tester) async {
    const custom = Color(0xFF123456);
    await tester.pumpWidget(
      _harness(
        const McListTile(
          title: Text('标题'),
          selected: true,
          selectedBackgroundColor: custom,
        ),
      ),
    );

    final selected = find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is ShapeDecoration &&
          (widget.decoration as ShapeDecoration).color == custom,
    );
    expect(selected, findsOneWidget);
  });

  testWidgets('disabled tile ignores taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _harness(
        McListTile(
          title: const Text('禁用'),
          enabled: false,
          onTap: () => taps++,
        ),
      ),
    );

    await tester.tap(find.text('禁用'));
    await tester.pumpAndSettle();
    expect(taps, 0);
  });

  testWidgets('long press fires onLongPress', (tester) async {
    var longPresses = 0;
    await tester.pumpWidget(
      _harness(
        McListTile(title: const Text('长按'), onLongPress: () => longPresses++),
      ),
    );

    await tester.longPress(find.text('长按'));
    await tester.pumpAndSettle();
    expect(longPresses, 1);
  });

  testWidgets('default content padding matches the grouped style', (
    tester,
  ) async {
    await tester.pumpWidget(_harness(const McListTile(title: Text('标题'))));

    final padding = find.byWidgetPredicate(
      (widget) =>
          widget is Padding &&
          widget.padding ==
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
    expect(padding, findsOneWidget);
  });

  testWidgets('subtitle reduces vertical padding', (tester) async {
    await tester.pumpWidget(
      _harness(const McListTile(title: Text('标题'), subtitle: Text('副标题'))),
    );

    final padding = find.byWidgetPredicate(
      (widget) =>
          widget is Padding &&
          widget.padding ==
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
    expect(padding, findsOneWidget);
  });

  testWidgets('legacy padding and titleStyle still work', (tester) async {
    const customColor = Color(0xFFAA0000);
    await tester.pumpWidget(
      _harness(
        McListTile(
          title: const Text('旧参数'),
          // ignore: deprecated_member_use_from_same_package
          padding: const EdgeInsets.all(7),
          // ignore: deprecated_member_use_from_same_package
          titleStyle: const TextStyle(color: customColor),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Padding && widget.padding == const EdgeInsets.all(7),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is DefaultTextStyle && widget.style.color == customColor,
      ),
      findsOneWidget,
    );
  });

  testWidgets('does not use Material ink widgets', (tester) async {
    await tester.pumpWidget(
      _harness(McListTile(title: const Text('Cupertino'), onTap: () {})),
    );

    expect(find.byType(InkWell), findsNothing);
  });
}
