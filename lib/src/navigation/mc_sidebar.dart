import 'package:material_ui/material_ui.dart';

import '../theme/mc_context.dart';

const _fontFamily = '.AppleSystemUIFont';
const _labelLight = Color.fromRGBO(0, 0, 0, 0.85);
const _labelDark = Color.fromRGBO(255, 255, 255, 0.85);

/// A navigation destination in [McSidebar].
@immutable
class McSidebarDestination {
  const McSidebarDestination({
    required this.icon,
    required this.label,
    IconData? selectedIcon,
    this.badge,
  }) : selectedIcon = selectedIcon ?? icon;

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String? badge;
}

/// macOS-style navigation, ported from ios_club_app.
///
/// Preserves its 34px rows, 20px icons, 5px selection radius and Apple system
/// typography. Supply window focus from the host app; no desktop plugin is
/// required. The parent controls selection and provides a bounded height and
/// width (for example with [SizedBox] or McSidebarShell).
class McSidebar extends StatelessWidget {
  const McSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isWindowFocused = true,
    this.top,
    this.bottom,
    this.backgroundColor,
  }) : assert(selectedIndex >= -1 && selectedIndex < items.length);

  final List<McSidebarDestination> items;

  /// Use -1 when no destination is selected.
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isWindowFocused;

  /// Optional content above and below the scrollable navigation list.
  final Widget? top;
  final Widget? bottom;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.mc.brightness == Brightness.dark;
    final selectionColor = isWindowFocused
        ? (isDark
              ? const Color.fromRGBO(22, 105, 229, 0.749)
              : const Color.fromRGBO(9, 129, 255, 0.749))
        : (isDark
              ? const Color.fromRGBO(76, 78, 65, 1)
              : const Color.fromRGBO(213, 213, 208, 1));

    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13,
        color: isDark ? _labelDark : _labelLight,
        decoration: TextDecoration.none,
      ),
      child: ColoredBox(
        color: backgroundColor ?? context.mc.groupedBackground,
        child: Column(
          children: [
            const SizedBox(height: 8),
            ?top,
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(12),
                children: [
                  for (var index = 0; index < items.length; index++)
                    _SidebarItem(
                      destination: items[index],
                      selected: selectedIndex == index,
                      selectionColor: selectionColor,
                      onTap: () => onItemSelected(index),
                    ),
                ],
              ),
            ),
            ?bottom,
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.destination,
    required this.selected,
    required this.selectionColor,
    required this.onTap,
  });

  final McSidebarDestination destination;
  final bool selected;
  final Color selectionColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.mc.brightness == Brightness.dark;
    final labelColor = selected
        ? (selectionColor.computeLuminance() >= 0.5
              ? const Color(0xFF000000)
              : const Color(0xFFFFFFFF))
        : (isDark ? _labelDark : _labelLight);

    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: FocusableActionDetector(
          descendantsAreFocusable: false,
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) => onTap(),
            ),
            ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
              onInvoke: (_) => onTap(),
            ),
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.basic,
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: ShapeDecoration(
                color: selected ? selectionColor : Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: Icon(
                      selected ? destination.selectedIcon : destination.icon,
                      size: 20,
                      color: selected ? Colors.white : context.mc.primary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      destination.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        letterSpacing: -0.23,
                        color: labelColor,
                      ),
                    ),
                  ),
                  if (destination.badge != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: Text(
                        destination.badge!,
                        style: TextStyle(color: labelColor, fontSize: 11),
                      ),
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

/// A bottom account/info row for [McSidebar.bottom].
///
/// Authentication, localization and routing stay in the host application.
class McSidebarUserTile extends StatelessWidget {
  const McSidebarUserTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.mc.colors;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.separator, width: 0.5)),
        ),
        padding: const EdgeInsets.only(top: 8),
        child: Semantics(
          button: onTap != null,
          child: GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: FocusableActionDetector(
              enabled: onTap != null,
              actions: <Type, Action<Intent>>{
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) => onTap?.call(),
                ),
                ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
                  onInvoke: (_) => onTap?.call(),
                ),
              },
              child: DefaultTextStyle(
                style: const TextStyle(decoration: TextDecoration.none),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.08,
                              color: colors.brightness == Brightness.dark
                                  ? _labelDark
                                  : _labelLight,
                            ),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 11,
                                letterSpacing: 0.06,
                                color: colors.secondaryLabel,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
