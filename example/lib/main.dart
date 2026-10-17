import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';
import 'package:luamris_ui/luamris_ui.dart';

import 'pages/home_page.dart';

enum _AppMode { materialSystem, cupertinoSystem }

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  final _AppMode _mode = _AppMode.cupertinoSystem;

  @override
  Widget build(BuildContext context) {
    final isMaterial = _mode == _AppMode.materialSystem;

    if (isMaterial) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: McThemeData.materialTheme(McColors.light),
        darkTheme: McThemeData.materialTheme(McColors.dark),
        home: HomePage(),
      );
    }

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => McThemeData.wrap(child: child!),
      home: HomePage(),
    );
  }
}
