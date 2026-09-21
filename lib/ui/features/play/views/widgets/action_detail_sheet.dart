import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';

class ActionDetailSheet extends StatefulWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  final String title;
  final String? subtitle;
  final String? description;
  final List<String> tags;

  final AttributeType attribute;
  final SkillType? skill;
  final int gearBonus;
  final int baseDamage;
  final String? range;

  const ActionDetailSheet({
    super.key,
    required this.character,
    required this.playViewModel,
    required this.diceViewModel,
    required this.title,
    this.subtitle,
    this.description,
    this.tags = const [],
    required this.attribute,
    this.skill,
    this.gearBonus = 0,
    this.baseDamage = 0,
    this.range,
  });

  factory ActionDetailSheet.forWeapon({
    required Character character,
    required PlayViewModel playViewModel,
    required DiceRollerViewModel diceViewModel,
    required Weapon weapon,
  }) {
    return ActionDetailSheet(
      character: character,
      playViewModel: playViewModel,
      diceViewModel: diceViewModel,
      title: weapon.name,
      subtitle: weapon.isRanged ? 'Ranged Weapon' : 'Melee Weapon',
      description: 'Damage: ${weapon.damage} • Range: ${weapon.range.label} • Bonus: +${weapon.bonus}',
      tags: weapon.qualities,
      attribute: weapon.isRanged ? AttributeType.precision : AttributeType.physique,
      skill: weapon.isRanged ? SkillType.rangedCombat : SkillType.closeCombat,
      gearBonus: weapon.bonus,
      baseDamage: weapon.damage,
      range: weapon.range.label,
    );
  }

  factory ActionDetailSheet.forSkill({
    required Character character,
    required PlayViewModel playViewModel,
    required DiceRollerViewModel diceViewModel,
    required SkillType skill,
  }) {
    return ActionDetailSheet(
      character: character,
      playViewModel: playViewModel,
      diceViewModel: diceViewModel,
      title: skill.label,
      subtitle: 'Governed by ${skill.attribute.label}',
      description: skill.description,
      attribute: skill.attribute,
      skill: skill,
    );
  }

  @override
  State<ActionDetailSheet> createState() => _ActionDetailSheetState();
}

class _ActionDetailSheetState extends State<ActionDetailSheet> {
  int _situationalModifier = 0;

  @override
  Widget build(BuildContext context) {
    final attrVal = widget.character.getEffectiveAttribute(widget.attribute);
    final skillVal = widget.skill != null ? widget.character.getSkill(widget.skill!) : 0;
    final penalty = widget.attribute.isPhysical
        ? widget.character.conditions.physicalPenalty
        : widget.character.conditions.mentalPenalty;

    final totalDice = (attrVal + skillVal + widget.gearBonus + _situationalModifier).clamp(1, 30);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(color: AppColors.goldBright, width: 1.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.goldDim.withAlpha(120),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title.toUpperCase(),
                      style: AppTypography.displayMedium.copyWith(
                        fontSize: 20,
                        color: AppColors.goldBright,
                      ),
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.gold),
                      ),
                  ],
                ),
              ),
              if (widget.baseDamage > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.crimsonGaze,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.crimson),
                  ),
                  child: Column(
                    children: [
                      Text('DAMAGE', style: AppTypography.titleSmall.copyWith(fontSize: 9, color: AppColors.lethal)),
                      Text('${widget.baseDamage}', style: AppTypography.statNumber.copyWith(fontSize: 16)),
                    ],
                  ),
                ),
            ],
          ),

          if (widget.description != null && widget.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.description!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
          ],

          // Tags (Qualities)
          if (widget.tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: widget.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.goldDim),
                  ),
                  child: Text(
                    tag,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.goldBright,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const OrnateDivider(height: 20),

          // Formula Breakdown Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surfaceOverlay),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DICE POOL BREAKDOWN',
                  style: AppTypography.titleSmall.copyWith(fontSize: 10, color: AppColors.goldDim),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.attribute.label} ($attrVal) + ${widget.skill?.label ?? "Skill"} ($skillVal)'
                      '${widget.gearBonus > 0 ? " + Gear (+${widget.gearBonus})" : ""}'
                      '${_situationalModifier != 0 ? " + Mod ($_situationalModifier)" : ""}'
                      '${penalty > 0 ? " - Trauma (-$penalty)" : ""}',
                      style: AppTypography.bodySmall.copyWith(fontSize: 12),
                    ),
                    Text(
                      '$totalDice d6',
                      style: AppTypography.statNumber.copyWith(
                        fontSize: 18,
                        color: AppColors.goldBright,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Situational Modifier Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SITUATIONAL MODIFIER', style: AppTypography.titleSmall.copyWith(fontSize: 11)),
              Row(
                children: [
                  IconButton.outlined(
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: _situationalModifier > -3
                        ? () => setState(() => _situationalModifier--)
                        : null,
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.surfaceOverlay),
                    ),
                  ),
                  Container(
                    width: 38,
                    alignment: Alignment.center,
                    child: Text(
                      _situationalModifier >= 0 ? '+$_situationalModifier' : '$_situationalModifier',
                      style: AppTypography.statNumber.copyWith(
                        fontSize: 16,
                        color: _situationalModifier > 0
                            ? AppColors.mentalCondition
                            : (_situationalModifier < 0 ? AppColors.physicalCondition : AppColors.goldBright),
                      ),
                    ),
                  ),
                  IconButton.outlined(
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: _situationalModifier < 3
                        ? () => setState(() => _situationalModifier++)
                        : null,
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.surfaceOverlay),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Big Roll Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                widget.diceViewModel.rollCustomPool(
                  poolSize: totalDice,
                  title: widget.title,
                  breakdown: '${widget.attribute.label} ($attrVal) + ${widget.skill?.label ?? "Skill"} ($skillVal)'
                      '${widget.gearBonus > 0 ? " + Gear (+${widget.gearBonus})" : ""}'
                      '${_situationalModifier != 0 ? " + Mod ($_situationalModifier)" : ""}'
                      '${penalty > 0 ? " - Trauma (-$penalty)" : ""}',
                );
                showDialog(
                  context: context,
                  builder: (_) => DiceTrayDialog(
                    diceViewModel: widget.diceViewModel,
                    playViewModel: widget.playViewModel,
                  ),
                );
              },
              icon: const Icon(Icons.casino, color: AppColors.goldBright, size: 20),
              label: Text(
                'ROLL $totalDice DICE',
                style: AppTypography.titleMedium.copyWith(
                  letterSpacing: 1.2,
                  color: AppColors.goldBright,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceLight,
                foregroundColor: AppColors.goldBright,
                side: const BorderSide(color: AppColors.goldBright, width: 1.2),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
