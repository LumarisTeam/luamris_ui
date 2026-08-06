import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import 'mc_network_image.dart';

/// A circular (or rounded-square) avatar that supports network images
/// (including SVG / DiceBear), with automatic initial-based fallback.
class McAvatar extends StatelessWidget {
  const McAvatar({
    super.key,
    this.url,
    this.name,
    this.size = 40,
    this.radius,
    this.isCircle = true,
  });

  /// Remote image URL. Supports PNG, JPEG, WebP, and SVG (including
  /// DiceBear SVG URLs).
  final String? url;

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
    final avatarUrl = url?.trim();
    final hasImage = avatarUrl != null && avatarUrl.isNotEmpty;
    final resolvedBg = m.secondary;

    Widget? imageWidget;
    if (hasImage) {
      final lowerUrl = avatarUrl.toLowerCase();
      if (lowerUrl.contains('.svg') ||
          lowerUrl.contains('/svg') ||
          (lowerUrl.contains('dicebear.com') &&
              !lowerUrl.contains('/png') &&
              !lowerUrl.contains('/jpg'))) {
        imageWidget = SvgPicture.network(
          avatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholderBuilder: (context) => Container(
            color: resolvedBg,
            child: const Center(child: CupertinoActivityIndicator(radius: 8)),
          ),
        );
      } else {
        imageWidget = McNetworkImage(
          url: avatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingPlaceholder: Container(
            color: resolvedBg,
            child: const Center(child: CupertinoActivityIndicator(radius: 8)),
          ),
          errorPlaceholder: _buildFallback(context),
        );
      }
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
      child: hasImage ? imageWidget : _buildFallback(context),
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
