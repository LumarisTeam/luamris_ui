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
  ///
  /// [fontFamily] is applied to the Material and Cupertino text themes.
  /// [locale] enables a 0.92 text scale for long-string languages such as
  /// German and Russian.
  static ThemeData materialTheme(
    McColors colors, {
    String? fontFamily,
    Locale? locale,
  }) {
    final b = colors.brightness;
    final isLight = b == Brightness.light;
    final shrink = _isLongTextLocale(locale);

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: b,
      fontFamily: fontFamily,
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
        titleTextStyle: TextStyle(
          color: colors.foreground,
          fontSize: shrink ? 16 : 18,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: colors.secondaryLabel,
          fontSize: shrink ? 13 : 14,
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
        contentTextStyle: TextStyle(
          color: colors.cardForeground,
          fontSize: shrink ? 13 : 14,
        ),
        actionTextColor: colors.primary,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: McSmoothCorners.shape(
          McRadii.cardBorder,
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

      // ── Tab bar ──
      tabBarTheme: TabBarThemeData(
        labelColor: colors.primary,
        unselectedLabelColor: colors.secondaryLabel,
        labelStyle: TextStyle(
          fontSize: shrink ? 14 : 15,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: shrink ? 14 : 15,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Cupertino override ────────────────────────────────────────────
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: b,
        primaryColor: colors.primary,
        scaffoldBackgroundColor: colors.groupedBackground,
        barBackgroundColor: colors.groupedBackground,
        textTheme: CupertinoTextThemeData(
          primaryColor: colors.primary,
          textStyle: TextStyle(
            color: colors.foreground,
            fontFamily: fontFamily,
          ),
        ),
      ),
    );

    return baseTheme.copyWith(
      textTheme: _buildTextTheme(baseTheme, colors.foreground, shrink),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colors.primary),
      ),
      iconTheme: IconThemeData(color: colors.foreground),
    );
  }

  /// Whether [locale] typically produces longer text strings (e.g. German,
  /// Russian) and benefits from a slightly smaller font size.
  static bool _isLongTextLocale(Locale? locale) {
    if (locale == null) return false;
    final lang = locale.languageCode;
    return lang == 'de' || lang == 'ru';
  }

  /// Builds the color text theme and, for long-text locales, merges the
  /// English-like geometry first so the 0.92 shrink has explicit font sizes
  /// to scale. Without the merge, [ThemeData.textTheme] carries no sizes until
  /// [Theme.of] localizes it, and scaling would be a no-op.
  static TextTheme _buildTextTheme(ThemeData theme, Color color, bool shrink) {
    final applied = theme.textTheme.apply(
      bodyColor: color,
      displayColor: color,
    );
    if (!shrink) return applied;

    final localized = theme.typography
        .geometryThemeFor(ScriptCategory.englishLike)
        .merge(applied);

    const double factor = 0.92;
    return TextTheme(
      displayLarge: _scaleStyle(localized.displayLarge, factor),
      displayMedium: _scaleStyle(localized.displayMedium, factor),
      displaySmall: _scaleStyle(localized.displaySmall, factor),
      headlineLarge: _scaleStyle(localized.headlineLarge, factor),
      headlineMedium: _scaleStyle(localized.headlineMedium, factor),
      headlineSmall: _scaleStyle(localized.headlineSmall, factor),
      titleLarge: _scaleStyle(localized.titleLarge, factor),
      titleMedium: _scaleStyle(localized.titleMedium, factor),
      titleSmall: _scaleStyle(localized.titleSmall, factor),
      bodyLarge: _scaleStyle(localized.bodyLarge, factor),
      bodyMedium: _scaleStyle(localized.bodyMedium, factor),
      bodySmall: _scaleStyle(localized.bodySmall, factor),
      labelLarge: _scaleStyle(localized.labelLarge, factor),
      labelMedium: _scaleStyle(localized.labelMedium, factor),
      labelSmall: _scaleStyle(localized.labelSmall, factor),
    );
  }

  static TextStyle? _scaleStyle(TextStyle? style, double factor) {
    if (style == null || style.fontSize == null) return style;
    return style.copyWith(fontSize: style.fontSize! * factor);
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
  static Widget wrap({
    required Widget child,
    McColors? colors,
    String? fontFamily,
    Locale? locale,
  }) {
    return _McThemeWrapper(
      colors: colors,
      fontFamily: fontFamily,
      locale: locale,
      child: child,
    );
  }
}

class _McThemeWrapper extends StatelessWidget {
  const _McThemeWrapper({
    required this.child,
    this.colors,
    this.fontFamily,
    this.locale,
  });

  final Widget child;
  final McColors? colors;
  final String? fontFamily;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    final resolved =
        colors ??
        ((CupertinoTheme.maybeBrightnessOf(context) ??
                    MediaQuery.platformBrightnessOf(context)) ==
                Brightness.dark
            ? McColors.dark
            : McColors.light);

    return Theme(
      data: McThemeData.materialTheme(
        resolved,
        fontFamily: fontFamily,
        locale: locale,
      ),
      child: child,
    );
  }
}
