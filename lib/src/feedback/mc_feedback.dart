import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../theme/mc_context.dart';

/// Toast and dialog feedback utilities.
abstract final class McFeedback {
  /// Show an informational toast (alias for [showInfo]).
  static Future<void> showMessage(
    BuildContext context, {
    required String message,
    String title = '',
  }) {
    return showInfo(context, message: message, title: title);
  }

  /// Show an informational (blue) toast.
  static Future<void> showInfo(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return _showToast(
      context,
      message: message,
      title: title,
      icon: CupertinoIcons.info_circle_fill,
      tint: context.mc.primary,
    );
  }

  /// Show a success (green) toast.
  static Future<void> showSuccess(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return _showToast(
      context,
      message: message,
      title: title,
      icon: CupertinoIcons.check_mark_circled_solid,
      tint: context.mc.success,
    );
  }

  /// Show an error (red) toast.
  static Future<void> showError(
    BuildContext context, {
    required String message,
    String? title,
  }) {
    return _showToast(
      context,
      message: message,
      title: title,
      icon: CupertinoIcons.exclamationmark_triangle_fill,
      tint: context.mc.destructive,
    );
  }

  /// Show a confirmation dialog.
  ///
  /// Returns `true` if the user confirmed, `false` if cancelled, or `null` if
  /// dismissed.
  static Future<bool?> confirm(
    BuildContext context, {
    required String message,
    String title = '',
    String cancelText = '',
    String confirmText = '',
    bool destructive = false,
  }) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) => _McFeedbackDialog(
        title: title,
        message: message,
        actions: [
          _McFeedbackAction(
            label: cancelText,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          _McFeedbackAction(
            label: confirmText,
            onPressed: () => Navigator.of(context).pop(true),
            isPrimary: !destructive,
            isDestructive: destructive,
          ),
        ],
      ),
    );
  }

  static Future<void> _showToast(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color tint,
    String? title,
  }) async {
    final hasTitle = title != null && title.trim().isNotEmpty;
    final overlay = Overlay.of(context, rootOverlay: true);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    final entry = OverlayEntry(
      builder: (context) => _McFeedbackToast(
        message: message,
        title: hasTitle ? title.trim() : null,
        icon: icon,
        tint: tint,
        bottomOffset: bottomInset + bottomPadding + 28,
      ),
    );

    overlay.insert(entry);
    await Future<void>.delayed(const Duration(seconds: 3));
    entry.remove();
  }
}

// ── private implementation widgets ──────────────────────────────────────

class _McFeedbackToast extends StatelessWidget {
  const _McFeedbackToast({
    required this.message,
    required this.icon,
    required this.tint,
    required this.bottomOffset,
    this.title,
  });

  final String message;
  final String? title;
  final IconData icon;
  final Color tint;
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return Positioned(
      left: 20,
      right: 20,
      bottom: bottomOffset,
      child: IgnorePointer(
        child: SafeArea(
          top: false,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(m.radiusLg),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xE61C1C1E),
                    borderRadius: BorderRadius.circular(m.radiusLg),
                    border: Border.all(color: const Color(0x1AFFFFFF)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, color: tint, size: 20),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (title != null) ...[
                                Text(
                                  title!,
                                  style: const TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                              Text(
                                message,
                                style: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _McFeedbackDialog extends StatelessWidget {
  const _McFeedbackDialog({
    required this.title,
    required this.message,
    required this.actions,
  });

  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: CupertinoPopupSurface(
            isSurfacePainted: false,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(m.radiusXl),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: m.background.withValues(alpha: 0.98),
                    borderRadius: BorderRadius.circular(m.radiusXl),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: m.textSection,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        message,
                        style: m.textMuted,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          for (final (index, action) in actions.indexed) ...[
                            if (index > 0) const SizedBox(width: 10),
                            Expanded(child: action),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _McFeedbackAction extends StatelessWidget {
  const _McFeedbackAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final backgroundColor = isDestructive
        ? m.dangerSoft
        : isPrimary
            ? m.primary
            : m.secondary;
    final foregroundColor = isDestructive
        ? m.destructive
        : isPrimary
            ? m.primaryForeground
            : m.foreground;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      borderRadius: BorderRadius.circular(m.radiusLg),
      color: backgroundColor,
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
