import 'package:flutter/cupertino.dart';

import 'mc_colors.dart';
import 'mc_radii.dart';

/// Pre-built [BoxDecoration] factories for common surface styles.
abstract final class McDecorations {
  /// Standard card surface with a subtle border.
  static BoxDecoration card(BuildContext context, {double radius = McRadii.xl}) {
    return BoxDecoration(
      color: CupertinoDynamicColor.resolve(McColors.card, context),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: CupertinoDynamicColor.resolve(
          McColors.border,
          context,
        ).withValues(alpha: 0.5),
      ),
    );
  }

  /// Muted / secondary card surface without a border.
  static BoxDecoration mutedCard(
    BuildContext context, {
    double radius = McRadii.xl,
  }) {
    return BoxDecoration(
      color: CupertinoDynamicColor.resolve(McColors.secondary, context),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Glass-morphism surface — semi-transparent with a subtle border.
  static BoxDecoration glass(BuildContext context, {double radius = McRadii.xl}) {
    return BoxDecoration(
      color: CupertinoDynamicColor.resolve(
        McColors.card,
        context,
      ).withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: CupertinoDynamicColor.resolve(
          McColors.border,
          context,
        ).withValues(alpha: 0.3),
      ),
    );
  }

  /// Pill-shaped container — ideal for badges, chips, and tags.
  ///
  /// [background] and [border] default to the design system's secondary
  /// and border colors respectively.
  static BoxDecoration pill(
    BuildContext context, {
    Color background = McColors.secondary,
    Color border = McColors.border,
    bool showBorder = false,
  }) {
    return BoxDecoration(
      color: CupertinoDynamicColor.resolve(background, context),
      borderRadius: BorderRadius.circular(McRadii.pill),
      border: showBorder
          ? Border.all(
              color: CupertinoDynamicColor.resolve(
                border,
                context,
              ).withValues(alpha: 0.45),
            )
          : null,
    );
  }
}
