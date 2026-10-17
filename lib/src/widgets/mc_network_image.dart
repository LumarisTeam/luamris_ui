import 'package:cupertino_ui/cupertino_ui.dart';

import '../theme/mc_context.dart';

/// A drop-in replacement for `Image.network` that adds Cupertino-style
/// loading / error placeholders and optional border-radius clipping.
///
/// Accepts any [ImageProvider] — use [NetworkImage] for remote images,
/// [AssetImage] for bundled assets, etc.  Wrap with [ResizeImage] if you
/// need cache-dimension control.
class McNetworkImage extends StatelessWidget {
  const McNetworkImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.loadingPlaceholder,
    this.errorPlaceholder,
  });

  /// Image provider (e.g. [NetworkImage], [AssetImage], [MemoryImage]).
  final ImageProvider image;

  /// Display width in logical pixels.
  final double? width;

  /// Display height in logical pixels.
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit? fit;

  /// Optional clip radius applied via an outer [ClipRRect].
  final double? borderRadius;

  /// Placeholder shown while the image is loading.
  final Widget? loadingPlaceholder;

  /// Widget shown when the image fails to load.
  final Widget? errorPlaceholder;

  @override
  Widget build(BuildContext context) {
    final imageWidget = Image(
      image: image,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return loadingPlaceholder ?? _defaultLoadingPlaceholder(context);
      },
      errorBuilder: (context, error, stackTrace) =>
          errorPlaceholder ?? _defaultErrorPlaceholder(context),
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: imageWidget,
      );
    }

    return imageWidget;
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
