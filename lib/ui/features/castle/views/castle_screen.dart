import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class CastleScreen extends StatelessWidget {
  final PlayViewModel viewModel;

  const CastleScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final castle = viewModel.castle;

        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              GothicCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            castle.name.toUpperCase(),
                            style: AppTypography.displayMedium.copyWith(
                              fontSize: 18,
                              color: AppColors.goldBright,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Dev points stepper
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.goldBright),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () => viewModel.adjustDevelopmentPoints(-1),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Text('-',
                                          style: TextStyle(
                                            color: AppColors.goldBright,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      '${castle.developmentPoints}',
                                      style: AppTypography.titleSmall.copyWith(
                                        fontSize: 14,
                                        color: AppColors.goldBright,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => viewModel.adjustDevelopmentPoints(1),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Text('+',
                                          style: TextStyle(
                                            color: AppColors.goldBright,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'DEV PTS',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.gold,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'The ancient Gothic fortress of the Society in Upsala. Here, investigators consult dusty archives, recover from traumatic injuries, and plan expeditions across the Scandinavian provinces.',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text('FACILITIES & UPGRADES', style: AppTypography.titleMedium),
              const SizedBox(height: 8),

              ...castle.facilities.map((fac) {
                final canAfford = castle.developmentPoints >= fac.devCost;
                final canToggle = fac.isBuilt || canAfford;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: GothicCard(
                    padding: const EdgeInsets.all(12),
                    borderColor: fac.isBuilt ? AppColors.goldDim : AppColors.surfaceOverlay,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          fac.isBuilt ? Icons.domain_verification : Icons.domain,
                          color: fac.isBuilt ? AppColors.goldBright : AppColors.textMuted,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    fac.name,
                                    style: AppTypography.titleSmall.copyWith(
                                      color: fac.isBuilt ? AppColors.goldBright : AppColors.textPrimary,
                                    ),
                                  ),
                                  if (!fac.isBuilt && !canAfford)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.crimsonDark,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: AppColors.crimsonLight, width: 0.8),
                                      ),
                                      child: Text(
                                        'NEEDS ${fac.devCost} PTS',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: AppColors.crimsonBright,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  else
                                    Text(
                                      fac.isBuilt ? 'BUILT' : 'COST: ${fac.devCost} PTS',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: fac.isBuilt ? AppColors.gold : AppColors.textMuted,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(fac.description, style: AppTypography.bodySmall),
                              const SizedBox(height: 4),
                              Text(
                                'Benefit: ${fac.benefit}',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.goldDim,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: fac.isBuilt,
                          activeThumbColor: AppColors.goldBright,
                          activeTrackColor: AppColors.surfaceLight,
                          inactiveThumbColor: canAfford ? null : AppColors.textMuted,
                          onChanged: canToggle
                              ? (_) async {
                                  final success = await viewModel.toggleFacility(fac.id);
                                  if (!success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Not enough Development Points to build this facility.'),
                                        backgroundColor: AppColors.crimsonDark,
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),
              Text('HIRED STAFF ROSTER', style: AppTypography.titleMedium),
              const SizedBox(height: 8),

              ...castle.staff.map((st) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: GothicCard(
                    padding: const EdgeInsets.all(12),
                    borderColor: st.isHired ? AppColors.goldDim : AppColors.surfaceOverlay,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_pin,
                          color: st.isHired ? AppColors.goldBright : AppColors.textMuted,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      st.name,
                                      style: AppTypography.titleSmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    st.role.toUpperCase(),
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.gold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Text(st.benefit, style: AppTypography.bodySmall),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Switch(
                          value: st.isHired,
                          activeThumbColor: AppColors.goldBright,
                          activeTrackColor: AppColors.surfaceLight,
                          onChanged: (_) => viewModel.toggleStaff(st.id),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 16),
              Text('MYSTERY EXPEDITION LOGS', style: AppTypography.titleMedium),
              const SizedBox(height: 8),

              ...castle.mysteryLogs.map((log) {
                return GothicCard(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(log.title, style: AppTypography.titleSmall),
                          Text(log.date, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(log.summary, style: AppTypography.bodyMedium),
                      const OrnateDivider(height: 12),
                      Text(
                        '+${log.xpAwarded} Experience Points awarded to participating investigators',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.gold),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
