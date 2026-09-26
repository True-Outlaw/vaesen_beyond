import 'package:flutter/material.dart';
import 'package:vaesen_beyond/data/seed/talents_data.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';

class AdvancementCard extends StatelessWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  const AdvancementCard({
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
        // ── 1. XP & ADVANCEMENT DASHBOARD ──────────────────────────────────
        GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.military_tech_outlined, color: AppColors.gold, size: 18),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'EXPERIENCE',
                            style: AppTypography.titleMedium.copyWith(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _openSessionDebriefDialog(context),
                    icon: const Icon(Icons.quiz_outlined, size: 13, color: AppColors.goldBright),
                    label: const Text('DEBRIEF (+XP)', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceOverlay,
                      foregroundColor: AppColors.goldBright,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: const BorderSide(color: AppColors.gold, width: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // XP Bar & Level Up Buttons
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.gold, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('CURRENT XP', style: AppTypography.labelSmall.copyWith(color: AppColors.goldDim, fontSize: 9)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 14, color: AppColors.textMuted),
                              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                              padding: EdgeInsets.zero,
                              onPressed: character.experiencePoints > 0
                                  ? () => playViewModel.addExperience(-1)
                                  : null,
                            ),
                            Container(
                              constraints: const BoxConstraints(minWidth: 26),
                              alignment: Alignment.center,
                              child: Text(
                                '${character.experiencePoints}',
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.goldBright,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 14, color: AppColors.gold),
                              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                              padding: EdgeInsets.zero,
                              onPressed: () => playViewModel.addExperience(1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        // Raise Skill Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: character.experiencePoints >= 5
                                ? () => _openRaiseSkillDialog(context)
                                : null,
                            icon: const Icon(Icons.upgrade, size: 16),
                            label: const Text('RAISE SKILL (5 XP)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold.withAlpha(40),
                              foregroundColor: AppColors.goldBright,
                              disabledBackgroundColor: AppColors.surfaceLight,
                              disabledForegroundColor: AppColors.textMuted,
                              side: BorderSide(
                                color: character.experiencePoints >= 5 ? AppColors.gold : AppColors.border,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Learn Talent Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: character.experiencePoints >= 5
                                ? () => _openLearnTalentDialog(context)
                                : null,
                            icon: const Icon(Icons.auto_awesome, size: 16),
                            label: const Text('LEARN TALENT (5 XP)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surfaceLight,
                              foregroundColor: AppColors.goldBright,
                              disabledBackgroundColor: AppColors.surfaceLight,
                              disabledForegroundColor: AppColors.textMuted,
                              side: BorderSide(
                                color: character.experiencePoints >= 5 ? AppColors.gold : AppColors.border,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Vaesen Rules: Spend 5 XP to increase a skill by 1 (max 5) or acquire a new talent.',
                style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── 2. COMPLETE 12-SKILL ROSTER BY ATTRIBUTE ────────────────────────
        ...AttributeType.values.map((attr) {
          final skills = SkillType.values.where((s) => s.attribute == attr).toList();
          final attrVal = character.getAttribute(attr);
          final penalty = attr.isPhysical
              ? character.conditions.physicalPenalty
              : character.conditions.mentalPenalty;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GothicCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              attr.isPhysical ? Icons.fitness_center : Icons.psychology,
                              size: 16,
                              color: attr.isPhysical ? AppColors.physicalCondition : AppColors.mentalCondition,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                attr.label.toUpperCase(),
                                style: AppTypography.titleSmall.copyWith(
                                  color: attr.isPhysical ? AppColors.physicalCondition : AppColors.mentalCondition,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.goldDim),
                        ),
                        child: Text(
                          'BASE: $attrVal ${penalty > 0 ? "(-$penalty)" : ""}',
                          style: const TextStyle(color: AppColors.gold, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...skills.map((skill) {
                    final rank = character.getSkill(skill);
                    final pool = character.getEffectiveSkillPool(skill);

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.border, width: 0.6),
                      ),
                      child: Row(
                        children: [
                          // Skill Name
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  skill.label,
                                  style: AppTypography.titleSmall.copyWith(fontSize: 13, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                // 5 Diamond Pips
                                Row(
                                  children: List.generate(5, (index) {
                                    final isFilled = index < rank;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: Icon(
                                        isFilled ? Icons.diamond : Icons.diamond_outlined,
                                        size: 10,
                                        color: isFilled ? AppColors.gold : AppColors.textMuted.withAlpha(80),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),

                          // Rank Badge & Upgrade Button (Locked to 5 XP per Vaesen rules)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: AppColors.gold.withAlpha(70), width: 0.6),
                                ),
                                child: Text(
                                  'RANK $rank',
                                  style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                              ),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, size: 16),
                                color: (rank < 5 && character.experiencePoints >= 5)
                                    ? AppColors.goldBright
                                    : AppColors.textMuted.withAlpha(80),
                                tooltip: rank >= 5
                                    ? 'Max Rank (5)'
                                    : character.experiencePoints < 5
                                        ? 'Requires 5 XP (Current: ${character.experiencePoints})'
                                        : 'Spend 5 XP to raise ${skill.label} to Rank ${rank + 1}',
                                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                                padding: EdgeInsets.zero,
                                onPressed: (rank < 5 && character.experiencePoints >= 5)
                                    ? () => _confirmRaiseSingleSkill(context, skill, rank)
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),

                          // Total Dice Pool Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.gold.withAlpha(100)),
                            ),
                            child: Text(
                              '$pool D',
                              style: const TextStyle(
                                color: AppColors.goldBright,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Roll Button
                          IconButton(
                            icon: const Icon(Icons.casino, size: 18, color: AppColors.gold),
                            tooltip: 'Roll ${skill.label}',
                            onPressed: () {
                              diceViewModel.rollSkill(character: character, skill: skill);
                              showDialog(
                                context: context,
                                builder: (_) => DiceTrayDialog(
                                  diceViewModel: diceViewModel,
                                  playViewModel: playViewModel,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _openSessionDebriefDialog(BuildContext context) {
    final questions = [
      '1. Did you participate in the session? (Always at least 1 XP)',
      '2. Did you confront any vaesen? (+1 XP)',
      '3. Did you identify a previously unknown vaesen? (+1 XP)',
      '4. Were you affected by your dark secret? (+1 XP)',
      '5. Did you take risks to protect other people? (+1 XP)',
      '6. Have you learned anything? (+1 XP)',
      '7. Did you develop something in your headquarters? (+1 XP)',
      '8. Did you perform an extraordinary action? (+1 XP)',
    ];
    final answers = List.filled(questions.length, false);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final earned = answers.where((a) => a).length;
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.gold, width: 1.2),
            ),
            title: Row(
              children: [
                const Icon(Icons.auto_stories, color: AppColors.gold, size: 20),
                const SizedBox(width: 8),
                Text('SESSION DEBRIEF', style: AppTypography.titleMedium),
              ],
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Answer the 8 official Vaesen session questions (Chapter 2, p. 25) to tally Advancement Points earned:',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 12),
                  ...List.generate(questions.length, (i) {
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.gold,
                      checkColor: Colors.black,
                      value: answers[i],
                      title: Text(questions[i], style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                      onChanged: (val) => setState(() => answers[i] = val ?? false),
                    );
                  }),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.goldDim),
                    ),
                    child: Text(
                      'TOTAL EARNED: +$earned ADVANCEMENT POINTS',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.goldBright, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (earned > 0) {
                    playViewModel.addExperience(earned);
                  }
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Awarded +$earned XP to ${character.name}!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceOverlay,
                  foregroundColor: AppColors.goldBright,
                  side: const BorderSide(color: AppColors.gold),
                ),
                child: const Text('CLAIM XP'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmRaiseSingleSkill(BuildContext context, SkillType skill, int currentRank) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.gold, width: 1.2),
        ),
        title: Row(
          children: [
            const Icon(Icons.upgrade, color: AppColors.gold, size: 20),
            const SizedBox(width: 8),
            Text('RAISE ${skill.label.toUpperCase()}', style: AppTypography.titleMedium),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spend 5 Advancement Points to increase ${skill.label} from Rank $currentRank to Rank ${currentRank + 1}?',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border, width: 0.8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('XP Cost: 5', style: AppTypography.bodySmall.copyWith(color: AppColors.gold)),
                  Text(
                    'Remaining: ${character.experiencePoints - 5} XP',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.goldBright, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final success = await playViewModel.raiseSkill(skill, spendXp: true);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Raised ${skill.label} to Rank ${currentRank + 1}! (-5 XP)'),
                    backgroundColor: AppColors.surfaceOverlay,
                    action: SnackBarAction(
                      label: 'UNDO',
                      textColor: AppColors.goldBright,
                      onPressed: () async {
                        await playViewModel.freeAdjustSkill(skill, -1);
                        await playViewModel.addExperience(5);
                      },
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.backgroundDark,
            ),
            child: const Text('SPEND 5 XP'),
          ),
        ],
      ),
    );
  }

  void _openRaiseSkillDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.gold, width: 1.2),
        ),
        title: Row(
          children: [
            const Icon(Icons.upgrade, color: AppColors.gold, size: 20),
            const SizedBox(width: 8),
            Text('RAISE A SKILL (5 XP)', style: AppTypography.titleMedium),
          ],
        ),
        content: SizedBox(
          width: 400,
          height: 380,
          child: ListView(
            children: SkillType.values.map((s) {
              final rank = character.getSkill(s);
              final canRaise = rank < 5;
              return ListTile(
                dense: true,
                title: Text(s.label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                subtitle: Text('Current Rank: $rank / 5  (${s.attribute.label})', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                trailing: ElevatedButton(
                  onPressed: canRaise
                      ? () async {
                          final success = await playViewModel.raiseSkill(s, spendXp: true);
                          if (ctx.mounted) Navigator.of(ctx).pop();
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Raised ${s.label} to rank ${rank + 1}!')),
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceLight,
                    foregroundColor: AppColors.gold,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  child: Text(canRaise ? 'RAISE (+1)' : 'MAX (5)', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CLOSE', style: TextStyle(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  void _openLearnTalentDialog(BuildContext context) {
    final existingTalentIds = character.talents.map((t) => t.id).toSet();
    final available = TalentsData.allTalents
        .where((t) => !existingTalentIds.contains(t.id))
        .toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.gold, width: 1.2),
        ),
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.gold, size: 20),
            const SizedBox(width: 8),
            Text('LEARN NEW TALENT (5 XP)', style: AppTypography.titleMedium),
          ],
        ),
        content: SizedBox(
          width: 440,
          height: 420,
          child: available.isEmpty
              ? const Center(child: Text('All talents acquired!'))
              : ListView.separated(
                  itemCount: available.length,
                  separatorBuilder: (_, _) => const Divider(color: AppColors.border, height: 1),
                  itemBuilder: (context, i) {
                    final t = available[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(t.name, style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright, fontSize: 13)),
                                    if (t.archetypeName != null) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: AppColors.surfaceLight,
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(color: AppColors.goldDim),
                                        ),
                                        child: Text(
                                          t.archetypeName!.toUpperCase(),
                                          style: const TextStyle(fontSize: 8, color: AppColors.gold),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(t.effect, style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              final success = await playViewModel.learnTalent(t, spendXp: true);
                              if (ctx.mounted) Navigator.of(ctx).pop();
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Acquired talent: ${t.name}!')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.surfaceLight,
                              foregroundColor: AppColors.gold,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            child: const Text('LEARN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CLOSE', style: TextStyle(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }
}
