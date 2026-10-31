import 'package:material_ui/material_ui.dart';

import 'mc_motion.dart';
import 'mc_motion_entrance.dart';

/// A list item that rises 8 px and fades in, staggered by [index].
///
/// ```dart
/// ListView.builder(
///   itemCount: items.length,
///   itemBuilder: (context, index) => McAnimatedListItem(
///     key: ValueKey(items[index].id),
///     index: index,
///     child: YourListTile(item: items[index]),
///   ),
/// )
/// ```
class McAnimatedListItem extends StatelessWidget {
  /// Item index, used to compute the stagger delay.
  final int index;

  final Widget child;

  /// Overrides [McMotion.listItemDuration].
  final Duration? duration;

  /// Overrides the delay derived from [index].
  final Duration? delay;

  /// Overrides [McMotion.easeOut].
  final Curve? curve;

  /// Overrides [McMotion.slideOffset].
  final double? slideOffset;

  const McAnimatedListItem({
    super.key,
    required this.index,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
    this.slideOffset,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: McMotionEntrance(
        duration: duration ?? McMotion.listItemDuration,
        delay: delay ?? McMotion.getListItemDelay(index),
        curve: curve ?? McMotion.easeOut,
        offset: Offset(0, slideOffset ?? McMotion.slideOffset),
        initialScale: 1,
        child: child,
      ),
    );
  }
}

/// A list item that slides in from the leading edge.
class McAnimatedListItemSlideLeft extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final Curve? curve;

  const McAnimatedListItemSlideLeft({
    super.key,
    required this.index,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: McMotionEntrance(
        duration: duration ?? McMotion.listItemDuration,
        delay: delay ?? McMotion.getListItemDelay(index),
        curve: curve ?? McMotion.easeOut,
        offset: Offset(
          (Directionality.of(context) == TextDirection.rtl ? 1 : -1) *
              McMotion.slideOffset,
          0,
        ),
        initialScale: 1,
        child: child,
      ),
    );
  }
}

/// A list item that scales in slightly (0.98 → 1) with a fade.
class McAnimatedListItemScale extends StatelessWidget {
  final int index;
  final Widget child;
  final Duration? duration;
  final Duration? delay;
  final Curve? curve;

  const McAnimatedListItemScale({
    super.key,
    required this.index,
    required this.child,
    this.duration,
    this.delay,
    this.curve,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: McMotionEntrance(
        duration: duration ?? McMotion.listItemDuration,
        delay: delay ?? McMotion.getListItemDelay(index),
        curve: curve ?? McMotion.easeOut,
        offset: Offset.zero,
        initialScale: 0.98,
        child: child,
      ),
    );
  }
}
