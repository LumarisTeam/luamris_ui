import 'package:material_ui/material_ui.dart';

/// Apple-style semantic color tokens with built-in light/dark mode support
/// via [ThemeExtension].
///
/// Use [McColors.light] or [McColors.dark] to create a preset, then inject
/// it into the widget tree via [ThemeData.extensions] or [McThemeData.wrap].
@immutable
class McColors extends ThemeExtension<McColors> {
  const McColors({
    required this.primary,
    required this.primarySoft,
    required this.primaryForeground,
    required this.background,
    required this.foreground,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.quaternaryLabel,
    required this.card,
    required this.cardForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.separator,
    required this.border,
    required this.input,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.destructive,
    required this.dangerSoft,
    required this.hot,
  });

  /// Light color scheme preset.
  static const light = McColors(
    // ── Accent ──
    primary: Color(0xFF0071E3),
    primarySoft: Color(0x1F0071E3),
    primaryForeground: Color(0xFFFFFFFF),
    // ── Surface ──
    background: Color(0xFFFFFFFF),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF1D1D1F),
    secondary: Color(0xFFF5F5F7),
    secondaryForeground: Color(0xFF1D1D1F),
    muted: Color(0xFFF5F5F7),
    // ── Text ──
    foreground: Color(0xFF1D1D1F),
    secondaryLabel: Color(0xFF86868B),
    tertiaryLabel: Color(0x4D3C3C43),
    quaternaryLabel: Color(0x2E3C3C43),
    // ── Divider ──
    separator: Color(0x333C3C43),
    border: Color(0xFFE5E5E7),
    input: Color(0xFFF5F5F7),
    // ── Semantic ──
    success: Color(0xFF34C759),
    successSoft: Color(0x1F34C759),
    warning: Color(0xFFFF9500),
    warningSoft: Color(0x1FFF9500),
    destructive: Color(0xFFFF3B30),
    dangerSoft: Color(0x1FFF3B30),
    hot: Color(0xFFFF7A00),
  );

  /// Dark color scheme preset.
  static const dark = McColors(
    // ── Accent ──
    primary: Color(0xFF0071E3),
    primarySoft: Color(0x260071E3),
    primaryForeground: Color(0xFFFFFFFF),
    // ── Surface ──
    background: Color(0xFF000000),
    card: Color(0xFF1C1C1E),
    cardForeground: Color(0xFFF5F5F7),
    secondary: Color(0xFF2C2C2E),
    secondaryForeground: Color(0xFFF5F5F7),
    muted: Color(0xFF2C2C2E),
    // ── Text ──
    foreground: Color(0xFFF5F5F7),
    secondaryLabel: Color(0xFF86868B),
    tertiaryLabel: Color(0x4DEBEBF5),
    quaternaryLabel: Color(0x2EEBEBF5),
    // ── Divider ──
    separator: Color(0x33545458),
    border: Color(0xFF2C2C2E),
    input: Color(0xFF1C1C1E),
    // ── Semantic ──
    success: Color(0xFF30D158),
    successSoft: Color(0x2630D158),
    warning: Color(0xFFFF9F0A),
    warningSoft: Color(0x26FF9F0A),
    destructive: Color(0xFFFF453A),
    dangerSoft: Color(0x26FF453A),
    hot: Color(0xFFFF7A00),
  );

  // ── Accent ──────────────────────────────────────────────────────────────

  /// Primary accent color.
  final Color primary;

  /// Soft / tinted primary background (used for selected chips, icon badges).
  final Color primarySoft;

  /// Text/icon color on primary backgrounds.
  final Color primaryForeground;

  // ── Surface ─────────────────────────────────────────────────────────────

  /// Main background color.
  final Color background;

  /// Primary text/icon color.
  final Color foreground;

  /// Secondary text color — captions, descriptions, helper text.
  final Color secondaryLabel;

  /// Tertiary text color — placeholders, disabled text.
  final Color tertiaryLabel;

  /// Quaternary text color — the lightest text, barely visible separators.
  final Color quaternaryLabel;

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

  // ── Divider ─────────────────────────────────────────────────────────────

  /// Hairline separator / divider (semi-transparent).
  final Color separator;

  /// Border / stroke color (opaque).
  final Color border;

  /// Input field background.
  final Color input;

  // ── Semantic ────────────────────────────────────────────────────────────

  /// Success / positive color (green).
  final Color success;

  /// Soft / tinted success background.
  final Color successSoft;

  /// Warning / caution color (orange).
  final Color warning;

  /// Soft / tinted warning background.
  final Color warningSoft;

  /// Destructive / danger color (red).
  final Color destructive;

  /// Soft / tinted danger background.
  final Color dangerSoft;

  /// Hot / trending accent (orange-red).
  final Color hot;

  // ── Helpers ─────────────────────────────────────────────────────────────

  /// Resolved [Brightness] based on background luminance.
  Brightness get brightness =>
      background.computeLuminance() > 0.5
          ? Brightness.light
          : Brightness.dark;

  @override
  McColors copyWith({
    Color? primary,
    Color? primarySoft,
    Color? primaryForeground,
    Color? background,
    Color? foreground,
    Color? secondaryLabel,
    Color? tertiaryLabel,
    Color? quaternaryLabel,
    Color? card,
    Color? cardForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? separator,
    Color? border,
    Color? input,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? destructive,
    Color? dangerSoft,
    Color? hot,
  }) {
    return McColors(
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      background: background ?? this.background,
      foreground: foreground ?? this.foreground,
      secondaryLabel: secondaryLabel ?? this.secondaryLabel,
      tertiaryLabel: tertiaryLabel ?? this.tertiaryLabel,
      quaternaryLabel: quaternaryLabel ?? this.quaternaryLabel,
      card: card ?? this.card,
      cardForeground: cardForeground ?? this.cardForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      separator: separator ?? this.separator,
      border: border ?? this.border,
      input: input ?? this.input,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      destructive: destructive ?? this.destructive,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      hot: hot ?? this.hot,
    );
  }

  @override
  McColors lerp(covariant ThemeExtension<McColors>? other, double t) {
    if (other is! McColors) return this;
    return McColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      primaryForeground:
          Color.lerp(primaryForeground, other.primaryForeground, t)!,
      background: Color.lerp(background, other.background, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      secondaryLabel: Color.lerp(secondaryLabel, other.secondaryLabel, t)!,
      tertiaryLabel: Color.lerp(tertiaryLabel, other.tertiaryLabel, t)!,
      quaternaryLabel:
          Color.lerp(quaternaryLabel, other.quaternaryLabel, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryForeground:
          Color.lerp(secondaryForeground, other.secondaryForeground, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      border: Color.lerp(border, other.border, t)!,
      input: Color.lerp(input, other.input, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      hot: Color.lerp(hot, other.hot, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is McColors &&
          primary == other.primary &&
          primarySoft == other.primarySoft &&
          primaryForeground == other.primaryForeground &&
          background == other.background &&
          foreground == other.foreground &&
          secondaryLabel == other.secondaryLabel &&
          tertiaryLabel == other.tertiaryLabel &&
          quaternaryLabel == other.quaternaryLabel &&
          card == other.card &&
          cardForeground == other.cardForeground &&
          secondary == other.secondary &&
          secondaryForeground == other.secondaryForeground &&
          muted == other.muted &&
          separator == other.separator &&
          border == other.border &&
          input == other.input &&
          success == other.success &&
          successSoft == other.successSoft &&
          warning == other.warning &&
          warningSoft == other.warningSoft &&
          destructive == other.destructive &&
          dangerSoft == other.dangerSoft &&
          hot == other.hot;

  @override
  int get hashCode => Object.hashAll([
        primary,
        primarySoft,
        primaryForeground,
        background,
        foreground,
        secondaryLabel,
        tertiaryLabel,
        quaternaryLabel,
        card,
        cardForeground,
        secondary,
        secondaryForeground,
        muted,
        separator,
        border,
        input,
        success,
        successSoft,
        warning,
        warningSoft,
        destructive,
        dangerSoft,
        hot,
      ]);
}
