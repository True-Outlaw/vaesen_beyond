import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/d6_dice_widget.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class DiceTrayDialog extends StatefulWidget {
  final DiceRollerViewModel diceViewModel;
  final PlayViewModel playViewModel;

  const DiceTrayDialog({
    super.key,
    required this.diceViewModel,
    required this.playViewModel,
  });

  @override
  State<DiceTrayDialog> createState() => _DiceTrayDialogState();
}

class _DiceTrayDialogState extends State<DiceTrayDialog> {
  int _situationalModifier = 0;
  bool _useAdvantage = false;
  bool _isChoosingPushCondition = false;
  late int _basePool;
  late String _rollTitle;

  @override
  void initState() {
    super.initState();
    final roll = widget.diceViewModel.currentRoll;
    final character = widget.playViewModel.activeCharacter;
    _basePool = roll?.dice.length ?? character?.getAttribute(AttributeType.logic) ?? 4;
    _rollTitle = roll?.title ?? 'TABLETOP DICE ROLL';

    // Auto-select advantage if the character has an active preparation advantage
    if (character?.hasActiveAdvantage == true) {
      _useAdvantage = true;
    }
  }

  int get totalModifier => _situationalModifier + (_useAdvantage ? 2 : 0);
  int get targetPool => (_basePool + totalModifier).clamp(1, 35);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.diceViewModel,
      builder: (context, _) {
        final roll = widget.diceViewModel.currentRoll;
        final character = widget.playViewModel.activeCharacter;
        final hasActivePrep = character?.hasActiveAdvantage ?? false;

        final successes = roll?.successes ?? 0;
        final isSuccess = roll?.isSuccess ?? false;
        final stunts = roll?.stunts ?? 0;

        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: isSuccess ? AppColors.gold : AppColors.surfaceOverlay,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Top Header ───────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.casino, color: AppColors.gold, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                roll != null ? roll.title.toUpperCase() : _rollTitle.toUpperCase(),
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.goldBright,
                                  fontSize: 13.5,
                                  letterSpacing: 1.1,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: AppColors.textMuted),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  if (roll != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 6),
                      child: Text(
                        roll.breakdown,
                        style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 4),

                  // ── Outcome Banner ───────────────────────────────────────
                  if (roll != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSuccess
                            ? AppColors.gold.withAlpha(35)
                            : AppColors.crimson.withAlpha(35),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSuccess ? AppColors.goldBright : AppColors.crimsonLight,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSuccess ? Icons.stars : Icons.cancel_outlined,
                            color: isSuccess ? AppColors.goldBright : AppColors.crimsonLight,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              isSuccess
                                  ? (stunts > 0
                                      ? '$successes SUCCESSES ($stunts STUNT${stunts > 1 ? "S" : ""})'
                                      : '1 SUCCESS!')
                                  : 'FAILURE (0 SIXES)',
                              style: AppTypography.titleMedium.copyWith(
                                color: isSuccess ? AppColors.goldBright : AppColors.crimsonLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 10),

                  // ── Dice Tray Pit ─────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 80, maxHeight: 180),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.surfaceOverlay),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: (roll == null || roll.dice.isEmpty)
                        ? const Center(
                            child: Text(
                              'Configure pool & tap ROLL below',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: roll.dice.map((d) {
                                return D6DiceWidget(value: d, isPushed: roll.isPushed);
                              }).toList(),
                            ),
                          ),
                  ),

                  const SizedBox(height: 12),

                  // ── Situational Modifiers & Advantage Bar ────────────────
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _modifierChip('+1 Help', 1),
                      _modifierChip('+2 Setup', 2),
                      _modifierChip('-1 Dim', -1),
                      _modifierChip('-2 Dire', -2),
                      // Advantage toggle (+2 dice)
                      FilterChip(
                        avatar: Icon(
                          Icons.verified,
                          size: 14,
                          color: _useAdvantage ? Colors.black : AppColors.goldBright,
                        ),
                        label: Text(
                          hasActivePrep ? '+2 ADVANTAGE (PREP)' : '+2 ADVANTAGE',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                            color: _useAdvantage ? Colors.black : AppColors.goldBright,
                          ),
                        ),
                        selected: _useAdvantage,
                        selectedColor: AppColors.gold,
                        backgroundColor: hasActivePrep ? AppColors.gold.withAlpha(35) : AppColors.surfaceLight,
                        side: BorderSide(
                          color: _useAdvantage
                              ? AppColors.goldBright
                              : (hasActivePrep ? AppColors.gold : AppColors.border),
                          width: 1.0,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        onSelected: (selected) {
                          setState(() {
                            _useAdvantage = selected;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ── Unified Modifier Display & Stepper ────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: totalModifier != 0 ? AppColors.gold.withAlpha(150) : AppColors.surfaceOverlay,
                        width: 0.8,
                      ),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'MODIFIER: ',
                              style: TextStyle(color: AppColors.textMuted, fontSize: 10.5, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, size: 18, color: AppColors.goldDim),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                              onPressed: () => setState(() => _situationalModifier--),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: totalModifier != 0 ? AppColors.gold.withAlpha(30) : AppColors.background,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: totalModifier != 0 ? AppColors.goldBright : AppColors.goldDim,
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                totalModifier >= 0 ? '+$totalModifier' : '$totalModifier',
                                style: TextStyle(
                                  color: totalModifier != 0 ? AppColors.goldBright : AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, size: 18, color: AppColors.goldDim),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                              onPressed: () => setState(() => _situationalModifier++),
                            ),
                          ],
                        ),
                        if (_useAdvantage)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withAlpha(25),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.gold, width: 0.6),
                            ),
                            child: const Text(
                              '+2 Adv Included',
                              style: TextStyle(color: AppColors.goldBright, fontSize: 9.5, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ── Roll / Re-Roll Button with Dynamic Pool Preview ────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _executeRoll(character),
                      icon: const Icon(Icons.casino, size: 16),
                      label: Text(
                        roll == null
                            ? 'ROLL $targetPool DICE'
                            : (roll.dice.length == targetPool && totalModifier == 0
                                ? 'RE-ROLL ($targetPool DICE)'
                                : 'ROLL $targetPool DICE WITH MODIFIERS ($_basePool Base${totalModifier != 0 ? (totalModifier > 0 ? " + $totalModifier" : " - ${totalModifier.abs()}") : ""})'),
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: totalModifier != 0 ? AppColors.gold.withAlpha(45) : AppColors.surfaceOverlay,
                        foregroundColor: AppColors.goldBright,
                        side: BorderSide(
                          color: totalModifier != 0 ? AppColors.goldBright : AppColors.gold,
                          width: 1.2,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const OrnateDivider(height: 6),
                  const SizedBox(height: 6),

                  // ── Push Roll & Condition Selection ──────────────────────
                  if (roll != null && !roll.isPushed) ...[
                    if (!_isChoosingPushCondition)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => setState(() => _isChoosingPushCondition = true),
                          icon: const Icon(Icons.replay, color: AppColors.crimsonLight, size: 15),
                          label: const Text('PUSH THE ROLL (+1 Condition)', style: TextStyle(fontSize: 11)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceLight,
                            foregroundColor: AppColors.crimsonLight,
                            side: const BorderSide(color: AppColors.crimsonLight),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.crimson.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.crimsonLight, width: 0.8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'CHOOSE CONDITION TO SUFFER:',
                                  style: TextStyle(color: AppColors.crimsonLight, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 14, color: AppColors.textMuted),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                  onPressed: () => setState(() => _isChoosingPushCondition = false),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Physical Conditions
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              alignment: WrapAlignment.center,
                              children: [
                                _pushConditionChip('Exhausted', character?.conditions.exhausted ?? false, isPhysical: true),
                                _pushConditionChip('Battered', character?.conditions.battered ?? false, isPhysical: true),
                                _pushConditionChip('Wounded', character?.conditions.wounded ?? false, isPhysical: true),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Mental Conditions
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              alignment: WrapAlignment.center,
                              children: [
                                _pushConditionChip('Angry', character?.conditions.angry ?? false, isPhysical: false),
                                _pushConditionChip('Frightened', character?.conditions.frightened ?? false, isPhysical: false),
                                _pushConditionChip('Hopeless', character?.conditions.hopeless ?? false, isPhysical: false),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ] else if (roll != null && roll.isPushed) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'ROLL PUSHED • Suffered ${roll.pushCondition ?? "Trauma"}',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _modifierChip(String label, int val) {
    final isSelected = _situationalModifier == val;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 9.5, color: isSelected ? Colors.black : AppColors.textPrimary)),
      selected: isSelected,
      selectedColor: AppColors.gold,
      backgroundColor: AppColors.surfaceLight,
      side: BorderSide(color: isSelected ? AppColors.gold : AppColors.border, width: 0.6),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      onSelected: (sel) {
        setState(() {
          _situationalModifier = sel ? val : 0;
        });
      },
    );
  }

  Widget _pushConditionChip(String name, bool isAlreadySuffered, {required bool isPhysical}) {
    return InkWell(
      onTap: isAlreadySuffered ? null : () => _executePushWithCondition(name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isAlreadySuffered ? AppColors.surfaceOverlay : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isAlreadySuffered ? AppColors.border : (isPhysical ? AppColors.physicalCondition : AppColors.mentalCondition),
            width: 0.8,
          ),
        ),
        child: Text(
          isAlreadySuffered ? '$name (Taken)' : name,
          style: TextStyle(
            fontSize: 9.5,
            color: isAlreadySuffered
                ? AppColors.textMuted
                : (isPhysical ? AppColors.physicalCondition : AppColors.mentalCondition),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _executeRoll(dynamic character) {
    if (character == null) return;

    // Spend active advantage if checked and present
    if (_useAdvantage) {
      final activeAdv = character.activeAdvantage;
      if (activeAdv != null) {
        widget.playViewModel.spendAdvantage(activeAdv.id);
      }
    }

    final pool = targetPool;
    final breakdownParts = <String>['Base ($_basePool)'];
    if (_situationalModifier != 0) {
      breakdownParts.add(_situationalModifier > 0 ? 'Mod (+$_situationalModifier)' : 'Mod ($_situationalModifier)');
    }
    if (_useAdvantage) {
      breakdownParts.add('Advantage (+2)');
    }
    final breakdownStr = '${breakdownParts.join(" + ")} = $pool dice';

    widget.diceViewModel.rollCustomPool(
      poolSize: pool,
      title: _rollTitle,
      breakdown: breakdownStr,
    );

    setState(() {
      _isChoosingPushCondition = false;
    });
  }

  void _executePushWithCondition(String conditionName) {
    switch (conditionName.toLowerCase()) {
      case 'exhausted':
        widget.playViewModel.toggleCondition(exhausted: true);
        break;
      case 'battered':
        widget.playViewModel.toggleCondition(battered: true);
        break;
      case 'wounded':
        widget.playViewModel.toggleCondition(wounded: true);
        break;
      case 'angry':
        widget.playViewModel.toggleCondition(angry: true);
        break;
      case 'frightened':
        widget.playViewModel.toggleCondition(frightened: true);
        break;
      case 'hopeless':
        widget.playViewModel.toggleCondition(hopeless: true);
        break;
    }

    widget.diceViewModel.pushRoll(conditionSuffered: conditionName);
    setState(() {
      _isChoosingPushCondition = false;
    });
  }
}
