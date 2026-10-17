import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

void main() {
  test('scaffold uses the grouped iOS background', () {
    final theme = McThemeData.materialTheme(McColors.light);
    expect(theme.scaffoldBackgroundColor, McColors.light.groupedBackground);
    expect(theme.canvasColor, McColors.light.groupedBackground);
  });

  test('card theme uses a smooth 18px radius', () {
    final shape = McThemeData.materialTheme(McColors.light).cardTheme.shape;
    expect(shape, isA<SmoothRectangleBorder>());
    expect((shape as SmoothRectangleBorder).borderRadius, McRadii.cardBorder);
  });

  test('dialog theme keeps the circular 24px radius', () {
    final shape = McThemeData.materialTheme(McColors.light).dialogTheme.shape;
    expect(shape, isA<RoundedRectangleBorder>());
    expect(
      (shape as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(McRadii.xl),
    );
  });

  test('bottom sheet uses smooth top corners', () {
    final shape = McThemeData.materialTheme(McColors.light)
        .bottomSheetTheme
        .shape;
    expect(shape, isA<SmoothRectangleBorder>());
    expect(
      (shape as SmoothRectangleBorder).borderRadius,
      McRadii.sheetTopBorder,
    );
  });

  test('input decoration uses the navigation radius', () {
    final border =
        McThemeData.materialTheme(McColors.light).inputDecorationTheme.border
            as OutlineInputBorder;
    expect(border.borderRadius, BorderRadius.circular(McRadii.navigation));
  });

  testWidgets('wrap honours an explicit color scheme', (tester) async {
    ThemeData? captured;
    await tester.pumpWidget(
      McThemeData.wrap(
        colors: McColors.dark,
        child: Builder(
          builder: (context) {
            captured = Theme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(captured!.brightness, Brightness.dark);
    expect(captured!.extension<McColors>(), McColors.dark);
  });

  testWidgets('wrap resolves brightness from the CupertinoTheme', (
    tester,
  ) async {
    ThemeData? captured;
    await tester.pumpWidget(
      CupertinoApp(
        theme: const CupertinoThemeData(brightness: Brightness.dark),
        builder: (context, child) => McThemeData.wrap(child: child!),
        home: Builder(
          builder: (context) {
            captured = Theme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(captured!.brightness, Brightness.dark);
    expect(captured!.extension<McColors>(), McColors.dark);
  });
}
