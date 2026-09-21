import 'package:flutter/material.dart';
import 'package:vaesen_beyond/data/seed/injuries_data.dart';
import 'package:vaesen_beyond/domain/models/critical_injury.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class CriticalInjuryDialog extends StatefulWidget {
  final PlayViewModel viewModel;
  final bool isPhysicalDefault;

  const CriticalInjuryDialog({
    super.key,
    required this.viewModel,
    this.isPhysicalDefault = true,
  });

  @override
  State<CriticalInjuryDialog> createState() => _CriticalInjuryDialogState();
}

class _CriticalInjuryDialogState extends State<CriticalInjuryDialog> {
  late bool _isPhysical;
  CriticalInjury? _currentInjury;

  @override
  void initState() {
    super.initState();
    _isPhysical = widget.isPhysicalDefault;
    _rollRandom();
  }

  void _rollRandom() {
    final roll = widget.viewModel.diceEngine.rollD66();
    setState(() {
      _currentInjury = InjuriesData.getInjury(roll, _isPhysical);
    });
  }

  @override
  Widget build(BuildContext context) {
    final inj = _currentInjury;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.lethal, width: 1.5),
      ),
      title: Row(
        children: [
          const Icon(Icons.healing, color: AppColors.lethal),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'CRITICAL INJURY TABLE',
              style: AppTypography.titleLarge.copyWith(color: AppColors.lethal),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20, color: AppColors.textMuted),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Toggle
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('PHYSICAL INJURY'),
                    selected: _isPhysical,
                    selectedColor: AppColors.physicalCondition,
                    labelStyle: TextStyle(
                      color: _isPhysical ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      setState(() {
                        _isPhysical = true;
                        _rollRandom();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('MENTAL INJURY'),
                    selected: !_isPhysical,
                    selectedColor: AppColors.mentalCondition,
                    labelStyle: TextStyle(
                      color: !_isPhysical ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      setState(() {
                        _isPhysical = false;
                        _rollRandom();
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (inj != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: inj.isLethal ? AppColors.lethal : AppColors.goldDim,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'ROLL: ${inj.d66}',
                            style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright),
                          ),
                        ),
                        if (inj.isLethal)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.lethal,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'LETHAL',
                              style: AppTypography.titleSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      inj.name,
                      style: AppTypography.titleLarge.copyWith(
                        fontSize: 18,
                        color: inj.isLethal ? AppColors.lethal : AppColors.goldBright,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      inj.effect,
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    const OrnateDivider(height: 8),
                    const SizedBox(height: 6),
                    _detailRow('Time Limit to Save', inj.timeLimit),
                    _detailRow('Treatment Skill', inj.treatmentSkill.label),
                    _detailRow('Healing Time', inj.healingTime),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _rollRandom,
                    icon: const Icon(Icons.casino, size: 16),
                    label: const Text('RE-ROLL D66'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentInjury != null) {
                        widget.viewModel.addCriticalInjury(_currentInjury!);
                      }
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.crimson,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('APPLY INJURY'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.goldBright,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
