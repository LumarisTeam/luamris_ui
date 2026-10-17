import 'package:material_ui/material_ui.dart';
import 'package:smooth_corner/smooth_corner.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

void main() {
  group('McSmoothCorners.effectiveSmoothness', () {
    test('large corners use the smooth value', () {
      expect(
        McSmoothCorners.effectiveSmoothness(BorderRadius.circular(18)),
        mcCornerSmoothness,
      );
    });

    test('small corners use the compact value', () {
      expect(
        McSmoothCorners.effectiveSmoothness(BorderRadius.circular(8)),
        mcCompactCornerSmoothness,
      );
    });

    test('the threshold is inclusive', () {
      expect(
        McSmoothCorners.effectiveSmoothness(BorderRadius.circular(12)),
        mcCompactCornerSmoothness,
      );
    });

    test('a visible border forces the compact value', () {
      expect(
        McSmoothCorners.effectiveSmoothness(
          BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xFF000000), width: 1),
        ),
        mcCompactCornerSmoothness,
      );
    });

    test('mixed corners use the smallest radius', () {
      const radius = BorderRadius.only(
        topLeft: Radius.circular(18),
        topRight: Radius.circular(18),
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(18),
      );
      expect(
        McSmoothCorners.effectiveSmoothness(radius),
        mcCompactCornerSmoothness,
      );
    });
  });

  group('McSmoothCorners.shape', () {
    test('returns a SmoothRectangleBorder with the expected radius', () {
      final shape = McSmoothCorners.shape(McRadii.cardBorder);
      expect(shape, isA<SmoothRectangleBorder>());
      expect(shape.borderRadius, McRadii.cardBorder);
      expect(shape.smoothness, mcCornerSmoothness);
    });

    test('uses compact smoothness for compact radii', () {
      final shape = McSmoothCorners.shape(McRadii.controlBorder);
      expect(shape.smoothness, mcCompactCornerSmoothness);
    });

    test('honours an explicit smoothness override', () {
      final shape = McSmoothCorners.shape(McRadii.cardBorder, smoothness: 0.3);
      expect(shape.smoothness, 0.3);
    });
  });
}
