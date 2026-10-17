import 'package:cupertino_ui/cupertino_ui.dart';

/// Responsive breakpoints used by [McResponsive].
abstract final class McBreakpoints {
  /// Minimum width for tablet / narrow-desktop layouts.
  static const tablet = 768.0;

  /// Minimum width for wide desktop layouts.
  static const desktop = 1100.0;
}

/// Responsive layout helpers.
abstract final class McResponsive {
  /// True when the viewport is narrower than [McBreakpoints.tablet].
  static bool isPhone(BuildContext context) {
    return MediaQuery.sizeOf(context).width < McBreakpoints.tablet;
  }

  /// True when the viewport is at least [McBreakpoints.tablet] wide.
  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= McBreakpoints.tablet;
  }

  /// True when the viewport is at least [McBreakpoints.desktop] wide.
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= McBreakpoints.desktop;
  }

  /// True when a two-pane layout should be used (alias for [isDesktop]).
  static bool isWideTwoPane(BuildContext context) {
    return isDesktop(context);
  }

  /// Recommended maximum content width for the current breakpoint.
  static double contentMaxWidth(BuildContext context, {double? fallback}) {
    if (isDesktop(context)) return fallback ?? 1180;
    if (isTablet(context)) return fallback ?? 720;
    return fallback ?? double.infinity;
  }

  /// Recommended maximum form width.
  static double formMaxWidth(BuildContext context) {
    return isDesktop(context) ? 980 : contentMaxWidth(context, fallback: 720);
  }

  /// Recommended maximum width for readable text blocks.
  static double readableMaxWidth(BuildContext context, {double? fallback}) {
    if (isDesktop(context)) return fallback ?? 920;
    if (isTablet(context)) return fallback ?? 720;
    return fallback ?? double.infinity;
  }

  /// Maximum width for modal sheets.
  static double sheetMaxWidth(BuildContext context) {
    return isPhone(context) ? double.infinity : 560;
  }

  /// Recommended width for a side pane in two-pane layouts.
  static double sidePaneWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1280) return 360;
    return 320;
  }

  /// Gap between panes in two-pane layouts.
  static double twoPaneGap(BuildContext context) {
    return isDesktop(context) ? 24 : 16;
  }

  /// Column count for list / grid layouts.
  static int listColumnCount(BuildContext context) {
    return isDesktop(context) ? 2 : 1;
  }

  /// Responsive horizontal padding.
  static double horizontalPadding(
    BuildContext context, {
    double narrow = 16,
    double tablet = 24,
    double desktop = 28,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return narrow;
  }

  /// Responsive page-level padding (horizontal + vertical).
  static EdgeInsets pagePadding(
    BuildContext context, {
    double narrow = 16,
    double wide = 24,
  }) {
    final horizontal = horizontalPadding(
      context,
      narrow: narrow,
      tablet: wide,
      desktop: wide,
    );
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: isTablet(context) ? wide : narrow,
    );
  }

  /// Responsive padding suitable for sliver-based pages.
  static EdgeInsets sliverPagePadding(
    BuildContext context, {
    double top = 12,
    double bottom = 24,
    double narrow = 16,
    double wide = 24,
  }) {
    final horizontal = horizontalPadding(
      context,
      narrow: narrow,
      tablet: wide,
      desktop: wide,
    );
    return EdgeInsets.fromLTRB(horizontal, top, horizontal, bottom);
  }
}
