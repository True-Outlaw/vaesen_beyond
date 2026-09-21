import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/pip_counter.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';

class AttributesSkillsGrid extends StatelessWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  const AttributesSkillsGrid({
    super.key,
    required this.character,
    required this.playViewModel,
    required this.diceViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(
            'ATTRIBUTES & SKILLS',
            style: AppTypography.label.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.0,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 850;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _buildAttributeCard(context, AttributeType.physique),
                        const SizedBox(height: 10),
                        _buildAttributeCard(context, AttributeType.precision),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        _buildAttributeCard(context, AttributeType.logic),
                        const SizedBox(height: 10),
                        _buildAttributeCard(context, AttributeType.empathy),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: AttributeType.values
                  .map((attr) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildAttributeCard(context, attr),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAttributeCard(BuildContext context, AttributeType attr) {
    final effectiveAttrVal = character.getEffectiveAttribute(attr);
    final penalty = attr.isPhysical
        ? character.conditions.physicalPenalty
        : character.conditions.mentalPenalty;
    final skillsForAttr = SkillType.values.where((s) => s.attribute == attr).toList();
    final accentColor = attr.isPhysical ? AppColors.crimson : AppColors.violet;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Attribute Header ────────────────────────────────────────────
          Container(
            color: AppColors.surfaceLight,
            padding: const EdgeInsets.fromLTRB(12, 8, 10, 8),
            child: Row(
              children: [
                // Color accent tab on left
                Container(
                  width: 3,
                  height: 28,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attr.label.toUpperCase(),
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 15,
                          color: AppColors.goldBright,
                        ),
                      ),
                      Text(
                        attr.isPhysical ? 'Physical Attribute' : 'Mental Attribute',
                        style: AppTypography.label.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                // Attribute value badge
                GestureDetector(
                  onTap: () {
                    diceViewModel.rollAttribute(character: character, attribute: attr);
                    showDialog(
                      context: context,
                      builder: (_) => DiceTrayDialog(
                        diceViewModel: diceViewModel,
                        playViewModel: playViewModel,
                      ),
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: accentColor.withAlpha(80), width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$effectiveAttrVal',
                          style: AppTypography.statHero.copyWith(fontSize: 20, height: 1),
                        ),
                        if (penalty > 0)
                          Text(
                            '-$penalty',
                            style: AppTypography.chip.copyWith(color: accentColor, fontSize: 8),
                          )
                        else
                          Text(
                            'D6',
                            style: AppTypography.chip.copyWith(color: AppColors.textMuted, fontSize: 8),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Skills List ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 10, 8),
            child: Column(
              children: skillsForAttr.map((skill) {
                final skillVal = character.getSkill(skill);
                final pool = character.getEffectiveSkillPool(skill);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          skill.label,
                          style: AppTypography.label.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      PipCounter(
                        value: skillVal,
                        max: 5,
                        onChanged: (newVal) {
                          final newSkills = Map<SkillType, int>.from(character.skills);
                          newSkills[skill] = newVal;
                          playViewModel.updateCharacter(character.copyWith(skills: newSkills));
                        },
                        size: 9,
                      ),
                      const SizedBox(width: 8),
                      // Dice pool roll pill
                      GestureDetector(
                        onTap: () {
                          diceViewModel.rollSkill(character: character, skill: skill);
                          showDialog(
                            context: context,
                            builder: (_) => DiceTrayDialog(
                              diceViewModel: diceViewModel,
                              playViewModel: playViewModel,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2B1A),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.goldDim, width: 0.7),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.casino, size: 10, color: AppColors.gold),
                              const SizedBox(width: 3),
                              Text(
                                '$pool d6',
                                style: AppTypography.chip.copyWith(
                                  color: AppColors.goldBright,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
