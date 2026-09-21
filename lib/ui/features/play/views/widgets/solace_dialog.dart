import 'package:flutter/material.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class SolaceDialog extends StatelessWidget {
  final PlayViewModel viewModel;

  const SolaceDialog({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final character = viewModel.activeCharacter;
    if (character == null) return const SizedBox.shrink();

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.goldBright),
          const SizedBox(width: 8),
          Text('Draw Solace', style: AppTypography.titleLarge),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '“${character.memento}”',
            style: AppTypography.quote.copyWith(color: AppColors.goldBright),
          ),
          const SizedBox(height: 8),
          Text(
            'You hold your memento close, breathing slowly in the cold dark. The memory of what it represents steadies your trembling hands and quiets the haunting visions.',
            style: AppTypography.bodyMedium,
          ),
          const SizedBox(height: 12),
          const OrnateDivider(height: 16),
          Text(
            'Which condition would you like to soothe?',
            style: AppTypography.titleSmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await viewModel.drawSolaceFromMemento(healPhysical: true);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.favorite, color: AppColors.physicalCondition, size: 16),
                  label: const Text('PHYSICAL'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceLight,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await viewModel.drawSolaceFromMemento(healPhysical: false);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.psychology, color: AppColors.mentalCondition, size: 16),
                  label: const Text('MENTAL'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceLight,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('CANCEL', style: AppTypography.bodySmall),
        ),
      ],
    );
  }
}
