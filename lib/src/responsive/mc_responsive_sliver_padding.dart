import 'package:cupertino_ui/cupertino_ui.dart';

import 'mc_responsive.dart';

/// A sliver that applies responsive padding and maximum-width constraint
/// to its child.
class McResponsiveSliverPadding extends StatelessWidget {
  const McResponsiveSliverPadding({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding ?? McResponsive.sliverPagePadding(context),
      sliver: SliverToBoxAdapter(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth ?? McResponsive.contentMaxWidth(context),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
