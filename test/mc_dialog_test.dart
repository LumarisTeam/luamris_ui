import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

Widget _app(Widget Function(BuildContext context) home) {
  return CupertinoApp(
    builder: (context, child) =>
        McThemeData.wrap(colors: McColors.light, child: child!),
    home: CupertinoPageScaffold(child: Builder(builder: home)),
  );
}

Widget _openButton(VoidCallback onPressed) {
  return Center(
    child: CupertinoButton(onPressed: onPressed, child: const Text('open')),
  );
}

void main() {
  testWidgets('confirm returns true when confirmed', (tester) async {
    bool? result;
    await tester.pumpWidget(
      _app(
        (context) => _openButton(() async {
          result = await showMcConfirmDialog(
            context: context,
            title: '标题',
            message: '内容',
            cancelText: '取消',
            confirmText: '确定',
          );
        }),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('标题'), findsOneWidget);
    expect(find.text('内容'), findsOneWidget);

    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('confirm returns false when cancelled', (tester) async {
    bool? result;
    await tester.pumpWidget(
      _app(
        (context) => _openButton(() async {
          result = await showMcConfirmDialog(
            context: context,
            message: '内容',
            cancelText: '取消',
            confirmText: '确定',
          );
        }),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('confirm returns null when the barrier is dismissed', (
    tester,
  ) async {
    bool? result;
    var completed = false;
    await tester.pumpWidget(
      _app(
        (context) => _openButton(() async {
          result = await showMcConfirmDialog(
            context: context,
            message: '内容',
            cancelText: '取消',
            confirmText: '确定',
            barrierDismissible: true,
          );
          completed = true;
        }),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(completed, isTrue);
    expect(result, isNull);
  });

  testWidgets('dialog keeps the 24px glass radius', (tester) async {
    await tester.pumpWidget(
      _app(
        (context) => _openButton(() {
          showMcConfirmDialog(
            context: context,
            message: '内容',
            cancelText: '取消',
            confirmText: '确定',
          );
        }),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final rounded = find.byWidgetPredicate(
      (widget) =>
          widget is ClipRRect &&
          widget.borderRadius == BorderRadius.circular(McRadii.xl),
    );
    expect(rounded, findsAtLeastNWidgets(1));
  });

  testWidgets('input dialog returns the entered text', (tester) async {
    String? result;
    await tester.pumpWidget(
      _app(
        (context) => _openButton(() async {
          result = await showMcInputDialog(
            context: context,
            title: '输入',
            hintText: '请输入',
            confirmText: '确定',
            cancelText: '取消',
          );
        }),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(CupertinoTextField), 'hello');
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(result, 'hello');
  });

  testWidgets('input dialog returns null when cancelled', (tester) async {
    String? result;
    await tester.pumpWidget(
      _app(
        (context) => _openButton(() async {
          result = await showMcInputDialog(
            context: context,
            title: '输入',
            confirmText: '确定',
            cancelText: '取消',
          );
        }),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    expect(result, isNull);
  });

  testWidgets('three or more actions stack vertically', (tester) async {
    String? result;
    await tester.pumpWidget(
      _app(
        (context) => _openButton(() async {
          result = await showMcDialog<String>(
            context: context,
            title: '选择',
            actions: const [
              McDialogAction<String>(label: 'A', value: 'a'),
              McDialogAction<String>(label: 'B', value: 'b'),
              McDialogAction<String>(label: 'C', value: 'c'),
            ],
          );
        }),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final a = tester.getCenter(find.text('A'));
    final b = tester.getCenter(find.text('B'));
    final c = tester.getCenter(find.text('C'));
    expect(a.dx, b.dx);
    expect(b.dx, c.dx);
    expect(a.dy, lessThan(b.dy));
    expect(b.dy, lessThan(c.dy));

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(result, 'b');
  });

  testWidgets('autoPop false keeps the dialog open', (tester) async {
    var callbackRan = false;
    String? result;
    await tester.pumpWidget(
      _app(
        (context) => _openButton(() async {
          result = await showMcDialog<String>(
            context: context,
            title: '选择',
            actions: [
              McDialogAction<String>(
                label: '保持',
                autoPop: false,
                onPressed: () => callbackRan = true,
              ),
              const McDialogAction<String>(label: '关闭', value: 'closed'),
            ],
          );
        }),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保持'));
    await tester.pumpAndSettle();

    expect(callbackRan, isTrue);
    expect(find.text('关闭'), findsOneWidget);

    await tester.tap(find.text('关闭'));
    await tester.pumpAndSettle();
    expect(result, 'closed');
  });
}
