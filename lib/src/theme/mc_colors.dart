import 'package:flutter/cupertino.dart';

/// Apple-style semantic color tokens with built-in light/dark mode support
/// via [CupertinoDynamicColor].
abstract final class McColors {
  /// Primary accent color (static — same in both modes).
  static const Color primary = Color(0xFF0071E3);

  /// Text/icon color on primary backgrounds.
  static const Color primaryForeground = Color(0xFFFFFFFF);

  /// Main background color.
  static const Color background = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF000000),
  );

  /// Primary text/icon color.
  static const Color foreground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF1D1D1F),
    darkColor: Color(0xFFF5F5F7),
  );

  /// Card / elevated surface background.
  static const Color card = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFFFFFF),
    darkColor: Color(0xFF1C1C1E),
  );

  /// Card foreground (text/icons on cards).
  static const Color cardForeground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF1D1D1F),
    darkColor: Color(0xFFF5F5F7),
  );

  /// Secondary / grouped background.
  static const Color secondary = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF5F5F7),
    darkColor: Color(0xFF2C2C2E),
  );

  /// Text/icon color on secondary backgrounds.
  static const Color secondaryForeground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF1D1D1F),
    darkColor: Color(0xFFF5F5F7),
  );

  /// Muted / tertiary surface.
  static const Color muted = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF5F5F7),
    darkColor: Color(0xFF2C2C2E),
  );

  /// Muted foreground for captions and secondary text.
  static const Color mutedForeground = CupertinoDynamicColor.withBrightness(
    color: Color(0xFF86868B),
    darkColor: Color(0xFF86868B),
  );

  /// Border / separator color.
  static const Color border = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFE5E5E7),
    darkColor: Color(0xFF2C2C2E),
  );

  /// Input field background.
  static const Color input = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFF5F5F7),
    darkColor: Color(0xFF1C1C1E),
  );

  /// Destructive / danger color.
  static const Color destructive = CupertinoDynamicColor.withBrightness(
    color: Color(0xFFFF3B30),
    darkColor: Color(0xFFFF453A),
  );

  /// Hot / trending accent (static — same in both modes).
  static const Color hot = Color(0xFFFF7A00);
}
