import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../responsive/mc_responsive.dart';
import '../theme/mc_context.dart';

/// Shows a Cupertino modal popup styled with glass-morphism.
///
/// On phones the sheet slides up from the bottom; on tablets / desktop it
/// appears as a centered dialog.
Future<T?> showMcBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (sheetContext) {
      final m = context.mc;
      final isPhone = McResponsive.isPhone(sheetContext);
      final maxWidth = McResponsive.sheetMaxWidth(sheetContext);
      final borderRadius = isPhone
          ? BorderRadius.vertical(top: Radius.circular(m.radiusXl))
          : BorderRadius.circular(m.radiusXl);
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
              child: ClipRRect(
                borderRadius: borderRadius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                  child: Container(
                    decoration: BoxDecoration(
                      color: m.background.withValues(alpha: 0.94),
                      borderRadius: borderRadius,
                      border: Border.all(
                        color: m.border.withValues(alpha: 0.35),
                      ),
                    ),
                    child: builder(sheetContext),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
