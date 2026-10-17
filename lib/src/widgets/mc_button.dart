import 'package:cupertino_ui/cupertino_ui.dart';

import '../theme/mc_context.dart';

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

  /// Filled primary action button.
  const McButton.primary({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  }) : _variant = _McButtonVariant.primary;

  /// Secondary / outline-style button with muted background.
  const McButton.secondary({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
  }) : _variant = _McButtonVariant.secondary;

  /// Transparent button — no background fill.
  const McButton.ghost({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  }) : _variant = _McButtonVariant.ghost;

  /// Destructive / danger button — red fill.
  const McButton.danger({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  }) : _variant = _McButtonVariant.danger;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final disabled = onPressed == null;

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

    return CupertinoButton(
      padding: padding,
      borderRadius: BorderRadius.circular(m.radiusLg),
      color: bg,
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w700),
        child: child,
      ),
    );
  }
}
