import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luamris_ui/luamris_ui.dart';

Widget _app(Widget Function(BuildContext context) home) {
  return CupertinoApp(
    builder: (context, child) =>
        McThemeData.wrap(colors: McColors.light, child: child!),
    home: CupertinoPageScaffold(child: Builder(builder: home)),
  );
}

/// The grabber is the sheet's only vertical-drag target.
Finder _grabber() => find.byWidgetPredicate(
  (widget) =>
      widget is RawGestureDetector &&
      widget.gestures.keys.contains(VerticalDragGestureRecognizer),
);

void main() {
  Future<void> usePhoneSurface(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> openSheet(
    WidgetTester tester, {
    double bottomInset = 0,
  }) async {
    await tester.pumpWidget(
      _app(
        (context) => Center(
          child: CupertinoButton(
            onPressed: () => showMcBottomSheet(
              context: context,
              showHandle: true,
              bottomInset: bottomInset,
              builder: (_) => const Padding(
                padding: EdgeInsets.all(24),
                child: Text('sheet body'),
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('grabber drags the sheet down and dismisses it', (tester) async {
    await usePhoneSurface(tester);
    await openSheet(tester);
    expect(find.text('sheet body'), findsOneWidget);

    final grabber = _grabber();
    expect(grabber, findsOneWidget);

    final restingTop = tester.getTopLeft(find.text('sheet body')).dy;
    final gesture = await tester.startGesture(tester.getCenter(grabber));
    await gesture.moveBy(const Offset(0, 40));
    await tester.pump(const Duration(milliseconds: 16));
    expect(
      tester.getTopLeft(find.text('sheet body')).dy,
      greaterThan(restingTop),
      reason: 'the sheet should follow the finger',
    );

    await gesture.moveBy(const Offset(0, 120));
    await tester.pump(const Duration(milliseconds: 16));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.text('sheet body'), findsNothing);
  });

  testWidgets('a short slow drag springs back instead of dismissing', (
    tester,
  ) async {
    await usePhoneSurface(tester);
    await openSheet(tester);

    final restingTop = tester.getTopLeft(find.text('sheet body')).dy;
    final gesture = await tester.startGesture(tester.getCenter(_grabber()));
    for (var i = 0; i < 4; i++) {
      await gesture.moveBy(const Offset(0, 5));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.text('sheet body'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('sheet body')).dy,
      moreOrLessEquals(restingTop, epsilon: 0.01),
    );
  });

  testWidgets('bottomInset lifts the phone sheet above a tab bar', (
    tester,
  ) async {
    await usePhoneSurface(tester);
    await openSheet(tester, bottomInset: 60);

    // 844 tall screen, 60 taken by the tab bar, then the 24 padding of the
    // sheet content.
    expect(
      tester.getBottomLeft(find.text('sheet body')).dy,
      moreOrLessEquals(844 - 60 - 24, epsilon: 0.5),
    );
  });

  testWidgets('tablets get no grabber and no drag target', (tester) async {
    await openSheet(tester);
    expect(find.text('sheet body'), findsOneWidget);
    expect(_grabber(), findsNothing);
  });
}
