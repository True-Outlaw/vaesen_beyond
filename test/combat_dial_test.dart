import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaesen_beyond/ui/core/theme/app_theme.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/combat_action_dial.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/condition_arc_hud.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/conditions_card.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/investigator_party_bar.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/tactile_weapon_cards.dart';

Widget createTestHarness(Widget child, PlayViewModel playVm, DiceRollerViewModel diceVm) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayViewModel>.value(value: playVm),
      ChangeNotifierProvider<DiceRollerViewModel>.value(value: diceVm),
    ],
    child: MaterialApp(
      theme: AppTheme.theme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Scandinavian Gothic Combat HUD Widgets', () {
    testWidgets('InvestigatorPartyBar renders party and triggers initiative roll', (WidgetTester tester) async {
      final playVm = PlayViewModel();
      await playVm.initialize();
      final diceVm = DiceRollerViewModel();

      await tester.pumpWidget(createTestHarness(
        InvestigatorPartyBar(viewModel: playVm, diceViewModel: diceVm),
        playVm,
        diceVm,
      ));
      await tester.pumpAndSettle();

      // Verify investigator avatars are present
      expect(find.byType(ClipOval), findsAtLeastNWidgets(4));

      // Verify Initiative pill is present with Agility bonus and tap it
      expect(find.textContaining('INIT'), findsOneWidget);
      await tester.tap(find.textContaining('INIT'));
      await tester.pumpAndSettle();

      // Verify dice tray opened with initiative roll
      expect(find.textContaining('INITIATIVE DRAW'), findsOneWidget);
    });

    testWidgets('ConditionArcHud renders condition tracks, armor shield and allows roll', (WidgetTester tester) async {
      final playVm = PlayViewModel();
      await playVm.initialize();
      final diceVm = DiceRollerViewModel();
      final character = playVm.activeCharacter!;

      await tester.pumpWidget(createTestHarness(
        ConditionArcHud(character: character, viewModel: playVm, diceViewModel: diceVm),
        playVm,
        diceVm,
      ));
      await tester.pumpAndSettle();

      // Verify character name and archetype
      expect(find.text(character.name), findsOneWidget);
      expect(find.text(character.archetypeName.toUpperCase()), findsOneWidget);

      // Verify armor protection shield and unharmed status
      expect(find.textContaining('ARMOR'), findsOneWidget);
      expect(find.text('UNHARMED'), findsOneWidget);

      // Tap UNHARMED status to open conditions management sheet
      await tester.tap(find.text('UNHARMED'));
      await tester.pumpAndSettle();

      // Verify conditions sheet opened
      expect(find.byType(ConditionsCard), findsOneWidget);
    });

    testWidgets('TactileWeaponCards renders equipped weapons and Solace ribbon', (WidgetTester tester) async {
      final playVm = PlayViewModel();
      await playVm.initialize();
      final diceVm = DiceRollerViewModel();
      final character = playVm.activeCharacter!;

      await tester.pumpWidget(createTestHarness(
        TactileWeaponCards(character: character, playViewModel: playVm, diceViewModel: diceVm),
        playVm,
        diceVm,
      ));
      await tester.pumpAndSettle();

      // Verify weapon cards
      expect(find.text('MAIN HAND'), findsOneWidget);
      expect(find.text('OFF HAND'), findsOneWidget);

      // Verify Solace ribbon is visible
      expect(find.text('SOLACE'), findsOneWidget);

      // Tap Solace ribbon to open solace dialog
      await tester.tap(find.text('SOLACE'));
      await tester.pumpAndSettle();

      // Verify solace dialog content is displayed
      expect(find.text('DRAW SOLACE'), findsWidgets);
    });

    testWidgets('CombatActionDial renders and center Talisman opens dice tray', (WidgetTester tester) async {
      final playVm = PlayViewModel();
      await playVm.initialize();
      final diceVm = DiceRollerViewModel();
      final character = playVm.activeCharacter!;

      await tester.pumpWidget(createTestHarness(
        CombatActionDial(character: character, playViewModel: playVm, diceViewModel: diceVm),
        playVm,
        diceVm,
      ));
      await tester.pumpAndSettle();

      // Verify CombatActionDial is present
      expect(find.byType(CombatActionDial), findsOneWidget);
      expect(find.text('D6'), findsOneWidget);

      // Tap center of dial (Society Talisman D6)
      await tester.tap(find.text('D6'), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Verify dice tray opened with Society Talisman D6 roll (uppercase in dialog)
      expect(find.text('SOCIETY TALISMAN D6'), findsOneWidget);
    });

    testWidgets('ConditionArcHud and bottom sheet checkboxes update in real-time', (WidgetTester tester) async {
      final playVm = PlayViewModel();
      await playVm.initialize();
      final diceVm = DiceRollerViewModel();
      final character = playVm.activeCharacter!;

      await tester.pumpWidget(createTestHarness(
        ConditionArcHud(character: character, viewModel: playVm, diceViewModel: diceVm),
        playVm,
        diceVm,
      ));
      await tester.pumpAndSettle();

      // Open conditions bottom sheet
      await tester.tap(find.text('UNHARMED'));
      await tester.pumpAndSettle();

      // Check Exhausted
      expect(find.text('Exhausted'), findsOneWidget);
      await tester.tap(find.text('Exhausted'));
      await tester.pumpAndSettle();

      // Verify real-time update in bottom sheet
      expect(find.text('-1 Dice'), findsOneWidget);

      // Check Angry
      expect(find.text('Angry'), findsOneWidget);
      await tester.tap(find.text('Angry'));
      await tester.pumpAndSettle();

      // Verify real-time update in bottom sheet (both Physical and Mental have -1 Dice)
      expect(find.text('-1 Dice'), findsNWidgets(2));
      expect(playVm.activeCharacter!.conditions.exhausted, isTrue);
      expect(playVm.activeCharacter!.conditions.angry, isTrue);
    });
  });
}
