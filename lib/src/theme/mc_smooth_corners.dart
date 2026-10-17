import 'package:material_ui/material_ui.dart';
import 'package:smooth_corner/smooth_corner.dart';

/// Corner smoothness for large surfaces (cards, sheets).
const double mcCornerSmoothness = 0.8;

/// Corner smoothness for compact controls and bordered surfaces.
const double mcCompactCornerSmoothness = 0.6;

/// Radii at or below this value use [mcCompactCornerSmoothness].
const double mcSmallCornerThreshold = 12;

/// Smooth (Apple-style squircle) corner helpers.
///
/// Mirrors the smooth-corner utilities used by the iOS apps so every surface
/// shares the same silhouette.
abstract final class McSmoothCorners {
  const McSmoothCorners._();

  /// Build a smooth [ShapeBorder] usable in [ShapeDecoration], [CardTheme],
  /// [DialogTheme], [BottomSheetTheme], etc.
  static SmoothRectangleBorder shape(
    BorderRadiusGeometry borderRadius, {
    BorderSide side = BorderSide.none,
    double? smoothness,
  }) {
    return SmoothRectangleBorder(
      borderRadius: borderRadius,
      side: side,
      smoothness: smoothness ?? effectiveSmoothness(borderRadius, side: side),
    );
  }

  /// Resolve a possibly direction-dependent [BorderRadiusGeometry].
  static BorderRadius resolve(
    BuildContext context,
    BorderRadiusGeometry borderRadius,
  ) {
    return borderRadius.resolve(Directionality.of(context));
  }

  /// Clip [child] with a smooth-corner shape.
  static SmoothClipRRect clip({
    Key? key,
    required BorderRadius borderRadius,
    BorderSide side = BorderSide.none,
    double? smoothness,
    required Widget child,
  }) {
    return SmoothClipRRect(
      key: key,
      borderRadius: borderRadius,
      side: side,
      smoothness: smoothness ?? effectiveSmoothness(borderRadius, side: side),
      child: child,
    );
  }

  /// Pick a smoothness value for the given radius / border combination.
  static double effectiveSmoothness(
    BorderRadiusGeometry borderRadius, {
    BorderSide side = BorderSide.none,
  }) {
    if (_hasVisibleBorder(side) || _isCompactRadius(borderRadius)) {
      return mcCompactCornerSmoothness;
    }
    return mcCornerSmoothness;
  }

  static bool _hasVisibleBorder(BorderSide side) {
    return side.style != BorderStyle.none && side.width > 0;
  }

  static bool _isCompactRadius(BorderRadiusGeometry borderRadius) {
    final resolved = borderRadius.resolve(TextDirection.ltr);
    final radii = <Radius>[
      resolved.topLeft,
      resolved.topRight,
      resolved.bottomLeft,
      resolved.bottomRight,
    ];

    return radii.any((radius) {
      final shortestAxis = radius.x < radius.y ? radius.x : radius.y;
      return shortestAxis > 0 && shortestAxis <= mcSmallCornerThreshold;
    });
  }
}
