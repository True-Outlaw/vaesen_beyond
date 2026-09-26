import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vaesen_beyond/data/seed/pregen_characters.dart';
import 'package:vaesen_beyond/data/seed/vaesen_bestiary_data.dart';
import 'package:vaesen_beyond/domain/models/vaesen_creature.dart';
import 'package:vaesen_beyond/ui/core/theme/app_theme.dart';
import 'package:vaesen_beyond/ui/features/compendium/views/compendium_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/initiative_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/initiative_tracker_dialog.dart';

void main() {
  group('Phase 4: Vaesen Bestiary & Scandinavian Folklore Data', () {
    test('Bestiary contains all 18 mythological Nordic folklore creatures', () {
      final creatures = VaesenBestiaryData.allCreatures;
      expect(creatures.length, equals(18));

      final names = creatures.map((c) => c.name).toSet();
      final expected = [
        'Ash Tree Wife',
        'Brook Horse',
        'Church Grim',
        'Fairy',
        'Ghost',
        'Giant',
        'Lindworm',
        'Mermaid / Sea Wife',
        'Myling',
        'Night Raven',
        'Nixie',
        'Revenant',
        'Spertus',
        'Troll',
        'Vaettir / Tomte',
        'Werewolf',
        'Will-o\'-the-Wisp',
        'Wood Wife / Forest Spirit',
      ];

      for (final expectedName in expected) {
        expect(names.contains(expectedName), isTrue,
            reason: 'Creature $expectedName should be present in Bestiary');
      }
    });

    test('Creature models have valid stats, fear values, weaknesses, and rituals', () {
      for (final creature in VaesenBestiaryData.allCreatures) {
        expect(creature.id.isNotEmpty, isTrue);
        expect(creature.name.isNotEmpty, isTrue);
        expect(creature.swedishName.isNotEmpty, isTrue);
        expect(creature.category.isNotEmpty, isTrue);
        expect(creature.might, greaterThan(0));
        expect(creature.body, greaterThan(0));
        expect(creature.mind, greaterThan(0));
        expect(creature.magic, greaterThanOrEqualTo(0));
        expect(creature.fear, inInclusiveRange(1, 3));
        expect(creature.weaknesses.isNotEmpty, isTrue,
            reason: '${creature.name} should have folklore weaknesses');
        expect(creature.ritualsOfBanishment.isNotEmpty, isTrue,
            reason: '${creature.name} should have banishment rituals');
      }
    });

    test('VaesenCreature JSON round-trip serialization', () {
      final original = VaesenBestiaryData.allCreatures.first;
      final json = original.toJson();
      final restored = VaesenCreature.fromJson(json);

      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.swedishName, equals(original.swedishName));
      expect(restored.might, equals(original.might));
      expect(restored.enchantments.length, equals(original.enchantments.length));
      expect(restored.attacks.length, equals(original.attacks.length));
      expect(restored.weaknesses, equals(original.weaknesses));
    });
  });

  group('Phase 4: Initiative Card Slot Tracker', () {
    test('Deals unique 1–10 cards and orders turns by lowest card first', () {
      final initVm = InitiativeViewModel();
      final party = PregenCharacters.characters; // 4 investigators
      initVm.initializeFromParty(party);

      expect(initVm.isCombatActive, isTrue);
      expect(initVm.round, equals(1));
      expect(initVm.combatants.length, equals(4));

      // Check card uniqueness
      final cards = initVm.combatants.map((c) => c.cardNumber).toList();
      expect(cards.toSet().length, equals(4));
      for (final card in cards) {
        expect(card, inInclusiveRange(1, 10));
      }

      // Check turn order sorted ascending
      final turnOrder = initVm.turnOrder;
      for (var i = 0; i < turnOrder.length - 1; i++) {
        expect(turnOrder[i].cardNumber, lessThan(turnOrder[i + 1].cardNumber));
      }

      // Lowest card acts first
      expect(initVm.currentTurnCard, equals(turnOrder.first.cardNumber));
    });

    test('Allows adding adversaries with unused cards up to 10', () {
      final initVm = InitiativeViewModel();
      initVm.initializeFromParty(PregenCharacters.characters.take(2).toList());
      expect(initVm.combatants.length, equals(2));

      initVm.addAdversary('Church Grim', type: 'Undead');
      expect(initVm.combatants.length, equals(3));
      final adversary = initVm.combatants.firstWhere((c) => c.name == 'Church Grim');
      expect(adversary.isInvestigator, isFalse);
      expect(adversary.cardNumber, inInclusiveRange(1, 10));

      // Add more up to 10
      for (var i = 0; i < 7; i++) {
        initVm.addAdversary('Foe $i');
      }
      expect(initVm.combatants.length, equals(10));

      // Attempting 11th should be ignored
      initVm.addAdversary('Extra Foe');
      expect(initVm.combatants.length, equals(10));
    });

    test('Two-tap swap correctly swaps cards between combatants', () {
      final initVm = InitiativeViewModel();
      initVm.initializeFromParty(PregenCharacters.characters.take(2).toList());

      final c1 = initVm.combatants[0];
      final c2 = initVm.combatants[1];
      final origCard1 = c1.cardNumber;
      final origCard2 = c2.cardNumber;

      // Tap first combatant
      initVm.selectCombatantForSwap(c1.id);
      expect(initVm.selectedCombatantIdForSwap, equals(c1.id));

      // Tap second combatant
      initVm.selectCombatantForSwap(c2.id);
      expect(initVm.selectedCombatantIdForSwap, isNull);

      // Verify cards swapped
      final updated1 = initVm.combatants.firstWhere((c) => c.id == c1.id);
      final updated2 = initVm.combatants.firstWhere((c) => c.id == c2.id);
      expect(updated1.cardNumber, equals(origCard2));
      expect(updated2.cardNumber, equals(origCard1));
    });

    test('Turn advance and round stepping', () {
      final initVm = InitiativeViewModel();
      initVm.initializeFromParty(PregenCharacters.characters.take(2).toList());

      final firstOnTurn = initVm.activeTurnCombatant!;
      expect(firstOnTurn.hasActed, isFalse);

      // Toggle acted on current turn -> advances turn
      initVm.toggleActed(firstOnTurn.id);
      expect(initVm.combatants.firstWhere((c) => c.id == firstOnTurn.id).hasActed, isTrue);

      final secondOnTurn = initVm.activeTurnCombatant!;
      expect(secondOnTurn.id, isNot(equals(firstOnTurn.id)));

      // Step to next round
      initVm.nextRound();
      expect(initVm.round, equals(2));
      expect(initVm.combatants.every((c) => !c.hasActed), isTrue);
    });
  });

  group('Phase 4: Global Compendium Search & Bestiary UI', () {
    testWidgets('Renders CompendiumScreen with Bestiary tab and category filter', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 2400);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const CompendiumScreen(initialBestiaryEnabled: true),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Bestiary tab chip is visible
      expect(find.text('BESTIARY'), findsOneWidget);
      expect(find.text('ARCHETYPES'), findsOneWidget);
      expect(find.text('TALENTS'), findsOneWidget);

      // Verify creature card rendered
      expect(find.text('ASH TREE WIFE'), findsOneWidget);
      expect(find.text('(Askfrun)'), findsOneWidget);

      // Tap "Undead" filter chip
      final undeadChip = find.widgetWithText(FilterChip, 'Undead');
      await tester.ensureVisible(undeadChip);
      await tester.tap(undeadChip);
      await tester.pumpAndSettle();

      // Undead creatures should appear
      expect(find.text('GHOST'), findsOneWidget);
      expect(find.text('ASH TREE WIFE'), findsNothing);
    });

    testWidgets('Global Search displays badge count pills and matches across categories', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const CompendiumScreen(initialBestiaryEnabled: true),
        ),
      );
      await tester.pumpAndSettle();

      // Search for "Askfrun"
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'Askfrun');
      await tester.pumpAndSettle();

      // Global search badge count tabs should display
      expect(find.textContaining('BESTIARY (1)'), findsOneWidget);
      expect(find.textContaining('ALL ('), findsOneWidget);

      // The Ash Tree Wife card should be visible
      expect(find.text('ASH TREE WIFE'), findsOneWidget);
    });

    testWidgets('Renders InitiativeTrackerDialog and allows adding adversary', (tester) async {
      final playVm = PlayViewModel()..initialize();
      final initVm = InitiativeViewModel();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: playVm),
            ChangeNotifierProvider.value(value: initVm),
          ],
          child: MaterialApp(
            theme: AppTheme.theme,
            home: const Scaffold(
              body: InitiativeTrackerDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('INITIATIVE CARD RACK'), findsOneWidget);
      expect(find.text('+ ADVERSARY'), findsOneWidget);
      expect(find.text('ADVANCE TURN'), findsOneWidget);

      // Open Add Adversary
      await tester.tap(find.text('+ ADVERSARY'));
      await tester.pumpAndSettle();

      expect(find.text('ADD ADVERSARY'), findsOneWidget);
      await tester.enterText(find.byType(TextField).last, 'Bäckahästen');
      await tester.tap(find.text('DEAL CARD'));
      await tester.pumpAndSettle();

      expect(find.text('Bäckahästen'), findsOneWidget);
    });

    testWidgets('CompendiumScreen renders desktop multi-column responsive layout and sub-category filtering', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1500, 1000);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          home: const CompendiumScreen(initialBestiaryEnabled: true),
        ),
      );
      await tester.pumpAndSettle();

      // On desktop (width >= 1180), header badge should display
      expect(find.text('REFERENCE ARCHIVE'), findsOneWidget);
      expect(find.text('SOCIETY COMPENDIUM'), findsOneWidget);

      // Verify Bestiary renders multiple creature cards
      expect(find.text('ASH TREE WIFE'), findsOneWidget);
      expect(find.text('BROOK HORSE'), findsOneWidget);

      // Switch to Critical Injuries tab
      final injuriesTab = find.text('CRITICAL INJURIES');
      await tester.ensureVisible(injuriesTab);
      await tester.tap(injuriesTab);
      await tester.pumpAndSettle();

      // Verify Critical Injury filters exist
      expect(find.widgetWithText(FilterChip, 'Physical'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Mental'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Lethal'), findsOneWidget);

      // Tap "Lethal" filter
      await tester.tap(find.widgetWithText(FilterChip, 'Lethal'));
      await tester.pumpAndSettle();
      expect(find.text('LETHAL'), findsWidgets);

      // Switch to Weapons & Gear tab
      final gearTab = find.text('WEAPONS & GEAR');
      await tester.ensureVisible(gearTab);
      await tester.tap(gearTab);
      await tester.pumpAndSettle();

      // Verify gear sub-filters exist
      expect(find.widgetWithText(FilterChip, 'Weapons'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Armor & Protection'), findsOneWidget);
      expect(find.widgetWithText(FilterChip, 'Common Equipment'), findsOneWidget);

      // Filter by Armor & Protection
      await tester.tap(find.widgetWithText(FilterChip, 'Armor & Protection'));
      await tester.pumpAndSettle();
      expect(find.textContaining('ARMOR & PROTECTION'), findsOneWidget);
      expect(find.textContaining('WEAPONS ('), findsNothing);

      // Switch to Archetypes tab
      final archetypesTab = find.text('ARCHETYPES');
      await tester.ensureVisible(archetypesTab);
      await tester.tap(archetypesTab);
      await tester.pumpAndSettle();
      expect(find.text('ACADEMIC'), findsOneWidget);
      expect(find.text('DOCTOR'), findsOneWidget);

      // Switch to Rules tab
      final rulesTab = find.text('RULES REFERENCE');
      await tester.ensureVisible(rulesTab);
      await tester.tap(rulesTab);
      await tester.pumpAndSettle();
      expect(find.text('PUSHING THE ROLL'), findsOneWidget);
      expect(find.text('FEAR TESTS'), findsOneWidget);
    });
  });
}
