import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import 'mc_motion.dart';

/// Unified press feedback: a slight press-in with a calm recovery.
///
/// Supports keyboard activation (Enter / Space) and a themed focus ring, and
/// honors the platform's reduce-motion setting by dropping the scale and
/// duration while keeping the opacity feedback.
class McAnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final double scaleOnPress;
  final double opacityOnPress;
  final Duration duration;
  final bool enableFeedback;

  const McAnimatedButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.scaleOnPress = McMotion.pressScale,
    this.opacityOnPress = 0.88,
    this.duration = McMotion.fast,
    this.enableFeedback = true,
  }) : assert(scaleOnPress > 0 && scaleOnPress <= 1),
       assert(opacityOnPress >= 0 && opacityOnPress <= 1);

  @override
  State<McAnimatedButton> createState() => _McAnimatedButtonState();
}

class _McAnimatedButtonState extends State<McAnimatedButton> {
  bool _pressed = false;
  bool _focused = false;
  bool get _interactive =>
      widget.enabled && (widget.onTap != null || widget.onLongPress != null);

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  void didUpdateWidget(McAnimatedButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_interactive || !widget.enableFeedback) _pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    final bool reduced = McMotion.reduceMotionOf(context);
    final bool pressed = _pressed && _interactive && widget.enableFeedback;
    final Duration duration = reduced ? Duration.zero : widget.duration;
    return FocusableActionDetector(
      enabled: _interactive,
      mouseCursor: _interactive ? SystemMouseCursors.click : MouseCursor.defer,
      onShowFocusHighlight: (value) => setState(() => _focused = value),
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            if (_interactive) widget.onTap?.call();
            return null;
          },
        ),
      },
      child: Semantics(
        button: _interactive,
        enabled: widget.enabled,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _interactive && widget.enableFeedback
              ? (_) => _setPressed(true)
              : null,
          onTapUp: _interactive && widget.enableFeedback
              ? (_) => _setPressed(false)
              : null,
          onTapCancel: _interactive && widget.enableFeedback
              ? () => _setPressed(false)
              : null,
          onTap: _interactive ? widget.onTap : null,
          onLongPress: _interactive && widget.onLongPress != null
              ? () {
                  _setPressed(false);
                  widget.onLongPress?.call();
                }
              : null,
          child: AnimatedScale(
            scale: pressed && !reduced ? widget.scaleOnPress : 1,
            duration: duration,
            curve: McMotion.easeOut,
            child: AnimatedOpacity(
              opacity: !widget.enabled
                  ? McMotion.disabledOpacity
                  : pressed
                  ? widget.opacityOnPress
                  : 1,
              duration: duration,
              curve: McMotion.easeOut,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(McRadii.sm),
                  border: _focused
                      ? Border.all(color: context.mc.primary, width: 2)
                      : null,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Legacy name kept for compatibility; delegates to [McAnimatedButton].
class McBounceButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;

  const McBounceButton({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) =>
      McAnimatedButton(onTap: onTap, enabled: enabled, child: child);
}

/// Text-only action: changes opacity without scaling.
class McFadeButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final double opacityOnPress;

  const McFadeButton({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.opacityOnPress = 0.72,
  });

  @override
  Widget build(BuildContext context) => McAnimatedButton(
    onTap: onTap,
    enabled: enabled,
    scaleOnPress: 1,
    opacityOnPress: opacityOnPress,
    child: child,
  );
}

/// Pressable container with optional padding and decoration.
class McScaleTapContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final bool enabled;

  const McScaleTapContainer({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.decoration,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) => McAnimatedButton(
    onTap: onTap,
    enabled: enabled,
    child: Container(padding: padding, decoration: decoration, child: child),
  );
}
