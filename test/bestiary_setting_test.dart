import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaesen_beyond/ui/core/theme/app_theme.dart';
import 'package:vaesen_beyond/ui/features/compendium/views/compendium_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Gamemaster Bestiary Setting & Spoiler Vault Tests', () {
    testWidgets('CompendiumScreen displays Confidential Vault gatekeeper when Bestiary is locked', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const CompendiumScreen(initialBestiaryEnabled: false),
        ),
      );
      await tester.pumpAndSettle();

      // Bestiary tab should be selected by default (index 0)
      expect(find.text('BESTIARY'), findsOneWidget);

      // Gatekeeper card should be displayed
      expect(find.text('CONFIDENTIAL ARCHIVES'), findsOneWidget);
      expect(find.text('GAMEMASTER ACCESS ONLY • SPOILER WARNING'), findsOneWidget);
      expect(find.text('UNLOCK GAMEMASTER BESTIARY'), findsOneWidget);

      // Creatures should NOT be rendered (spoiler protection)
      expect(find.text('ASH TREE WIFE'), findsNothing);
      expect(find.text('BROOK HORSE'), findsNothing);

      // Category chips should NOT be shown
      expect(find.widgetWithText(FilterChip, 'Nature Spirits'), findsNothing);
    });

    testWidgets('Tapping UNLOCK GAMEMASTER BESTIARY unlocks and displays creatures', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const CompendiumScreen(initialBestiaryEnabled: false),
        ),
      );
      await tester.pumpAndSettle();

      // Tap unlock button
      final unlockBtn = find.text('UNLOCK GAMEMASTER BESTIARY');
      await tester.tap(unlockBtn);
      await tester.pumpAndSettle();

      // Gatekeeper should disappear, creature cards should appear
      expect(find.text('CONFIDENTIAL ARCHIVES'), findsNothing);
      expect(find.text('ASH TREE WIFE'), findsOneWidget);
      expect(find.text('(Askfrun)'), findsOneWidget);

      // Category filter chips should now be visible
      expect(find.widgetWithText(FilterChip, 'Nature Spirits'), findsOneWidget);
    });

    testWidgets('Global Search excludes Bestiary creatures when locked to protect from spoilers', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const CompendiumScreen(initialBestiaryEnabled: false),
        ),
      );
      await tester.pumpAndSettle();

      // Search for Askfrun
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Askfrun');
      await tester.pumpAndSettle();

      // Bestiary match count should be 0 because it's locked
      expect(find.textContaining('BESTIARY (0)'), findsOneWidget);
      expect(find.text('ASH TREE WIFE'), findsNothing);
    });

    testWidgets('PlayViewModel tracks and updates Bestiary enabled state', (tester) async {
      final playVm = PlayViewModel();
      await playVm.initialize();

      expect(playVm.isBestiaryEnabled, isFalse);

      await playVm.setBestiaryEnabled(true);
      expect(playVm.isBestiaryEnabled, isTrue);

      await playVm.setBestiaryEnabled(false);
      expect(playVm.isBestiaryEnabled, isFalse);
    });
  });
}
