import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../theme/mc_context.dart';

// =============================================================================
// McCard — unified card with named constructors per variant
// =============================================================================

enum _McCardVariant { glass, elevated, flat }

/// A single card class covering glass, elevated, and flat styles via named
/// constructors. All variants support an optional [onPressed] for tap handling.
///
/// ```dart
/// McCard.glass(child: ...);
/// McCard.elevated(onPressed: () {}, child: ...);
/// McCard.flat(child: ...);
/// ```
class McCard extends StatelessWidget {
  final _McCardVariant _variant;
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final double? radius;

  /// Glass-morphism card with backdrop blur.
  const McCard.glass({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.all(18),
    this.radius,
  }) : _variant = _McCardVariant.glass;

  /// Elevated card with border and shadow. Tap-able via [onPressed].
  const McCard.elevated({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.all(18),
    this.radius,
  }) : _variant = _McCardVariant.elevated;

  /// Flat card with border, no shadow. Tap-able via [onPressed].
  const McCard.flat({
    super.key,
    required this.child,
    this.onPressed,
    this.padding = const EdgeInsets.all(18),
    this.radius,
  }) : _variant = _McCardVariant.flat;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final r = radius ?? m.radiusXl;
    final p = padding ?? const EdgeInsets.all(18);

    Widget card = Container(
      width: double.infinity,
      padding: p,
      decoration: switch (_variant) {
        _McCardVariant.glass => m.glassDecoration(radius: r),
        _McCardVariant.elevated => BoxDecoration(
            color: m.card,
            borderRadius: BorderRadius.circular(r),
            border: Border.all(color: m.border.withValues(alpha: 0.5)),
            boxShadow: m.shadowCard,
          ),
        _McCardVariant.flat => BoxDecoration(
            color: m.card,
            borderRadius: BorderRadius.circular(r),
            border: Border.all(color: m.border.withValues(alpha: 0.5)),
          ),
      },
      child: child,
    );

    // Glass variant wraps the container in a BackdropFilter.
    if (_variant == _McCardVariant.glass) {
      card = ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: card,
        ),
      );
    }

    if (onPressed == null) return card;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      pressedOpacity: 0.92,
      onPressed: onPressed,
      child: card,
    );
  }
}
