import 'package:material_ui/material_ui.dart';

import 'mc_animated_button.dart';
import 'mc_motion.dart';
import 'mc_motion_entrance.dart';

/// A card with an entrance animation: a 12 px rise plus fade-in.
///
/// ```dart
/// McAnimatedCard(child: YourCardContent())
/// ```
class McAnimatedCard extends StatelessWidget {
  final Widget child;
  final Duration? delay;
  final Duration? duration;
  final Curve? curve;

  const McAnimatedCard({
    super.key,
    required this.child,
    this.delay,
    this.duration,
    this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return McMotionEntrance(
      duration: duration ?? McMotion.standard,
      delay: delay ?? Duration.zero,
      curve: curve ?? McMotion.easeOut,
      offset: const Offset(0, McMotion.cardSlideOffset),
      child: child,
    );
  }
}

/// A card with press feedback. Scales down slightly while pressed.
///
/// ```dart
/// McInteractiveCard(
///   onTap: openDetails,
///   child: YourCardContent(),
/// )
/// ```
class McInteractiveCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableFeedback;

  const McInteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.enableFeedback = true,
  });

  @override
  Widget build(BuildContext context) => McAnimatedButton(
    onTap: onTap,
    onLongPress: onLongPress,
    enableFeedback: enableFeedback,
    child: child,
  );
}

/// A card with a subtle hover lift for desktop pointers (no content scaling).
class McHoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool enableHover;

  const McHoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.enableHover = true,
  });

  @override
  State<McHoverCard> createState() => _McHoverCardState();
}

class _McHoverCardState extends State<McHoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool reduced = McMotion.reduceMotionOf(context);
    return MouseRegion(
      onEnter: widget.enableHover
          ? (_) => setState(() => _hovered = true)
          : null,
      onExit: widget.enableHover
          ? (_) => setState(() => _hovered = false)
          : null,
      child: AnimatedSlide(
        offset: _hovered && widget.enableHover && !reduced
            ? const Offset(0, -0.005)
            : Offset.zero,
        duration: reduced ? Duration.zero : McMotion.fast,
        curve: McMotion.easeOut,
        child: McAnimatedButton(onTap: widget.onTap, child: widget.child),
      ),
    );
  }
}

/// Entrance animation plus press feedback.
///
/// ```dart
/// McAnimatedInteractiveCard(
///   delay: const Duration(milliseconds: 100),
///   onTap: openDetails,
///   child: YourCardContent(),
/// )
/// ```
class McAnimatedInteractiveCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Duration? delay;
  final Duration? duration;
  final bool enableFeedback;

  const McAnimatedInteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.delay,
    this.duration,
    this.enableFeedback = true,
  });

  @override
  Widget build(BuildContext context) {
    return McAnimatedCard(
      delay: delay,
      duration: duration,
      child: McInteractiveCard(
        onTap: onTap,
        onLongPress: onLongPress,
        enableFeedback: enableFeedback,
        child: child,
      ),
    );
  }
}
