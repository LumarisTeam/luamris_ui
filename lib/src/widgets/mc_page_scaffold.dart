import 'package:cupertino_ui/cupertino_ui.dart';

import '../responsive/mc_responsive.dart';
import '../theme/mc_context.dart';

/// Navigation bar style for [McPageScaffold].
enum McNavigationBarStyle { large, compact }

/// Full-page scaffold with an optional Cupertino navigation bar,
/// responsive content centering, and an optional bottom bar.
class McPageScaffold extends StatelessWidget {
  const McPageScaffold({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.previousPageTitle,
    this.navigationBarStyle = McNavigationBarStyle.large,
    this.alwaysShowMiddle = true,
    this.transitionBetweenRoutes = true,
    this.bottomBar,
    this.backgroundColor,
    this.maxContentWidth,
    this.padding,
    this.scrollController,
    this.physics = const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    ),
    this.resizeToAvoidBottomInset = true,
    this.child,
    this.slivers,
  }) : assert(
         child != null || slivers != null,
         'McPageScaffold requires either child or slivers.',
       ),
       assert(
         child == null || slivers == null,
         'McPageScaffold cannot receive both child and slivers.',
       );

  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final String? previousPageTitle;
  final McNavigationBarStyle navigationBarStyle;
  final bool alwaysShowMiddle;
  final bool transitionBetweenRoutes;
  final Widget? bottomBar;

  /// Page background. Defaults to [McColors.groupedBackground].
  final Color? backgroundColor;

  final double? maxContentWidth;
  final EdgeInsets? padding;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final bool resizeToAvoidBottomInset;
  final Widget? child;
  final List<Widget>? slivers;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final contentPadding =
        padding ?? McResponsive.pagePadding(context, narrow: 16, wide: 24);
    final contentMaxWidth =
        maxContentWidth ?? McResponsive.contentMaxWidth(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bg = backgroundColor ?? m.groupedBackground;

    return CupertinoPageScaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: bottomBar == null
          ? resizeToAvoidBottomInset
          : false,
      child: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            physics: physics,
            slivers: [
              if (title != null)
                switch (navigationBarStyle) {
                  McNavigationBarStyle.large => CupertinoSliverNavigationBar(
                    largeTitle: Text(
                      title!,
                      style: TextStyle(
                        color: m.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    leading: leading,
                    trailing: trailing,
                    previousPageTitle: previousPageTitle,
                    alwaysShowMiddle: alwaysShowMiddle,
                    transitionBetweenRoutes: transitionBetweenRoutes,
                    backgroundColor: bg.withValues(alpha: 0.94),
                    border: Border(
                      bottom: BorderSide(
                        color: m.border.withValues(alpha: 0.35),
                      ),
                    ),
                    automaticallyImplyLeading: leading == null,
                    padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                  ),
                  McNavigationBarStyle.compact => _McCompactNavigationBarSliver(
                    title: title!,
                    leading: leading,
                    trailing: trailing,
                    previousPageTitle: previousPageTitle,
                    transitionBetweenRoutes: transitionBetweenRoutes,
                    backgroundColor: bg,
                  ),
                },
              if (slivers != null)
                ...slivers!
              else
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: contentMaxWidth),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: contentPadding.left,
                          right: contentPadding.right,
                          top: contentPadding.top,
                          bottom: bottomBar == null
                              ? contentPadding.bottom
                              : 120 + bottomInset,
                        ),
                        child: child!,
                      ),
                    ),
                  ),
                ),
              if (slivers != null && bottomBar != null)
                SliverToBoxAdapter(child: SizedBox(height: 120 + bottomInset)),
            ],
          ),
          if (bottomBar != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentMaxWidth),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        contentPadding.left,
                        0,
                        contentPadding.right,
                        12 + bottomInset,
                      ),
                      child: bottomBar!,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _McCompactNavigationBarSliver extends StatelessWidget {
  const _McCompactNavigationBarSliver({
    required this.title,
    this.leading,
    this.trailing,
    this.previousPageTitle,
    required this.transitionBetweenRoutes,
    required this.backgroundColor,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final String? previousPageTitle;
  final bool transitionBetweenRoutes;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final navigationBar = CupertinoNavigationBar(
      middle: Text(
        title,
        style: TextStyle(color: m.foreground, fontWeight: FontWeight.w700),
      ),
      leading: leading,
      trailing: trailing,
      previousPageTitle: previousPageTitle,
      automaticallyImplyLeading: leading == null,
      transitionBetweenRoutes: transitionBetweenRoutes,
      backgroundColor: backgroundColor.withValues(alpha: 0.94),
      border: Border(
        bottom: BorderSide(color: m.border.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
    );

    return SliverPersistentHeader(
      pinned: true,
      delegate: _McCompactNavigationBarDelegate(
        navigationBar: navigationBar,
        height:
            navigationBar.preferredSize.height +
            MediaQuery.paddingOf(context).top,
      ),
    );
  }
}

class _McCompactNavigationBarDelegate extends SliverPersistentHeaderDelegate {
  const _McCompactNavigationBarDelegate({
    required this.navigationBar,
    required this.height,
  });

  final CupertinoNavigationBar navigationBar;
  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return navigationBar;
  }

  @override
  bool shouldRebuild(_McCompactNavigationBarDelegate oldDelegate) {
    return navigationBar != oldDelegate.navigationBar ||
        height != oldDelegate.height;
  }
}
