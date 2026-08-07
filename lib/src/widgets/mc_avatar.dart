import 'package:flutter/cupertino.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';

/// A circular (or rounded-square) avatar that accepts any [ImageProvider],
/// with automatic initial-based fallback.
class McAvatar extends StatelessWidget {
  const McAvatar({
    super.key,
    this.image,
    this.name,
    this.size = 40,
    this.radius,
    this.isCircle = true,
  });

  /// Image provider (e.g. [NetworkImage], [AssetImage], [MemoryImage]).
  /// When `null`, displays an initial-based fallback.
  final ImageProvider? image;

  /// Display name — used to generate initials for the fallback.
  final String? name;

  /// Width and height in logical pixels.
  final double size;

  /// Override corner radius. Defaults to `size / 2` when [isCircle] is true,
  /// or [McRadii.md] otherwise.
  final double? radius;

  /// When true (default), the avatar is a circle.
  final bool isCircle;

  String _buildInitial(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final trimmed = name.trim();
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    }
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final borderRadius = radius ?? (isCircle ? size / 2 : McRadii.md);
    final resolvedBg = m.secondary;

    Widget? imageWidget;
    if (image != null) {
      imageWidget = Image(
        image: image!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: resolvedBg,
            child:
                const Center(child: CupertinoActivityIndicator(radius: 8)),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            _buildFallback(context),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: image != null ? imageWidget : _buildFallback(context),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final m = context.mc;
    return Text(
      _buildInitial(name),
      style: TextStyle(
        color: m.primary,
        fontWeight: FontWeight.w800,
        fontSize: size * 0.4,
      ),
    );
  }
}
