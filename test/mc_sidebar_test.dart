import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

const _items = [
  McSidebarDestination(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: '首页',
  ),
  McSidebarDestination(icon: Icons.schedule, label: '课表', badge: '2'),
];

Widget _wrap(Widget child, {bool dark = false}) => MaterialApp(
  theme: McThemeData.materialTheme(dark ? McColors.dark : McColors.light),
  home: child,
);

Finder _row(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(Container)).first;

Color? _fill(WidgetTester tester, String label) =>
    (tester.widget<Container>(_row(label)).decoration! as ShapeDecoration)
        .color;

void main() {
  testWidgets(
    'preserves source geometry and text style without Material ancestor',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          McSidebar(
            items: _items,
            selectedIndex: 0,
            onItemSelected: (_) {},
            bottom: const McSidebarUserTile(title: '用户', subtitle: '已登录'),
          ),
        ),
      );
      expect(tester.getSize(_row('首页')).height, 34);
      expect(_fill(tester, '首页'), const Color.fromRGBO(9, 129, 255, 0.749));
      expect(_fill(tester, '课表'), Colors.transparent);
      final paragraph = tester.renderObject<RenderParagraph>(find.text('首页'));
      final style = (paragraph.text as TextSpan).style!;
      expect(style.fontFamily, '.AppleSystemUIFont');
      expect(style.fontSize, 13);
      expect(style.decoration, TextDecoration.none);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('用户'), findsOneWidget);
    },
  );

  testWidgets('updates selection and window focus in light and dark themes', (
    tester,
  ) async {
    for (final dark in [false, true]) {
      for (final focused in [true, false]) {
        await tester.pumpWidget(
          _wrap(
            McSidebar(
              items: _items,
              selectedIndex: 1,
              onItemSelected: (_) {},
              isWindowFocused: focused,
            ),
            dark: dark,
          ),
        );
        await tester.pumpAndSettle();
        expect(_fill(tester, '首页'), Colors.transparent);
        expect(
          _fill(tester, '课表'),
          focused
              ? (dark
                    ? const Color.fromRGBO(22, 105, 229, 0.749)
                    : const Color.fromRGBO(9, 129, 255, 0.749))
              : (dark
                    ? const Color.fromRGBO(76, 78, 65, 1)
                    : const Color.fromRGBO(213, 213, 208, 1)),
        );
        expect(
          tester.widget<Text>(find.text('首页')).style!.color,
          dark
              ? const Color.fromRGBO(255, 255, 255, 0.85)
              : const Color.fromRGBO(0, 0, 0, 0.85),
        );
      }
    }
  });

  testWidgets(
    'supports pointer and keyboard activation and selection semantics',
    (tester) async {
      var selected = -1;
      await tester.pumpWidget(
        _wrap(
          McSidebar(
            items: _items,
            selectedIndex: 0,
            onItemSelected: (value) => selected = value,
          ),
        ),
      );
      final semantics = tester.ensureSemantics();
      expect(
        tester.getSemantics(find.text('首页')),
        matchesSemantics(
          label: '首页',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
        ),
      );
      await tester.tap(find.text('课表'));
      expect(selected, 1);
      selected = -1;
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(selected, 0);
      semantics.dispose();
    },
  );

  testWidgets('uses the wrapped Cupertino dark theme', (tester) async {
    await tester.pumpWidget(
      CupertinoApp(
        theme: const CupertinoThemeData(brightness: Brightness.dark),
        builder: (context, child) => McThemeData.wrap(child: child!),
        home: McSidebar(
          items: _items,
          selectedIndex: 0,
          onItemSelected: (_) {},
        ),
      ),
    );
    expect(_fill(tester, '首页'), const Color.fromRGBO(22, 105, 229, 0.749));
  });

  testWidgets('keeps bottom content fixed while navigation scrolls', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        Center(
          child: SizedBox(
            width: 220,
            height: 180,
            child: McSidebar(
              items: List.generate(
                30,
                (i) => McSidebarDestination(icon: Icons.home, label: '项目$i'),
              ),
              selectedIndex: -1,
              onItemSelected: (_) {},
              bottom: const McSidebarUserTile(title: '底部'),
            ),
          ),
        ),
      ),
    );
    final position = tester.getTopLeft(find.text('底部'));
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('底部')), position);
    expect(tester.takeException(), isNull);
  });

  testWidgets('user tile forwards pointer and keyboard activation', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        Align(
          alignment: Alignment.bottomLeft,
          child: SizedBox(
            width: 220,
            child: McSidebarUserTile(title: '用户', onTap: () => taps++),
          ),
        ),
      ),
    );
    await tester.tap(find.text('用户'));
    expect(taps, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(taps, 2);
  });

  testWidgets(
    'shell resizes, clamps, collapses and reopens from the left edge',
    (tester) async {
      const sideKey = ValueKey('sidebar');
      await tester.pumpWidget(
        _wrap(
          const McSidebarShell(
            sidebar: ColoredBox(key: sideKey, color: Colors.blue),
            child: Text('content'),
          ),
        ),
      );
      double width() => tester.getSize(find.byKey(sideKey)).width;
      Future<void> dragFrom(double x, double delta) async {
        final gesture = await tester.startGesture(Offset(x, 100));
        // Cross the gesture threshold before applying the intended resize.
        await gesture.moveBy(Offset(delta.sign * 20, 0));
        await tester.pump();
        await gesture.moveBy(Offset(delta, 0));
        await gesture.up();
        await tester.pump();
      }

      expect(width(), 220);
      await dragFrom(220, 200);
      expect(width(), 280);
      await dragFrom(280, -110);
      expect(width(), 180);
      await dragFrom(180, -160);
      expect(find.byKey(sideKey), findsNothing);
      await dragFrom(1, 120);
      expect(width(), 180);
      expect(find.text('content'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
