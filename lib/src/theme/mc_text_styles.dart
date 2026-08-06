import 'package:flutter/cupertino.dart';

import 'mc_colors.dart';

/// Typography scale for the design system.
///
/// All methods require a [BuildContext] because colors are resolved
/// via [CupertinoDynamicColor] for automatic light/dark mode support.
abstract final class McTextStyles {
  /// Hero / large display text — 32px, weight 800.
  static TextStyle hero(BuildContext context) => TextStyle(
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.w800,
    color: CupertinoDynamicColor.resolve(McColors.foreground, context),
    letterSpacing: -0.5,
  );

  /// Page / section title — 24px, weight 700.
  static TextStyle title(BuildContext context) => TextStyle(
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: CupertinoDynamicColor.resolve(McColors.foreground, context),
    letterSpacing: -0.4,
  );

  /// Sub-section title — 18px, weight 700.
  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: CupertinoDynamicColor.resolve(McColors.foreground, context),
    letterSpacing: -0.2,
  );

  /// Body text — 16px, normal weight.
  static TextStyle body(BuildContext context) => TextStyle(
    fontSize: 16,
    height: 1.5,
    color: CupertinoDynamicColor.resolve(McColors.foreground, context),
  );

  /// Muted / caption text — 14px, normal weight.
  static TextStyle muted(BuildContext context) => TextStyle(
    fontSize: 14,
    height: 1.4,
    color: CupertinoDynamicColor.resolve(McColors.mutedForeground, context),
  );

  /// Label / badge text — 12px, weight 600.
  static TextStyle label(BuildContext context) => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: CupertinoDynamicColor.resolve(McColors.mutedForeground, context),
  );
}
