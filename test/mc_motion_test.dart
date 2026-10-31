import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:luamris_ui/luamris_ui.dart';

Widget wrap(Widget child, {bool reduced = false}) => MaterialApp(
  theme: McThemeData.materialTheme(McColors.light),
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: reduced),
    child: Scaffold(body: Center(child: child)),
  ),
);

Finder inside(Type type, Type descendant) => find.descendant(
  of: find.byType(type).first,
  matching: find.byType(descendant),
);

double entranceOpacity(WidgetTester tester) =>
    tester.widget<Opacity>(inside(McAnimatedCard, Opacity).first).opacity;

void main() {
  group('McMotion', () {
    test('should provide expected tokens and delay cap', () {
      expect(McMotion.fast, const Duration(milliseconds: 120));
      expect(McMotion.standard, const Duration(milliseconds: 240));
      expect(McMotion.extraSlow, const Duration(milliseconds: 1000));

      expect(McMotion.getListItemDelay(2), const Duration(milliseconds: 48));
      expect(McMotion.getListItemDelay(20), McMotion.listItemMaxDelay);
      expect(McMotion.getListItemDelay(-1), Duration.zero);
      expect(McMotion.slideOffset, 8.0);
      expect(McMotion.cardSlideOffset, 12.0);
      expect(McMotion.pressScale, 0.98);
      expect(McMotion.secondaryOpacity, 0.6);
      expect(McMotion.spring, Curves.easeOutCubic);
    });
  });

  group('McAnimatedCard', () {
    testWidgets('should_wait_then_animate_when_entrance_has_delay', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const McAnimatedCard(
            delay: Duration(milliseconds: 100),
            duration: Duration(milliseconds: 200),
            child: Text('card'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 80));
      expect(entranceOpacity(tester), 0);
      await tester.pump(const Duration(milliseconds: 20));
      await tester.pump(const Duration(milliseconds: 100));
      expect(entranceOpacity(tester), inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(entranceOpacity(tester), 1);
    });

    testWidgets('should_show_immediately_when_reduced_motion_changes', (
      tester,
    ) async {
      const Widget card = McAnimatedCard(
        delay: Duration(seconds: 1),
        child: Text('card'),
      );
      await tester.pumpWidget(wrap(card));
      expect(entranceOpacity(tester), 0);
      await tester.pumpWidget(wrap(card, reduced: true));
      expect(entranceOpacity(tester), 1);
      await tester.pump(const Duration(seconds: 2));
      expect(tester.hasRunningAnimations, isFalse);
      await tester.pumpWidget(wrap(card));
      expect(entranceOpacity(tester), 1);
    });

    testWidgets('should_skip_nested_entrance_when_parent_orchestrates', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const McAnimatedCard(
            child: McAnimatedListItem(index: 5, child: Text('nested')),
          ),
        ),
      );
      final List<Opacity> opacities = tester
          .widgetList<Opacity>(inside(McAnimatedCard, Opacity))
          .toList();
      expect(opacities.map((opacity) => opacity.opacity), [0, 1]);
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('should_cancel_pending_delay_when_disposed', (tester) async {
      await tester.pumpWidget(
        wrap(
          const McAnimatedCard(
            delay: Duration(seconds: 1),
            child: Text('card'),
          ),
        ),
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('should_render_child_and_finish_animation', (tester) async {
      await tester.pumpWidget(
        wrap(const McAnimatedCard(child: Text('card-child'))),
      );

      expect(find.text('card-child'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('card-child'), findsOneWidget);
    });

    testWidgets('should_accept_custom_duration_and_delay', (tester) async {
      await tester.pumpWidget(
        wrap(
          const McAnimatedCard(
            duration: Duration(milliseconds: 100),
            delay: Duration(milliseconds: 200),
            child: Text('custom'),
          ),
        ),
      );

      expect(find.text('custom'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('custom'), findsOneWidget);
    });
  });

  group('McAnimatedButton', () {
    testWidgets('should_restore_scale_when_press_is_cancelled', (tester) async {
      await tester.pumpWidget(
        wrap(
          McAnimatedButton(
            onTap: () {},
            child: const SizedBox(width: 80, height: 44),
          ),
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(McAnimatedButton)),
      );
      await tester.pump(const Duration(milliseconds: 150));
      expect(
        tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
        0.98,
      );
      await gesture.cancel();
      await tester.pumpAndSettle();
      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
    });

    testWidgets('should_keep_feedback_without_scale_when_motion_reduced', (
      tester,
    ) async {
      int taps = 0;
      await tester.pumpWidget(
        wrap(
          McAnimatedButton(
            onTap: () => taps++,
            child: const SizedBox(width: 80, height: 44),
          ),
          reduced: true,
        ),
      );
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(McAnimatedButton)),
      );
      await tester.pump(const Duration(milliseconds: 150));
      expect(tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale, 1);
      expect(
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        0.88,
      );
      await gesture.up();
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('should_activate_once_when_keyboard_used_and_ignore_disabled', (
      tester,
    ) async {
      int taps = 0;
      Widget button(bool enabled) => McAnimatedButton(
        enabled: enabled,
        onTap: () => taps++,
        child: const Text('button'),
      );
      await tester.pumpWidget(wrap(button(true)));
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(taps, 2);
      await tester.pumpWidget(wrap(button(false)));
      await tester.tap(find.text('button'));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(taps, 2);
    });
  });

  group('McInteractiveCard', () {
    testWidgets('should_call_tap_and_long_press_callbacks', (tester) async {
      var tapped = false;
      var longPressed = false;

      await tester.pumpWidget(
        wrap(
          McInteractiveCard(
            onTap: () => tapped = true,
            onLongPress: () => longPressed = true,
            child: const Text('interactive'),
          ),
        ),
      );

      await tester.tap(find.text('interactive'));
      await tester.pump();
      expect(tapped, isTrue);

      await tester.longPress(find.text('interactive'));
      await tester.pump();
      expect(longPressed, isTrue);
    });

    testWidgets('should_toggle_feedback_handlers_by_flag', (tester) async {
      await tester.pumpWidget(
        wrap(
          const McInteractiveCard(
            enableFeedback: false,
            child: Text('no-feedback'),
          ),
        ),
      );

      final detector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(detector.onTapDown, isNull);
      expect(detector.onTapUp, isNull);
      expect(detector.onTapCancel, isNull);
    });
  });

  group('McHoverCard', () {
    testWidgets('should_enable_hover_handlers_by_default', (tester) async {
      await tester.pumpWidget(wrap(const McHoverCard(child: Text('hover'))));

      final mouseRegionFinder = find.descendant(
        of: find.byType(McHoverCard),
        matching: find.byType(MouseRegion),
      );
      final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder.first);
      expect(mouseRegion.onEnter, isNotNull);
      expect(mouseRegion.onExit, isNotNull);
    });

    testWidgets('should_disable_hover_handlers_when_flag_false', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const McHoverCard(enableHover: false, child: Text('hover-off'))),
      );

      final mouseRegionFinder = find.descendant(
        of: find.byType(McHoverCard),
        matching: find.byType(MouseRegion),
      );
      final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder.first);
      expect(mouseRegion.onEnter, isNull);
      expect(mouseRegion.onExit, isNull);
    });
  });

  testWidgets('should compose entrance and press feedback', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      wrap(
        McAnimatedInteractiveCard(
          onTap: () => tapped = true,
          child: const Text('combo'),
        ),
      ),
    );

    expect(find.byType(McAnimatedCard), findsOneWidget);
    expect(find.byType(McInteractiveCard), findsOneWidget);

    await tester.pumpAndSettle();
    await tester.tap(find.text('combo'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  group('McShimmerLoading', () {
    testWidgets('should_stop_shimmer_when_loaded_or_reduced_or_hidden', (
      tester,
    ) async {
      Widget loading({
        bool active = true,
        bool reduced = false,
        bool visible = true,
      }) => wrap(
        TickerMode(
          enabled: visible,
          child: McShimmerLoading(
            isLoading: active,
            skeleton: const SizedBox(width: 100, height: 44),
            child: const Text('loaded'),
          ),
        ),
        reduced: reduced,
      );
      await tester.pumpWidget(loading());
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pumpWidget(loading(reduced: true));
      await tester.pumpAndSettle();
      expect(find.byType(ShaderMask), findsNothing);
      expect(tester.hasRunningAnimations, isFalse);
      await tester.pumpWidget(loading());
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pumpWidget(loading(visible: false));
      expect(tester.hasRunningAnimations, isFalse);
      await tester.pumpWidget(loading(active: false));
      await tester.pumpAndSettle();
      expect(find.text('loaded'), findsOneWidget);
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
