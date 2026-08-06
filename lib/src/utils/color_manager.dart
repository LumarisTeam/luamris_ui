import 'package:flutter/cupertino.dart';

/// Deterministic soft-color generator from a hash.
///
/// Useful for generating consistent avatar background colors or tag tints
/// based on a user ID, name, or any other stable key.
class McColorManager {
  /// Generates a low-saturation, medium-lightness color from [key]'s hash.
  ///
  /// The same [key] always produces the same color.
  static Color generateSoftColor(Object key, {bool isDark = false}) {
    final hashCode = key.hashCode;
    final hue = (hashCode % 360).toDouble();
    const saturation = 0.4;
    const lightness = 0.6;
    return HSLColor.fromAHSL(isDark ? 1 : 0.75, hue, saturation, lightness)
        .toColor();
  }
}
