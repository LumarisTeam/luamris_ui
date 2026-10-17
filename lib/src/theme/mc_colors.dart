import 'package:material_ui/material_ui.dart';

/// Apple-style semantic color tokens with built-in light/dark mode support
/// via [ThemeExtension].
///
/// The palette follows the iOS system colors. Use [McColors.light] or
/// [McColors.dark] to create a preset, then inject it into the widget tree
/// via [ThemeData.extensions] or [McThemeData.wrap].
///
/// iOS-style aliases are available for consumers migrating from a
/// `ClubColors`-style API: [appBackground], [cardBackground], [label] and
/// [danger].
@immutable
class McColors extends ThemeExtension<McColors> {
  const McColors({
    required this.primary,
    required this.primarySoft,
    required this.primaryForeground,
    required this.background,
    required this.groupedBackground,
    required this.card,
    required this.cardOverlay,
    required this.cardForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.surfaceRaised,
    required this.surfaceMuted,
    required this.surfaceSunken,
    required this.foreground,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.quaternaryLabel,
    required this.inverseLabel,
    required this.separator,
    required this.border,
    required this.borderStrong,
    required this.input,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.destructive,
    required this.dangerSoft,
    required this.indigo,
    required this.purple,
    required this.pink,
    required this.cyan,
    required this.yellow,
    required this.indigoSoft,
    required this.purpleSoft,
    required this.pinkSoft,
    required this.cyanSoft,
    required this.yellowSoft,
    required this.onAccent,
    required this.selectionFill,
    required this.shadowColor,
    required this.skeletonBase,
    required this.skeletonHighlight,
    required this.hot,
  });

  /// Light color scheme preset (iOS system colors).
  static const light = McColors(
    // ── Accent ──
    primary: Color(0xFF007AFF),
    primarySoft: Color(0x1F007AFF),
    primaryForeground: Color(0xFFFFFFFF),
    // ── Surface ──
    background: Color(0xFFFFFFFF),
    groupedBackground: Color(0xFFF8F8F8),
    card: Color(0xFFFFFFFF),
    cardOverlay: Color(0xB3FFFFFF),
    cardForeground: Color(0xFF000000),
    secondary: Color(0xFFF2F2F7),
    secondaryForeground: Color(0xFF000000),
    muted: Color(0xFFEFEFF4),
    surfaceRaised: Color(0xFFF2F2F7),
    surfaceMuted: Color(0xFFEFEFF4),
    surfaceSunken: Color(0xFFE5E5EA),
    // ── Text ──
    foreground: Color(0xFF000000),
    secondaryLabel: Color(0x993C3C43),
    tertiaryLabel: Color(0x4D3C3C43),
    quaternaryLabel: Color(0x2E3C3C43),
    inverseLabel: Color(0xFFFFFFFF),
    // ── Divider ──
    separator: Color(0x333C3C43),
    border: Color(0xFFE5E5EA),
    borderStrong: Color(0xFFD1D1D6),
    input: Color(0xFFEFEFF4),
    // ── Semantic ──
    success: Color(0xFF34C759),
    successSoft: Color(0x1F34C759),
    warning: Color(0xFFFF9500),
    warningSoft: Color(0x1FFF9500),
    destructive: Color(0xFFFF3B30),
    dangerSoft: Color(0x1FFF3B30),
    // ── Accent palette ──
    indigo: Color(0xFF5856D6),
    purple: Color(0xFFAF52DE),
    pink: Color(0xFFFF2D55),
    cyan: Color(0xFF5AC8FA),
    yellow: Color(0xFFFFCC00),
    indigoSoft: Color(0x1F5856D6),
    purpleSoft: Color(0x1FAF52DE),
    pinkSoft: Color(0x1FFF2D55),
    cyanSoft: Color(0x1F5AC8FA),
    yellowSoft: Color(0x1FFFCC00),
    // ── Effects ──
    onAccent: Color(0xFFFFFFFF),
    selectionFill: Color(0x1F787880),
    shadowColor: Color(0x1A000000),
    skeletonBase: Color(0xFFEBEBF4),
    skeletonHighlight: Color(0xFFF4F4F4),
    hot: Color(0xFFFF7A00),
  );

  /// Dark color scheme preset (iOS system colors).
  static const dark = McColors(
    // ── Accent ──
    primary: Color(0xFF0A84FF),
    primarySoft: Color(0x260A84FF),
    primaryForeground: Color(0xFFFFFFFF),
    // ── Surface ──
    background: Color(0xFF000000),
    groupedBackground: Color(0xFF000000),
    card: Color(0xFF1C1C1E),
    cardOverlay: Color(0x1FEBEBF5),
    cardForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFF2C2C2E),
    secondaryForeground: Color(0xFFFFFFFF),
    muted: Color(0xFF242426),
    surfaceRaised: Color(0xFF2C2C2E),
    surfaceMuted: Color(0xFF242426),
    surfaceSunken: Color(0xFF3A3A3C),
    // ── Text ──
    foreground: Color(0xFFFFFFFF),
    secondaryLabel: Color(0x99EBEBF5),
    tertiaryLabel: Color(0x4DEBEBF5),
    quaternaryLabel: Color(0x2EEBEBF5),
    inverseLabel: Color(0xFF000000),
    // ── Divider ──
    separator: Color(0x33545458),
    border: Color(0xFF3A3A3C),
    borderStrong: Color(0xFF545458),
    input: Color(0xFF242426),
    // ── Semantic ──
    success: Color(0xFF30D158),
    successSoft: Color(0x2630D158),
    warning: Color(0xFFFF9F0A),
    warningSoft: Color(0x26FF9F0A),
    destructive: Color(0xFFFF453A),
    dangerSoft: Color(0x26FF453A),
    // ── Accent palette ──
    indigo: Color(0xFF5E5CE6),
    purple: Color(0xFFBF5AF2),
    pink: Color(0xFFFF375F),
    cyan: Color(0xFF64D2FF),
    yellow: Color(0xFFFFD60A),
    indigoSoft: Color(0x265E5CE6),
    purpleSoft: Color(0x26BF5AF2),
    pinkSoft: Color(0x26FF375F),
    cyanSoft: Color(0x2664D2FF),
    yellowSoft: Color(0x26FFD60A),
    // ── Effects ──
    onAccent: Color(0xFFFFFFFF),
    selectionFill: Color(0x33787880),
    shadowColor: Color(0x00000000),
    skeletonBase: Color(0xFF2C2C2E),
    skeletonHighlight: Color(0xFF3A3A3C),
    hot: Color(0xFFFF7A00),
  );

  // ── Accent ──────────────────────────────────────────────────────────────

  /// Primary accent color (iOS system blue).
  final Color primary;

  /// Soft / tinted primary background (used for selected chips, icon badges).
  final Color primarySoft;

  /// Text/icon color on primary backgrounds.
  final Color primaryForeground;

  // ── Surface ─────────────────────────────────────────────────────────────

  /// Main app background color.
  final Color background;

  /// iOS grouped-list page background (slightly off-white in light mode).
  final Color groupedBackground;

  /// Card / elevated surface background.
  final Color card;

  /// Translucent overlay used for hover / pressed faint fills.
  final Color cardOverlay;

  /// Card foreground (text/icons on cards).
  final Color cardForeground;

  /// Secondary / grouped surface.
  final Color secondary;

  /// Text/icon color on secondary backgrounds.
  final Color secondaryForeground;

  /// Muted / tertiary surface.
  final Color muted;

  /// Raised surface above the page background.
  final Color surfaceRaised;

  /// Muted surface for inset controls.
  final Color surfaceMuted;

  /// Sunken surface for wells and tracks.
  final Color surfaceSunken;

  // ── Text ────────────────────────────────────────────────────────────────

  /// Primary text/icon color.
  final Color foreground;

  /// Secondary text color — captions, descriptions, helper text.
  final Color secondaryLabel;

  /// Tertiary text color — placeholders, disabled text.
  final Color tertiaryLabel;

  /// Quaternary text color — the lightest text, barely visible separators.
  final Color quaternaryLabel;

  /// Text/icon color that contrasts with [foreground] (e.g. on inverted bars).
  final Color inverseLabel;

  // ── Divider ─────────────────────────────────────────────────────────────

  /// Hairline separator / divider (semi-transparent).
  final Color separator;

  /// Subtle border / stroke color.
  final Color border;

  /// Stronger opaque border.
  final Color borderStrong;

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

  /// Indigo accent.
  final Color indigo;

  /// Purple accent.
  final Color purple;

  /// Pink accent.
  final Color pink;

  /// Cyan accent.
  final Color cyan;

  /// Yellow accent.
  final Color yellow;

  /// Soft / tinted indigo background.
  final Color indigoSoft;

  /// Soft / tinted purple background.
  final Color purpleSoft;

  /// Soft / tinted pink background.
  final Color pinkSoft;

  /// Soft / tinted cyan background.
  final Color cyanSoft;

  /// Soft / tinted yellow background.
  final Color yellowSoft;

  /// Text/icon color on accent fills.
  final Color onAccent;

  /// Selection / pressed fill used by list rows and menus.
  final Color selectionFill;

  /// Shadow color token (transparent in dark mode).
  final Color shadowColor;

  /// Skeleton placeholder base color.
  final Color skeletonBase;

  /// Skeleton placeholder highlight color.
  final Color skeletonHighlight;

  /// Hot / trending accent (orange-red), Luamris-specific.
  final Color hot;

  // ── iOS-style aliases ───────────────────────────────────────────────────

  /// Alias for [background] — iOS `appBackground`.
  Color get appBackground => background;

  /// Alias for [card] — iOS `cardBackground`.
  Color get cardBackground => card;

  /// Alias for [foreground] — iOS `label`.
  Color get label => foreground;

  /// Alias for [destructive] — iOS `danger`.
  Color get danger => destructive;

  // ── Helpers ─────────────────────────────────────────────────────────────

  /// Resolved [Brightness] based on background luminance.
  Brightness get brightness =>
      background.computeLuminance() > 0.5 ? Brightness.light : Brightness.dark;

  @override
  McColors copyWith({
    Color? primary,
    Color? primarySoft,
    Color? primaryForeground,
    Color? background,
    Color? groupedBackground,
    Color? card,
    Color? cardOverlay,
    Color? cardForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? surfaceRaised,
    Color? surfaceMuted,
    Color? surfaceSunken,
    Color? foreground,
    Color? secondaryLabel,
    Color? tertiaryLabel,
    Color? quaternaryLabel,
    Color? inverseLabel,
    Color? separator,
    Color? border,
    Color? borderStrong,
    Color? input,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? destructive,
    Color? dangerSoft,
    Color? indigo,
    Color? purple,
    Color? pink,
    Color? cyan,
    Color? yellow,
    Color? indigoSoft,
    Color? purpleSoft,
    Color? pinkSoft,
    Color? cyanSoft,
    Color? yellowSoft,
    Color? onAccent,
    Color? selectionFill,
    Color? shadowColor,
    Color? skeletonBase,
    Color? skeletonHighlight,
    Color? hot,
  }) {
    return McColors(
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      primaryForeground: primaryForeground ?? this.primaryForeground,
      background: background ?? this.background,
      groupedBackground: groupedBackground ?? this.groupedBackground,
      card: card ?? this.card,
      cardOverlay: cardOverlay ?? this.cardOverlay,
      cardForeground: cardForeground ?? this.cardForeground,
      secondary: secondary ?? this.secondary,
      secondaryForeground: secondaryForeground ?? this.secondaryForeground,
      muted: muted ?? this.muted,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      foreground: foreground ?? this.foreground,
      secondaryLabel: secondaryLabel ?? this.secondaryLabel,
      tertiaryLabel: tertiaryLabel ?? this.tertiaryLabel,
      quaternaryLabel: quaternaryLabel ?? this.quaternaryLabel,
      inverseLabel: inverseLabel ?? this.inverseLabel,
      separator: separator ?? this.separator,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      input: input ?? this.input,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      destructive: destructive ?? this.destructive,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      indigo: indigo ?? this.indigo,
      purple: purple ?? this.purple,
      pink: pink ?? this.pink,
      cyan: cyan ?? this.cyan,
      yellow: yellow ?? this.yellow,
      indigoSoft: indigoSoft ?? this.indigoSoft,
      purpleSoft: purpleSoft ?? this.purpleSoft,
      pinkSoft: pinkSoft ?? this.pinkSoft,
      cyanSoft: cyanSoft ?? this.cyanSoft,
      yellowSoft: yellowSoft ?? this.yellowSoft,
      onAccent: onAccent ?? this.onAccent,
      selectionFill: selectionFill ?? this.selectionFill,
      shadowColor: shadowColor ?? this.shadowColor,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
      hot: hot ?? this.hot,
    );
  }

  @override
  McColors lerp(covariant ThemeExtension<McColors>? other, double t) {
    if (other is! McColors) return this;
    return McColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      primaryForeground: Color.lerp(
        primaryForeground,
        other.primaryForeground,
        t,
      )!,
      background: Color.lerp(background, other.background, t)!,
      groupedBackground: Color.lerp(
        groupedBackground,
        other.groupedBackground,
        t,
      )!,
      card: Color.lerp(card, other.card, t)!,
      cardOverlay: Color.lerp(cardOverlay, other.cardOverlay, t)!,
      cardForeground: Color.lerp(cardForeground, other.cardForeground, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryForeground: Color.lerp(
        secondaryForeground,
        other.secondaryForeground,
        t,
      )!,
      muted: Color.lerp(muted, other.muted, t)!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceSunken: Color.lerp(surfaceSunken, other.surfaceSunken, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
      secondaryLabel: Color.lerp(secondaryLabel, other.secondaryLabel, t)!,
      tertiaryLabel: Color.lerp(tertiaryLabel, other.tertiaryLabel, t)!,
      quaternaryLabel: Color.lerp(quaternaryLabel, other.quaternaryLabel, t)!,
      inverseLabel: Color.lerp(inverseLabel, other.inverseLabel, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      input: Color.lerp(input, other.input, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningSoft: Color.lerp(warningSoft, other.warningSoft, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      indigo: Color.lerp(indigo, other.indigo, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      indigoSoft: Color.lerp(indigoSoft, other.indigoSoft, t)!,
      purpleSoft: Color.lerp(purpleSoft, other.purpleSoft, t)!,
      pinkSoft: Color.lerp(pinkSoft, other.pinkSoft, t)!,
      cyanSoft: Color.lerp(cyanSoft, other.cyanSoft, t)!,
      yellowSoft: Color.lerp(yellowSoft, other.yellowSoft, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      selectionFill: Color.lerp(selectionFill, other.selectionFill, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight: Color.lerp(
        skeletonHighlight,
        other.skeletonHighlight,
        t,
      )!,
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
          groupedBackground == other.groupedBackground &&
          card == other.card &&
          cardOverlay == other.cardOverlay &&
          cardForeground == other.cardForeground &&
          secondary == other.secondary &&
          secondaryForeground == other.secondaryForeground &&
          muted == other.muted &&
          surfaceRaised == other.surfaceRaised &&
          surfaceMuted == other.surfaceMuted &&
          surfaceSunken == other.surfaceSunken &&
          foreground == other.foreground &&
          secondaryLabel == other.secondaryLabel &&
          tertiaryLabel == other.tertiaryLabel &&
          quaternaryLabel == other.quaternaryLabel &&
          inverseLabel == other.inverseLabel &&
          separator == other.separator &&
          border == other.border &&
          borderStrong == other.borderStrong &&
          input == other.input &&
          success == other.success &&
          successSoft == other.successSoft &&
          warning == other.warning &&
          warningSoft == other.warningSoft &&
          destructive == other.destructive &&
          dangerSoft == other.dangerSoft &&
          indigo == other.indigo &&
          purple == other.purple &&
          pink == other.pink &&
          cyan == other.cyan &&
          yellow == other.yellow &&
          indigoSoft == other.indigoSoft &&
          purpleSoft == other.purpleSoft &&
          pinkSoft == other.pinkSoft &&
          cyanSoft == other.cyanSoft &&
          yellowSoft == other.yellowSoft &&
          onAccent == other.onAccent &&
          selectionFill == other.selectionFill &&
          shadowColor == other.shadowColor &&
          skeletonBase == other.skeletonBase &&
          skeletonHighlight == other.skeletonHighlight &&
          hot == other.hot;

  @override
  int get hashCode => Object.hashAll([
    primary,
    primarySoft,
    primaryForeground,
    background,
    groupedBackground,
    card,
    cardOverlay,
    cardForeground,
    secondary,
    secondaryForeground,
    muted,
    surfaceRaised,
    surfaceMuted,
    surfaceSunken,
    foreground,
    secondaryLabel,
    tertiaryLabel,
    quaternaryLabel,
    inverseLabel,
    separator,
    border,
    borderStrong,
    input,
    success,
    successSoft,
    warning,
    warningSoft,
    destructive,
    dangerSoft,
    indigo,
    purple,
    pink,
    cyan,
    yellow,
    indigoSoft,
    purpleSoft,
    pinkSoft,
    cyanSoft,
    yellowSoft,
    onAccent,
    selectionFill,
    shadowColor,
    skeletonBase,
    skeletonHighlight,
    hot,
  ]);
}
