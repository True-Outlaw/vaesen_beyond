import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';

class CombatCard extends StatelessWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  const CombatCard({
    super.key,
    required this.character,
    required this.playViewModel,
    required this.diceViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return GothicCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('WEAPONS & COMBAT', style: AppTypography.titleMedium),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.goldDim),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield, size: 14, color: AppColors.goldBright),
                    const SizedBox(width: 4),
                    Text(
                      'ARMOR: ${character.totalArmorProtection}',
                      style: AppTypography.titleSmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          if (character.weapons.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'No weapons equipped. Unarmed attacks deal 1 damage at Engaged range.',
                style: AppTypography.bodySmall,
              ),
            )
          else
            ...character.weapons.map((w) => _buildWeaponTile(context, w)),
        ],
      ),
    );
  }

  Widget _buildWeaponTile(BuildContext context, Weapon weapon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.surfaceOverlay),
      ),
      child: Row(
        children: [
          Icon(
            weapon.isRanged ? Icons.my_location : Icons.colorize,
            color: AppColors.gold,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weapon.name,
                  style: AppTypography.titleSmall.copyWith(fontSize: 13),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _tag('DMG ${weapon.damage}'),
                    const SizedBox(width: 4),
                    if (weapon.bonus > 0) ...[
                      _tag('+${weapon.bonus} Die', color: AppColors.gold),
                      const SizedBox(width: 4),
                    ],
                    _tag(weapon.range.label),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              diceViewModel.rollWeaponAttack(character: character, weapon: weapon);
              showDialog(
                context: context,
                builder: (_) => DiceTrayDialog(
                  diceViewModel: diceViewModel,
                  playViewModel: playViewModel,
                ),
              );
            },
            icon: const Icon(Icons.flash_on, size: 13, color: AppColors.goldBright),
            label: const Text('STRIKE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceOverlay,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: (color ?? AppColors.surfaceOverlay).withAlpha(120),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          fontSize: 10,
          color: color ?? AppColors.textSecondary,
        ),
      ),
    );
  }
}
