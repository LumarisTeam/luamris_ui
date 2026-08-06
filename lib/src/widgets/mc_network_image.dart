import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../theme/mc_context.dart';

/// Singleton cache manager for [McNetworkImage].
class _McImageCacheManager extends CacheManager with ImageCacheManager {
  static const _key = 'mcUiImageCache';

  static final _McImageCacheManager _instance = _McImageCacheManager._();

  factory _McImageCacheManager() => _instance;

  _McImageCacheManager._()
      : super(
          Config(
            _key,
            maxNrOfCacheObjects: 5000,
            stalePeriod: const Duration(days: 30),
            repo: JsonCacheInfoRepository(databaseName: _key),
            fileService: HttpFileService(),
          ),
        );
}

/// A drop-in replacement for `Image.network` that adds disk caching,
/// configurable memory-cache dimensions, and Cupertino-style
/// loading / error placeholders.
class McNetworkImage extends StatelessWidget {
  const McNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.gaplessPlayback = false,
    this.loadingPlaceholder,
    this.errorPlaceholder,
    this.cacheWidth,
    this.cacheHeight,
  });

  /// Remote image URL.
  final String url;

  /// Display width in logical pixels.
  final double? width;

  /// Display height in logical pixels.
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit? fit;

  /// Optional clip radius applied via an outer [ClipRRect].
  final double? borderRadius;

  /// Whether to show the previously-loaded image while the new one loads.
  final bool gaplessPlayback;

  /// Placeholder shown while the image is loading.
  final Widget? loadingPlaceholder;

  /// Widget shown when the image fails to load.
  final Widget? errorPlaceholder;

  /// Explicit memory-cache decode width (pixels).
  final int? cacheWidth;

  /// Explicit memory-cache decode height (pixels).
  final int? cacheHeight;

  static int? _resolveCacheDim(
    double? displaySize,
    int? override,
    BuildContext context,
  ) {
    if (override != null) return override;
    if (displaySize == null || displaySize == double.infinity) return null;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    return (displaySize * dpr).round();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedMemCacheWidth = _resolveCacheDim(width, cacheWidth, context);
    final resolvedMemCacheHeight = _resolveCacheDim(height, cacheHeight, context);

    final image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      cacheManager: _McImageCacheManager(),
      memCacheWidth: resolvedMemCacheWidth,
      memCacheHeight: resolvedMemCacheHeight,
      placeholder:
          (context, _) => loadingPlaceholder ?? _defaultLoadingPlaceholder(context),
      errorWidget:
          (context, _, error) =>
              errorPlaceholder ?? _defaultErrorPlaceholder(context),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      useOldImageOnUrlChange: gaplessPlayback,
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: image,
      );
    }

    return image;
  }

  static Widget _defaultLoadingPlaceholder(BuildContext context) {
    final m = context.mc;
    return Container(
      color: m.secondary,
      child: const Center(child: CupertinoActivityIndicator(radius: 10)),
    );
  }

  static Widget _defaultErrorPlaceholder(BuildContext context) {
    final m = context.mc;
    return Container(
      color: m.secondary,
      child: Center(
        child: Icon(
          CupertinoIcons.photo,
          size: 24,
          color: m.mutedForeground,
        ),
      ),
    );
  }
}
