import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/d6_dice_widget.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class FearTestDialog extends StatefulWidget {
  final Character character;
  final PlayViewModel viewModel;

  const FearTestDialog({
    super.key,
    required this.character,
    required this.viewModel,
  });

  @override
  State<FearTestDialog> createState() => _FearTestDialogState();
}

class _FearTestDialogState extends State<FearTestDialog> {
  final DiceRollerViewModel _diceVm = DiceRollerViewModel();
  AttributeType _chosenAttr = AttributeType.logic;
  int _fearValue = 1;
  int _companionsCount = 1;
  bool _conditionsApplied = false;

  @override
  Widget build(BuildContext context) {
    final char = widget.character;
    final mentalPenalty = char.conditions.mentalPenalty;
    final attrVal = char.getAttribute(_chosenAttr);
    final totalPool = (attrVal + _companionsCount - mentalPenalty).clamp(1, 30);

    return ListenableBuilder(
      listenable: _diceVm,
      builder: (context, _) {
        final result = _diceVm.fearResult;

        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.crimsonLight, width: 1.5),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.visibility, color: AppColors.crimsonLight),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'FEAR TEST',
                          style: AppTypography.titleLarge.copyWith(color: AppColors.crimsonLight),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: AppColors.textMuted),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  Text(
                    'You come face-to-face with an uncanny horror from Scandinavian folklore.',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 12),

                  if (result == null) ...[
                    // Attribute Choice
                    Text('CHOOSE RESISTANCE ATTRIBUTE', style: AppTypography.titleSmall.copyWith(fontSize: 11)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Text('LOGIC (${char.getAttribute(AttributeType.logic)})'),
                            selected: _chosenAttr == AttributeType.logic,
                            selectedColor: AppColors.goldBright,
                            labelStyle: TextStyle(
                              color: _chosenAttr == AttributeType.logic ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (_) => setState(() => _chosenAttr = AttributeType.logic),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: Text('EMPATHY (${char.getAttribute(AttributeType.empathy)})'),
                            selected: _chosenAttr == AttributeType.empathy,
                            selectedColor: AppColors.goldBright,
                            labelStyle: TextStyle(
                              color: _chosenAttr == AttributeType.empathy ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            onSelected: (_) => setState(() => _chosenAttr = AttributeType.empathy),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Fear Value Picker
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text('Creature Fear Value:', style: AppTypography.bodyMedium),
                        ),
                        const SizedBox(width: 8),
                        Wrap(
                          spacing: 4,
                          children: [1, 2, 3].map((fv) {
                            return ChoiceChip(
                              label: Text('Fear $fv'),
                              selected: _fearValue == fv,
                              selectedColor: AppColors.crimson,
                              labelStyle: TextStyle(
                                color: _fearValue == fv ? Colors.white : AppColors.textPrimary,
                              ),
                              onSelected: (_) => setState(() => _fearValue = fv),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Companions in zone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Allies in zone (+1 die, max +3):', style: AppTypography.bodyMedium),
                        DropdownButton<int>(
                          value: _companionsCount,
                          dropdownColor: AppColors.surfaceLight,
                          items: [0, 1, 2, 3].map((n) {
                            return DropdownMenuItem(
                              value: n,
                              child: Text('+$n dice', style: AppTypography.titleSmall),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _companionsCount = val ?? 0),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const OrnateDivider(height: 12),
                    const SizedBox(height: 6),

                    Center(
                      child: Text(
                        'Total Dice Pool: $totalPool d6',
                        style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright),
                      ),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _diceVm.executeFearTest(
                            character: char,
                            fearValue: _fearValue,
                            attribute: _chosenAttr,
                            companionsCount: _companionsCount,
                          );
                        },
                        icon: const Icon(Icons.casino, color: Colors.white),
                        label: const Text('ROLL FEAR TEST'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.crimson,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Fear Result View
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: result.passed
                            ? AppColors.gold.withAlpha(40)
                            : AppColors.crimson.withAlpha(50),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: result.passed ? AppColors.goldBright : AppColors.crimsonLight,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            result.passed ? Icons.shield : Icons.psychology_alt,
                            size: 32,
                            color: result.passed ? AppColors.goldBright : AppColors.crimsonLight,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            result.passed ? 'STEADY NERVES: PASSED!' : 'TERRIFIED!',
                            style: AppTypography.titleMedium.copyWith(
                              color: result.passed ? AppColors.goldBright : AppColors.crimsonLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            result.panickedAction,
                            style: AppTypography.quote.copyWith(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          if (!result.passed) ...[
                            const SizedBox(height: 8),
                            Text(
                              '• Panicked Duration: ${result.panickedRounds} rounds\n• Suffers ${result.conditionsSuffered} Mental Condition(s)',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.lethal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Rolled Dice
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: result.rollResult.dice.map((d) {
                        return D6DiceWidget(value: d, size: 40);
                      }).toList(),
                    ),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _diceVm.clearRoll();
                          setState(() => _conditionsApplied = false);
                        },
                        child: const Text('ROLL AGAIN'),
                      ),
                    ),

                    if (!result.passed) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _conditionsApplied
                              ? null
                              : () async {
                                  await widget.viewModel.applyFearConditions(
                                    result.conditionsSuffered,
                                  );
                                  setState(() => _conditionsApplied = true);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${result.conditionsSuffered} mental condition(s) applied.',
                                        ),
                                        backgroundColor: AppColors.crimsonDark,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                          icon: Icon(
                            _conditionsApplied ? Icons.check_circle : Icons.psychology_alt,
                            size: 16,
                            color: _conditionsApplied ? AppColors.textMuted : Colors.white,
                          ),
                          label: Text(
                            _conditionsApplied
                                ? 'CONDITIONS APPLIED'
                                : 'APPLY ${result.conditionsSuffered} MENTAL CONDITION(S)',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _conditionsApplied
                                ? AppColors.surfaceLight
                                : AppColors.crimsonDark,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
