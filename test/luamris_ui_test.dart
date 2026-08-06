import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

void main() {
  group('McColors', () {
    test('primary is correct hex value', () {
      expect(McColors.primary.toARGB32(), 0xFF0071E3);
    });

    test('primaryForeground is white', () {
      expect(McColors.primaryForeground.toARGB32(), 0xFFFFFFFF);
    });

    test('hot is correct hex value', () {
      expect(McColors.hot.toARGB32(), 0xFFFF7A00);
    });
  });

  group('McRadii', () {
    test('has expected values', () {
      expect(McRadii.sm, 8);
      expect(McRadii.md, 12);
      expect(McRadii.lg, 16);
      expect(McRadii.xl, 24);
      expect(McRadii.xxl, 32);
      expect(McRadii.pill, 999);
    });
  });

  group('McBreakpoints', () {
    test('has expected values', () {
      expect(McBreakpoints.tablet, 768.0);
      expect(McBreakpoints.desktop, 1100.0);
    });
  });

  group('McColorManager', () {
    test('same key produces same color', () {
      final a = McColorManager.generateSoftColor('test-key');
      final b = McColorManager.generateSoftColor('test-key');
      expect(a.toARGB32(), b.toARGB32());
    });

    test('different keys produce different colors', () {
      final a = McColorManager.generateSoftColor('key-a');
      final b = McColorManager.generateSoftColor('key-b');
      expect(a.toARGB32(), isNot(b.toARGB32()));
    });
  });

  group('Barrel export', () {
    test('all public classes are importable', () {
      expect(McColors.primary, isA<Object>());
      expect(McRadii.xl, isA<Object>());
      expect(McShadows.card, isA<Object>());
      expect(McFeedback.showInfo, isA<Object>());
      expect(McBreakpoints.tablet, isA<Object>());
    });
  });
}
