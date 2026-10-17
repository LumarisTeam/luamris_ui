import 'dart:async';
import 'dart:ui';

import 'package:cupertino_ui/cupertino_ui.dart';

import '../theme/mc_context.dart';
import '../theme/mc_radii.dart';
import '../widgets/mc_field.dart';

// =============================================================================
// Actions
// =============================================================================

/// A single action shown in a glass dialog.
@immutable
class McDialogAction<T> {
  const McDialogAction({
    required this.label,
    this.value,
    this.isDestructiveAction = false,
    this.isDefaultAction = false,
    this.autoPop = true,
    this.onPressed,
  });

  final String label;

  /// Value returned by [showMcDialog] when this action is pressed.
  final T? value;

  /// Renders the action in the destructive (red) style.
  final bool isDestructiveAction;

  /// Renders the action with the primary fill.
  final bool isDefaultAction;

  /// When true, the dialog closes before [onPressed] runs.
  final bool autoPop;

  /// Optional callback. Runs after the dialog closes (or immediately when
  /// [autoPop] is false).
  final FutureOr<void> Function()? onPressed;
}

// =============================================================================
// Public API
// =============================================================================

/// Shows the library's glass dialog with a custom title, content and actions.
///
/// Returns the `value` of the pressed [McDialogAction], or `null` when the
/// dialog is dismissed. Note that an action whose `value` is `null` cannot be
/// distinguished from a dismissal.
Future<T?> showMcDialog<T>({
  required BuildContext context,
  String? title,
  String? message,
  Widget? content,
  List<McDialogAction<T>> actions = const [],
  bool barrierDismissible = true,
  double width = 320,
}) {
  return showCupertinoDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (dialogContext) {
      final m = dialogContext.mc;
      return _McDialogSurface(
        title: title,
        width: width,
        content:
            content ??
            (message == null
                ? null
                : Text(
                    message,
                    style: m.textMuted,
                    textAlign: TextAlign.center,
                  )),
        actions: [
          for (final action in actions)
            _McDialogActionButton(
              label: action.label,
              isDefault: action.isDefaultAction && !action.isDestructiveAction,
              isDestructive: action.isDestructiveAction,
              onPressed: () => _handleAction(dialogContext, action),
            ),
        ],
      );
    },
  );
}

/// Shows a confirmation dialog.
///
/// Returns `true` when confirmed, `false` when cancelled, and `null` when
/// dismissed (barrier tap or back gesture, depending on
/// [barrierDismissible]).
Future<bool?> showMcConfirmDialog({
  required BuildContext context,
  String? title,
  required String message,
  String cancelText = 'Cancel',
  String confirmText = 'OK',
  bool destructive = false,
  bool barrierDismissible = true,
}) {
  return showMcDialog<bool>(
    context: context,
    title: title,
    message: message,
    barrierDismissible: barrierDismissible,
    actions: [
      McDialogAction<bool>(label: cancelText, value: false),
      McDialogAction<bool>(
        label: confirmText,
        value: true,
        isDefaultAction: !destructive,
        isDestructiveAction: destructive,
      ),
    ],
  );
}

/// Shows a glass dialog with a single text field.
///
/// Returns the entered text (which may be empty) on confirm, or `null` on
/// cancel / dismissal.
Future<String?> showMcInputDialog({
  required BuildContext context,
  String? title,
  String? message,
  String? hintText,
  String? initialValue,
  String cancelText = 'Cancel',
  String confirmText = 'OK',
  bool obscureText = false,
  TextInputType? keyboardType,
  TextInputAction? textInputAction,
  bool barrierDismissible = false,
}) {
  return showCupertinoDialog<String>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => _McInputDialog(
      title: title,
      message: message,
      hintText: hintText,
      initialValue: initialValue,
      cancelText: cancelText,
      confirmText: confirmText,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
    ),
  );
}

Future<void> _handleAction<T>(
  BuildContext routeContext,
  McDialogAction<T> action,
) async {
  if (action.autoPop) Navigator.of(routeContext).pop(action.value);
  await action.onPressed?.call();
}

// =============================================================================
// Glass dialog surface (visually unchanged from McFeedback.confirm)
// =============================================================================

class _McDialogSurface extends StatelessWidget {
  const _McDialogSurface({
    required this.title,
    required this.content,
    required this.actions,
    this.width = 320,
  });

  final String? title;
  final Widget? content;
  final List<Widget> actions;
  final double width;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final hasTitle = title != null && title!.trim().isNotEmpty;

    Widget layoutActions() {
      if (actions.length == 1) {
        return SizedBox(width: double.infinity, child: actions.first);
      }
      if (actions.length == 2) {
        return Row(
          children: [
            Expanded(child: actions[0]),
            const SizedBox(width: 10),
            Expanded(child: actions[1]),
          ],
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            SizedBox(width: double.infinity, child: actions[i]),
          ],
        ],
      );
    }

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: CupertinoPopupSurface(
              isSurfacePainted: false,
              child: ClipRRect(
                // Intentionally keeps the original circular 24px radius.
                borderRadius: BorderRadius.circular(McRadii.xl),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: m.background.withValues(alpha: 0.98),
                      borderRadius: BorderRadius.circular(McRadii.xl),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasTitle) ...[
                          Text(
                            title!,
                            style: m.textSection,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                        ],
                        ?content,
                        if (actions.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          layoutActions(),
                        ],
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

class _McDialogActionButton extends StatelessWidget {
  const _McDialogActionButton({
    required this.label,
    required this.onPressed,
    this.isDefault = false,
    this.isDestructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isDefault;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;
    final backgroundColor = isDestructive
        ? m.dangerSoft
        : isDefault
        ? m.primary
        : m.secondary;
    final foregroundColor = isDestructive
        ? m.destructive
        : isDefault
        ? m.primaryForeground
        : m.foreground;

    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      borderRadius: BorderRadius.circular(McRadii.lg),
      color: backgroundColor,
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: foregroundColor, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// =============================================================================
// Input dialog
// =============================================================================

class _McInputDialog extends StatefulWidget {
  const _McInputDialog({
    this.title,
    this.message,
    this.hintText,
    this.initialValue,
    required this.cancelText,
    required this.confirmText,
    required this.obscureText,
    this.keyboardType,
    this.textInputAction,
  });

  final String? title;
  final String? message;
  final String? hintText;
  final String? initialValue;
  final String cancelText;
  final String confirmText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  State<_McInputDialog> createState() => _McInputDialogState();
}

class _McInputDialogState extends State<_McInputDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue ?? '',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text);

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    return _McDialogSurface(
      title: widget.title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.message != null) ...[
            Text(
              widget.message!,
              style: m.textMuted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
          ],
          McField.text(
            controller: _controller,
            placeholder: widget.hintText,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            autofocus: true,
            obscureText: widget.obscureText,
            onFieldSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        _McDialogActionButton(
          label: widget.cancelText,
          onPressed: () => Navigator.of(context).pop(),
        ),
        _McDialogActionButton(
          label: widget.confirmText,
          isDefault: true,
          onPressed: _submit,
        ),
      ],
    );
  }
}
