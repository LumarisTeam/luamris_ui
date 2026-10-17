import 'package:cupertino_ui/cupertino_ui.dart';

import '../theme/mc_context.dart';

/// A list-tile row with optional leading, title, subtitle, trailing, and tap.
class McListTile extends StatelessWidget {
  const McListTile({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.titleStyle,
  });

  final Widget title;
  final Widget? leading;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    final content = Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: titleStyle ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: m.foreground,
                      ),
                  child: title,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle(
                    style: m.textMuted,
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );

    if (onTap == null) return content;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      pressedOpacity: 0.94,
      onPressed: onTap,
      child: content,
    );
  }
}
