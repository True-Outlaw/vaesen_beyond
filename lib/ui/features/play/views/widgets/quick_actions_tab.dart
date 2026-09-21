import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/act_screen.dart';

/// QuickActionsTab now cleanly aliases ActScreen, the pure Scandinavian Gothic
/// combat cockpit with zero redundancies (equipped weapons in tactile cards,
/// defenses under Physique/Agility/Close Combat, fear tests in the radial dial).
class QuickActionsTab extends StatelessWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  const QuickActionsTab({
    super.key,
    required this.character,
    required this.playViewModel,
    required this.diceViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ActScreen(
      character: character,
      playViewModel: playViewModel,
      diceViewModel: diceViewModel,
    );
  }
}
