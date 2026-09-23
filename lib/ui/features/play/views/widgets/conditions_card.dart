import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/critical_injury_dialog.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/fear_test_dialog.dart';

class ConditionsCard extends StatelessWidget {
  final Character character;
  final PlayViewModel viewModel;

  const ConditionsCard({
    super.key,
    required this.character,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final activeChar = viewModel.activeCharacter ?? character;
        final cond = activeChar.conditions;

        return Column(
          children: [
            // Broken Warning Banner if Broken
            if (cond.isBroken)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.crimsonGaze,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.crimsonLight, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.lethal, size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INVESTIGATOR IS BROKEN!',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.lethal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            cond.brokenPhysical && cond.brokenMental
                                ? 'Both body and mind have collapsed. Incapacitated.'
                                : cond.brokenPhysical
                                    ? 'Physical trauma has shattered your endurance.'
                                    : 'Psychological terror has overwhelmed your sanity.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => CriticalInjuryDialog(
                          viewModel: viewModel,
                          isPhysicalDefault: cond.brokenPhysical,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.crimson,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('ROLL INJURY'),
                    ),
                  ],
                ),
              ),

            // Main Conditions Dual Card
            GothicCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'CONDITIONS',
                          style: AppTypography.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => FearTestDialog(character: activeChar, viewModel: viewModel),
                        ),
                        icon: const Icon(Icons.visibility, size: 14, color: AppColors.goldBright),
                        label: const Text('FEAR TEST'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceLight,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Physical Column
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: cond.physicalPenalty > 0
                              ? AppColors.physicalCondition
                              : AppColors.surfaceOverlay,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PHYSICAL',
                                style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.physicalCondition,
                                  fontSize: 12,
                                ),
                              ),
                              if (cond.physicalPenalty > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.physicalCondition.withAlpha(50),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-${cond.physicalPenalty} Dice',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.physicalCondition,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildConditionTile(
                            label: 'Exhausted',
                            value: cond.exhausted,
                            onChanged: (val) => viewModel.toggleCondition(exhausted: val),
                          ),
                          _buildConditionTile(
                            label: 'Battered',
                            value: cond.battered,
                            onChanged: (val) => viewModel.toggleCondition(battered: val),
                          ),
                          _buildConditionTile(
                            label: 'Wounded',
                            value: cond.wounded,
                            onChanged: (val) => viewModel.toggleCondition(wounded: val),
                          ),
                          const Divider(color: AppColors.surfaceOverlay, height: 12),
                          _buildConditionTile(
                            label: 'Broken (Phys)',
                            value: cond.brokenPhysical,
                            isBroken: true,
                            onChanged: (val) => viewModel.setBroken(isPhysical: true, broken: val ?? false),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Mental Column
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: cond.mentalPenalty > 0
                              ? AppColors.mentalCondition
                              : AppColors.surfaceOverlay,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'MENTAL',
                                style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.mentalCondition,
                                  fontSize: 12,
                                ),
                              ),
                              if (cond.mentalPenalty > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.mentalCondition.withAlpha(50),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '-${cond.mentalPenalty} Dice',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.mentalCondition,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildConditionTile(
                            label: 'Angry',
                            value: cond.angry,
                            onChanged: (val) => viewModel.toggleCondition(angry: val),
                          ),
                          _buildConditionTile(
                            label: 'Frightened',
                            value: cond.frightened,
                            onChanged: (val) => viewModel.toggleCondition(frightened: val),
                          ),
                          _buildConditionTile(
                            label: 'Hopeless',
                            value: cond.hopeless,
                            onChanged: (val) => viewModel.toggleCondition(hopeless: val),
                          ),
                          const Divider(color: AppColors.surfaceOverlay, height: 12),
                          _buildConditionTile(
                            label: 'Broken (Ment)',
                            value: cond.brokenMental,
                            isBroken: true,
                            onChanged: (val) => viewModel.setBroken(isPhysical: false, broken: val ?? false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Active Critical Injuries List (if any)
              if (activeChar.activeInjuries.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text('ACTIVE CRITICAL INJURIES', style: AppTypography.titleSmall.copyWith(fontSize: 12)),
                const SizedBox(height: 6),
                ...activeChar.activeInjuries.map((inj) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceOverlay,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: inj.injury.isLethal ? AppColors.lethal : AppColors.goldDim,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            inj.injury.isLethal ? Icons.warning : Icons.healing,
                            size: 16,
                            color: inj.injury.isLethal ? AppColors.lethal : AppColors.gold,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${inj.injury.d66}: ${inj.injury.name} ${inj.injury.isLethal ? "[LETHAL]" : ""}',
                                  style: AppTypography.titleSmall.copyWith(
                                    fontSize: 12,
                                    color: inj.injury.isLethal ? AppColors.lethal : AppColors.goldBright,
                                  ),
                                ),
                                Text(
                                  '${inj.injury.effect} • Healing: ${inj.injury.healingTime}',
                                  style: AppTypography.bodySmall.copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline, size: 18, color: AppColors.gold),
                            tooltip: 'Treat / Remove Injury',
                            onPressed: () => viewModel.removeCriticalInjury(inj.id),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
      ],
    );
      },
    );
  }

  Widget _buildConditionTile({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
    bool isBroken = false,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: isBroken ? AppColors.lethal : AppColors.gold,
                checkColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 12,
                  color: value
                      ? (isBroken ? AppColors.lethal : AppColors.goldBright)
                      : AppColors.textPrimary,
                  fontWeight: value ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
