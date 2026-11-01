import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../motion/mc_animated_button.dart';
import '../theme/mc_context.dart';

/// A command in a toolbar pull-down or overflow menu.
@immutable
class McToolBarMenuItem {
  const McToolBarMenuItem({
    required this.label,
    this.icon,
    this.onSelected,
    this.enabled = true,
    this.isDestructive = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onSelected;
  final bool enabled;
  final bool isDestructive;

  bool get _enabled => enabled && onSelected != null;
}

/// A toolbar item with a known width and an accessible overflow representation.
abstract class McToolBarItem extends StatelessWidget {
  const McToolBarItem({super.key});

  /// Width including the item's own horizontal padding.
  double widthFor(BuildContext context);

  /// Commands shown when this item does not fit in the toolbar.
  List<McToolBarMenuItem> get overflowItems;
}

/// A macOS-style toolbar rendered within Flutter's content area.
///
/// Like macos_ui's ToolBar, defaults to 52px high and moves trailing commands
/// into a menu when space runs out. Uses Mc theme colors without requiring
/// macos_ui or a native window plugin. Can be placed in McSidebarShell.toolbar,
/// a Column, or a Material Scaffold.appBar. Native title-bar integration and
/// window dragging remain the host application's responsibility.
class McToolBar extends StatelessWidget implements PreferredSizeWidget {
  const McToolBar({
    super.key,
    this.title,
    this.titleWidth = 150,
    this.leading,
    this.leadingWidth = 40,
    this.automaticallyImplyLeading = true,
    this.backButtonLabel = 'Back',
    this.actions = const [],
    this.height = 52,
    this.centerTitle = false,
    this.backgroundColor,
    this.dividerColor,
    this.isWindowFocused = true,
    this.enableBlur = false,
    this.overflowLabel = 'More actions',
    this.onBackgroundPanStart,
    this.onBackgroundDoubleTap,
  }) : assert(height >= 44 && height < double.infinity),
       assert(leadingWidth >= 0 && leadingWidth < double.infinity),
       assert(titleWidth >= 0 && titleWidth < double.infinity);

  final Widget? title;

  /// Preferred title width; shrinks before the leading/overflow controls.
  final double titleWidth;
  final Widget? leading;

  /// Space reserved for [leading], e.g. 80px for two adjacent controls.
  final double leadingWidth;
  final bool automaticallyImplyLeading;

  /// Localizable label for the automatically supplied back button.
  final String backButtonLabel;
  final List<McToolBarItem> actions;
  final double height;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? dividerColor;
  final bool isWindowFocused;
  final bool enableBlur;

  /// Localizable tooltip and accessibility label for the overflow button.
  final String overflowLabel;

  /// Host-provided window dragging/zooming for the title and empty space.
  /// Leading controls and actions keep their own gestures.
  final GestureDragStartCallback? onBackgroundPanStart;
  final VoidCallback? onBackgroundDoubleTap;

  Widget _dragArea(Widget child) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onPanStart: onBackgroundPanStart,
    onDoubleTap: onBackgroundDoubleTap,
    child: child,
  );

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final effectiveLeading =
        leading ??
        (automaticallyImplyLeading && (ModalRoute.of(context)?.canPop ?? false)
            ? McToolBarIconButton(
                label: backButtonLabel,
                icon: const Icon(CupertinoIcons.chevron_back),
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null);
    Widget content = DefaultTextStyle(
      style: TextStyle(
        fontFamily: '.AppleSystemUIFont',
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: isWindowFocused ? m.foreground : m.secondaryLabel,
        decoration: TextDecoration.none,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: IconTheme(
        data: IconThemeData(color: m.secondaryLabel, size: 20),
        child: SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color:
                  backgroundColor ??
                  m.groupedBackground.withValues(alpha: enableBlur ? 0.85 : 1),
              border: Border(
                bottom: BorderSide(
                  color: dividerColor ?? m.separator,
                  width: 0.5,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // A finite content width is required to decide overflow.
                  assert(
                    constraints.hasBoundedWidth,
                    'McToolBar requires a bounded width.',
                  );
                  final available = constraints.maxWidth;
                  final leadingWidth = effectiveLeading == null
                      ? 0.0
                      : math.min(this.leadingWidth, available);
                  final widths = [
                    for (final item in actions) item.widthFor(context),
                  ];
                  final total = widths.fold(0.0, (sum, width) => sum + width);
                  final desiredTitle = title == null ? 0.0 : titleWidth;
                  final actionSpace = math.max(
                    0.0,
                    available - leadingWidth - desiredTitle,
                  );
                  var visibleCount = actions.length;
                  var visibleWidth = total;
                  if (total > actionSpace) {
                    final budget = math.max(0.0, actionSpace - 36);
                    while (visibleCount > 0 && visibleWidth > budget) {
                      visibleWidth -= widths[--visibleCount];
                    }
                  }
                  final hidden = [
                    for (final item in actions.skip(visibleCount))
                      ...item.overflowItems,
                  ];
                  final overflowWidth = hidden.isEmpty ? 0.0 : 36.0;
                  final usedActions = visibleWidth + overflowWidth;
                  final actualTitleWidth = math.min(
                    desiredTitle,
                    math.max(
                      0.0,
                      centerTitle
                          ? available - 2 * math.max(leadingWidth, usedActions)
                          : available - leadingWidth - usedActions,
                    ),
                  );
                  final titleWidget = title == null
                      ? null
                      : _dragArea(
                          SizedBox(
                            width: actualTitleWidth,
                            child: Align(
                              alignment: centerTitle
                                  ? Alignment.center
                                  : AlignmentDirectional.centerStart,
                              child: Semantics(header: true, child: title),
                            ),
                          ),
                        );
                  // Also clips arbitrary caller widgets and extremely small
                  // hosts; ordinary narrow windows retain an overflow button.
                  final row = Row(
                    children: [
                      if (effectiveLeading != null)
                        SizedBox(width: leadingWidth, child: effectiveLeading),
                      if (!centerTitle) ?titleWidget,
                      Expanded(child: _dragArea(const SizedBox.expand())),
                      for (var i = 0; i < visibleCount; i++)
                        SizedBox(width: widths[i], child: actions[i]),
                      if (hidden.isNotEmpty)
                        SizedBox(
                          width: math.min(
                            36.0,
                            math.max(0.0, available - leadingWidth),
                          ),
                          child: _ToolBarMenuButton(
                            label: overflowLabel,
                            icon: const Icon(CupertinoIcons.chevron_right_2),
                            items: hidden,
                          ),
                        ),
                    ],
                  );
                  return ClipRect(
                    child: centerTitle
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              row,
                              Center(child: titleWidget),
                            ],
                          )
                        : row,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    if (enableBlur) {
      content = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: content,
        ),
      );
    }
    return content;
  }
}

/// A toolbar command. A null callback disables pointer and keyboard activation.
class McToolBarIconButton extends McToolBarItem {
  const McToolBarIconButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.showLabel = false,
    this.tooltipMessage,
    this.selected = false,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool showLabel;
  final String? tooltipMessage;
  final bool selected;

  @override
  double widthFor(BuildContext context) =>
      showLabel ? math.max(56, _labelWidth(context, label) + 16) : 40;

  @override
  List<McToolBarMenuItem> get overflowItems => [
    McToolBarMenuItem(label: label, onSelected: onPressed),
  ];

  @override
  Widget build(BuildContext context) => _ToolBarButton(
    label: label,
    icon: icon,
    onPressed: onPressed,
    showLabel: showLabel,
    tooltip: tooltipMessage,
    selected: selected,
  );
}

/// A toolbar command that opens an anchored, keyboard-navigable menu.
class McToolBarPullDownButton extends McToolBarItem {
  const McToolBarPullDownButton({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    this.showLabel = false,
    this.enabled = true,
    this.tooltipMessage,
  });

  final String label;
  final Widget icon;
  final List<McToolBarMenuItem> items;
  final bool showLabel;
  final bool enabled;
  final String? tooltipMessage;

  @override
  double widthFor(BuildContext context) =>
      showLabel ? math.max(56, _labelWidth(context, label) + 16) : 40;

  @override
  List<McToolBarMenuItem> get overflowItems => [
    for (final item in items)
      McToolBarMenuItem(
        label: '$label / ${item.label}',
        icon: item.icon,
        onSelected: item.onSelected,
        enabled: enabled && item.enabled,
        isDestructive: item.isDestructive,
      ),
  ];

  @override
  Widget build(BuildContext context) => _ToolBarMenuButton(
    label: label,
    icon: icon,
    items: items,
    enabled: enabled,
    showLabel: showLabel,
    tooltip: tooltipMessage,
  );
}

/// Fixed spacing between toolbar groups, in units of 32px.
class McToolBarSpacer extends McToolBarItem {
  const McToolBarSpacer({super.key, this.spacerUnits = 1})
    : assert(spacerUnits >= 0 && spacerUnits < double.infinity);

  final double spacerUnits;

  @override
  double widthFor(BuildContext context) => spacerUnits * 32;

  @override
  List<McToolBarMenuItem> get overflowItems => const [];

  @override
  Widget build(BuildContext context) => SizedBox(width: widthFor(context));
}

/// A fixed-width custom control, such as a search field or segmented selector.
///
/// Supply equivalent commands for the overflow menu so the control remains
/// usable when the window becomes narrow.
class McToolBarCustomItem extends McToolBarItem {
  const McToolBarCustomItem({
    super.key,
    required this.width,
    required this.child,
    required this.overflowItems,
  }) : assert(width > 0 && width < double.infinity),
       assert(overflowItems.length > 0);

  final double width;
  final Widget child;
  @override
  final List<McToolBarMenuItem> overflowItems;

  @override
  double widthFor(BuildContext context) => width;

  @override
  Widget build(BuildContext context) => SizedBox(width: width, child: child);
}

double _labelWidth(BuildContext context, String label) {
  final painter = TextPainter(
    text: TextSpan(
      text: label,
      style: const TextStyle(fontFamily: '.AppleSystemUIFont', fontSize: 11),
    ),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width;
}

class _ToolBarButton extends StatefulWidget {
  const _ToolBarButton({
    required this.label,
    required this.icon,
    this.onPressed,
    this.showLabel = false,
    this.tooltip,
    this.selected = false,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool showLabel;
  final String? tooltip;
  final bool selected;

  @override
  State<_ToolBarButton> createState() => _ToolBarButtonState();
}

class _ToolBarButtonState extends State<_ToolBarButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    return Tooltip(
      message: widget.tooltip ?? widget.label,
      child: Semantics(
        label: widget.label,
        button: true,
        selected: widget.selected,
        enabled: widget.onPressed != null,
        child: McAnimatedButton(
          onTap: widget.onPressed,
          enabled: widget.onPressed != null,
          scaleOnPress: 1,
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit: (_) => setState(() => _hovered = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: widget.selected
                    ? m.selectionFill
                    : _hovered && widget.onPressed != null
                    ? m.cardOverlay
                    : null,
                borderRadius: BorderRadius.circular(6),
              ),
              child: ExcludeSemantics(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          size: widget.showLabel ? 16 : 20,
                          color: widget.selected ? m.primary : m.secondaryLabel,
                        ),
                        child: widget.icon,
                      ),
                      if (widget.showLabel) ...[
                        const SizedBox(height: 3),
                        Text(
                          widget.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: m.secondaryLabel,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolBarMenuButton extends StatelessWidget {
  const _ToolBarMenuButton({
    required this.label,
    required this.icon,
    required this.items,
    this.enabled = true,
    this.showLabel = false,
    this.tooltip,
  });

  final String label;
  final Widget icon;
  final List<McToolBarMenuItem> items;
  final bool enabled;
  final bool showLabel;
  final String? tooltip;

  @override
  Widget build(BuildContext context) => _ToolBarButton(
    label: label,
    icon: icon,
    showLabel: showLabel,
    tooltip: tooltip,
    onPressed: enabled && items.isNotEmpty
        ? () => _showToolBarMenu(context, items, label)
        : null,
  );
}

Future<void> _showToolBarMenu(
  BuildContext context,
  List<McToolBarMenuItem> items,
  String label,
) async {
  final box = context.findRenderObject()! as RenderBox;
  final navigator = Navigator.of(context, rootNavigator: true);
  final overlayBox =
      navigator.overlay!.context.findRenderObject()! as RenderBox;
  final anchor =
      box.localToGlobal(Offset.zero, ancestor: overlayBox) & box.size;
  final themes = InheritedTheme.capture(from: context, to: navigator.context);
  final index = await showGeneralDialog<int>(
    context: context,
    barrierDismissible: true,
    barrierLabel: label,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 100),
    pageBuilder: (context, _, _) =>
        themes.wrap(_ToolBarMenu(anchor: anchor, items: items)),
  );
  // Invoke after the popup is removed, so callbacks can safely navigate.
  if (index != null && context.mounted && items[index]._enabled) {
    items[index].onSelected!();
  }
}

class _ToolBarMenu extends StatefulWidget {
  const _ToolBarMenu({required this.anchor, required this.items});
  final Rect anchor;
  final List<McToolBarMenuItem> items;

  @override
  State<_ToolBarMenu> createState() => _ToolBarMenuState();
}

class _ToolBarMenuState extends State<_ToolBarMenu> {
  late final _nodes = [for (final _ in widget.items) FocusNode()];
  Size? _windowSize;

  @override
  void dispose() {
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _move(int direction) {
    final enabled = [
      for (var i = 0; i < widget.items.length; i++)
        if (widget.items[i]._enabled) i,
    ];
    if (enabled.isEmpty) return;
    final current = enabled.indexWhere((i) => _nodes[i].hasFocus);
    final next = enabled[(current + direction) % enabled.length];
    _nodes[next].requestFocus();
    final rowContext = _nodes[next].context;
    if (rowContext != null) Scrollable.ensureVisible(rowContext);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (_windowSize != null && _windowSize != size) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
    }
    _windowSize = size;
    final padding = MediaQuery.paddingOf(context);
    final safe = Rect.fromLTRB(
      padding.left + 8,
      padding.top + 8,
      size.width - padding.right - 8,
      size.height - padding.bottom - 8,
    );
    final width = math.min(240.0, math.max(0.0, safe.width));
    final below = math.max(0.0, safe.bottom - widget.anchor.bottom - 4);
    final above = math.max(0.0, widget.anchor.top - safe.top - 4);
    final openBelow =
        below >= math.min(200, widget.items.length * 32 + 8) || below >= above;
    final maxHeight = openBelow ? below : above;
    final left =
        (Directionality.of(context) == TextDirection.rtl
                ? widget.anchor.left
                : widget.anchor.right - width)
            .clamp(safe.left, math.max(safe.left, safe.right - width));
    final m = context.mc;
    final firstEnabled = widget.items.indexWhere((item) => item._enabled);
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowDown): _MenuMoveIntent(1),
        SingleActivator(LogicalKeyboardKey.arrowUp): _MenuMoveIntent(-1),
        SingleActivator(LogicalKeyboardKey.escape): DismissIntent(),
      },
      child: Actions(
        actions: {
          _MenuMoveIntent: CallbackAction<_MenuMoveIntent>(
            onInvoke: (intent) {
              _move(intent.direction);
              return null;
            },
          ),
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) {
              Navigator.of(context).pop();
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: firstEnabled == -1,
          child: Stack(
            children: [
              Positioned(
                left: left.toDouble(),
                top: openBelow ? widget.anchor.bottom + 4 : null,
                bottom: openBelow ? null : size.height - widget.anchor.top + 4,
                width: width,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontFamily: '.AppleSystemUIFont',
                    fontSize: 13,
                    color: m.foreground,
                    decoration: TextDecoration.none,
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    decoration: BoxDecoration(
                      color: m.card,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: m.separator, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: m.shadowColor,
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < widget.items.length; i++)
                            _ToolBarMenuRow(
                              item: widget.items[i],
                              focusNode: _nodes[i],
                              autofocus: i == firstEnabled,
                              onSelected: () => Navigator.of(context).pop(i),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuMoveIntent extends Intent {
  const _MenuMoveIntent(this.direction);
  final int direction;
}

class _ToolBarMenuRow extends StatefulWidget {
  const _ToolBarMenuRow({
    required this.item,
    required this.focusNode,
    required this.autofocus,
    required this.onSelected,
  });
  final McToolBarMenuItem item;
  final FocusNode focusNode;
  final bool autofocus;
  final VoidCallback onSelected;

  @override
  State<_ToolBarMenuRow> createState() => _ToolBarMenuRowState();
}

class _ToolBarMenuRowState extends State<_ToolBarMenuRow> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final item = widget.item;
    final highlighted = item._enabled && (_hovered || _focused);
    final color = !item._enabled
        ? m.tertiaryLabel
        : highlighted
        ? m.onAccent
        : item.isDestructive
        ? m.destructive
        : m.foreground;
    return FocusableActionDetector(
      enabled: item._enabled,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (value) => setState(() => _focused = value),
      mouseCursor: item._enabled ? SystemMouseCursors.click : MouseCursor.defer,
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            if (item._enabled) widget.onSelected();
            return null;
          },
        ),
      },
      child: Semantics(
        button: true,
        enabled: item._enabled,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: item._enabled ? widget.onSelected : null,
            child: Container(
              constraints: const BoxConstraints(minHeight: 28),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: highlighted ? m.primary : null,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  if (item.icon != null) ...[
                    Icon(item.icon, size: 16, color: color),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(item.label, style: TextStyle(color: color)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
