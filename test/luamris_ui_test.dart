import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

void main() {
  group('McColors', () {
    test('light primary uses iOS system blue', () {
      expect(McColors.light.primary.toARGB32(), 0xFF007AFF);
    });

    test('dark primary uses iOS system blue', () {
      expect(McColors.dark.primary.toARGB32(), 0xFF0A84FF);
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

    test('iOS-style aliases resolve to their canonical tokens', () {
      expect(McColors.light.appBackground, McColors.light.background);
      expect(McColors.light.cardBackground, McColors.light.card);
      expect(McColors.light.label, McColors.light.foreground);
      expect(McColors.light.danger, McColors.light.destructive);
    });

    test('new iOS surface and accent tokens are populated', () {
      expect(McColors.light.groupedBackground.toARGB32(), 0xFFF8F8F8);
      expect(McColors.dark.groupedBackground.toARGB32(), 0xFF000000);
      expect(McColors.light.indigo.toARGB32(), 0xFF5856D6);
      expect(McColors.dark.pink.toARGB32(), 0xFFFF375F);
      expect(McColors.light.selectionFill.toARGB32(), 0x1F787880);
      expect(McColors.dark.shadowColor.toARGB32(), 0x00000000);
    });

    test('copyWith returns new instance with updated field', () {
      final modified = McColors.light.copyWith(
        primary: const Color(0xFFFF0000),
      );
      expect(modified.primary.toARGB32(), 0xFFFF0000);
      expect(
        modified.background.toARGB32(),
        McColors.light.background.toARGB32(),
      );
    });

    test('copyWith supports newly added tokens', () {
      final modified = McColors.light.copyWith(
        indigo: const Color(0xFF112233),
        groupedBackground: const Color(0xFFABCDEF),
      );
      expect(modified.indigo.toARGB32(), 0xFF112233);
      expect(modified.groupedBackground.toARGB32(), 0xFFABCDEF);
      expect(modified.purple, McColors.light.purple);
    });

    test('lerp returns intermediate color', () {
      final result = McColors.light.lerp(McColors.dark, 0.5);
      expect(result.primary, isA<Color>());
      expect(result.background, isA<Color>());
      expect(result.surfaceSunken, isA<Color>());
    });

    test('brightness detects light correctly', () {
      expect(McColors.light.brightness, Brightness.light);
    });

    test('brightness detects dark correctly', () {
      expect(McColors.dark.brightness, Brightness.dark);
    });
  });

  group('McRadii', () {
    test('numeric scale has expected values', () {
      expect(McRadii.xs, 4);
      expect(McRadii.sm, 8);
      expect(McRadii.md, 12);
      expect(McRadii.lg, 16);
      expect(McRadii.xl, 24);
      expect(McRadii.xxl, 32);
      expect(McRadii.pill, 999);
    });

    test('semantic scale has expected values', () {
      expect(McRadii.control, 8);
      expect(McRadii.navigation, 12);
      expect(McRadii.panel, 16);
      expect(McRadii.card, 18);
      expect(McRadii.tile, 22);
      expect(McRadii.sheetTop, 18);
      expect(McRadii.handle, 2.5);
      expect(McRadii.indicator, 2);
    });

    test('border radius shortcuts match the scale', () {
      expect(McRadii.cardBorder, BorderRadius.circular(18));
      expect(McRadii.tileBorder, BorderRadius.circular(22));
      expect(
        McRadii.sheetTopBorder,
        const BorderRadius.vertical(top: Radius.circular(18)),
      );
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
      expect(McSmoothCorners.shape, isA<Object>());
      expect(showMcDialog, isA<Object>());
      expect(showMcConfirmDialog, isA<Object>());
      expect(showMcInputDialog, isA<Object>());
    });
  });
}
