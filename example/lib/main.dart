import 'package:flutter/cupertino.dart';

import 'pages/home_page.dart';

enum _AppTheme { system, light, dark }

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  _AppTheme _theme = _AppTheme.system;

  void _cycleTheme() {
    setState(() {
      _theme = switch (_theme) {
        _AppTheme.system => _AppTheme.light,
        _AppTheme.light => _AppTheme.dark,
        _AppTheme.dark => _AppTheme.system,
      };
    });
  }

  IconData _themeIcon() => switch (_theme) {
        _AppTheme.system => CupertinoIcons.gear,
        _AppTheme.light => CupertinoIcons.sun_max_fill,
        _AppTheme.dark => CupertinoIcons.moon_fill,
      };

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: _ThemeWrapper(
        theme: _theme,
        child: HomePage(
          themeIcon: _themeIcon(),
          onToggleTheme: _cycleTheme,
        ),
      ),
    );
  }
}

/// Resolves the app-wide [Brightness] and applies it via [CupertinoTheme].
class _ThemeWrapper extends StatelessWidget {
  const _ThemeWrapper({required this.theme, required this.child});

  final _AppTheme theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final brightness = switch (theme) {
      _AppTheme.system => platformBrightness,
      _AppTheme.light => Brightness.light,
      _AppTheme.dark => Brightness.dark,
    };

    return CupertinoTheme(
      data: CupertinoThemeData(brightness: brightness),
      child: child,
    );
  }
}
