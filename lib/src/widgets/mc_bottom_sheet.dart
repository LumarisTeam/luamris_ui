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
  bool showHandle = true,
  bool showCloseButton = false,
  bool floating = true,
  EdgeInsetsGeometry? contentPadding,
  bool scrollable = false,
  double bottomInset = 0,
  VoidCallback? onClose,
  String closeButtonSemanticLabel = 'Close',
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (sheetContext) {
      final m = sheetContext.mc;
      final isPhone = McResponsive.isPhone(sheetContext);
      final maxWidth = McResponsive.sheetMaxWidth(sheetContext);
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
      final bottomGap = isPhone
          ? (bottomInset > 0
                ? bottomInset
                : (floating ? _floatingBottomGap : 0.0))
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

      Widget surface = _SheetSurface(
        draggable: isPhone,
        // Only the phone sheet is draggable; a centered tablet dialog is not.
        showGrabber: showHandle && isPhone,
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

      if (maxHeight != null) {
        surface = ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: surface,
        );
      }

      return Align(
        alignment: isPhone ? Alignment.bottomCenter : Alignment.center,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: isPhone
                ? EdgeInsets.fromLTRB(
                    horizontalGap,
                    40,
                    horizontalGap,
                    bottomGap,
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
    required this.draggable,
    required this.showGrabber,
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

  /// Whether dragging the grabber can dismiss the sheet.
  final bool draggable;
  final bool showGrabber;
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

  /// Release velocity (px/s) that dismisses regardless of distance.
  static const _dismissVelocity = 700.0;

  /// Touch target of the grabber. Taller than the visible pill so the sheet
  /// is easy to grab.
  static const _grabberHeight = 28.0;

  late final AnimationController _settle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  Animation<double>? _settleAnimation;

  /// How far the sheet has been pulled down; 0 when resting.
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _settle.addListener(_onSettleTick);
  }

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }

  void _onSettleTick() {
    final value = _settleAnimation?.value;
    if (value != null) {
      setState(() => _offset = value);
    }
  }

  void _onDragStart(DragStartDetails details) {
    _settle.stop();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset = (_offset + details.delta.dy).clamp(0.0, double.infinity);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;
    if (_offset > _dismissDistance || velocity > _dismissVelocity) {
      Navigator.of(context).pop();
      return;
    }

    _settleAnimation = Tween<double>(
      begin: _offset,
      end: 0,
    ).animate(CurvedAnimation(parent: _settle, curve: Curves.easeOutCubic));
    _settle.forward(from: 0);
  }

  Widget _buildGrabber() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: widget.draggable ? _onDragStart : null,
      onVerticalDragUpdate: widget.draggable ? _onDragUpdate : null,
      onVerticalDragEnd: widget.draggable ? _onDragEnd : null,
      child: SizedBox(
        height: _grabberHeight,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child;
    if (widget.showGrabber || widget.showCloseButton) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (widget.showGrabber) _buildGrabber(),
          if (widget.showCloseButton)
            Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                widget.showGrabber ? 0 : 12,
                16,
                4,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _SheetCloseButton(
                  onPressed: widget.onClose,
                  semanticLabel: widget.closeButtonSemanticLabel,
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
      borderRadius: widget.borderRadius,
      side: widget.side,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: ColoredBox(color: widget.background, child: content),
      ),
    );

    final surface = widget.shadows.isEmpty
        ? clipped
        : DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              boxShadow: widget.shadows,
            ),
            child: clipped,
          );

    if (!widget.draggable) return surface;

    return Transform.translate(offset: Offset(0, _offset), child: surface);
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
