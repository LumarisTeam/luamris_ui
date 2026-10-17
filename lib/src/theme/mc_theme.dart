import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

import 'mc_colors.dart';
import 'mc_radii.dart';
import 'mc_smooth_corners.dart';

/// Generates Material [ThemeData] and Cupertino wrappers from [McColors].
///
/// Use with [MaterialApp]:
/// ```dart
/// MaterialApp(
///   theme: McThemeData.materialTheme(McColors.light),
///   darkTheme: McThemeData.materialTheme(McColors.dark),
///   home: MyPage(),
/// );
/// ```
///
/// Use with [CupertinoApp]:
/// ```dart
/// CupertinoApp(
///   builder: (context, child) => McThemeData.wrap(child: child!),
///   home: MyPage(),
/// );
/// ```
abstract final class McThemeData {
  McThemeData._();

  /// Build a Material [ThemeData] from [colors].
  ///
  /// Includes a fully-configured [ColorScheme], component themes, and
  /// [cupertinoOverrideTheme] so Cupertino widgets render correctly inside
  /// a Material app.
  static ThemeData materialTheme(McColors colors) {
    final b = colors.brightness;
    final isLight = b == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: b,
      colorScheme: ColorScheme(
        brightness: b,
        primary: colors.primary,
        onPrimary: colors.onAccent,
        secondary: colors.primary,
        onSecondary: colors.onAccent,
        surface: colors.card,
        onSurface: colors.foreground,
        error: colors.destructive,
        onError: colors.onAccent,
        surfaceTint: Colors.transparent,
      ),
      scaffoldBackgroundColor: colors.groupedBackground,
      canvasColor: colors.groupedBackground,
      dividerColor: colors.separator,
      cardColor: colors.card,
      disabledColor: colors.tertiaryLabel,
      splashColor: colors.selectionFill,
      highlightColor: colors.selectionFill,
      hoverColor: colors.cardOverlay,
      shadowColor: colors.shadowColor,
      extensions: [colors],

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        backgroundColor: colors.groupedBackground,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colors.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),

      // ── Card ──
      cardTheme: CardThemeData(
        color: colors.card,
        surfaceTintColor: Colors.transparent,
        shape: McSmoothCorners.shape(
          McRadii.cardBorder,
          side: BorderSide(
            color: colors.separator.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),

      // ── Dialog ──
      // Radius intentionally stays 24: the glass dialog style is unchanged.
      dialogTheme: DialogThemeData(
        backgroundColor: colors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(McRadii.xl),
        ),
      ),

      // ── Bottom Sheet ──
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.card,
        modalBackgroundColor: colors.card,
        surfaceTintColor: Colors.transparent,
        shape: McSmoothCorners.shape(McRadii.sheetTopBorder),
      ),

      // ── SnackBar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.card,
        contentTextStyle: TextStyle(color: colors.cardForeground),
        actionTextColor: colors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(McRadii.lg),
          side: BorderSide(color: colors.separator.withValues(alpha: 0.1)),
        ),
      ),

      // ── Input ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(McRadii.navigation),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(McRadii.navigation),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(McRadii.navigation),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(McRadii.navigation),
          borderSide: BorderSide(color: colors.destructive),
        ),
      ),

      // ── List Tile ──
      listTileTheme: ListTileThemeData(
        iconColor: colors.secondaryLabel,
        textColor: colors.foreground,
      ),

      // ── Cupertino override ────────────────────────────────────────────
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: b,
        primaryColor: colors.primary,
        scaffoldBackgroundColor: colors.groupedBackground,
        barBackgroundColor: colors.groupedBackground.withValues(alpha: 0.94),
        textTheme: CupertinoTextThemeData(
          primaryColor: colors.primary,
          textStyle: TextStyle(color: colors.foreground),
        ),
      ),
    );
  }

  /// Wraps [child] in a [Theme] that injects [McColors] as a [ThemeExtension].
  ///
  /// When [colors] is omitted, the brightness is resolved from the ambient
  /// [CupertinoTheme] (so `CupertinoApp(theme: ...)` is respected), falling
  /// back to the platform brightness. Use this as the [CupertinoApp.builder]
  /// when you want [context.mc] to work without Material theming.
  ///
  /// ```dart
  /// CupertinoApp(
  ///   builder: (context, child) => McThemeData.wrap(child: child!),
  ///   home: MyPage(),
  /// );
  /// ```
  static Widget wrap({required Widget child, McColors? colors}) {
    return _McThemeWrapper(colors: colors, child: child);
  }
}

class _McThemeWrapper extends StatelessWidget {
  const _McThemeWrapper({required this.child, this.colors});

  final Widget child;
  final McColors? colors;

  @override
  Widget build(BuildContext context) {
    final resolved =
        colors ??
        ((CupertinoTheme.maybeBrightnessOf(context) ??
                    MediaQuery.platformBrightnessOf(context)) ==
                Brightness.dark
            ? McColors.dark
            : McColors.light);

    return Theme(data: McThemeData.materialTheme(resolved), child: child);
  }
}
