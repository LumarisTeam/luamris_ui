import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import '../theme/mc_smooth_corners.dart';

/// A list-tile row with optional leading, title, subtitle, trailing, and tap
/// handling.
///
/// Supports the full iOS-style row API: selection fill, disabled state, a
/// built-in chevron, long-press, custom corner radius, and custom text
/// styles. Place rows inside [McCard.grouped] to build inset-grouped lists.
class McListTile extends StatelessWidget {
  const McListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.contentPadding,
    this.borderRadius = McRadii.cardBorder,
    this.enabled = true,
    this.selected = false,
    this.showChevron = false,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.selectedBackgroundColor,
    @Deprecated('Use contentPadding instead.') this.padding,
    @Deprecated('Use titleTextStyle instead.') this.titleStyle,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Padding around the row. Defaults to 16 horizontal and 14/10 vertical
  /// (the smaller vertical value is used when a subtitle is present).
  final EdgeInsetsGeometry? contentPadding;

  /// Corner radius of the row. Defaults to [McRadii.cardBorder] (18).
  final BorderRadiusGeometry borderRadius;

  final bool enabled;
  final bool selected;
  final bool showChevron;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final Color? selectedBackgroundColor;

  /// Legacy padding parameter. Prefer [contentPadding].
  @Deprecated('Use contentPadding instead.')
  final EdgeInsets? padding;

  /// Legacy title style parameter. Prefer [titleTextStyle].
  @Deprecated('Use titleTextStyle instead.')
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    // ignore: deprecated_member_use_from_same_package
    final legacyPadding = padding;
    // ignore: deprecated_member_use_from_same_package
    final legacyTitleStyle = titleStyle;

    final effectivePadding =
        contentPadding ??
        legacyPadding ??
        EdgeInsets.symmetric(
          horizontal: 16,
          vertical: subtitle == null ? 14 : 10,
        );

    final effectiveTitleStyle = TextStyle(
      fontSize: 16,
      color: enabled ? m.foreground : m.tertiaryLabel,
    ).merge(titleTextStyle ?? legacyTitleStyle);

    final effectiveSubtitleStyle = TextStyle(
      fontSize: 13,
      color: enabled ? m.secondaryLabel : m.tertiaryLabel,
    ).merge(subtitleTextStyle);

    final effectiveTrailing =
        trailing ??
        (showChevron
            ? Icon(
                CupertinoIcons.chevron_right,
                size: 18,
                color: m.tertiaryLabel,
              )
            : null);

    final resolvedRadius = McSmoothCorners.resolve(context, borderRadius);
    final shape = McSmoothCorners.shape(borderRadius);

    final content = DecoratedBox(
      decoration: ShapeDecoration(
        color: selected
            ? (selectedBackgroundColor ?? m.selectionFill)
            : Colors.transparent,
        shape: shape,
      ),
      child: Padding(
        padding: effectivePadding,
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle.merge(
                    style: effectiveTitleStyle,
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    DefaultTextStyle.merge(
                      style: effectiveSubtitleStyle,
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            if (effectiveTrailing != null) ...[
              const SizedBox(width: 12),
              effectiveTrailing,
            ],
          ],
        ),
      ),
    );

    final clipped = McSmoothCorners.clip(
      borderRadius: resolvedRadius,
      child: content,
    );

    if (onTap == null && onLongPress == null) return clipped;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      pressedOpacity: 0.94,
      foregroundColor: enabled ? m.foreground : m.tertiaryLabel,
      borderRadius: resolvedRadius,
      onPressed: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      child: clipped,
    );
  }
}
