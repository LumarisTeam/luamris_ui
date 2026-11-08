import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import '../responsive/mc_responsive.dart';
import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import '../theme/mc_smooth_corners.dart';

/// Shows a Cupertino modal popup styled with glass-morphism.
///
/// On phones the sheet slides up from the bottom as a floating card: all four
/// corners are rounded, it keeps 8pt from the left / right edges and an 8pt
/// gap above the bottom safe area. Its grabber can be dragged down to dismiss
/// it. On tablets / desktop it appears as a centered dialog (no grabber, not
/// draggable).
///
/// By default the sheet shows a grabber. Set [showHandle] to false to hide it,
/// or pass [showCloseButton] = true to add a circular close button in the
/// top-left corner. Pass [floating] = false to revert to the edge-to-edge
/// sheet.
///
/// On phones, [detents] sets the heights the sheet snaps to when the grabber
/// is dragged. Pass strictly increasing fractions in (0, 0.85] of the
/// available height after insets and [maxHeight] are applied. The highest
/// detent extends to the screen edges, with safe-area padding inside the
/// surface and any explicit [bottomInset] still reserved below it.
/// [initialDetentIndex] selects the opening height and defaults to the lowest
/// detent. An empty list keeps the content-sized sheet. Use [scrollable] for
/// content taller than the lowest detent.
///
/// [bottomInset] keeps the phone sheet clear of whatever sits at the bottom of
/// the screen — typically a tab bar the sheet would otherwise cover. It is
/// measured from the safe area, so pass the bar's own height. When it is
/// greater than zero the sheet floats above the bar. It is ignored on tablets
/// / desktop.
///
/// [onClose] is invoked by the close button and defaults to popping the sheet.
/// [closeButtonSemanticLabel] is the accessibility label used for that button.
Future<T?> showMcBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double? maxHeight,
  List<double> detents = const [],
  int initialDetentIndex = 0,
  bool showHandle = true,
  bool showCloseButton = false,
  bool floating = true,
  EdgeInsetsGeometry? contentPadding,
  bool scrollable = false,
  double bottomInset = 0,
  VoidCallback? onClose,
  String closeButtonSemanticLabel = 'Close',
}) {
  final snapHeights = List<double>.of(detents);
  var previous = 0.0;
  for (final height in snapHeights) {
    if (!height.isFinite || height <= previous || height > 0.85) {
      throw ArgumentError.value(
        detents,
        'detents',
        'Expected strictly increasing fractions in (0, 0.85].',
      );
    }
    previous = height;
  }
  RangeError.checkValueInInterval(
    initialDetentIndex,
    0,
    math.max(0, snapHeights.length - 1),
    'initialDetentIndex',
  );

  return showCupertinoModalPopup<T>(
    context: context,
    builder: (sheetContext) {
      final m = sheetContext.mc;
      final isPhone = McResponsive.isPhone(sheetContext);
      final maxWidth = McResponsive.sheetMaxWidth(sheetContext);
      final hasDetents = isPhone && snapHeights.isNotEmpty;
      final reservesBottomInset = isPhone && bottomInset > 0;
      final safeArea = MediaQuery.paddingOf(sheetContext);
      final movableSafePadding = hasDetents
          ? EdgeInsets.only(
              left: safeArea.left,
              right: safeArea.right,
              bottom: reservesBottomInset ? 0 : safeArea.bottom,
            )
          : EdgeInsets.zero;
      // Tablets / desktop always use the dialog look. On phones the sheet
      // floats unless the caller opts out — or it has to clear a tab bar.
      final isFloating = !isPhone || floating || bottomInset > 0;
      final radius = isFloating ? McRadii.xl : McRadii.sheetTop;
      final borderRadius = isFloating
          ? BorderRadius.circular(radius)
          : BorderRadius.vertical(
              top: Radius.circular(radius),
              bottom: Radius.circular(32),
            );
      final side = BorderSide(
        color: m.border.withValues(alpha: 0.35),
        width: 0.5,
      );
      final background = isFloating
          ? m.surfaceRaised.withValues(alpha: 0.97)
          : m.background.withValues(alpha: 0.94);
      final bottomGap = isPhone && floating && !reservesBottomInset
          ? _floatingBottomGap
          : 0.0;
      final horizontalGap = isPhone && isFloating
          ? _floatingHorizontalGap
          : 0.0;

      Widget sheetContent = builder(sheetContext);
      if (scrollable) {
        sheetContent = SingleChildScrollView(
          padding: contentPadding ?? EdgeInsets.zero,
          child: sheetContent,
        );
      } else if (contentPadding != null) {
        sheetContent = Padding(padding: contentPadding, child: sheetContent);
      }

      // Modal routes are not descendants of a Material/Scaffold, so reset the
      // fallback text style to avoid Flutter's yellow debug underline.
      final themedContent = DefaultTextStyle(
        style: TextStyle(
          color: m.foreground,
          fontSize: 16,
          decoration: TextDecoration.none,
        ),
        child: sheetContent,
      );

      final surface = _SheetSurface(
        // Only the phone sheet is draggable; a centered tablet dialog is not.
        showGrabber: showHandle && isPhone,
        detents: isPhone ? snapHeights : const [],
        initialDetentIndex: isPhone ? initialDetentIndex : 0,
        maxHeight: maxHeight,
        floatingPadding: EdgeInsets.fromLTRB(
          horizontalGap,
          0,
          horizontalGap,
          bottomGap,
        ),
        movableSafePadding: movableSafePadding,
        showCloseButton: showCloseButton,
        onClose: onClose ?? () => Navigator.of(sheetContext).pop(),
        closeButtonSemanticLabel: closeButtonSemanticLabel,
        borderRadius: borderRadius,
        side: side,
        background: background,
        grabberColor: m.borderStrong.withValues(alpha: 0.8),
        shadows: isFloating ? _floatingShadows(m) : const <BoxShadow>[],
        child: themedContent,
      );

      return Align(
        alignment: isPhone ? Alignment.bottomCenter : Alignment.center,
        child: SafeArea(
          top: false,
          left: !hasDetents,
          right: !hasDetents,
          bottom: !hasDetents || reservesBottomInset,
          child: Padding(
            padding: isPhone
                ? EdgeInsets.only(
                    top: 40,
                    bottom: reservesBottomInset ? bottomInset : 0,
                  )
                : const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: surface,
            ),
          ),
        ),
      );
    },
  );
}

/// Horizontal gap between a floating phone sheet and the screen edge.
const double _floatingHorizontalGap = 8;

/// Gap between a floating phone sheet and the bottom safe area.
const double _floatingBottomGap = 8;

List<BoxShadow> _floatingShadows(McTheme m) {
  return <BoxShadow>[
    BoxShadow(
      color: Colors.black.withValues(
        alpha: m.brightness == Brightness.dark ? 0.35 : 0.12,
      ),
      blurRadius: 28,
      spreadRadius: -6,
      offset: const Offset(0, 12),
    ),
  ];
}

/// The glass surface of an mc sheet, plus the grabber that drags it away.
class _SheetSurface extends StatefulWidget {
  const _SheetSurface({
    required this.showGrabber,
    required this.detents,
    required this.initialDetentIndex,
    required this.maxHeight,
    required this.floatingPadding,
    required this.movableSafePadding,
    required this.showCloseButton,
    required this.onClose,
    required this.closeButtonSemanticLabel,
    required this.borderRadius,
    required this.side,
    required this.background,
    required this.grabberColor,
    required this.shadows,
    required this.child,
  });

  final bool showGrabber;
  final List<double> detents;
  final int initialDetentIndex;
  final double? maxHeight;
  final EdgeInsets floatingPadding;
  final EdgeInsets movableSafePadding;
  final bool showCloseButton;
  final VoidCallback onClose;
  final String closeButtonSemanticLabel;
  final BorderRadius borderRadius;
  final BorderSide side;
  final Color background;
  final Color grabberColor;
  final List<BoxShadow> shadows;
  final Widget child;

  @override
  State<_SheetSurface> createState() => _SheetSurfaceState();
}

class _SheetSurfaceState extends State<_SheetSurface>
    with SingleTickerProviderStateMixin {
  /// Distance (logical px) the sheet must be pulled before a release dismisses.
  static const _dismissDistance = 96.0;

  /// Release speed (px/s) at which the sheet snaps in the drag direction.
  static const _flingVelocity = 700.0;

  /// Touch target of the grabber. Taller than the visible pill so the sheet
  /// is easy to grab.
  static const _grabberHeight = 28.0;

  double get _minExtent => widget.detents.firstOrNull ?? 0;
  double get _maxExtent => widget.detents.lastOrNull ?? 0;
  double get _initialExtent =>
      widget.detents.isEmpty ? 0 : widget.detents[widget.initialDetentIndex];

  double get _dockProgress {
    final detents = widget.detents;
    if (detents.isEmpty) return 0;
    if (detents.length == 1) return 1;
    final previous = detents[detents.length - 2];
    return ((_extent.value - previous) / (_maxExtent - previous)).clamp(0, 1);
  }

  // In detent mode this is a fraction of the available height. Below the
  // minimum it translates the sheet downward instead of shrinking it further.
  late final AnimationController _extent = AnimationController.unbounded(
    value: _initialExtent,
    vsync: this,
    animationBehavior: AnimationBehavior.normal,
  );
  bool _pointerCancelled = false;

  @override
  void initState() {
    super.initState();
    _extent.addListener(_onExtentChanged);
  }

  @override
  void didUpdateWidget(covariant _SheetSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.detents != widget.detents) _extent.value = _initialExtent;
  }

  @override
  void dispose() {
    _extent.dispose();
    super.dispose();
  }

  void _onExtentChanged() => setState(() {});

  void _onDragUpdate(double delta, double availableHeight) {
    if (availableHeight == 0) return;
    _extent.value = math.min(
      _maxExtent,
      _extent.value - delta / availableHeight,
    );
  }

  double _snapTarget(double velocity) {
    if (velocity < -_flingVelocity) {
      return widget.detents.firstWhere(
        (height) => height > _extent.value,
        orElse: () => _maxExtent,
      );
    }
    if (velocity > _flingVelocity) {
      return widget.detents.lastWhere(
        (height) => height < _extent.value,
        orElse: () => _minExtent,
      );
    }
    var nearest = _minExtent;
    for (final height in widget.detents.skip(1)) {
      if ((height - _extent.value).abs() < (nearest - _extent.value).abs()) {
        nearest = height;
      }
    }
    return nearest;
  }

  void _settleTo(double extent) {
    _extent.animateTo(
      extent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  void _onDragEnd(double velocity, double availableHeight) {
    if (_pointerCancelled) {
      _settleTo(_snapTarget(0));
      return;
    }
    final pullDown = (_minExtent - _extent.value) * availableHeight;
    final canDismiss = widget.detents.isEmpty || pullDown > 0;
    if (canDismiss &&
        (pullDown > _dismissDistance || velocity > _flingVelocity) &&
        ModalRoute.of(context)?.isCurrent == true) {
      Navigator.of(context).pop();
      return;
    }
    _settleTo(_snapTarget(velocity));
  }

  Widget _buildGrabber(double availableHeight, double height) {
    return Listener(
      onPointerCancel: (_) {
        // Flutter also calls onVerticalDragEnd for an accepted drag on cancel.
        _pointerCancelled = true;
        scheduleMicrotask(() => _pointerCancelled = false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (_) => _extent.stop(),
        onVerticalDragUpdate: (details) =>
            _onDragUpdate(details.delta.dy, availableHeight),
        onVerticalDragEnd: (details) =>
            _onDragEnd(details.velocity.pixelsPerSecond.dy, availableHeight),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: ShapeDecoration(
                color: widget.grabberColor,
                shape: McSmoothCorners.shape(
                  BorderRadius.circular(McRadii.handle),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = widget.movableSafePadding;
    return MediaQuery.removePadding(
      context: context,
      removeLeft: safePadding.left > 0,
      removeRight: safePadding.right > 0,
      removeBottom: safePadding.bottom > 0,
      child: LayoutBuilder(
        builder: (context, constraints) => _buildSurface(constraints),
      ),
    );
  }

  Widget _buildSurface(BoxConstraints constraints) {
    final floatingPadding = widget.floatingPadding + widget.movableSafePadding;
    final availableHeight = math.min(
      constraints.deflate(floatingPadding).maxHeight,
      widget.maxHeight ?? double.infinity,
    );
    final dockProgress = _dockProgress;
    final outerPadding = EdgeInsets.lerp(
      floatingPadding,
      EdgeInsets.zero,
      dockProgress,
    )!;
    final innerPadding = widget.movableSafePadding * dockProgress;
    final borderRadius = BorderRadius.lerp(
      widget.borderRadius,
      const BorderRadius.vertical(top: Radius.circular(McRadii.sheetTop)),
      dockProgress,
    )!;
    final sheetHeight = widget.detents.isEmpty
        ? null
        : math.max(_minExtent, _extent.value) * availableHeight;
    final heightLimit = math.max(
      0.0,
      (sheetHeight ?? availableHeight) - innerPadding.vertical,
    );
    final grabberHeight = widget.showGrabber
        ? math.min(_grabberHeight, heightLimit)
        : 0.0;

    Widget content = widget.child;
    if (widget.showGrabber || widget.showCloseButton) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (widget.showGrabber) _buildGrabber(availableHeight, grabberHeight),
          if (widget.showCloseButton)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: heightLimit - grabberHeight,
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  widget.showGrabber ? 0 : 12,
                  16,
                  4,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  heightFactor: 1,
                  child: _SheetCloseButton(
                    onPressed: widget.onClose,
                    semanticLabel: widget.closeButtonSemanticLabel,
                  ),
                ),
              ),
            ),
          // Keep header fixed while long / scrollable content shrinks to the
          // remaining sheet height instead of overflowing it.
          Flexible(child: widget.child),
        ],
      );
    }

    final clipped = McSmoothCorners.clip(
      borderRadius: borderRadius,
      side: widget.side,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: ColoredBox(
          color: widget.background,
          child: Padding(padding: innerPadding, child: content),
        ),
      ),
    );

    final surface = widget.shadows.isEmpty
        ? clipped
        : DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                for (final shadow in widget.shadows)
                  shadow.copyWith(
                    color: shadow.color.withValues(
                      alpha: shadow.color.a * (1 - dockProgress),
                    ),
                  ),
              ],
            ),
            child: clipped,
          );

    final pullDown = math.max(0.0, _minExtent - _extent.value);
    return Padding(
      padding: outerPadding,
      child: Transform.translate(
        offset: Offset(0, pullDown * availableHeight),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: availableHeight),
          child: SizedBox(
            width: sheetHeight == null ? null : double.infinity,
            height: sheetHeight,
            child: surface,
          ),
        ),
      ),
    );
  }
}

/// Circular close button shown in the sheet's top-left corner.
class _SheetCloseButton extends StatefulWidget {
  const _SheetCloseButton({
    required this.onPressed,
    required this.semanticLabel,
  });

  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  State<_SheetCloseButton> createState() => _SheetCloseButtonState();
}

class _SheetCloseButtonState extends State<_SheetCloseButton> {
  static const double _size = 40;

  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            width: _size,
            height: _size,
            decoration: ShapeDecoration(
              color: _pressed ? m.borderStrong : m.surfaceSunken,
              shape: const CircleBorder(),
            ),
            child: Icon(
              CupertinoIcons.xmark,
              size: 16,
              color: m.secondaryLabel,
            ),
          ),
        ),
      ),
    );
  }
}
