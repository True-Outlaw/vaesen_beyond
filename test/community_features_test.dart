import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaesen_beyond/data/datasources/local_storage_service.dart';
import 'package:vaesen_beyond/data/repositories/character_repository.dart';
import 'package:vaesen_beyond/domain/models/talent.dart';
import 'package:vaesen_beyond/ui/core/theme/app_theme.dart';
import 'package:vaesen_beyond/ui/features/compendium/views/compendium_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/fear_test_dialog.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Critical Injuries D66 & Text Search Tests', () {
    testWidgets('CompendiumScreen searches Critical Injuries by D66 roll number AND text name/treatment', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const CompendiumScreen(initialTabIndex: 3), // Critical Injuries tab
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('CRITICAL INJURIES'), findsOneWidget);

      final searchField = find.byType(TextField);

      // 1. Search by exact D66 number "11"
      await tester.enterText(searchField, '11');
      await tester.pumpAndSettle();

      // D66 11 should match both physical (Wind Knocked Out) and mental (Rattled Nerves) 11
      expect(find.text('Wind Knocked Out'), findsOneWidget);
      expect(find.text('Rattled Nerves'), findsOneWidget);
      // D66 12 should not be visible
      expect(find.text('Bruised Ribs'), findsNothing);

      // 2. Search by another D66 number "66"
      await tester.enterText(searchField, '66');
      await tester.pumpAndSettle();
      expect(find.text('66'), findsWidgets);

      // 3. Search by Injury Name (text search, e.g. "Broken")
      await tester.enterText(searchField, 'Broken');
      await tester.pumpAndSettle();
      // Should find broken ribs, broken arm, broken leg, etc.
      expect(find.textContaining('Broken'), findsWidgets);

      // 4. Search by Treatment skill e.g. "Medicine"
      await tester.enterText(searchField, 'Medicine');
      await tester.pumpAndSettle();
      expect(find.textContaining('Medicine'), findsWidgets);
    });
  });

  group('Homebrew / Custom Talents Tests', () {
    test('Talent model supports isCustom flag and JSON serialization', () {
      const customTalent = Talent(
        id: 'ghost_whisperer',
        name: 'Ghost Whisperer',
        archetypeName: null,
        description: 'You can hear departed spirits without casting a ritual.',
        effect: 'Add +2 to Observation when listening to echoes of the dead.',
        isCustom: true,
      );

      expect(customTalent.isCustom, isTrue);
      expect(customTalent.isGeneral, isTrue);

      final json = customTalent.toJson();
      expect(json['name'], 'Ghost Whisperer');
      expect(json['isCustom'], isTrue);

      final deserialized = Talent.fromJson(json);
      expect(deserialized.name, 'Ghost Whisperer');
      expect(deserialized.isCustom, isTrue);
      expect(deserialized.isGeneral, isTrue);
    });

    test('PlayViewModel adds, persists, and deletes custom talents', () async {
      final storage = LocalStorageService();
      final repo = CharacterRepository(storage: storage);
      final playVm = PlayViewModel(repository: repo);

      await playVm.loadCustomTalents();
      expect(playVm.customTalents, isEmpty);

      const customTalent = Talent(
        id: 'rune_carver',
        name: 'Rune Carver',
        archetypeName: 'Scholar',
        description: 'Inscribe Nordic protection runes on wood or bone.',
        effect: 'Spend 1 action to ward an entrance against lesser spirits.',
        isCustom: true,
      );

      await playVm.addCustomTalent(customTalent);
      expect(playVm.customTalents.length, 1);
      expect(playVm.customTalents.first.name, 'Rune Carver');
      expect(playVm.allAvailableTalents.any((t) => t.name == 'Rune Carver'), isTrue);

      // Check persistence by reloading in a fresh repository
      final freshRepo = CharacterRepository(storage: storage);
      final persisted = await freshRepo.loadCustomTalents();
      expect(persisted.length, 1);
      expect(persisted.first.name, 'Rune Carver');

      // Delete custom talent
      await playVm.deleteCustomTalent('rune_carver');
      expect(playVm.customTalents, isEmpty);
      expect(playVm.allAvailableTalents.any((t) => t.name == 'Rune Carver'), isFalse);
    });

    testWidgets('CompendiumScreen displays custom talents with HOMEBREW badge and forge button', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final storage = LocalStorageService();
      final repo = CharacterRepository(storage: storage);
      final playVm = PlayViewModel(repository: repo);

      await playVm.addCustomTalent(const Talent(
        id: 'troll_friend',
        name: 'Troll-Friend',
        archetypeName: 'General',
        description: 'You speak the tongue of the ancient jotuns.',
        effect: 'Gain +2 Manipulation when negotiating with trolls.',
        isCustom: true,
      ));

      await tester.pumpWidget(
        ChangeNotifierProvider<PlayViewModel>.value(
          value: playVm,
          child: MaterialApp(
            theme: AppTheme.theme,
            home: const CompendiumScreen(initialTabIndex: 2), // Talents tab
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Talents tab should display "FORGE HOMEBREW TALENT"
      expect(find.text('FORGE HOMEBREW TALENT'), findsOneWidget);

      // Filter or search for our custom talent
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Troll-Friend');
      await tester.pumpAndSettle();

      expect(
        find.descendant(of: find.byType(ListView), matching: find.text('Troll-Friend')),
        findsOneWidget,
      );
      expect(find.text('HOMEBREW'), findsWidgets);
    });
  });

  group('Bestiary Player Lore Mode & Progressive Reveals Tests', () {
    testWidgets('Player Lore mode shows folklore & habitats but redacts combat stats and rituals', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final storage = LocalStorageService();
      final repo = CharacterRepository(storage: storage);
      final playVm = PlayViewModel(repository: repo);

      await tester.pumpWidget(
        ChangeNotifierProvider<PlayViewModel>.value(
          value: playVm,
          child: MaterialApp(
            theme: AppTheme.theme,
            home: const CompendiumScreen(initialBestiaryEnabled: false),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Gatekeeper should offer both UNLOCK GAMEMASTER BESTIARY and UNLOCK PLAYER FOLKLORE ARCHIVE
      expect(find.text('UNLOCK GAMEMASTER BESTIARY'), findsOneWidget);
      expect(find.text('UNLOCK PLAYER FOLKLORE ARCHIVE'), findsOneWidget);

      // Tap Player Lore Archive unlock
      await tester.tap(find.text('UNLOCK PLAYER FOLKLORE ARCHIVE'));
      await tester.pumpAndSettle();

      // Now creatures should be visible
      expect(find.text('ASH TREE WIFE'), findsOneWidget);
      expect(find.text('(Askfrun)'), findsOneWidget);

      // Redacted notices should be present (Fear, Combat attributes, Attacks, Rituals)
      expect(find.text('FEAR: CLASSIFIED'), findsWidgets);
      expect(find.textContaining('COMBAT ATTRIBUTES • [CLASSIFIED BY GM]'), findsWidgets);
      expect(find.textContaining('ATTACKS • [CLASSIFIED BY GM]'), findsWidgets);
      expect(find.textContaining('BANISHMENT RITUALS • [CLASSIFIED BY GM]'), findsWidgets);

      // GM reveal toggles should NOT be present in player lore mode
      expect(find.text('CONCEAL'), findsNothing);
    });

    testWidgets('Progressive reveals: GM revealed section appears in Player Lore mode with GM REVEALED badge', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final storage = LocalStorageService();
      final repo = CharacterRepository(storage: storage);
      final playVm = PlayViewModel(repository: repo);

      // Set bestiary mode to playerLore, but GM has revealed 'rituals' for 'Ash Tree Wife'
      await playVm.setBestiaryMode('playerLore');
      await playVm.toggleSectionReveal('Ash Tree Wife', 'rituals');

      await tester.pumpWidget(
        ChangeNotifierProvider<PlayViewModel>.value(
          value: playVm,
          child: MaterialApp(
            theme: AppTheme.theme,
            home: const CompendiumScreen(initialBestiaryMode: 'playerLore'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ash Tree Wife rituals should now show GM REVEALED badge
      expect(find.text('GM REVEALED'), findsOneWidget);
      expect(find.text('BANISHMENT RITUALS'), findsWidgets);

      // Attacks should still be classified for Ash Tree Wife
      expect(find.textContaining('ATTACKS • [CLASSIFIED BY GM]'), findsWidgets);
    });
  });

  group('Fear Test Dialog Layout Tests', () {
    testWidgets('FearTestDialog renders on narrow viewport without overflow or squishing', (tester) async {
      // Test on ultra narrow mobile screen width (320px)
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(320, 600);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final playVm = PlayViewModel();
      await playVm.initialize();
      await playVm.loadPregenCharacters();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => FearTestDialog(
                      character: playVm.activeCharacter!,
                      viewModel: playVm,
                    ),
                  );
                },
                child: const Text('OPEN DIALOG'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('OPEN DIALOG'));
      await tester.pumpAndSettle();

      expect(find.textContaining('FEAR TEST'), findsWidgets);
      expect(find.textContaining('ROLL FEAR TEST'), findsWidgets);
    });
  });
}
