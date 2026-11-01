import 'package:material_ui/material_ui.dart';

import '../theme/mc_context.dart';

/// Controls sidebar visibility from a toolbar or another part of the window.
///
/// The owner creates and disposes the controller. Dragging the sidebar closed
/// updates [isVisible] and notifies listeners as well.
class McSidebarController extends ChangeNotifier {
  // Keep the public constructor parameter separate from the private field.
  // ignore: prefer_initializing_formals
  McSidebarController({bool isVisible = true}) : _isVisible = isVisible;

  bool _isVisible;
  bool get isVisible => _isVisible;

  void show() => _setVisible(true);
  void hide() => _setVisible(false);
  void toggle() => _setVisible(!_isVisible);

  void _setVisible(bool value) {
    if (_isVisible == value) return;
    _isVisible = value;
    notifyListeners();
  }
}

/// Desktop layout with a resizable left sidebar and an expanded content pane.
///
/// Dragging 90px past [minWidth] collapses the sidebar. Drag the left edge to
/// open it again. The parent must provide a bounded width and height.
class McSidebarShell extends StatefulWidget {
  const McSidebarShell({
    super.key,
    required this.sidebar,
    required this.child,
    this.toolbar,
    this.controller,
    this.initialWidth = 220,
    this.minWidth = 180,
    this.maxWidth = 280,
  }) : assert(minWidth > 0 && minWidth < double.infinity),
       assert(maxWidth >= minWidth && maxWidth < double.infinity),
       assert(initialWidth >= minWidth && initialWidth <= maxWidth);

  final Widget sidebar;
  final Widget child;

  /// A toolbar above the content pane, alongside the sidebar.
  final PreferredSizeWidget? toolbar;
  final McSidebarController? controller;
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
  void initState() {
    super.initState();
    _visible = widget.controller?.isVisible ?? true;
    widget.controller?.addListener(_onVisibilityChanged);
  }

  void _onVisibilityChanged() {
    setState(() => _visible = widget.controller!.isVisible);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onVisibilityChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant McSidebarShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onVisibilityChanged);
      widget.controller?.addListener(_onVisibilityChanged);
      _visible = widget.controller?.isVisible ?? _visible;
    }
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
    widget.controller?._setVisible(_visible);
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.toolbar != null)
                      SizedBox(
                        height: widget.toolbar!.preferredSize.height,
                        child: widget.toolbar,
                      ),
                    Expanded(child: widget.child),
                  ],
                ),
              ),
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
