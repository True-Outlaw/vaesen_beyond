import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_portrait.dart';

class DossierCompactHeader extends StatelessWidget {
  final Character character;

  const DossierCompactHeader({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          GothicPortrait(
            portraitAsset: character.effectivePortraitAsset,
            width: 44,
            height: 44,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(120),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            fallbackInitial: character.name,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  character.name,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.goldBright,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.gold.withAlpha(60), width: 0.6),
                      ),
                      child: Text(
                        character.archetypeName.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.gold,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AGE ${character.actualAge}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _financePill('RES', character.resources),
              const SizedBox(width: 6),
              _financePill('CAP', character.capital),
            ],
          ),
        ],
      ),
    );
  }

  Widget _financePill(String label, int val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.goldDim, width: 0.8),
      ),
      child: Text(
        '$label: $val',
        style: AppTypography.titleSmall.copyWith(
          fontSize: 10,
          color: AppColors.gold,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
