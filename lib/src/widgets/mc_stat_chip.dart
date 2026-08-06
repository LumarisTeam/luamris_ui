import 'package:flutter/cupertino.dart';

import '../theme/mc_context.dart';

/// An icon + label pill used for displaying stats (likes, views, etc.).
class McStatChip extends StatelessWidget {
  const McStatChip({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final resolvedIcon = iconColor ?? m.mutedForeground;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: m.pillDecoration(
        background: backgroundColor ?? m.secondary,
        showBorder: true,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: resolvedIcon),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: m.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
