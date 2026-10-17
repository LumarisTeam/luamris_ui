import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import '../theme/mc_smooth_corners.dart';

/// A single entry in an [McMenu].
@immutable
class McMenuItem<T> {
  const McMenuItem({
    required this.value,
    required this.label,
    this.icon,
    this.isDestructive = false,
    this.enabled = true,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool isDestructive;
  final bool enabled;
}

/// A glass-style popup menu with smooth corners and optional per-item icons.
///
/// ```dart
/// McMenu<String>(
///   items: const [
///     McMenuItem(value: 'edit', label: '编辑', icon: CupertinoIcons.pencil),
///     McMenuItem(
///       value: 'delete',
///       label: '删除',
///       icon: CupertinoIcons.trash,
///       isDestructive: true,
///     ),
///   ],
///   onSelected: (value) {},
/// );
/// ```
class McMenu<T> extends StatelessWidget {
  const McMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.icon = CupertinoIcons.ellipsis_circle,
    this.child,
    this.tooltip,
  });

  final List<McMenuItem<T>> items;
  final ValueChanged<T> onSelected;
  final IconData icon;
  final Widget? child;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final borderSide = BorderSide(
      color: m.separator.withValues(alpha: 0.18),
      width: 0.75,
    );

    return PopupMenuButton<T>(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      splashRadius: 18,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 10),
      color: m.card.withValues(alpha: 0.96),
      surfaceTintColor: Colors.transparent,
      shadowColor: m.shadowColor.withValues(alpha: 0.18),
      elevation: 10,
      constraints: const BoxConstraints(minWidth: 196, maxWidth: 240),
      shape: McSmoothCorners.shape(McRadii.cardBorder, side: borderSide),
      menuPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemBuilder: (BuildContext context) {
        return items
            .map((McMenuItem<T> item) {
              final foregroundColor = item.enabled
                  ? (item.isDestructive ? m.destructive : m.foreground)
                  : m.tertiaryLabel;

              return PopupMenuItem<T>(
                value: item.value,
                enabled: item.enabled,
                padding: EdgeInsets.zero,
                child: _McMenuEntry(
                  label: item.label,
                  icon: item.icon,
                  foregroundColor: foregroundColor,
                ),
              );
            })
            .toList(growable: false);
      },
      onSelected: onSelected,
      child: child ?? Icon(icon, size: 19, color: m.secondaryLabel),
    );
  }
}

class _McMenuEntry extends StatelessWidget {
  const _McMenuEntry({
    required this.label,
    required this.foregroundColor,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: ShapeDecoration(
        shape: McSmoothCorners.shape(McRadii.navigationBorder),
      ),
      child: Row(
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 18, color: foregroundColor),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
