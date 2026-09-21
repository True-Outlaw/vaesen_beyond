import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';

class TactileWeaponCards extends StatelessWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  const TactileWeaponCards({
    super.key,
    required this.character,
    required this.playViewModel,
    required this.diceViewModel,
  });

  void _rollAttack(BuildContext context, Weapon weapon) {
    final isRanged = weapon.isRanged;
    final skill = isRanged ? SkillType.rangedCombat : SkillType.closeCombat;
    final basePool = character.getEffectiveSkill(skill);
    final totalPool = (basePool + weapon.bonus).clamp(1, 20);

    diceViewModel.rollCustomPool(
      poolSize: totalPool,
      title: '${weapon.name} Attack',
      breakdown: '${skill.label} ($basePool) + Weapon Bonus (+${weapon.bonus}) = $totalPool D6. Damage: ${weapon.damage}. Range: ${weapon.range.label}.',
    );

    showDialog(
      context: context,
      builder: (_) => DiceTrayDialog(
        diceViewModel: diceViewModel,
        playViewModel: playViewModel,
      ),
    );
  }

  void _rollUnarmed(BuildContext context) {
    final pool = character.getEffectiveSkill(SkillType.closeCombat).clamp(1, 20);
    diceViewModel.rollCustomPool(
      poolSize: pool,
      title: 'Unarmed Strike / Brawl',
      breakdown: 'Close Combat ($pool D6). Damage: 1. Range: Engaged.',
    );
    showDialog(
      context: context,
      builder: (_) => DiceTrayDialog(
        diceViewModel: diceViewModel,
        playViewModel: playViewModel,
      ),
    );
  }

  void _drawSolace(BuildContext context) {
    if (character.isMementoUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Memento solace already drawn for this mystery.\n("${character.memento}")'),
          backgroundColor: AppColors.surfaceOverlay,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.gold, width: 1),
        ),
        title: Row(
          children: [
            const Icon(Icons.bookmark_outline, color: AppColors.goldBright, size: 20),
            const SizedBox(width: 8),
            Text('DRAW SOLACE', style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memento: "${character.memento}"',
              style: AppTypography.bodyMedium.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Once per mystery, you can spend a moment with your memento to heal 1 Mental Condition (Angry, Frightened, or Hopeless).',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await playViewModel.useMemento();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You drew solace from your memento. One mental condition healed.'),
                    backgroundColor: AppColors.surfaceOverlay,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.backgroundDark,
            ),
            child: const Text('DRAW SOLACE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final equippedWeapons = character.weapons.where((w) => w.isEquipped).toList();
    Weapon? primaryMelee;
    Weapon? primaryRanged;

    for (final w in equippedWeapons) {
      if (!w.isRanged && primaryMelee == null) {
        primaryMelee = w;
      } else if (w.isRanged && primaryRanged == null) {
        primaryRanged = w;
      }
    }

    // Fallback assignment if only one weapon type is carried
    if (primaryMelee == null && equippedWeapons.isNotEmpty && primaryRanged != equippedWeapons.first) {
      primaryMelee = equippedWeapons.first;
    }
    if (primaryRanged == null && equippedWeapons.length > 1 && primaryMelee != equippedWeapons.last) {
      primaryRanged = equippedWeapons.last;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Card: Secondary / Firearm / Ranged Weapon
          Expanded(
            child: _buildWeaponCard(
              context: context,
              label: 'OFF HAND',
              weapon: primaryRanged,
              isMelee: false,
              onTap: () {
                if (primaryRanged != null) {
                  _rollAttack(context, primaryRanged);
                } else {
                  _rollUnarmed(context);
                }
              },
            ),
          ),

          const SizedBox(width: 8),

          // Center Ribbon: Memento / Solace Bookmark
          GestureDetector(
            onTap: () => _drawSolace(context),
            child: Tooltip(
              message: character.isMementoUsed ? 'Solace Already Used' : 'Draw Solace from Memento',
              child: Container(
                width: 42,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: character.isMementoUsed
                        ? [const Color(0xFF2A231C), const Color(0xFF1E1812)]
                        : [const Color(0xFF8F7026), const Color(0xFF5A4413)],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                    bottom: Radius.circular(14),
                  ),
                  border: Border.all(
                    color: character.isMementoUsed
                        ? AppColors.goldDim.withAlpha(60)
                        : AppColors.goldBright,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(140),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      character.isMementoUsed ? Icons.bookmark_border : Icons.bookmark,
                      color: character.isMementoUsed ? AppColors.textMuted : AppColors.goldBright,
                      size: 20,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'SOLACE',
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: character.isMementoUsed ? AppColors.textMuted : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Right Card: Primary / Melee Weapon
          Expanded(
            child: _buildWeaponCard(
              context: context,
              label: 'MAIN HAND',
              weapon: primaryMelee,
              isMelee: true,
              onTap: () {
                if (primaryMelee != null) {
                  _rollAttack(context, primaryMelee);
                } else {
                  _rollUnarmed(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponCard({
    required BuildContext context,
    required String label,
    required Weapon? weapon,
    required bool isMelee,
    required VoidCallback onTap,
  }) {
    final skill = isMelee ? SkillType.closeCombat : SkillType.rangedCombat;
    final basePool = character.getEffectiveSkill(skill);
    final totalPool = weapon != null ? (basePool + weapon.bonus).clamp(1, 20) : basePool.clamp(1, 20);
    final weaponName = weapon?.name ?? (isMelee ? 'Unarmed Strike' : 'Quick Throw');
    final damage = weapon?.damage ?? 1;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF222930),
              Color(0xFF161B20),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.gold.withAlpha(120),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(120),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.goldDim,
                    fontSize: 8,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Icon(
                  isMelee ? Icons.sports_kabaddi : Icons.gps_fixed,
                  size: 11,
                  color: AppColors.goldDim,
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              weaponName,
              style: AppTypography.titleSmall.copyWith(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(35),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.gold.withAlpha(140), width: 0.6),
                  ),
                  child: Text(
                    '$totalPool D6',
                    style: AppTypography.statValue.copyWith(
                      fontSize: 10,
                      color: AppColors.goldBright,
                    ),
                  ),
                ),
                Text(
                  'DMG $damage',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 9,
                    color: AppColors.crimsonBright,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
