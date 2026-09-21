import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_portrait.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/party_management_dialog.dart';

class InvestigatorPartyBar extends StatelessWidget {
  final PlayViewModel viewModel;
  final DiceRollerViewModel diceViewModel;

  const InvestigatorPartyBar({
    super.key,
    required this.viewModel,
    required this.diceViewModel,
  });

  void _rollInitiative(BuildContext context, Character character) {
    final agilityPool = character.getEffectiveSkill(SkillType.agility);
    diceViewModel.rollCustomPool(
      poolSize: agilityPool,
      title: '${character.name} — Initiative Draw',
      breakdown: 'Rolling Agility ($agilityPool D6) for turn priority.',
    );
    showDialog(
      context: context,
      builder: (_) => DiceTrayDialog(
        diceViewModel: diceViewModel,
        playViewModel: viewModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characters = viewModel.characters;
    final activeChar = viewModel.activeCharacter;
    if (characters.isEmpty || activeChar == null) return const SizedBox.shrink();

    final agilityValue = activeChar.getEffectiveSkill(SkillType.agility);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.6),
        ),
      ),
      child: Row(
        children: [
          // Horizontal Avatar Carousel
          Expanded(
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: characters.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final char = characters[index];
                  final isActive = char.id == activeChar.id;
                  final hasPenalties = char.conditions.physicalPenalty > 0 || char.conditions.mentalPenalty > 0;
                  final isBroken = char.conditions.isBroken;

                  return GestureDetector(
                    onTap: () => viewModel.switchCharacter(char.id),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GothicPortrait(
                          portraitAsset: char.effectivePortraitAsset,
                          width: 32,
                          height: 32,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isBroken
                                ? AppColors.crimson
                                : isActive
                                    ? AppColors.goldBright
                                    : AppColors.goldDim.withAlpha(90),
                            width: isActive ? 2.0 : 1.0,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: AppColors.gold.withAlpha(120),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                          fallbackInitial: char.name,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? AppColors.goldBright
                                : isBroken
                                    ? AppColors.crimson
                                    : hasPenalties
                                        ? AppColors.goldDim
                                        : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Manage Society Roster Button
          IconButton(
            icon: const Icon(Icons.manage_accounts_outlined, color: AppColors.gold, size: 20),
            tooltip: 'Society Roster & Party Management',
            padding: const EdgeInsets.symmetric(horizontal: 4),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () => showPartyManagementDialog(context, viewModel),
          ),
          const SizedBox(width: 4),

          // Initiative Roller Pill (Right side)
          GestureDetector(
            onTap: () => _rollInitiative(context, activeChar),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF221A0C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold.withAlpha(180), width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withAlpha(60),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.flash_on, color: AppColors.goldBright, size: 13),
                  const SizedBox(width: 4),
                  Text(
                    '+$agilityValue INIT',
                    style: AppTypography.statValue.copyWith(
                      fontSize: 11,
                      color: AppColors.goldBright,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
