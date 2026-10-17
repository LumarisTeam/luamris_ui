import 'package:cupertino_ui/cupertino_ui.dart';

import '../theme/mc_context.dart';
import 'mc_button.dart';
import 'mc_card.dart';

// =============================================================================
// McEmpty — unified empty / retry state
// =============================================================================

/// A centered placeholder for empty or error states.
///
/// ```dart
/// McEmpty.placeholder(
///   icon: CupertinoIcons.tray,
///   title: '暂无数据',
///   description: '稍后再来看看吧',
/// );
///
/// McEmpty.retry(
///   title: '加载失败',
///   description: '请检查网络连接',
///   onRetry: () async { ... },
/// );
/// ```
class McEmpty extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? action;
  final Future<void> Function()? onRetry;
  final String retryLabel;

  /// Empty-state placeholder with icon, title, description, and optional action.
  const McEmpty.placeholder({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  }) : onRetry = null,
       retryLabel = 'Reload';

  /// Error / retry state with a retry button.
  const McEmpty.retry({
    super.key,
    required this.title,
    required this.description,
    required this.onRetry,
    this.icon = CupertinoIcons.exclamationmark_triangle,
    this.retryLabel = 'Reload',
  }) : action = null;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    final act = action ??
        (onRetry != null
            ? McButton.primary(
                onPressed: onRetry,
                child: Text(retryLabel),
              )
            : null);

    return SizedBox(
      width: double.infinity,
      child: McCard.glass(
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: m.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: m.mutedForeground, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: m.textSection,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: m.textMuted,
                textAlign: TextAlign.center,
              ),
              if (act != null) ...[const SizedBox(height: 18), act],
            ],
          ),
        ),
      ),
    );
  }
}
