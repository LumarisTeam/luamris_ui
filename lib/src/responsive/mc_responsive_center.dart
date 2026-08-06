import 'package:flutter/cupertino.dart';

import 'mc_responsive.dart';

/// Centers child content with a responsive maximum width and padding.
class McResponsiveCenter extends StatelessWidget {
  const McResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final contentPadding =
        padding ?? McResponsive.pagePadding(context, narrow: 16, wide: 24);

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? McResponsive.contentMaxWidth(context),
        ),
        child: Padding(padding: contentPadding, child: child),
      ),
    );
  }
}
