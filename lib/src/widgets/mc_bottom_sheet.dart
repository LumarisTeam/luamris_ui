import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart';

import '../responsive/mc_responsive.dart';
import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import '../theme/mc_smooth_corners.dart';

/// Shows a Cupertino modal popup styled with glass-morphism.
///
/// On phones the sheet slides up from the bottom; on tablets / desktop it
/// appears as a centered dialog.
Future<T?> showMcBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  double? maxHeight,
  bool showHandle = false,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (sheetContext) {
      final m = sheetContext.mc;
      final isPhone = McResponsive.isPhone(sheetContext);
      final maxWidth = McResponsive.sheetMaxWidth(sheetContext);
      final borderRadius = isPhone
          ? BorderRadius.vertical(top: Radius.circular(McRadii.sheetTop))
          : BorderRadius.circular(McRadii.sheetTop);
      final side = BorderSide(
        color: m.border.withValues(alpha: 0.35),
        width: 0.5,
      );

      final content = showHandle
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: ShapeDecoration(
                      color: m.borderStrong.withValues(alpha: 0.8),
                      shape: McSmoothCorners.shape(
                        BorderRadius.circular(McRadii.handle),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                builder(sheetContext),
              ],
            )
          : builder(sheetContext);

      Widget surface = McSmoothCorners.clip(
        borderRadius: borderRadius,
        side: side,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: ColoredBox(
            color: m.background.withValues(alpha: 0.94),
            child: content,
          ),
        ),
      );

      if (maxHeight != null) {
        surface = ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: surface,
        );
      }

      return Align(
        alignment: isPhone ? Alignment.bottomCenter : Alignment.center,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: isPhone
                ? const EdgeInsets.only(top: 40)
                : const EdgeInsets.symmetric(horizontal: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: surface,
            ),
          ),
        ),
      );
    },
  );
}
