import 'package:material_ui/material_ui.dart';

/// Corner radius tokens used throughout the design system.
///
/// Two scales are exposed:
/// - A raw numeric scale (`xs` … `xxl`, `pill`).
/// - Semantic tokens (`control`, `navigation`, `panel`, `card`, `tile`,
///   `sheetTop`) that map to the intended surface type.
abstract final class McRadii {
  // ── Numeric scale ────────────────────────────────────────────────────────

  /// Extra-small radius — 4px.
  static const double xs = 4;

  /// Small radius — 8px.
  static const double sm = 8;

  /// Medium radius — 12px.
  static const double md = 12;

  /// Large radius — 16px.
  static const double lg = 16;

  /// Extra-large radius — 24px.
  ///
  /// Kept at 24 so the existing glass dialogs and toasts keep their look.
  static const double xl = 24;

  /// Double extra-large radius — 32px.
  static const double xxl = 32;

  /// Pill-shaped radius — effectively infinite for typical widget sizes.
  static const double pill = 999;

  // ── Semantic scale ───────────────────────────────────────────────────────

  /// Icon containers and inline controls — 8px.
  static const double control = 8;

  /// Buttons, input fields and segmented controls — 12px.
  static const double navigation = 12;

  /// Large panels — 16px.
  static const double panel = 16;

  /// Cards, grouped lists and list rows — 18px.
  static const double card = 18;

  /// Dashboard / feature tiles — 22px.
  static const double tile = 22;

  /// Top corners of a bottom sheet — 18px.
  static const double sheetTop = 18;

  /// Bottom-sheet grab handle — 2.5px.
  static const double handle = 2.5;

  /// Thin indicator bars — 2px.
  static const double indicator = 2;

  // ── Radius objects ───────────────────────────────────────────────────────

  static const Radius xsRadius = Radius.circular(xs);
  static const Radius smRadius = Radius.circular(sm);
  static const Radius mdRadius = Radius.circular(md);
  static const Radius lgRadius = Radius.circular(lg);
  static const Radius xlRadius = Radius.circular(xl);
  static const Radius xxlRadius = Radius.circular(xxl);
  static const Radius controlRadius = Radius.circular(control);
  static const Radius navigationRadius = Radius.circular(navigation);
  static const Radius panelRadius = Radius.circular(panel);
  static const Radius cardRadius = Radius.circular(card);
  static const Radius tileRadius = Radius.circular(tile);
  static const Radius handleRadius = Radius.circular(handle);
  static const Radius indicatorRadius = Radius.circular(indicator);

  // ── BorderRadius objects ─────────────────────────────────────────────────

  static const BorderRadius xsBorder = BorderRadius.all(xsRadius);
  static const BorderRadius controlBorder = BorderRadius.all(controlRadius);
  static const BorderRadius navigationBorder = BorderRadius.all(
    navigationRadius,
  );
  static const BorderRadius panelBorder = BorderRadius.all(panelRadius);
  static const BorderRadius cardBorder = BorderRadius.all(cardRadius);
  static const BorderRadius tileBorder = BorderRadius.all(tileRadius);
  static const BorderRadius handleBorder = BorderRadius.all(handleRadius);
  static const BorderRadius indicatorBorder = BorderRadius.all(indicatorRadius);

  /// Top-only rounding used by bottom sheets.
  static const BorderRadius sheetTopBorder = BorderRadius.vertical(
    top: Radius.circular(sheetTop),
  );
}
