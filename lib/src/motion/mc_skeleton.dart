import 'package:material_ui/material_ui.dart';

import '../theme/mc_context.dart';
import 'mc_motion.dart';

/// Shimmer-based skeleton loading, in the style of Apple's skeleton screens.
///
/// The shimmer loop stops when [isLoading] is `false`, when the platform asks
/// for reduced motion, or when the enclosing [TickerMode] is disabled.
///
/// ```dart
/// McShimmerLoading(
///   isLoading: isLoading,
///   skeleton: const McListItemSkeleton(),
///   child: YourLoadedContent(),
/// )
/// ```
class McShimmerLoading extends StatefulWidget {
  final bool isLoading;

  /// Skeleton shown while loading. Defaults to the card-colored surface.
  final Widget? skeleton;

  /// Content shown once loading finishes.
  final Widget child;

  final Duration duration;

  const McShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
    this.skeleton,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<McShimmerLoading> createState() => _McShimmerLoadingState();
}

class _McShimmerLoadingState extends State<McShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  void _syncAnimation() {
    if (widget.isLoading &&
        !McMotion.reduceMotionOf(context) &&
        TickerMode.valuesOf(context).enabled) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(McShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.stop();
      _controller.duration = widget.duration;
    }
    _syncAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool reduced = McMotion.reduceMotionOf(context);
    return AnimatedSwitcher(
      duration: reduced ? Duration.zero : McMotion.standard,
      switchInCurve: McMotion.easeOut,
      switchOutCurve: McMotion.easeIn,
      child: KeyedSubtree(
        key: ValueKey<bool>(widget.isLoading),
        child: !widget.isLoading
            ? widget.child
            : reduced
            ? widget.skeleton ?? _buildDefaultSkeleton(context)
            : AnimatedBuilder(
                animation: _controller,
                child: widget.skeleton ?? _buildDefaultSkeleton(context),
                builder: (context, child) {
                  final colors = context.mc;
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment(-2 + _controller.value * 4, 0),
                      end: Alignment(-1 + _controller.value * 4, 0),
                      colors: [
                        colors.skeletonBase,
                        colors.skeletonHighlight,
                        colors.skeletonBase,
                      ],
                      stops: const [0, 0.5, 1],
                    ).createShader(bounds),
                    child: child,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDefaultSkeleton(BuildContext context) {
    return ColoredBox(color: context.mc.card);
  }
}

/// A rectangular skeleton placeholder.
class McSkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const McSkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: context.mc.card,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}

/// A circular skeleton placeholder.
class McSkeletonCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const McSkeletonCircle({super.key, required this.size, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: BoxDecoration(color: context.mc.card, shape: BoxShape.circle),
    );
  }
}

/// A single skeleton text line.
class McSkeletonLine extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const McSkeletonLine({super.key, this.width, this.height = 12, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: context.mc.card,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

/// Preset skeleton for a list row.
class McListItemSkeleton extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final int lines;

  const McListItemSkeleton({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (hasLeading)
            const McSkeletonCircle(
              size: 48,
              margin: EdgeInsets.only(right: 12),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const McSkeletonLine(
                  width: double.infinity,
                  height: 14,
                  margin: EdgeInsets.only(bottom: 8),
                ),
                if (lines > 1)
                  McSkeletonLine(
                    width: MediaQuery.sizeOf(context).width * 0.6,
                    height: 12,
                  ),
              ],
            ),
          ),
          if (hasTrailing)
            const McSkeletonBox(
              width: 60,
              height: 30,
              margin: EdgeInsets.only(left: 12),
            ),
        ],
      ),
    );
  }
}

/// Preset skeleton for a card.
class McCardSkeleton extends StatelessWidget {
  final double? height;

  const McCardSkeleton({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    return Container(
      height: height ?? 200,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.mc.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const McSkeletonCircle(
                size: 40,
                margin: EdgeInsets.only(right: 12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    McSkeletonLine(
                      width: width * 0.4,
                      height: 16,
                      margin: const EdgeInsets.only(bottom: 6),
                    ),
                    McSkeletonLine(width: width * 0.3, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          const McSkeletonLine(
            width: double.infinity,
            height: 14,
            margin: EdgeInsets.only(bottom: 8),
          ),
          McSkeletonLine(width: width * 0.7, height: 14),
        ],
      ),
    );
  }
}
