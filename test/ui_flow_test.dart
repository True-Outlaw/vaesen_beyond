import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaesen_beyond/ui/core/theme/app_theme.dart';
import 'package:vaesen_beyond/ui/features/builder/views/character_builder_screen.dart';
import 'package:vaesen_beyond/ui/features/castle/views/castle_screen.dart';
import 'package:vaesen_beyond/ui/features/compendium/views/compendium_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/play_screen.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/combat_action_dial.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/condition_arc_hud.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/tactile_weapon_cards.dart';

Widget createTestApp(Widget child, PlayViewModel playVm, DiceRollerViewModel diceVm) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayViewModel>.value(value: playVm),
      ChangeNotifierProvider<DiceRollerViewModel>.value(value: diceVm),
    ],
    child: MaterialApp(
      theme: AppTheme.theme,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('PlayScreen displays investigator identity, attributes, and conditions', (WidgetTester tester) async {
    final playVm = PlayViewModel();
    await playVm.initialize();
    final diceVm = DiceRollerViewModel();

    await tester.pumpWidget(createTestApp(
      PlayScreen(viewModel: playVm, diceViewModel: diceVm),
      playVm,
      diceVm,
    ));
    await tester.pumpAndSettle();

    // Verify default active character is Dr. Astrid Lindholm
    expect(find.text('Dr. Astrid Lindholm'), findsOneWidget);
    expect(find.text('DOCTOR'), findsOneWidget);

    // Verify 3-Tab Bottom Navigation is present
    expect(find.text('TABLE'), findsOneWidget);
    expect(find.text('ACT'), findsOneWidget);
    expect(find.text('SHEET'), findsOneWidget);

    // Default tab is ACT: verify Action Dial, Weapon Cards, and ConditionArcHud (Investigator HUD)
    expect(find.byType(ConditionArcHud), findsOneWidget);
    expect(find.byType(CombatActionDial), findsOneWidget);
    expect(find.byType(TactileWeaponCards), findsOneWidget);
    expect(find.text('MAIN HAND'), findsOneWidget);
    expect(find.text('OFF HAND'), findsOneWidget);
    expect(find.text('SOLACE'), findsOneWidget);

    // Switch to SHEET tab
    await tester.tap(find.text('SHEET'));
    await tester.pumpAndSettle();

    // Verify SHEET contains dedicated INVENTORY, ADVANCEMENT, and PREP & LORE sub-tabs
    expect(find.text('INVENTORY'), findsOneWidget);
    expect(find.text('ADVANCEMENT'), findsOneWidget);
    expect(find.text('GEAR & FINANCES'), findsOneWidget);
    expect(find.text('ADD GEAR'), findsOneWidget);

    // Switch to ADVANCEMENT sub-tab
    await tester.tap(find.text('ADVANCEMENT'));
    await tester.pumpAndSettle();
    expect(find.text('EXPERIENCE'), findsOneWidget);
    expect(find.text('DEBRIEF (+XP)'), findsOneWidget);
    expect(find.text('RAISE SKILL (5 XP)'), findsOneWidget);

    // Switch to PREP & LORE sub-tab
    await tester.tap(find.text('PREP & LORE'));
    await tester.pumpAndSettle();
    expect(find.text('MYSTERY PREPARATION & ADVANTAGES'), findsOneWidget);
    expect(find.text('INVESTIGATOR DOSSIER'), findsOneWidget);
  });

  testWidgets('PlayScreen Add Gear bottom sheet opens and displays weapons compendium', (WidgetTester tester) async {
    final playVm = PlayViewModel();
    await playVm.initialize();
    final diceVm = DiceRollerViewModel();

    await tester.pumpWidget(createTestApp(
      PlayScreen(viewModel: playVm, diceViewModel: diceVm),
      playVm,
      diceVm,
    ));
    await tester.pumpAndSettle();

    // Switch to SHEET tab
    await tester.tap(find.text('SHEET'));
    await tester.pumpAndSettle();

    // Tap ADD GEAR
    await tester.tap(find.text('ADD GEAR'));
    await tester.pumpAndSettle();

    // Verify AddItemSheet is open and has tabs & items
    expect(find.text('ACQUIRE ITEM & GEAR'), findsOneWidget);
    expect(find.text('WEAPONS'), findsOneWidget);
    expect(find.text('ARMOR'), findsOneWidget);
    expect(find.text('GEAR'), findsOneWidget);
    expect(find.text('CUSTOM'), findsOneWidget);
    expect(find.text('Hunting Knife'), findsNWidgets(2));
    expect(find.text('Cavalry Sabre'), findsOneWidget);

    // Tap close button
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('ACQUIRE ITEM & GEAR'), findsNothing);
  });

  testWidgets('PlayScreen condition toggle updates penalty and broken status via ConditionArcHud', (WidgetTester tester) async {
    final playVm = PlayViewModel();
    await playVm.initialize();
    final diceVm = DiceRollerViewModel();

    await tester.pumpWidget(createTestApp(
      PlayScreen(viewModel: playVm, diceViewModel: diceVm),
      playVm,
      diceVm,
    ));
    await tester.pumpAndSettle();

    // ConditionArcHud is present on ACT tab. Tap UNHARMED badge to open conditions sheet
    expect(find.text('UNHARMED'), findsOneWidget);
    await tester.tap(find.text('UNHARMED'));
    await tester.pumpAndSettle();

    // Tap on the Exhausted condition chip in the conditions drawer
    final exhaustedChip = find.text('Exhausted');
    expect(exhaustedChip, findsOneWidget);
    await tester.tap(exhaustedChip);
    await tester.pumpAndSettle();

    // Verify physical condition penalty is applied to active character
    expect(playVm.activeCharacter!.conditions.exhausted, isTrue);
    expect(playVm.activeCharacter!.conditions.physicalPenalty, equals(1));
  });

  testWidgets('CastleScreen displays Castle Gyllencreutz facilities and staff', (WidgetTester tester) async {
    final playVm = PlayViewModel();
    await playVm.initialize();
    final diceVm = DiceRollerViewModel();

    await tester.pumpWidget(createTestApp(
      CastleScreen(viewModel: playVm),
      playVm,
      diceVm,
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('CASTLE GYLLENCREUTZ'), findsOneWidget);
    expect(find.text('FACILITIES & UPGRADES'), findsOneWidget);
    expect(find.text('Grand Library'), findsOneWidget);

    // Scroll down to view hired staff
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('HIRED STAFF ROSTER'), findsOneWidget);
    expect(find.text('Algot Frisk'), findsOneWidget);
  });

  testWidgets('CompendiumScreen displays tabs for Archetypes, Talents, Injuries, Gear, Rules', (WidgetTester tester) async {
    final playVm = PlayViewModel();
    await playVm.initialize();
    final diceVm = DiceRollerViewModel();

    await tester.pumpWidget(createTestApp(
      const CompendiumScreen(),
      playVm,
      diceVm,
    ));
    await tester.pumpAndSettle();

    expect(find.text('SOCIETY COMPENDIUM'), findsOneWidget);
    expect(find.text('ARCHETYPES'), findsOneWidget);
    expect(find.text('TALENTS'), findsOneWidget);
    expect(find.text('CRITICAL INJURIES'), findsOneWidget);
    expect(find.text('WEAPONS & GEAR'), findsOneWidget);
    expect(find.text('RULES REFERENCE'), findsOneWidget);

    // Verify search bar is present
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('CharacterBuilderScreen renders Step 1: Choose Archetype with 10 archetypes', (WidgetTester tester) async {
    final playVm = PlayViewModel();
    await playVm.initialize();
    final diceVm = DiceRollerViewModel();

    await tester.pumpWidget(createTestApp(
      CharacterBuilderScreen(playViewModel: playVm, onFinished: () {}),
      playVm,
      diceVm,
    ));
    await tester.pumpAndSettle();

    expect(find.text('Identity'), findsOneWidget);
    expect(find.text('ACADEMIC'), findsOneWidget);
    expect(find.text('DOCTOR'), findsOneWidget);
    expect(find.text('HUNTER'), findsOneWidget);
    expect(find.text('NEXT STEP'), findsOneWidget);
  });

  testWidgets('DiceTrayDialog toggles Advantage, updates modifier display, and rolls pool with modifiers', (WidgetTester tester) async {
    final playVm = PlayViewModel();
    await playVm.initialize();
    final diceVm = DiceRollerViewModel();

    // Trigger initial 4 dice roll
    diceVm.rollCustomPool(poolSize: 4, title: 'Logic Check', breakdown: 'Logic 4 = 4 dice');

    await tester.pumpWidget(createTestApp(
      Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => DiceTrayDialog(diceViewModel: diceVm, playViewModel: playVm),
            ),
            child: const Text('OPEN DIALOG'),
          ),
        ),
      ),
      playVm,
      diceVm,
    ));

    await tester.tap(find.text('OPEN DIALOG'));
    await tester.pumpAndSettle();

    expect(find.text('LOGIC CHECK'), findsOneWidget);
    expect(find.text('MODIFIER: '), findsOneWidget);
    expect(find.text('+0'), findsOneWidget);

    // Toggle Advantage (+2)
    await tester.tap(find.text('+2 ADVANTAGE'));
    await tester.pumpAndSettle();

    // Verify modifier updated to +2 and '+2 Adv Included' is shown
    expect(find.text('+2'), findsOneWidget);
    expect(find.text('+2 Adv Included'), findsOneWidget);
    expect(find.textContaining('ROLL 6 DICE WITH MODIFIERS'), findsOneWidget);

    // Tap Roll with modifiers
    await tester.tap(find.textContaining('ROLL 6 DICE WITH MODIFIERS'));
    await tester.pumpAndSettle();

    expect(diceVm.currentRoll!.dice.length, 6);
  });
}
