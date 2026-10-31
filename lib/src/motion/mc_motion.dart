import 'package:material_ui/material_ui.dart';

/// Shared motion tokens for the Luamris design system.
///
/// The curves intentionally avoid overshoot: state changes use
/// [Curves.easeInOutCubic], while entrances and press feedback use
/// [Curves.easeOutCubic]. These values are design choices, not Apple-defined
/// constants.
abstract final class McMotion {
  McMotion._();

  /// Whether the platform asks apps to minimize motion.
  ///
  /// Custom animations should collapse their duration to [Duration.zero] when
  /// this returns `true`:
  ///
  /// ```dart
  /// AnimatedContainer(
  ///   duration: McMotion.reduceMotionOf(context)
  ///       ? Duration.zero
  ///       : McMotion.standard,
  ///   curve: McMotion.defaultCurve,
  /// )
  /// ```
  static bool reduceMotionOf(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  // ── Durations ─────────────────────────────────────────────────────────────

  /// Fast — micro-interactions such as button presses (~120 ms).
  static const Duration fast = Duration(milliseconds: 120);

  /// Standard — most UI transitions such as cards and list items (~240 ms).
  static const Duration standard = Duration(milliseconds: 240);

  /// Medium — heavier page-content transitions (~320 ms).
  static const Duration medium = Duration(milliseconds: 320);

  /// Slow — attention-grabbing effects such as progress or completion
  /// (~480 ms).
  static const Duration slow = Duration(milliseconds: 480);

  /// Extra slow — continuous changes such as value counters (~1000 ms).
  static const Duration extraSlow = Duration(milliseconds: 1000);

  // ── Curves ────────────────────────────────────────────────────────────────

  /// Standard ease-in-out, for state changes.
  static const Curve defaultCurve = Curves.easeInOutCubic;

  /// Ease-out, for entrances (elements appearing).
  static const Curve easeOut = Curves.easeOutCubic;

  /// Ease-in, for exits (elements disappearing).
  static const Curve easeIn = Curves.easeInCubic;

  /// Legacy alias — resolves to [easeOut] (no overshoot).
  static const Curve spring = Curves.easeOutCubic;

  /// Smooth ease-out, for continuously changing animations.
  static const Curve smooth = Curves.easeOutQuart;

  // ── List entrance ─────────────────────────────────────────────────────────

  /// Per-item stagger while a list enters.
  static const Duration listItemDelay = Duration(milliseconds: 24);

  /// Upper bound for the stagger delay.
  static const Duration listItemMaxDelay = Duration(milliseconds: 120);

  /// Entrance duration for list items.
  static const Duration listItemDuration = standard;

  /// Stagger delay for [index], capped at [listItemMaxDelay].
  static Duration getListItemDelay(int index) {
    final Duration delay = listItemDelay * (index < 0 ? 0 : index);
    return delay > listItemMaxDelay ? listItemMaxDelay : delay;
  }

  // ── Offsets ───────────────────────────────────────────────────────────────

  /// Vertical travel for list-item entrances — 8 logical pixels.
  static const double slideOffset = 8.0;

  /// Vertical travel for card entrances — 12 logical pixels.
  static const double cardSlideOffset = 12.0;

  // ── Scale ─────────────────────────────────────────────────────────────────

  /// Scale while a control is pressed.
  static const double pressScale = 0.98;

  /// Initial scale for card entrances (no scaling by default).
  static const double cardInitialScale = 1.0;

  /// Scale used while hovering (no scaling by default).
  static const double hoverScale = 1.0;

  // ── Opacity ───────────────────────────────────────────────────────────────

  /// Opacity of disabled controls.
  static const double disabledOpacity = 0.4;

  /// Opacity of secondary elements.
  static const double secondaryOpacity = 0.6;
}
