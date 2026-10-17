import 'package:material_ui/material_ui.dart';
import 'package:smooth_corner/smooth_corner.dart';

import 'mc_colors.dart';
import 'mc_radii.dart';
import 'mc_shadows.dart';
import 'mc_smooth_corners.dart';

// =============================================================================
// One-stop theme access: context.mc
// =============================================================================

/// Extension on [BuildContext] that provides a single entry point to all
/// design tokens. Colors are resolved from the ambient [McColors]
/// [ThemeExtension] so they follow the current brightness automatically.
///
/// ```dart
/// final bg = context.mc.background;
/// final titleStyle = context.mc.textTitle;
/// final card = context.mc.cardDecoration();
/// ```
extension McContext on BuildContext {
  /// Theme accessor — use `context.mc.xxx` anywhere in the widget tree.
  McTheme get mc => McTheme._(this);
}

/// Lazy theme reference. Reads color tokens from [McColors] via
/// [ThemeExtension] so values always reflect the current [Brightness]
/// of the owning context.
class McTheme {
  final BuildContext _context;
  const McTheme._(this._context);

  McColors get _colors {
    final theme = Theme.of(_context);
    return theme.extension<McColors>() ??
        (theme.brightness == Brightness.dark ? McColors.dark : McColors.light);
  }

  /// Raw token set.
  ///
  /// Drop-in replacement for callers migrating from a `context.clubColors`
  /// style API: values follow the ambient brightness automatically.
  McColors get colors => _colors;

  /// Current resolved brightness.
  Brightness get brightness => _colors.brightness;

  // ── Colors ────────────────────────────────────────────────────────────────

  Color get primary => _colors.primary;
  Color get primarySoft => _colors.primarySoft;
  Color get primaryForeground => _colors.primaryForeground;
  Color get background => _colors.background;
  Color get groupedBackground => _colors.groupedBackground;
  Color get foreground => _colors.foreground;
  Color get secondaryLabel => _colors.secondaryLabel;
  Color get tertiaryLabel => _colors.tertiaryLabel;
  Color get quaternaryLabel => _colors.quaternaryLabel;
  Color get inverseLabel => _colors.inverseLabel;
  Color get card => _colors.card;
  Color get cardOverlay => _colors.cardOverlay;
  Color get cardForeground => _colors.cardForeground;
  Color get secondary => _colors.secondary;
  Color get secondaryForeground => _colors.secondaryForeground;
  Color get muted => _colors.muted;
  Color get mutedForeground => _colors.secondaryLabel; // legacy alias
  Color get surfaceRaised => _colors.surfaceRaised;
  Color get surfaceMuted => _colors.surfaceMuted;
  Color get surfaceSunken => _colors.surfaceSunken;
  Color get separator => _colors.separator;
  Color get border => _colors.border;
  Color get borderStrong => _colors.borderStrong;
  Color get input => _colors.input;
  Color get success => _colors.success;
  Color get successSoft => _colors.successSoft;
  Color get warning => _colors.warning;
  Color get warningSoft => _colors.warningSoft;
  Color get destructive => _colors.destructive;
  Color get dangerSoft => _colors.dangerSoft;
  Color get indigo => _colors.indigo;
  Color get purple => _colors.purple;
  Color get pink => _colors.pink;
  Color get cyan => _colors.cyan;
  Color get yellow => _colors.yellow;
  Color get indigoSoft => _colors.indigoSoft;
  Color get purpleSoft => _colors.purpleSoft;
  Color get pinkSoft => _colors.pinkSoft;
  Color get cyanSoft => _colors.cyanSoft;
  Color get yellowSoft => _colors.yellowSoft;
  Color get onAccent => _colors.onAccent;
  Color get selectionFill => _colors.selectionFill;
  Color get shadowColor => _colors.shadowColor;
  Color get skeletonBase => _colors.skeletonBase;
  Color get skeletonHighlight => _colors.skeletonHighlight;
  Color get hot => _colors.hot;

  // iOS-style aliases
  Color get appBackground => _colors.appBackground;
  Color get cardBackground => _colors.cardBackground;
  Color get label => _colors.label;
  Color get danger => _colors.danger;

  // ── Text styles ───────────────────────────────────────────────────────────

  TextStyle get textHero => TextStyle(
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.w800,
    color: foreground,
    letterSpacing: -0.5,
  );

  TextStyle get textTitle => TextStyle(
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: foreground,
    letterSpacing: -0.4,
  );

  TextStyle get textSection => TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: foreground,
    letterSpacing: -0.2,
  );

  TextStyle get textBody =>
      TextStyle(fontSize: 16, height: 1.5, color: foreground);

  TextStyle get textMuted =>
      TextStyle(fontSize: 14, height: 1.4, color: mutedForeground);

  TextStyle get textLabel => TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: mutedForeground,
  );

  // ── Radii ─────────────────────────────────────────────────────────────────

  double get radiusXs => McRadii.xs;
  double get radiusSm => McRadii.sm;
  double get radiusMd => McRadii.md;
  double get radiusLg => McRadii.lg;
  double get radiusXl => McRadii.xl;
  double get radiusXxl => McRadii.xxl;
  double get radiusPill => McRadii.pill;
  double get radiusControl => McRadii.control;
  double get radiusNavigation => McRadii.navigation;
  double get radiusPanel => McRadii.panel;
  double get radiusCard => McRadii.card;
  double get radiusTile => McRadii.tile;
  double get radiusSheetTop => McRadii.sheetTop;
  double get radiusHandle => McRadii.handle;
  double get radiusIndicator => McRadii.indicator;

  // ── Shadows ───────────────────────────────────────────────────────────────

  List<BoxShadow> get shadowCard => McShadows.card;
  List<BoxShadow> get shadowNone => McShadows.none;

  /// Card shadow, only visible in light mode (matches the iOS apps).
  List<BoxShadow> get cardShadow => brightness == Brightness.light
      ? [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ]
      : const [];

  // ── Shapes ────────────────────────────────────────────────────────────────

  /// Smooth-corner card shape with an optional border.
  SmoothRectangleBorder cardShape({
    double radius = McRadii.card,
    BorderSide side = BorderSide.none,
  }) {
    return McSmoothCorners.shape(BorderRadius.circular(radius), side: side);
  }

  // ── Decorations ───────────────────────────────────────────────────────────

  /// Standard card surface with a subtle border.
  BoxDecoration cardDecoration({double? radius}) {
    final r = radius ?? McRadii.card;
    return BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(r),
      border: Border.all(color: border.withValues(alpha: 0.5)),
    );
  }

  /// Glass-morphism surface — semi-transparent + border.
  BoxDecoration glassDecoration({double? radius}) {
    final r = radius ?? McRadii.card;
    return BoxDecoration(
      color: card.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(r),
      border: Border.all(color: border.withValues(alpha: 0.3)),
    );
  }

  /// Muted / secondary surface without a border.
  BoxDecoration mutedDecoration({double? radius}) {
    final r = radius ?? McRadii.panel;
    return BoxDecoration(
      color: secondary,
      borderRadius: BorderRadius.circular(r),
    );
  }

  /// Pill-shaped container — ideal for badges, chips, and tags.
  BoxDecoration pillDecoration({Color? background, bool showBorder = false}) {
    return BoxDecoration(
      color: background ?? secondary,
      borderRadius: BorderRadius.circular(McRadii.pill),
      border: showBorder
          ? Border.all(color: border.withValues(alpha: 0.45))
          : null,
    );
  }
}
