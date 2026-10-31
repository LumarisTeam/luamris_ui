import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'mc_motion.dart';

/// A one-shot entrance animation: fade in with a slight offset and optional
/// scale.
///
/// The delay is timed independently of the animation itself. Nested entrances
/// are skipped when an ancestor [McMotionEntrance] already orchestrates the
/// region, so content never fades in twice.
///
/// Respects the platform's reduce-motion setting: when enabled, the child is
/// shown immediately and the animation is never started.
class McMotionEntrance extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Offset offset;
  final double initialScale;

  const McMotionEntrance({
    super.key,
    required this.child,
    this.duration = McMotion.standard,
    this.delay = Duration.zero,
    this.curve = McMotion.easeOut,
    this.offset = const Offset(0, McMotion.slideOffset),
    this.initialScale = 1,
  });

  @override
  State<McMotionEntrance> createState() => _McMotionEntranceState();
}

class _McMotionEntranceState extends State<McMotionEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _delayTimer;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    assert(!widget.duration.isNegative && !widget.delay.isNegative);
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (McMotion.reduceMotionOf(context) ||
        context.dependOnInheritedWidgetOfExactType<_McEntranceScope>() !=
            null) {
      _delayTimer?.cancel();
      _controller.value = 1;
      _started = true;
    } else if (!_started) {
      _started = true;
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        _delayTimer = Timer(widget.delay, () => _controller.forward());
      }
    }
  }

  @override
  void didUpdateWidget(McMotionEntrance oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _McEntranceScope(
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          final double value = widget.curve.transform(_controller.value);
          return IgnorePointer(
            ignoring: _controller.value == 0,
            child: Transform.translate(
              offset: widget.offset * (1 - value),
              child: Transform.scale(
                scale: widget.initialScale + (1 - widget.initialScale) * value,
                child: Opacity(opacity: value.clamp(0, 1), child: child),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _McEntranceScope extends InheritedWidget {
  const _McEntranceScope({required super.child});

  @override
  bool updateShouldNotify(_McEntranceScope oldWidget) => false;
}
