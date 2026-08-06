import 'package:flutter/cupertino.dart';

import 'mc_colors.dart';
import 'mc_radii.dart';
import 'mc_shadows.dart';

// =============================================================================
// One-stop theme access: context.mc
// =============================================================================

/// Extension on [BuildContext] that provides a single entry point to all
/// design tokens. Colors are automatically resolved via
/// [CupertinoDynamicColor] so they follow the ambient brightness.
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

/// Lazy theme reference. Resolves dynamic colors on each property access
/// so values always reflect the current [Brightness] of the owning context.
class McTheme {
  final BuildContext _context;
  const McTheme._(this._context);

  Color _r(Color c) => CupertinoDynamicColor.resolve(c, _context);

  // ── Colors ────────────────────────────────────────────────────────────────

  Color get primary           => _r(McColors.primary);
  Color get primaryForeground => _r(McColors.primaryForeground);
  Color get background        => _r(McColors.background);
  Color get foreground        => _r(McColors.foreground);
  Color get card              => _r(McColors.card);
  Color get cardForeground    => _r(McColors.cardForeground);
  Color get secondary         => _r(McColors.secondary);
  Color get secondaryForeground => _r(McColors.secondaryForeground);
  Color get muted             => _r(McColors.muted);
  Color get mutedForeground   => _r(McColors.mutedForeground);
  Color get border            => _r(McColors.border);
  Color get input             => _r(McColors.input);
  Color get destructive       => _r(McColors.destructive);
  Color get hot               => _r(McColors.hot);

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

  TextStyle get textBody => TextStyle(
        fontSize: 16,
        height: 1.5,
        color: foreground,
      );

  TextStyle get textMuted => TextStyle(
        fontSize: 14,
        height: 1.4,
        color: mutedForeground,
      );

  TextStyle get textLabel => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: mutedForeground,
      );

  // ── Radii ─────────────────────────────────────────────────────────────────

  double get radiusSm  => McRadii.sm;
  double get radiusMd  => McRadii.md;
  double get radiusLg  => McRadii.lg;
  double get radiusXl  => McRadii.xl;
  double get radiusXxl => McRadii.xxl;
  double get radiusPill => McRadii.pill;

  // ── Shadows ───────────────────────────────────────────────────────────────

  List<BoxShadow> get shadowCard => McShadows.card;
  List<BoxShadow> get shadowNone => McShadows.none;

  // ── Decorations ───────────────────────────────────────────────────────────

  /// Standard card surface with a subtle border.
  BoxDecoration cardDecoration({double? radius}) {
    final r = radius ?? McRadii.xl;
    return BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(r),
      border: Border.all(color: border.withValues(alpha: 0.5)),
    );
  }

  /// Glass-morphism surface — semi-transparent + border.
  BoxDecoration glassDecoration({double? radius}) {
    final r = radius ?? McRadii.xl;
    return BoxDecoration(
      color: card.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(r),
      border: Border.all(color: border.withValues(alpha: 0.3)),
    );
  }

  /// Muted / secondary surface without a border.
  BoxDecoration mutedDecoration({double? radius}) {
    final r = radius ?? McRadii.xl;
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
