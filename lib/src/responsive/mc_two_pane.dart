import 'package:cupertino_ui/cupertino_ui.dart';

import 'mc_responsive.dart';

/// A responsive two-pane layout.
///
/// On narrow screens (phone), stacks children vertically.
/// On wide screens (tablet/desktop), places them side-by-side.
class McTwoPane extends StatelessWidget {
  const McTwoPane({
    super.key,
    required this.primary,
    required this.secondary,
    this.secondaryWidth,
    this.gap,
    this.secondaryFirstOnWide = false,
    this.stackGap = 16,
  });

  /// The main content pane.
  final Widget primary;

  /// The sidebar / detail pane.
  final Widget secondary;

  /// Override the default sidebar width.
  final double? secondaryWidth;

  /// Override the gap between panes.
  final double? gap;

  /// When true, the secondary pane appears on the left in wide mode.
  final bool secondaryFirstOnWide;

  /// Vertical gap when stacked (phone mode).
  final double stackGap;

  @override
  Widget build(BuildContext context) {
    if (!McResponsive.isWideTwoPane(context)) {
      final children = secondaryFirstOnWide
          ? <Widget>[secondary, SizedBox(height: stackGap), primary]
          : <Widget>[primary, SizedBox(height: stackGap), secondary];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    }

    final side = SizedBox(
      width: secondaryWidth ?? McResponsive.sidePaneWidth(context),
      child: secondary,
    );
    final main = Expanded(child: primary);
    final children = secondaryFirstOnWide
        ? <Widget>[
            side,
            SizedBox(width: gap ?? McResponsive.twoPaneGap(context)),
            main,
          ]
        : <Widget>[
            main,
            SizedBox(width: gap ?? McResponsive.twoPaneGap(context)),
            side,
          ];

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
