import 'package:flutter/material.dart';

import '../theme/mc_context.dart';

// =============================================================================
// McBadge — pill-shaped badge / tag with tint variants
// =============================================================================

enum _McBadgeTint { neutral, success, warning, error }

/// A pill-shaped badge / tag.
///
/// ```dart
/// McBadge(child: const Text('默认'));
/// McBadge.neutral(child: const Text('标签'));
/// McBadge.success(child: const Text('已完成'));
/// McBadge.warning(child: const Text('待处理'));
/// McBadge.error(child: const Text('失败'));
/// ```
class McBadge extends StatelessWidget {
  final _McBadgeTint? _tint;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;

  /// Default badge with optional explicit [backgroundColor] and [foregroundColor].
  const McBadge({
    super.key,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
  }) : _tint = null;

  /// Neutral / default tint.
  const McBadge.neutral({
    super.key,
    required this.child,
  }) : _tint = _McBadgeTint.neutral,
       backgroundColor = null,
       foregroundColor = null;

  /// Success tint (green).
  const McBadge.success({
    super.key,
    required this.child,
  }) : _tint = _McBadgeTint.success,
       backgroundColor = null,
       foregroundColor = null;

  /// Warning tint (orange).
  const McBadge.warning({
    super.key,
    required this.child,
  }) : _tint = _McBadgeTint.warning,
       backgroundColor = null,
       foregroundColor = null;

  /// Error tint (red).
  const McBadge.error({
    super.key,
    required this.child,
  }) : _tint = _McBadgeTint.error,
       backgroundColor = null,
       foregroundColor = null;

  @override
  Widget build(BuildContext context) {
    final m = context.mc;

    final (Color bg, Color fg) = switch (_tint) {
      _McBadgeTint.neutral => (m.secondary, m.foreground),
      _McBadgeTint.success => (m.successSoft, m.success),
      _McBadgeTint.warning => (m.warningSoft, m.warning),
      _McBadgeTint.error => (m.dangerSoft, m.destructive),
      null => (
          backgroundColor ?? m.secondary,
          foregroundColor ?? m.foreground,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: m.pillDecoration(background: bg),
      child: DefaultTextStyle(
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        child: child,
      ),
    );
  }
}
