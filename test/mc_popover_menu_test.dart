import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

Widget _trigger({String label = '打开'}) {
  return SizedBox(width: 200, height: 48, child: Center(child: Text(label)));
}

Widget _app(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  testWidgets('opens, selects an item and closes', (tester) async {
    String? selected;
    await tester.pumpWidget(
      _app(
        Center(
          child: McPopoverMenu<String>(
            items: const [
              McPopoverMenuItem(value: 'a', label: '选项 A'),
              McPopoverMenuItem(value: 'b', label: '选项 B'),
            ],
            onSelected: (value) => selected = value,
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(find.text('选项 A'), findsOneWidget);
    expect(find.text('选项 B'), findsOneWidget);

    await tester.tap(find.text('选项 B'));
    await tester.pumpAndSettle();

    expect(selected, 'b');
    expect(find.text('选项 A'), findsNothing);
  });

  testWidgets('closes when the barrier is tapped', (tester) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: McPopoverMenu<String>(
            items: const [McPopoverMenuItem(value: 'a', label: '选项 A')],
            onSelected: (_) {},
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(find.text('选项 A'), findsOneWidget);

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(find.text('选项 A'), findsNothing);
  });

  testWidgets('a tap over the trigger hits the barrier and closes', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: McPopoverMenu<String>(
            items: const [McPopoverMenuItem(value: 'a', label: '选项 A')],
            onSelected: (_) {},
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(find.text('选项 A'), findsOneWidget);

    // The barrier covers the trigger while open, so this tap hits the barrier.
    await tester.tapAt(tester.getCenter(find.text('打开')));
    await tester.pumpAndSettle();

    expect(find.text('选项 A'), findsNothing);
  });

  testWidgets('selected item shows a checkmark', (tester) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: McPopoverMenu<int>(
            items: const [
              McPopoverMenuItem(value: 0, label: '第一学期'),
              McPopoverMenuItem(value: 1, label: '第二学期'),
            ],
            selectedValue: 1,
            onSelected: (_) {},
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.byIcon(CupertinoIcons.checkmark), findsOneWidget);
  });

  testWidgets('disabled items do not fire onSelected and keep the menu open', (
    tester,
  ) async {
    String? selected;
    await tester.pumpWidget(
      _app(
        Center(
          child: McPopoverMenu<String>(
            items: const [
              McPopoverMenuItem(value: 'a', label: '选项 A', enabled: false),
            ],
            onSelected: (value) => selected = value,
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('选项 A'));
    await tester.pumpAndSettle();

    expect(selected, isNull);
    expect(find.text('选项 A'), findsOneWidget);
  });

  testWidgets('flips above the trigger when there is no room below', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Align(
          alignment: Alignment.bottomCenter,
          child: McPopoverMenu<String>(
            items: const [
              McPopoverMenuItem(value: 'a', label: '选项 A'),
              McPopoverMenuItem(value: 'b', label: '选项 B'),
              McPopoverMenuItem(value: 'c', label: '选项 C'),
            ],
            onSelected: (_) {},
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final follower = tester.widget<CompositedTransformFollower>(
      find.byType(CompositedTransformFollower),
    );
    expect(follower.targetAnchor, Alignment.topLeft);
    expect(follower.followerAnchor, Alignment.bottomLeft);
  });

  testWidgets('opens below when there is room', (tester) async {
    await tester.pumpWidget(
      _app(
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: McPopoverMenu<String>(
              items: const [McPopoverMenuItem(value: 'a', label: '选项 A')],
              onSelected: (_) {},
              child: _trigger(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final follower = tester.widget<CompositedTransformFollower>(
      find.byType(CompositedTransformFollower),
    );
    expect(follower.targetAnchor, Alignment.bottomLeft);
    expect(follower.followerAnchor, Alignment.topLeft);
  });

  testWidgets('matchTriggerWidth sizes the menu to the trigger', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: McPopoverMenu<String>(
            items: const [McPopoverMenuItem(value: 'a', label: '选项 A')],
            matchTriggerWidth: true,
            onSelected: (_) {},
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(CompositedTransformFollower));
    expect(size.width, 200);
  });

  testWidgets('uses a custom width and background color', (tester) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: McPopoverMenu<String>(
            width: 280,
            backgroundColor: const Color(0xFF102030),
            onSelected: (_) {},
            items: const [McPopoverMenuItem(value: 'a', label: '选项 A')],
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(CompositedTransformFollower)).width, 280);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox && widget.color == const Color(0xFF102030),
      ),
      findsOneWidget,
    );
  });

  testWidgets('closes when another route covers the menu', (tester) async {
    await tester.pumpWidget(
      _app(
        Center(
          child: McPopoverMenu<String>(
            items: const [McPopoverMenuItem(value: 'a', label: '选项 A')],
            onSelected: (_) {},
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(find.text('选项 A'), findsOneWidget);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('新页面')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('选项 A'), findsNothing);
    expect(find.text('新页面'), findsOneWidget);
  });

  testWidgets('onOpenChanged reports open and closed', (tester) async {
    final states = <bool>[];
    await tester.pumpWidget(
      _app(
        Center(
          child: McPopoverMenu<String>(
            items: const [McPopoverMenuItem(value: 'a', label: '选项 A')],
            onSelected: (_) {},
            onOpenChanged: states.add,
            child: _trigger(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect(states, [true]);

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
    expect(states, [true, false]);
  });
}
