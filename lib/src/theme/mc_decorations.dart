import 'package:material_ui/material_ui.dart';

import 'mc_context.dart';
import 'mc_radii.dart';

/// Pre-built [BoxDecoration] factories for common surface styles.
abstract final class McDecorations {
  /// Standard card surface with a subtle border.
  static BoxDecoration card(BuildContext context, {double radius = McRadii.xl}) {
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
    double radius = McRadii.xl,
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
    double radius = McRadii.xl,
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
      border: showBorder
          ? Border.all(color: bd.withValues(alpha: 0.45))
          : null,
    );
  }
}
