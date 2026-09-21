import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/combat_action_dial.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/condition_arc_hud.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/investigator_party_bar.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/tactile_weapon_cards.dart';

class ActScreen extends StatelessWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  const ActScreen({
    super.key,
    required this.character,
    required this.playViewModel,
    required this.diceViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
      ),
      child: Column(
        children: [
          // 1. Top Investigator Party Strip with Initiative Roller
          InvestigatorPartyBar(
            viewModel: playViewModel,
            diceViewModel: diceViewModel,
          ),

          // 2. Main Scrollable/Adaptive Action Cockpit
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),

                  // Character HUD with 6-Arc Condition Gauge & Armor Shield
                  ConditionArcHud(
                    character: character,
                    viewModel: playViewModel,
                    diceViewModel: diceViewModel,
                  ),

                  const SizedBox(height: 4),

                  // Centerpiece: The Sculpted 4-Attribute Action Dial
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: CombatActionDial(
                      character: character,
                      playViewModel: playViewModel,
                      diceViewModel: diceViewModel,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Bottom Docked Tactile Weapon Cards & Memento Ribbon
                  TactileWeaponCards(
                    character: character,
                    playViewModel: playViewModel,
                    diceViewModel: diceViewModel,
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
