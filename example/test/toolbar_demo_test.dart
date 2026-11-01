import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luamris_ui/luamris_ui.dart';

import 'package:example/pages/toolbar_demo.dart';

void main() {
  testWidgets('toolbar demo creates a document and toggles its sidebar', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1100, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      CupertinoApp(
        builder: (context, child) => McThemeData.wrap(child: child!),
        home: const ToolbarDemo(),
      ),
    );
    await tester.tap(find.byIcon(CupertinoIcons.add));
    await tester.pumpAndSettle();
    expect(find.text('已新建文档，共 1 份'), findsOneWidget);
    await tester.tap(find.byIcon(CupertinoIcons.sidebar_left));
    await tester.pumpAndSettle();
    expect(find.byType(McSidebar), findsNothing);
    expect(find.byType(McToolBar), findsOneWidget);
    await tester.tap(find.byIcon(CupertinoIcons.sidebar_left));
    await tester.pumpAndSettle();
    expect(find.byType(McSidebar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
