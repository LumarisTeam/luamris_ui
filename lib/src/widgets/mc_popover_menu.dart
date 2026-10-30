import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import '../theme/mc_smooth_corners.dart';

/// Horizontal alignment of an [McPopoverMenu] relative to its trigger.
///
/// The menu still flips to the other side when the requested alignment would
/// run off screen, so this is a preference rather than a hard constraint.
enum McPopoverMenuAlignment {
  /// Align the menu's leading edge with the trigger's leading edge.
  start,

  /// Center the menu on the trigger.
  center,

  /// Align the menu's trailing edge with the trigger's trailing edge.
  end,
}

/// A single entry in an [McPopoverMenu].
@immutable
class McPopoverMenuItem<T> {
  const McPopoverMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
    this.isDestructive = false,
    this.enabled = true,
  });

  final T value;
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Overrides the icon color. Defaults to the label color.
  final Color? iconColor;

  /// Paints the label (and default icon color) with the danger color.
  final bool isDestructive;

  /// Disabled entries are dimmed and do not fire `onSelected`.
  final bool enabled;
}

/// An iOS-style popover dropdown anchored to [child].
///
/// Tapping [child] inserts the menu into the root [Overlay] and keeps it
/// attached to the trigger with a [CompositedTransformTarget] /
/// [CompositedTransformFollower] pair, so the menu follows the trigger when
/// the trigger moves (keyboard insets, rotation, animations, …).
///
/// The menu:
/// * flips above the trigger when there is not enough room below;
/// * flips / shifts horizontally to stay inside the safe area;
/// * becomes scrollable when the available vertical space is too short;
/// * closes when the barrier is tapped or an entry is selected.
///
/// ```dart
/// McPopoverMenu<int>(
///   items: const [
///     McPopoverMenuItem(value: 0, label: '第一学期'),
///     McPopoverMenuItem(value: 1, label: '第二学期'),
///   ],
///   selectedValue: _term,
///   matchTriggerWidth: true,
///   onSelected: (value) => setState(() => _term = value),
///   child: const Text('选择学期'),
/// );
/// ```
class McPopoverMenu<T> extends StatefulWidget {
  const McPopoverMenu({
    super.key,
    required this.items,
    required this.onSelected,
    required this.child,
    this.selectedValue,
    this.width = 224,
    this.matchTriggerWidth = false,
    this.radius = McRadii.card,
    this.backgroundColor,
    this.borderColor,
    this.barrierColor,
    this.shadows,
    this.padding = const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    this.itemHeight = 44,
    this.offset = const Offset(0, 8),
    this.alignment = McPopoverMenuAlignment.start,
    this.showCheckmark = true,
    this.animationDuration = const Duration(milliseconds: 170),
    this.animationCurve = Curves.easeOutCubic,
    this.enabled = true,
    this.openOnTap = true,
    this.openOnLongPress = false,
    this.onOpenChanged,
  });

  /// Menu entries, rendered in order.
  final List<McPopoverMenuItem<T>> items;

  /// Called with the tapped entry's value, then the menu closes.
  final ValueChanged<T> onSelected;

  /// The widget that opens the menu. It should not handle taps itself.
  final Widget child;

  /// Value used to render the selected row and its checkmark.
  ///
  /// When null, no row is marked as selected.
  final T? selectedValue;

  /// Menu width. Ignored when [matchTriggerWidth] is true.
  final double width;

  /// Sizes the menu to the trigger's width — ideal for dropdown-style fields.
  final bool matchTriggerWidth;

  /// Corner radius of the menu surface.
  final double radius;

  /// Menu background. Defaults to a semi-transparent card color.
  final Color? backgroundColor;

  /// Hairline border color. Defaults to a translucent separator.
  final Color? borderColor;

  /// Color painted behind the menu while it is open. Transparent by default.
  final Color? barrierColor;

  /// Custom elevation shadows. Defaults to a soft ambient shadow.
  final List<BoxShadow>? shadows;

  /// Padding around the entries inside the menu surface.
  final EdgeInsetsGeometry padding;

  /// Minimum height of an entry.
  final double itemHeight;

  /// Gap between the trigger and the menu. [Offset.dx] nudges the menu
  /// horizontally before it is clamped to the screen.
  final Offset offset;

  /// Preferred horizontal alignment.
  final McPopoverMenuAlignment alignment;

  /// Whether the selected row shows a checkmark.
  final bool showCheckmark;

  /// Open / close animation duration.
  final Duration animationDuration;

  /// Open / close animation curve.
  final Curve animationCurve;

  /// When false, tapping [child] does nothing.
  final bool enabled;

  /// Whether a tap on [child] opens the menu.
  ///
  /// Set this to false together with [openOnLongPress] when the trigger has
  /// its own tap behaviour (e.g. a schedule header that jumps on tap and opens
  /// the menu on long press).
  final bool openOnTap;

  /// Whether a long press on [child] opens the menu.
  final bool openOnLongPress;

  /// Notifies the trigger when the menu starts opening or closing, e.g. to
  /// rotate a chevron.
  final ValueChanged<bool>? onOpenChanged;

  @override
  State<McPopoverMenu<T>> createState() => _McPopoverMenuState<T>();
}

class _McPopoverMenuState<T> extends State<McPopoverMenu<T>>
    with SingleTickerProviderStateMixin {
  static const double _screenMargin = 8;

  final LayerLink _layerLink = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  final ValueNotifier<int> _revision = ValueNotifier<int>(0);

  OverlayEntry? _entry;
  AnimationController? _controller;
  _McPopoverGeometry? _geometry;
  ModalRoute<dynamic>? _route;
  bool _closing = false;

  @override
  void didUpdateWidget(covariant McPopoverMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_entry == null) return;
    if (widget.items.isEmpty) {
      _close(notify: false);
      return;
    }
    // Items / selectedValue changed while the menu is open — repaint it with
    // the latest data.
    _revision.value++;
  }

  @override
  void dispose() {
    _detachRoute();
    _entry?.remove();
    _entry = null;
    _controller?.dispose();
    _controller = null;
    _revision.dispose();
    super.dispose();
  }

  /// Closes the menu when its route stops being the top-most route, so the
  /// overlay never lingers over a page pushed afterwards.
  void _attachRoute() {
    _detachRoute();
    _route = ModalRoute.of(context);
    _route?.secondaryAnimation?.addListener(_onRouteChanged);
  }

  void _detachRoute() {
    _route?.secondaryAnimation?.removeListener(_onRouteChanged);
    _route = null;
  }

  void _onRouteChanged() {
    final route = _route;
    if (!mounted || route == null) return;
    final covered = (route.secondaryAnimation?.value ?? 0) > 0;
    if (covered || !route.isCurrent) {
      _close();
    }
  }

  void _toggle() {
    if (!widget.enabled) return;
    if (_entry != null) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (!mounted || widget.items.isEmpty || _entry != null) return;

    final geometry = _resolveGeometry();
    if (geometry == null) return;

    final controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _geometry = geometry;
    _controller = controller;
    _closing = false;

    final entry = OverlayEntry(builder: _buildOverlay);
    _entry = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
    _attachRoute();
    controller.forward();
    widget.onOpenChanged?.call(true);
  }

  void _close({bool notify = true}) {
    final entry = _entry;
    final controller = _controller;
    if (entry == null || controller == null || _closing) return;

    _closing = true;
    if (notify && mounted) {
      widget.onOpenChanged?.call(false);
    }
    if (widget.animationDuration == Duration.zero) {
      _finishClose(entry, controller);
      return;
    }
    controller.reverse().whenComplete(() => _finishClose(entry, controller));
  }

  void _finishClose(OverlayEntry entry, AnimationController controller) {
    _detachRoute();
    if (_entry == entry) {
      entry.remove();
      _entry = null;
    }
    if (identical(_controller, controller)) {
      _controller = null;
    }
    controller.dispose();
    _closing = false;
  }

  void _select(McPopoverMenuItem<T> item) {
    if (!widget.enabled || !item.enabled) return;
    try {
      widget.onSelected(item.value);
    } finally {
      _close();
    }
  }

  /// Measures the trigger in overlay coordinates and decides which side of it
  /// the menu can occupy.
  _McPopoverGeometry? _resolveGeometry() {
    final triggerContext = _triggerKey.currentContext;
    final triggerBox = triggerContext?.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context, rootOverlay: true);
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (triggerBox == null ||
        overlayBox == null ||
        !triggerBox.attached ||
        !overlayBox.attached) {
      return null;
    }

    final triggerRect = MatrixUtils.transformRect(
      triggerBox.getTransformTo(overlayBox),
      Offset.zero & triggerBox.size,
    );
    final screenSize = overlayBox.size;

    final media = MediaQuery.maybeOf(context);
    final safePadding = media?.padding ?? EdgeInsets.zero;
    final viewInsets = media?.viewInsets ?? EdgeInsets.zero;
    final safe = Rect.fromLTRB(
      _screenMargin + safePadding.left,
      _screenMargin + safePadding.top,
      math.max(
        _screenMargin + safePadding.left,
        screenSize.width - _screenMargin - safePadding.right,
      ),
      math.max(
        _screenMargin + safePadding.top,
        screenSize.height -
            _screenMargin -
            safePadding.bottom -
            viewInsets.bottom,
      ),
    );

    final requestedWidth = widget.matchTriggerWidth
        ? triggerRect.width
        : widget.width;
    final safeWidth = safe.width > 0 ? safe.width : screenSize.width;
    final width = requestedWidth.clamp(0.0, safeWidth);

    final estimatedHeight =
        widget.items.length * widget.itemHeight + widget.padding.vertical;
    final gap = math.max(0.0, widget.offset.dy);
    final spaceBelow = safe.bottom - triggerRect.bottom - gap;
    final spaceAbove = triggerRect.top - safe.top - gap;

    // Prefer below when it fits; otherwise take whichever side has more room.
    final placeBelow =
        spaceBelow >= estimatedHeight || spaceBelow >= spaceAbove;
    final spaceOnSide = placeBelow ? spaceBelow : spaceAbove;
    final maxHeight = math.max(spaceOnSide, 0.0);
    if (maxHeight == 0) return null;

    var horizontal = widget.alignment;
    final nudge = widget.offset.dx;

    // Flip horizontally only when the requested side genuinely cannot hold the
    // menu and the other side can.
    if (horizontal == McPopoverMenuAlignment.start &&
        triggerRect.left + nudge + width > safe.right &&
        triggerRect.right + nudge - width >= safe.left) {
      horizontal = McPopoverMenuAlignment.end;
    } else if (horizontal == McPopoverMenuAlignment.end &&
        triggerRect.right + nudge - width < safe.left &&
        triggerRect.left + nudge + width <= safe.right) {
      horizontal = McPopoverMenuAlignment.start;
    }

    final double targetX;
    final double followerX;
    final double dx;
    switch (horizontal) {
      case McPopoverMenuAlignment.start:
        targetX = -1;
        followerX = -1;
        final minLeft = safe.left;
        final maxLeft = math.max(minLeft, safe.right - width);
        dx =
            (triggerRect.left + nudge).clamp(minLeft, maxLeft) -
            triggerRect.left;
      case McPopoverMenuAlignment.center:
        targetX = 0;
        followerX = 0;
        final minCenter = safe.left + width / 2;
        final maxCenter = math.max(minCenter, safe.right - width / 2);
        dx =
            (triggerRect.center.dx + nudge).clamp(minCenter, maxCenter) -
            triggerRect.center.dx;
      case McPopoverMenuAlignment.end:
        targetX = 1;
        followerX = 1;
        final minRight = math.min(safe.right, safe.left + width);
        final maxRight = safe.right;
        dx =
            (triggerRect.right + nudge).clamp(minRight, maxRight) -
            triggerRect.right;
    }

    return _McPopoverGeometry(
      width: width,
      maxHeight: maxHeight,
      offset: Offset(dx, placeBelow ? gap : -gap),
      targetAnchor: Alignment(targetX, placeBelow ? 1 : -1),
      followerAnchor: Alignment(followerX, placeBelow ? -1 : 1),
      scaleOrigin: Alignment(targetX, placeBelow ? -1 : 1),
    );
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    return ValueListenableBuilder<int>(
      valueListenable: _revision,
      builder: (context, _, _) {
        final controller = _controller;
        final geometry = _geometry;
        if (controller == null || geometry == null) {
          return const SizedBox.shrink();
        }

        final animation = CurvedAnimation(
          parent: controller,
          curve: widget.animationCurve,
        );

        return SizedBox.expand(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _close,
                  child: ColoredBox(
                    color: widget.barrierColor ?? const Color(0x00000000),
                  ),
                ),
              ),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: geometry.targetAnchor,
                followerAnchor: geometry.followerAnchor,
                offset: geometry.offset,
                child: FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.92,
                      end: 1,
                    ).animate(animation),
                    alignment: geometry.scaleOrigin,
                    child: _buildPanel(context, geometry),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPanel(BuildContext context, _McPopoverGeometry geometry) {
    final m = context.mc;
    final borderRadius = BorderRadius.circular(widget.radius);
    final side = BorderSide(
      color: widget.borderColor ?? m.border.withValues(alpha: 0.4),
      width: 0.5,
    );

    final rows = <Widget>[
      for (final item in widget.items)
        _McPopoverMenuRow(
          label: item.label,
          icon: item.icon,
          iconColor: item.iconColor,
          selected:
              widget.selectedValue != null &&
              item.value == widget.selectedValue,
          showCheckmark: widget.showCheckmark,
          destructive: item.isDestructive,
          enabled: item.enabled && widget.enabled,
          minHeight: widget.itemHeight,
          onTap: () => _select(item),
        ),
    ];

    final content = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: geometry.maxHeight),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context)
            .copyWith(scrollbars: false, overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: widget.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: rows,
          ),
        ),
      ),
    );

    final shadows =
        widget.shadows ??
        <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: m.brightness == Brightness.dark ? 0.42 : 0.16,
            ),
            blurRadius: 28,
            spreadRadius: -4,
            offset: const Offset(0, 10),
          ),
        ];

    // Text inside an overlay is not under a Material / Scaffold, so provide a
    // sane default instead of Flutter's yellow debug underline.
    final surface = DefaultTextStyle(
      style: TextStyle(
        color: m.foreground,
        fontSize: 15,
        decoration: TextDecoration.none,
      ),
      child: McSmoothCorners.clip(
        borderRadius: borderRadius,
        side: side,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: ColoredBox(
            color: widget.backgroundColor ?? m.card.withValues(alpha: 0.94),
            child: content,
          ),
        ),
      ),
    );

    return SizedBox(
      width: geometry.width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: shadows,
        ),
        child: surface,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: widget.enabled,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: MouseRegion(
          cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.enabled && widget.openOnTap ? _toggle : null,
            onLongPress: widget.enabled && widget.openOnLongPress
                ? _toggle
                : null,
            child: KeyedSubtree(key: _triggerKey, child: widget.child),
          ),
        ),
      ),
    );
  }
}

/// Resolved overlay placement for an open menu.
@immutable
class _McPopoverGeometry {
  const _McPopoverGeometry({
    required this.width,
    required this.maxHeight,
    required this.offset,
    required this.targetAnchor,
    required this.followerAnchor,
    required this.scaleOrigin,
  });

  final double width;
  final double maxHeight;
  final Offset offset;
  final Alignment targetAnchor;
  final Alignment followerAnchor;
  final Alignment scaleOrigin;
}

class _McPopoverMenuRow extends StatefulWidget {
  const _McPopoverMenuRow({
    required this.label,
    required this.selected,
    required this.showCheckmark,
    required this.destructive,
    required this.enabled,
    required this.minHeight,
    required this.onTap,
    this.icon,
    this.iconColor,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool selected;
  final bool showCheckmark;
  final bool destructive;
  final bool enabled;
  final double minHeight;
  final VoidCallback onTap;

  @override
  State<_McPopoverMenuRow> createState() => _McPopoverMenuRowState();
}

class _McPopoverMenuRowState extends State<_McPopoverMenuRow> {
  bool _hovered = false;
  bool _pressed = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final enabled = widget.enabled;
    final foreground = !enabled
        ? m.tertiaryLabel
        : widget.destructive
        ? m.destructive
        : m.foreground;
    final iconColor = widget.iconColor ?? foreground;

    final Color background;
    if (!enabled) {
      background = const Color(0x00000000);
    } else if (_pressed) {
      background = m.selectionFill;
    } else if (widget.selected) {
      background = m.primary.withValues(alpha: _hovered ? 0.16 : 0.10);
    } else if (_hovered) {
      background = m.selectionFill;
    } else {
      background = const Color(0x00000000);
    }

    return Semantics(
      button: true,
      enabled: enabled,
      selected: widget.selected,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled ? (_) => _setPressed(true) : null,
          onTapUp: enabled ? (_) => _setPressed(false) : null,
          onTapCancel: enabled ? () => _setPressed(false) : null,
          onTap: enabled ? widget.onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            constraints: BoxConstraints(minHeight: widget.minHeight),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: ShapeDecoration(
              color: background,
              shape: McSmoothCorners.shape(
                BorderRadius.circular(McRadii.navigation),
              ),
            ),
            child: Row(
              children: <Widget>[
                if (widget.icon != null) ...<Widget>[
                  Icon(widget.icon, size: 18, color: iconColor),
                  const SizedBox(width: 11),
                ],
                Expanded(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: widget.selected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: foreground,
                      letterSpacing: -0.2,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                if (widget.showCheckmark) ...<Widget>[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 18,
                    child: widget.selected
                        ? Icon(
                            CupertinoIcons.checkmark,
                            size: 16,
                            color: widget.destructive
                                ? m.destructive
                                : m.primary,
                          )
                        : null,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
