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

  test('fontFamily is applied to the text theme', () {
    final theme = McThemeData.materialTheme(
      McColors.light,
      fontFamily: 'Courier',
    );
    expect(theme.textTheme.bodyMedium?.fontFamily, 'Courier');
  });

  test('long-text locales shrink the text theme', () {
    final en = McThemeData.materialTheme(
      McColors.light,
      locale: const Locale('en'),
    );
    final de = McThemeData.materialTheme(
      McColors.light,
      locale: const Locale('de'),
    );
    // Non-shrink locales keep the unlocalized color theme (no font sizes);
    // shrink locales carry explicit, scaled geometry.
    expect(en.textTheme.bodyMedium?.fontSize, isNull);
    expect(de.textTheme.bodyMedium!.fontSize!, closeTo(14 * 0.92, 0.01));
  });

  test('tab bar theme follows the iOS palette', () {
    final tabBar = McThemeData.materialTheme(McColors.light).tabBarTheme;
    expect(tabBar.labelColor, McColors.light.primary);
    expect(tabBar.unselectedLabelColor, McColors.light.secondaryLabel);
    expect(tabBar.dividerColor, Colors.transparent);
  });

  test('dialog text styles follow the iOS palette', () {
    final dialog = McThemeData.materialTheme(McColors.dark).dialogTheme;
    expect(dialog.titleTextStyle?.color, McColors.dark.foreground);
    expect(dialog.contentTextStyle?.color, McColors.dark.secondaryLabel);
  });

  test('snack bar is flat with a smooth card shape', () {
    final snackBar = McThemeData.materialTheme(McColors.light).snackBarTheme;
    expect(snackBar.elevation, 0);
    expect(snackBar.contentTextStyle?.fontSize, 14);
    expect(snackBar.shape, isA<SmoothRectangleBorder>());
    expect(
      (snackBar.shape as SmoothRectangleBorder).borderRadius,
      McRadii.cardBorder,
    );
  });

  testWidgets('context.mc.colors falls back to dark tokens', (tester) async {
    late McColors colors;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        home: Builder(
          builder: (context) {
            colors = context.mc.colors;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(colors, same(McColors.dark));
  });

  testWidgets('wrap forwards fontFamily and locale', (tester) async {
    ThemeData? captured;
    await tester.pumpWidget(
      McThemeData.wrap(
        fontFamily: 'Courier',
        locale: const Locale('ru'),
        child: Builder(
          builder: (context) {
            captured = Theme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(captured!.textTheme.bodyMedium?.fontFamily, 'Courier');
    expect(captured!.textTheme.bodyMedium!.fontSize, closeTo(14 * 0.92, 0.01));
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
