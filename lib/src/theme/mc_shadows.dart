import 'package:cupertino_ui/cupertino_ui.dart';

/// Elevation shadow tokens.
abstract final class McShadows {
  /// No shadow.
  static const List<BoxShadow> none = [];

  /// Default card shadow — subtle elevation with a soft blur.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ];
}
