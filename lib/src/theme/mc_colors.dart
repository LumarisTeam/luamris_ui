import 'package:flutter/material.dart';

/// Apple-style semantic color tokens with built-in light/dark mode support
/// via [ThemeExtension].
///
/// Use [McColors.light] or [McColors.dark] to create a preset, then inject
/// it into the widget tree via [ThemeData.extensions] or [McThemeData.wrap].
@immutable
class McColors extends ThemeExtension<McColors> {
  const McColors({
    required this.primary,
    required this.primaryForeground,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.border,
    required this.input,
    required this.destructive,
    required this.hot,
  });

  /// Light color scheme preset.
  static const light = McColors(
    primary: Color(0xFF0071E3),
    primaryForeground: Color(0xFFFFFFFF),
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF1D1D1F),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF1D1D1F),
    secondary: Color(0xFFF5F5F7),
    secondaryForeground: Color(0xFF1D1D1F),
    muted: Color(0xFFF5F5F7),
    mutedForeground: Color(0xFF86868B),
    border: Color(0xFFE5E5E7),
    input: Color(0xFFF5F5F7),
    destructive: Color(0xFFFF3B30),
    hot: Color(0xFFFF7A00),
  );

  /// Dark color scheme preset.
  static const dark = McColors(
    primary: Color(0xFF0071E3),
    primaryForeground: Color(0xFFFFFFFF),
    background: Color(0xFF000000),
    foreground: Color(0xFFF5F5F7),
    card: Color(0xFF1C1C1E),
    cardForeground: Color(0xFFF5F5F7),
    secondary: Color(0xFF2C2C2E),
    secondaryForeground: Color(0xFFF5F5F7),
    muted: Color(0xFF2C2C2E),
    mutedForeground: Color(0xFF86868B),
    border: Color(0xFF2C2C2E),
    input: Color(0xFF1C1C1E),
    destructive: Color(0xFFFF453A),
    hot: Color(0xFFFF7A00),
  );

  /// Primary accent color.
  final Color primary;

  /// Text/icon color on primary backgrounds.
  final Color primaryForeground;

  /// Main background color.
  final Color background;

  /// Primary text/icon color.
  final Color foreground;

  /// Card / elevated surface background.
  final Color card;

  /// Card foreground (text/icons on cards).
  final Color cardForeground;

  /// Secondary / grouped background.
  final Color secondary;

  /// Text/icon color on secondary backgrounds.
  final Color secondaryForeground;

  /// Muted / tertiary surface.
  final Color muted;

  /// Muted foreground for captions and secondary text.
  final Color mutedForeground;

  /// Border / separator color.
  final Color border;

  /// Input field background.
  final Color input;

  /// Destructive / danger color.
  final Color destructive;

  /// Hot / trending accent.
  final Color hot;

  /// Resolved [Brightness] based on background luminance.
  Brightness get brightness =>
      background.computeLuminance() > 0.5
          ? Brightness.light
          : Brightness.dark;

  @override
  McColors copyWith({
    Color? primary,
    Color? primaryForeground,
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? border,
    Color? input,
    Color? destructive,
    Color? hot,
  }) {
    return McColors(
      primary: primary ?? this.primary,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      border: border ?? this.border,
      input: input ?? this.input,
      destructive: destructive ?? this.destructive,
      hot: hot ?? this.hot,
    );
  }

  @override
  McColors lerp(covariant ThemeExtension<McColors>? other, double t) {
    if (other is! McColors) return this;
    return McColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryForeground:
          Color.lerp(primaryForeground, other.primaryForeground, t)!,
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryForeground:
          Color.lerp(secondaryForeground, other.secondaryForeground, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      mutedForeground:
          Color.lerp(mutedForeground, other.mutedForeground, t)!,
      border: Color.lerp(border, other.border, t)!,
      input: Color.lerp(input, other.input, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      hot: Color.lerp(hot, other.hot, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is McColors &&
          primary == other.primary &&
          primaryForeground == other.primaryForeground &&
          background == other.background &&
          foreground == other.foreground &&
          card == other.card &&
          cardForeground == other.cardForeground &&
          secondary == other.secondary &&
          secondaryForeground == other.secondaryForeground &&
          muted == other.muted &&
          mutedForeground == other.mutedForeground &&
          border == other.border &&
          input == other.input &&
          destructive == other.destructive &&
          hot == other.hot;

  @override
  int get hashCode => Object.hash(
        primary,
        primaryForeground,
        background,
        foreground,
        card,
        cardForeground,
        secondary,
        secondaryForeground,
        muted,
        mutedForeground,
        border,
        input,
        destructive,
        hot,
      );
}
