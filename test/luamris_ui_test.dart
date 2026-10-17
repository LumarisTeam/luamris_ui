import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

void main() {
  group('McColors', () {
    test('light primary is correct hex value', () {
      expect(McColors.light.primary.toARGB32(), 0xFF0071E3);
    });

    test('dark primary is correct hex value', () {
      expect(McColors.dark.primary.toARGB32(), 0xFF0071E3);
    });

    test('light primaryForeground is white', () {
      expect(McColors.light.primaryForeground.toARGB32(), 0xFFFFFFFF);
    });

    test('hot is correct hex value', () {
      expect(McColors.light.hot.toARGB32(), 0xFFFF7A00);
    });

    test('light and dark have different backgrounds', () {
      expect(
        McColors.light.background.toARGB32(),
        isNot(McColors.dark.background.toARGB32()),
      );
    });

    test('copyWith returns new instance with updated field', () {
      final modified = McColors.light.copyWith(
        primary: const Color(0xFFFF0000),
      );
      expect(modified.primary.toARGB32(), 0xFFFF0000);
      expect(modified.background.toARGB32(),
          McColors.light.background.toARGB32());
    });

    test('lerp returns intermediate color', () {
      final result = McColors.light.lerp(McColors.dark, 0.5);
      expect(result.primary, isA<Color>());
      expect(result.background, isA<Color>());
    });

    test('brightness detects light correctly', () {
      expect(McColors.light.brightness, Brightness.light);
    });

    test('brightness detects dark correctly', () {
      expect(McColors.dark.brightness, Brightness.dark);
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

  group('McThemeData', () {
    test('materialTheme returns ThemeData of correct brightness', () {
      final lightTheme = McThemeData.materialTheme(McColors.light);
      final darkTheme = McThemeData.materialTheme(McColors.dark);

      expect(lightTheme.brightness, Brightness.light);
      expect(darkTheme.brightness, Brightness.dark);
    });

    test('materialTheme includes McColors extension', () {
      final theme = McThemeData.materialTheme(McColors.light);
      final extension = theme.extensions[McColors];
      expect(extension, isA<McColors>());
    });
  });

  group('Barrel export', () {
    test('all public classes are importable', () {
      expect(McColors.light.primary, isA<Object>());
      expect(McRadii.xl, isA<Object>());
      expect(McShadows.card, isA<Object>());
      expect(McFeedback.showInfo, isA<Object>());
      expect(McBreakpoints.tablet, isA<Object>());
      expect(McThemeData.materialTheme, isA<Object>());
    });
  });
}
