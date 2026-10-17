import 'package:material_ui/material_ui.dart';

import 'mc_context.dart';
import 'mc_radii.dart';
import 'mc_smooth_corners.dart';

/// Pre-built [BoxDecoration] factories for common surface styles.
///
/// These use standard rounded corners. For the smooth (squircle) silhouette
/// used by the built-in widgets, use the `smooth*` factories below.
abstract final class McDecorations {
  /// Standard card surface with a subtle border.
  static BoxDecoration card(
    BuildContext context, {
    double radius = McRadii.card,
  }) {
    final m = context.mc;
    return BoxDecoration(
      color: m.card,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: m.border.withValues(alpha: 0.5)),
    );
  }

  /// Muted / secondary card surface without a border.
  static BoxDecoration mutedCard(
    BuildContext context, {
    double radius = McRadii.panel,
  }) {
    final m = context.mc;
    return BoxDecoration(
      color: m.secondary,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Glass-morphism surface — semi-transparent with a subtle border.
  static BoxDecoration glass(
    BuildContext context, {
    double radius = McRadii.card,
  }) {
    final m = context.mc;
    return BoxDecoration(
      color: m.card.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: m.border.withValues(alpha: 0.3)),
    );
  }

  /// Pill-shaped container — ideal for badges, chips, and tags.
  static BoxDecoration pill(
    BuildContext context, {
    Color? background,
    Color? border,
    bool showBorder = false,
  }) {
    final m = context.mc;
    final bg = background ?? m.secondary;
    final bd = border ?? m.border;
    return BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(McRadii.pill),
      border: showBorder ? Border.all(color: bd.withValues(alpha: 0.45)) : null,
    );
  }

  // ── Smooth-corner variants ────────────────────────────────────────────────

  /// Smooth-corner card surface with a hairline border.
  static ShapeDecoration smoothCard(
    BuildContext context, {
    double radius = McRadii.card,
    BorderSide? side,
    List<BoxShadow>? shadows,
  }) {
    final m = context.mc;
    return ShapeDecoration(
      color: m.card,
      shape: McSmoothCorners.shape(
        BorderRadius.circular(radius),
        side:
            side ??
            BorderSide(color: m.separator.withValues(alpha: 0.1), width: 0.5),
      ),
      shadows: shadows,
    );
  }

  /// Smooth-corner glass surface.
  static ShapeDecoration smoothGlass(
    BuildContext context, {
    double radius = McRadii.card,
    BorderSide? side,
  }) {
    final m = context.mc;
    return ShapeDecoration(
      color: m.card.withValues(alpha: 0.7),
      shape: McSmoothCorners.shape(
        BorderRadius.circular(radius),
        side:
            side ??
            BorderSide(color: m.border.withValues(alpha: 0.3), width: 0.5),
      ),
    );
  }

  /// Smooth-corner muted surface without a border.
  static ShapeDecoration smoothMutedCard(
    BuildContext context, {
    double radius = McRadii.panel,
  }) {
    final m = context.mc;
    return ShapeDecoration(
      color: m.secondary,
      shape: McSmoothCorners.shape(BorderRadius.circular(radius)),
    );
  }
}
