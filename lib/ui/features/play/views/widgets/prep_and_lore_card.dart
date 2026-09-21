import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class PrepAndLoreCard extends StatelessWidget {
  final Character character;
  final PlayViewModel playViewModel;

  const PrepAndLoreCard({
    super.key,
    required this.character,
    required this.playViewModel,
  });

  @override
  Widget build(BuildContext context) {
    final activeAdv = character.activeAdvantage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. MYSTERY PREPARATIONS & ADVANTAGE CARD ────────────────────────
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
                        const Icon(Icons.bookmark_added_outlined, color: AppColors.gold, size: 18),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'MYSTERY PREPARATION & ADVANTAGES',
                            style: AppTypography.titleMedium.copyWith(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (activeAdv == null) ...[
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _openPreparationModal(context),
                      icon: const Icon(Icons.add, size: 13, color: AppColors.goldBright),
                      label: const Text('PREPARE', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold)),
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
                ],
              ),
              const SizedBox(height: 10),

              if (activeAdv != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.goldBright, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withAlpha(30),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
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
                                const Icon(Icons.verified, color: AppColors.goldBright, size: 18),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'ACTIVE ADVANTAGE (+2 DICE)',
                                    style: AppTypography.titleSmall.copyWith(
                                      color: AppColors.goldBright,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                            tooltip: 'Dismiss Advantage',
                            onPressed: () => playViewModel.spendAdvantage(activeAdv.id),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activeAdv.title,
                        style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeAdv.effect,
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await playViewModel.spendAdvantage(activeAdv.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Advantage spent for +2 dice!')),
                                  );
                                }
                              },
                              icon: const Icon(Icons.check, size: 14),
                              label: const Text('SPEND ADVANTAGE (+2 DICE)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.surfaceOverlay,
                                foregroundColor: AppColors.goldBright,
                                side: const BorderSide(color: AppColors.gold),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border, width: 0.8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: AppColors.goldDim),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No active Advantage. Before departing for a mystery, prepare at Castle Gyllencreutz or Upsala to gain +2 dice on a key test.',
                          style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── 2. NARRATIVE DOSSIER CARD ───────────────────────────────────────
        GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book, color: AppColors.gold, size: 18),
                  const SizedBox(width: 8),
                  Text('INVESTIGATOR DOSSIER', style: AppTypography.titleMedium),
                ],
              ),
              const SizedBox(height: 12),

              _buildLoreField('MOTIVATION', character.motivation.isNotEmpty ? character.motivation : 'Driven by secrets of the unseen world.'),
              const SizedBox(height: 10),
              _buildLoreField('TRAUMA & THE SIGHT', character.trauma.isNotEmpty ? character.trauma : 'Awakened to the Mythic North through near-fatal terror.'),
              const SizedBox(height: 10),
              _buildLoreField('DARK SECRET', character.darkSecret.isNotEmpty ? character.darkSecret : 'A burden kept hidden from the Society.'),
              const SizedBox(height: 10),

              // Personal Memento
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.goldDim, width: 0.8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.card_giftcard, color: AppColors.gold, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('PERSONAL MEMENTO', style: AppTypography.labelSmall.copyWith(color: AppColors.goldDim, fontSize: 9)),
                          Text(
                            character.memento.isNotEmpty ? character.memento : 'An antique token of comfort',
                            style: AppTypography.bodyMedium.copyWith(fontSize: 12, color: AppColors.goldBright),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: !character.isMementoUsed
                          ? () async {
                              final healed = await playViewModel.drawSolaceFromMemento(healPhysical: false);
                              if (context.mounted && healed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Drew solace from memento! 1 condition healed.')),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceOverlay,
                        foregroundColor: AppColors.gold,
                        disabledBackgroundColor: AppColors.surface,
                        disabledForegroundColor: AppColors.textMuted,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      ),
                      child: Text(
                        character.isMementoUsed ? 'SOLACE USED' : 'DRAW SOLACE',
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              if (character.notes.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildLoreField('FIELD NOTES', character.notes),
              ],
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── 3. TALENTS & SPECIAL ABILITIES ──────────────────────────────────
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
                        const Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'TALENTS & ABILITIES',
                            style: AppTypography.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${character.talents.length} TALENTS',
                    style: AppTypography.labelSmall.copyWith(color: AppColors.goldDim),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (character.talents.isEmpty)
                Text('No talents acquired yet.', style: AppTypography.bodySmall)
              else
                ...character.talents.map((t) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.goldDim, width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                t.name,
                                style: AppTypography.titleSmall.copyWith(
                                  fontSize: 13,
                                  color: AppColors.goldBright,
                                ),
                              ),
                              if (t.archetypeName != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withAlpha(30),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    t.archetypeName!.toUpperCase(),
                                    style: AppTypography.labelSmall.copyWith(
                                      fontSize: 9,
                                      color: AppColors.gold,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t.effect,
                            style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoreField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.goldDim,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(fontSize: 12, height: 1.3),
        ),
      ],
    );
  }

  void _openPreparationModal(BuildContext context) {
    final preps = [
      {
        'title': 'Grand Library Archival Research',
        'effect': '+2 dice to Learning or Investigation test when deciphering folklore, ruins, or texts.',
        'skill': SkillType.investigation,
      },
      {
        'title': 'Shooting Range Practice',
        'effect': '+2 dice to Ranged Combat test during a firefight or ambush.',
        'skill': SkillType.rangedCombat,
      },
      {
        'title': 'Fencing Drills & Conditioning',
        'effect': '+2 dice to Close Combat or Agility test in melee.',
        'skill': SkillType.closeCombat,
      },
      {
        'title': 'Consult Upsala Contacts & Academics',
        'effect': '+2 dice to Manipulation or Observation test when questioning witnesses.',
        'skill': SkillType.manipulation,
      },
      {
        'title': 'Medical Preparation & Antidote Prep',
        'effect': '+2 dice to Medicine test when stabilizing a lethal Critical Injury.',
        'skill': SkillType.medicine,
      },
      {
        'title': 'Cathedral Prayer & Holy Communion',
        'effect': '+2 dice to a Fear & Horror test when confronting a supernatural apparition.',
        'skill': null,
      },
    ];

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
            const Icon(Icons.bookmark_added, color: AppColors.gold, size: 20),
            const SizedBox(width: 8),
            Text('CHOOSE PREPARATION', style: AppTypography.titleMedium),
          ],
        ),
        content: SizedBox(
          width: 440,
          height: 380,
          child: ListView.separated(
            itemCount: preps.length,
            separatorBuilder: (_, _) => const Divider(color: AppColors.border, height: 1),
            itemBuilder: (context, i) {
              final p = preps[i];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['title'] as String, style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text(p['effect'] as String, style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        playViewModel.makePreparation(
                          title: p['title'] as String,
                          effect: p['effect'] as String,
                          targetSkill: p['skill'] as SkillType?,
                        );
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Prepared: ${p["title"]} (+2 Advantage active)!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceLight,
                        foregroundColor: AppColors.gold,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      ),
                      child: const Text('SELECT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
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
