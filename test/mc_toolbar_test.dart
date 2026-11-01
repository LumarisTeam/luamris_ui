import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

Widget _host(
  Widget child, {
  double width = 600,
  bool dark = false,
  bool cupertino = false,
}) {
  final home = Align(
    alignment: Alignment.topLeft,
    child: SizedBox(width: width, child: child),
  );
  if (cupertino) {
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: dark ? Brightness.dark : Brightness.light,
      ),
      builder: (context, child) => McThemeData.wrap(child: child!),
      home: home,
    );
  }
  return MaterialApp(
    theme: McThemeData.materialTheme(dark ? McColors.dark : McColors.light),
    home: home,
  );
}

void main() {
  testWidgets('only title and background gestures invoke host window actions', (
    tester,
  ) async {
    var drags = 0;
    var zooms = 0;
    var presses = 0;
    await tester.pumpWidget(
      _host(
        McToolBar(
          title: const Text('窗口标题'),
          onBackgroundPanStart: (_) => drags++,
          onBackgroundDoubleTap: () => zooms++,
          leading: McToolBarIconButton(
            label: '操作',
            icon: const Icon(CupertinoIcons.add),
            onPressed: () => presses++,
          ),
        ),
      ),
    );
    await tester.dragFrom(const Offset(500, 26), const Offset(40, 0));
    expect(drags, 1);
    await tester.tap(find.text('窗口标题'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('窗口标题'));
    await tester.pumpAndSettle();
    expect(zooms, 1);
    await tester.tap(find.byIcon(CupertinoIcons.add));
    await tester.pumpAndSettle();
    expect(presses, 1);
    expect(drags, 1);
    expect(zooms, 1);
  });

  testWidgets('reserves leadingWidth for two adjacent controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        McToolBar(
          title: const Text('应用标题'),
          leadingWidth: 80,
          leading: Row(
            children: [
              SizedBox(
                width: 40,
                child: McToolBarIconButton(
                  label: '侧边栏',
                  icon: const Icon(CupertinoIcons.sidebar_left),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                width: 40,
                child: McToolBarIconButton(
                  label: '返回',
                  icon: const Icon(CupertinoIcons.chevron_back),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.getCenter(find.byIcon(CupertinoIcons.chevron_back)).dx -
          tester.getCenter(find.byIcon(CupertinoIcons.sidebar_left)).dx,
      40,
    );
    expect(tester.getTopLeft(find.text('应用标题')).dx, greaterThanOrEqualTo(88));
    expect(tester.takeException(), isNull);
  });

  testWidgets('centers the title in the toolbar with asymmetric actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        McToolBar(
          title: const Text('居中'),
          centerTitle: true,
          actions: [
            McToolBarIconButton(
              label: '添加',
              icon: const Icon(CupertinoIcons.add),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
    expect(
      tester.getCenter(find.text('居中')).dx,
      tester.getCenter(find.byType(McToolBar)).dx,
    );
  });

  testWidgets('visible labels fit at large text scale', (tester) async {
    await tester.pumpWidget(
      _host(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: McToolBar(
            actions: [
              McToolBarIconButton(
                label: '操作',
                showLabel: true,
                icon: const Icon(CupertinoIcons.add),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('操作'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an all-disabled menu still dismisses with Escape', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const McToolBar(
          actions: [
            McToolBarPullDownButton(
              label: '操作',
              icon: Icon(CupertinoIcons.ellipsis),
              items: [McToolBarMenuItem(label: '不可用')],
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byIcon(CupertinoIcons.ellipsis));
    await tester.pumpAndSettle();
    expect(find.text('不可用'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('不可用'), findsNothing);
  });

  testWidgets(
    'renders 52px toolbar with clean title typography in both app types',
    (tester) async {
      for (final cupertino in [false, true]) {
        await tester.pumpWidget(
          _host(
            const McToolBar(title: Text('文档')),
            cupertino: cupertino,
            dark: true,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.getSize(find.byType(McToolBar)).height, 52);
        final paragraph = tester.renderObject<RenderParagraph>(find.text('文档'));
        final style = (paragraph.text as TextSpan).style!;
        expect(style.fontSize, 15);
        expect(style.decoration, TextDecoration.none);
        expect(style.color, McColors.dark.foreground);
      }
    },
  );

  testWidgets(
    'icon commands activate with pointer and keyboard; disabled stays inactive',
    (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          McToolBar(
            actions: [
              McToolBarIconButton(
                label: '添加',
                icon: const Icon(CupertinoIcons.add),
                onPressed: () => taps++,
              ),
              const McToolBarIconButton(
                label: '删除',
                icon: Icon(CupertinoIcons.trash),
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.byIcon(CupertinoIcons.add));
      expect(taps, 1);
      await tester.tap(find.byIcon(CupertinoIcons.trash));
      expect(taps, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(taps, 2);
    },
  );

  testWidgets(
    'pull-down menu supports arrows, disabled skipping, Enter and Escape',
    (tester) async {
      var choice = '';
      await tester.pumpWidget(
        _host(
          McToolBar(
            actions: [
              McToolBarPullDownButton(
                label: '操作',
                icon: const Icon(CupertinoIcons.ellipsis),
                items: [
                  McToolBarMenuItem(
                    label: '打开',
                    onSelected: () => choice = 'open',
                  ),
                  McToolBarMenuItem(
                    label: '不可用',
                    enabled: false,
                    onSelected: () => choice = 'disabled',
                  ),
                  McToolBarMenuItem(
                    label: '保存',
                    onSelected: () => choice = 'save',
                  ),
                ],
              ),
            ],
          ),
          cupertino: true,
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(find.text('打开'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(choice, 'save');
      expect(find.text('打开'), findsNothing);
      await tester.tap(find.byIcon(CupertinoIcons.ellipsis));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('打开'), findsNothing);
      expect(choice, 'save');
    },
  );

  testWidgets(
    'overflow retains commands, disabled items, custom fallbacks and pull-down entries',
    (tester) async {
      var selected = '';
      Widget toolbar(double width) => _host(
        McToolBar(
          title: const Text('标题'),
          actions: [
            McToolBarIconButton(
              label: '添加',
              icon: const Icon(CupertinoIcons.add),
              onPressed: () => selected = 'add',
            ),
            const McToolBarSpacer(),
            McToolBarCustomItem(
              width: 180,
              overflowItems: [
                McToolBarMenuItem(
                  label: '搜索',
                  onSelected: () => selected = 'search',
                ),
              ],
              child: const Text('搜索框'),
            ),
            McToolBarPullDownButton(
              label: '文件',
              icon: const Icon(CupertinoIcons.folder),
              enabled: false,
              items: [
                McToolBarMenuItem(
                  label: '打开',
                  onSelected: () => selected = 'open',
                ),
              ],
            ),
          ],
        ),
        width: width,
      );
      await tester.pumpWidget(toolbar(600));
      expect(find.text('搜索框'), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.chevron_right_2), findsNothing);
      await tester.pumpWidget(toolbar(200));
      await tester.pumpAndSettle();
      expect(find.text('搜索框'), findsNothing);
      await tester.tap(find.byIcon(CupertinoIcons.chevron_right_2));
      await tester.pumpAndSettle();
      expect(find.text('文件 / 打开'), findsOneWidget);
      await tester.tap(find.text('文件 / 打开'));
      await tester.pumpAndSettle();
      expect(selected, '');
      await tester.tap(find.text('搜索'));
      await tester.pumpAndSettle();
      expect(selected, 'search');
      await tester.pumpWidget(toolbar(600));
      await tester.pumpAndSettle();
      expect(find.text('搜索框'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'menu stays inside the viewport near the bottom and closes on outside tap',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 160,
              child: McToolBar(
                actions: [
                  McToolBarPullDownButton(
                    label: '菜单',
                    icon: const Icon(CupertinoIcons.ellipsis),
                    items: [McToolBarMenuItem(label: '执行', onSelected: () {})],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(CupertinoIcons.ellipsis));
      await tester.pumpAndSettle();
      final rect = tester.getRect(find.text('执行'));
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.bottom, lessThan(600));
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('执行'), findsNothing);
    },
  );

  testWidgets('automatically supplies a route back button', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const Align(
                    alignment: Alignment.topCenter,
                    child: McToolBar(title: Text('详情')),
                  ),
                ),
              ),
              child: const Text('打开详情'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开详情'));
    await tester.pumpAndSettle();
    expect(find.byIcon(CupertinoIcons.chevron_back), findsOneWidget);
    await tester.tap(find.byIcon(CupertinoIcons.chevron_back));
    await tester.pumpAndSettle();
    expect(find.text('打开详情'), findsOneWidget);
  });

  testWidgets(
    'controller toggles sidebar without moving toolbar into the sidebar',
    (tester) async {
      final controller = McSidebarController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(
            height: 400,
            child: McSidebarShell(
              controller: controller,
              sidebar: const ColoredBox(
                key: ValueKey('side'),
                color: Colors.blue,
              ),
              toolbar: McToolBar(
                leading: McToolBarIconButton(
                  label: '切换侧边栏',
                  icon: const Icon(CupertinoIcons.sidebar_left),
                  onPressed: controller.toggle,
                ),
                title: const Text('工具栏'),
              ),
              child: const Text('内容'),
            ),
          ),
        ),
      );
      expect(tester.getTopLeft(find.byType(McToolBar)).dx, 220);
      await tester.tap(find.byIcon(CupertinoIcons.sidebar_left));
      await tester.pumpAndSettle();
      expect(controller.isVisible, isFalse);
      expect(find.byKey(const ValueKey('side')), findsNothing);
      expect(tester.getTopLeft(find.byType(McToolBar)).dx, 0);
      await tester.tap(find.byIcon(CupertinoIcons.sidebar_left));
      await tester.pumpAndSettle();
      expect(controller.isVisible, isTrue);
      expect(tester.getTopLeft(find.byType(McToolBar)).dx, 220);
      await tester.pumpWidget(const SizedBox());
      controller.toggle(); // No shell listener remains after unmounting.
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('narrow toolbar keeps overflow available with large text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: McToolBar(
            title: const Text('很长很长的标题'),
            actions: [
              McToolBarIconButton(
                label: '带文字的操作',
                showLabel: true,
                icon: const Icon(CupertinoIcons.add),
                onPressed: () {},
              ),
            ],
          ),
        ),
        width: 180,
      ),
    );
    expect(find.byIcon(CupertinoIcons.chevron_right_2), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
