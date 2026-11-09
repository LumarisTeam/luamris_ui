import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:example/pages/skeleton_demo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luamris_ui/luamris_ui.dart';

void main() {
  testWidgets('skeleton demo switches between loading and content', (
    tester,
  ) async {
    await tester.pumpWidget(
      CupertinoApp(
        builder: (context, child) => McThemeData.wrap(child: child!),
        home: const SkeletonDemo(),
      ),
    );
    expect(find.byType(McListItemSkeleton), findsNWidgets(2));
    await tester.tap(find.text('显示加载完成'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('课程通知'), findsOneWidget);
    expect(find.text('重新显示骨架屏'), findsOneWidget);
    await tester.tap(find.text('重新显示骨架屏'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(McListItemSkeleton), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
