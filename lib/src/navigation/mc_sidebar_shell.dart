import 'package:material_ui/material_ui.dart';

import '../theme/mc_context.dart';

/// Desktop layout with a resizable left sidebar and an expanded content pane.
///
/// Dragging 90px past [minWidth] collapses the sidebar. Drag the left edge to
/// open it again. The parent must provide a bounded width and height.
class McSidebarShell extends StatefulWidget {
  const McSidebarShell({
    super.key,
    required this.sidebar,
    required this.child,
    this.initialWidth = 220,
    this.minWidth = 180,
    this.maxWidth = 280,
  }) : assert(minWidth > 0 && minWidth < double.infinity),
       assert(maxWidth >= minWidth && maxWidth < double.infinity),
       assert(initialWidth >= minWidth && initialWidth <= maxWidth);

  final Widget sidebar;
  final Widget child;
  final double initialWidth;
  final double minWidth;
  final double maxWidth;

  @override
  State<McSidebarShell> createState() => _McSidebarShellState();
}

class _McSidebarShellState extends State<McSidebarShell> {
  late double _width = widget.initialWidth;
  bool _visible = true;
  double _dragStartWidth = 0;
  double _dragStartX = 0;

  double get _visibleWidth => _visible ? _width : 0;

  @override
  void didUpdateWidget(covariant McSidebarShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _width = _width.clamp(widget.minWidth, widget.maxWidth);
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStartWidth = _visibleWidth;
    _dragStartX = details.globalPosition.dx;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final newWidth = _dragStartWidth + details.globalPosition.dx - _dragStartX;
    setState(() {
      _visible = newWidth >= widget.minWidth - 90;
      _width = newWidth.clamp(widget.minWidth, widget.maxWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cursor = !_visible || _width == widget.minWidth
        ? SystemMouseCursors.resizeRight
        : _width == widget.maxWidth
        ? SystemMouseCursors.resizeLeft
        : SystemMouseCursors.resizeColumn;

    return ColoredBox(
      color: context.mc.groupedBackground,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Row(
            children: [
              SizedBox(
                width: _visibleWidth,
                child: _visible ? widget.sidebar : null,
              ),
              Expanded(child: widget.child),
            ],
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: _visibleWidth - 4,
            width: 7,
            child: MouseRegion(
              cursor: cursor,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: _handleDragStart,
                onHorizontalDragUpdate: _handleDragUpdate,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
