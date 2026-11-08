import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luamris_ui/luamris_ui.dart';

import 'package:example/main.dart';

void main() {
  testWidgets('phone catalog groups demos and navigates to a preview', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const ExampleApp());

    expect(find.text('Luamris UI'), findsWidgets);
    expect(find.text('基础组件'), findsOneWidget);
    expect(find.text('输入与反馈'), findsOneWidget);
    expect(find.text('导航与布局'), findsOneWidget);
    expect(find.text('按钮 McButton'), findsOneWidget);
    await tester.tap(find.text('按钮 McButton'));
    await tester.pumpAndSettle();
    expect(find.text('确认提交'), findsOneWidget);
  });

  testWidgets('desktop switches previews while keeping the sidebar visible', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const ExampleApp());

    expect(find.byType(McSidebar), findsOneWidget);
    expect(find.text('确认提交'), findsOneWidget);
    await tester.tap(find.text('卡片 McCard'));
    await tester.pumpAndSettle();
    expect(find.byType(McSidebar), findsOneWidget);
    expect(find.text('确认提交'), findsNothing);
    expect(find.text('分组行一'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
