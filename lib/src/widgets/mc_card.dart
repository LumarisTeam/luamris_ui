import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import '../theme/mc_smooth_corners.dart';

// =============================================================================
// McCard — unified card with named constructors per variant
// =============================================================================

enum _McCardVariant { glass, elevated, flat, grouped }

/// A single card class covering glass, elevated, flat, and grouped styles via
/// named constructors. All variants support an optional [onPressed] for tap
/// handling.
///
/// ```dart
/// McCard.glass(child: ...);
/// McCard.elevated(onPressed: () {}, child: ...);
/// McCard.flat(child: ...);
/// McCard.grouped(child: Column(children: [McListTile(...), ...]));
/// ```
class McCard extends StatelessWidget {
  final _McCardVariant _variant;
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? radius;

  /// Glass-morphism card with backdrop blur.
  const McCard.glass({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.radius,
  }) : _variant = _McCardVariant.glass;

  /// Elevated card with border and shadow. Tap-able via [onPressed].
  const McCard.elevated({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.radius,
  }) : _variant = _McCardVariant.elevated;

  /// Flat card with border, no shadow. Tap-able via [onPressed].
  const McCard.flat({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.all(18),
    this.margin,
    this.radius,
  }) : _variant = _McCardVariant.flat;

  /// Zero-padding surface for grouped rows (iOS inset-grouped style).
  ///
  /// Use with [McListTile] to build settings-style groups. The card clips its
  /// children to the rounded shape, so selected row fills follow the corners.
  const McCard.grouped({
    super.key,
    required this.child,
    this.onPressed,
    this.margin,
    this.radius,
  }) : padding = EdgeInsets.zero,
       _variant = _McCardVariant.grouped;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final r = radius ?? McRadii.card;
    final borderRadius = BorderRadius.circular(r);
    final p = padding ?? const EdgeInsets.all(18);

    final hairline = BorderSide(
      color: m.separator.withValues(alpha: 0.1),
      width: 0.5,
    );

    final Widget card;
    switch (_variant) {
      case _McCardVariant.glass:
        final side = BorderSide(
          color: m.border.withValues(alpha: 0.3),
          width: 0.5,
        );
        card = McSmoothCorners.clip(
          borderRadius: borderRadius,
          side: side,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: ColoredBox(
              color: m.card.withValues(alpha: 0.7),
              child: Padding(padding: p, child: child),
            ),
          ),
        );
      case _McCardVariant.elevated:
        card = DecoratedBox(
          decoration: ShapeDecoration(
            color: m.card,
            shape: McSmoothCorners.shape(borderRadius, side: hairline),
            shadows: m.cardShadow,
          ),
          child: Padding(padding: p, child: child),
        );
      case _McCardVariant.flat:
        card = DecoratedBox(
          decoration: ShapeDecoration(
            color: m.card,
            shape: McSmoothCorners.shape(borderRadius, side: hairline),
          ),
          child: Padding(padding: p, child: child),
        );
      case _McCardVariant.grouped:
        card = DecoratedBox(
          decoration: ShapeDecoration(
            color: m.card,
            shape: McSmoothCorners.shape(borderRadius, side: hairline),
            shadows: m.cardShadow,
          ),
          child: Material(
            type: MaterialType.transparency,
            clipBehavior: Clip.antiAlias,
            shape: McSmoothCorners.shape(borderRadius, side: hairline),
            child: child,
          ),
        );
    }

    final sized = SizedBox(width: double.infinity, child: card);
    final Widget result = onPressed == null
        ? sized
        : CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            pressedOpacity: 0.92,
            foregroundColor: m.cardForeground,
            onPressed: onPressed,
            child: sized,
          );

    return margin == null ? result : Padding(padding: margin!, child: result);
  }
}
