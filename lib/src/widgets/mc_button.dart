import 'package:cupertino_ui/cupertino_ui.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import '../theme/mc_smooth_corners.dart';

// =============================================================================
// McButton — unified button with named constructors per variant
// =============================================================================

enum _McButtonVariant { primary, secondary, ghost, danger }

/// A single button class covering all visual styles via named constructors.
///
/// ```dart
/// McButton.primary(onPressed: () {}, child: const Text('确认'));
/// McButton.secondary(onPressed: () {}, child: const Text('取消'));
/// McButton.ghost(onPressed: () {}, child: const Text('了解更多'));
/// McButton.danger(onPressed: () {}, child: const Text('删除'));
/// ```
class McButton extends StatelessWidget {
  final _McButtonVariant _variant;
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsets padding;

  /// Corner radius override. Defaults to [McRadii.navigation] (12).
  final double? radius;

  /// Filled primary action button.
  const McButton.primary({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    this.radius,
  }) : _variant = _McButtonVariant.primary;

  /// Secondary / outline-style button with muted background.
  const McButton.secondary({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
    this.radius,
  }) : _variant = _McButtonVariant.secondary;

  /// Transparent button — no background fill.
  const McButton.ghost({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.radius,
  }) : _variant = _McButtonVariant.ghost;

  /// Destructive / danger button — red fill.
  const McButton.danger({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    this.radius,
  }) : _variant = _McButtonVariant.danger;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final disabled = onPressed == null;
    final r = radius ?? McRadii.navigation;

    final (Color? bg, Color fg) = switch (_variant) {
      _McButtonVariant.primary => (
        disabled ? m.primary.withValues(alpha: 0.45) : m.primary,
        m.primaryForeground,
      ),
      _McButtonVariant.secondary => (
        m.secondary,
        disabled ? m.mutedForeground : m.secondaryForeground,
      ),
      _McButtonVariant.ghost => (
        null,
        disabled ? m.mutedForeground : m.primary,
      ),
      _McButtonVariant.danger => (
        disabled ? m.destructive.withValues(alpha: 0.45) : m.destructive,
        m.primaryForeground,
      ),
    };

    final content = DefaultTextStyle(
      style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w700),
      child: child,
    );

    // The fill is painted inside the button so the pressed-state opacity
    // applies to it, and so it can use the smooth corner shape.
    final Widget body = bg == null
        ? Padding(padding: padding, child: content)
        : DecoratedBox(
            decoration: ShapeDecoration(
              color: bg,
              shape: McSmoothCorners.shape(BorderRadius.circular(r)),
            ),
            child: Padding(padding: padding, child: content),
          );

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      pressedOpacity: 0.9,
      foregroundColor: fg,
      borderRadius: BorderRadius.circular(r),
      onPressed: onPressed,
      child: body,
    );
  }
}
