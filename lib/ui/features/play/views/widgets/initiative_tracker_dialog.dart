import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaesen_beyond/domain/models/initiative_combatant.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_button.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_portrait.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/initiative_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

/// Tactile 1–10 card slot tracker for Vaesen combat turns.
/// In Vaesen rules, 10 physical cards numbered 1–10 are dealt to combatants.
/// Lowest number acts first. Cards can be swapped between allies or through fast reflexes.
class InitiativeTrackerDialog extends StatefulWidget {
  const InitiativeTrackerDialog({super.key});

  @override
  State<InitiativeTrackerDialog> createState() => _InitiativeTrackerDialogState();
}

class _InitiativeTrackerDialogState extends State<InitiativeTrackerDialog> {
  final TextEditingController _adversaryNameController = TextEditingController();

  static const _romanNumerals = [
    'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'
  ];

  @override
  void dispose() {
    _adversaryNameController.dispose();
    super.dispose();
  }

  void _showAddAdversaryDialog(BuildContext context, InitiativeViewModel initVm) {
    _adversaryNameController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.crimson, width: 1.5),
        ),
        title: Row(
          children: [
            const Icon(Icons.dangerous, color: AppColors.crimson, size: 22),
            const SizedBox(width: 8),
            Text('ADD ADVERSARY', style: AppTypography.titleMedium.copyWith(color: AppColors.crimsonLight)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the name of the beast, creature, or foe entering combat:',
              style: AppTypography.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _adversaryNameController,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'e.g., Church Grim, Highwayman, Troll',
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  initVm.addAdversary(val.trim());
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.goldDim)),
          ),
          GothicButton(
            label: 'DEAL CARD',
            icon: Icons.add_circle_outline,
            color: AppColors.crimson,
            onPressed: () {
              final name = _adversaryNameController.text.trim();
              initVm.addAdversary(name.isEmpty ? 'Adversary' : name);
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initVm = context.watch<InitiativeViewModel>();
    final playVm = context.watch<PlayViewModel>();

    // Auto-populate if combatants empty
    if (initVm.combatants.isEmpty && playVm.characters.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && initVm.combatants.isEmpty) {
          initVm.initializeFromParty(playVm.characters);
        }
      });
    }

    final turnOrder = initVm.turnOrder;
    final swappingId = initVm.selectedCombatantIdForSwap;

    return Dialog(
      backgroundColor: AppColors.backgroundDark,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.gold, width: 1.5),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Title & Round Counter
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withAlpha(40),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldBright, width: 1.2),
                  ),
                  child: const Icon(Icons.style, color: AppColors.goldBright, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INITIATIVE CARD RACK',
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 17,
                          color: AppColors.goldBright,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Vaesen Combat Turn Order • Lowest Card Acts First',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.goldDim,
                        ),
                      ),
                    ],
                  ),
                ),
                // Round Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF241C10),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.goldBright, width: 1.0),
                  ),
                  child: Text(
                    'ROUND ${initVm.round}',
                    style: AppTypography.statValue.copyWith(
                      fontSize: 12,
                      color: AppColors.goldBright,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.goldDim, size: 20),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Close Tracker',
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 8),

            // Card Swap Notice Banner (if swap active)
            if (swappingId != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.gold.withAlpha(35),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.goldBright, width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz, color: AppColors.goldBright, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'SELECT ANOTHER COMBATANT TO SWAP CARDS',
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 11,
                          color: AppColors.goldBright,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => initVm.selectCombatantForSwap(swappingId),
                      child: const Text('CANCEL', style: TextStyle(color: AppColors.goldDim, fontSize: 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Action Toolbar (Draw, Next Round, Add Adversary)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gold,
                      side: const BorderSide(color: AppColors.goldDim, width: 0.8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.shuffle, size: 15),
                    label: const Text('RE-DEAL (1–10)', style: TextStyle(fontSize: 11)),
                    onPressed: () => initVm.drawInitiative(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.crimsonLight,
                      side: const BorderSide(color: AppColors.crimson, width: 0.8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.person_add, size: 15),
                    label: const Text('+ ADVERSARY', style: TextStyle(fontSize: 11)),
                    onPressed: initVm.combatants.length >= 10
                        ? null
                        : () => _showAddAdversaryDialog(context, initVm),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Card Slots List
            Expanded(
              child: turnOrder.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.style_outlined, size: 48, color: AppColors.goldDim),
                          const SizedBox(height: 8),
                          Text('No combatants in initiative rack.', style: AppTypography.bodySmall),
                          const SizedBox(height: 12),
                          GothicButton(
                            label: 'DEAL PARTY CARDS',
                            icon: Icons.play_arrow,
                            onPressed: () => initVm.initializeFromParty(playVm.characters),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: turnOrder.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final combatant = turnOrder[index];
                        final isCurrentTurn = combatant.cardNumber == initVm.currentTurnCard;
                        final isSelectedForSwap = combatant.id == swappingId;
                        return _buildTactileInitiativeCard(
                          context,
                          combatant,
                          initVm,
                          isCurrentTurn,
                          isSelectedForSwap,
                        );
                      },
                    ),
            ),

            const SizedBox(height: 8),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 10),

            // Footer Controls: Advance Turn / Next Round
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: GothicButton(
                    label: 'ADVANCE TURN',
                    icon: Icons.fast_forward,
                    color: AppColors.gold,
                    onPressed: () => initVm.advanceTurn(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.goldBright,
                      side: const BorderSide(color: AppColors.gold, width: 1.2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text(
                      'NEXT ROUND',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    onPressed: () => initVm.nextRound(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTactileInitiativeCard(
    BuildContext context,
    InitiativeCombatant combatant,
    InitiativeViewModel initVm,
    bool isCurrentTurn,
    bool isSelectedForSwap,
  ) {
    final roman = (combatant.cardNumber >= 1 && combatant.cardNumber <= 10)
        ? _romanNumerals[combatant.cardNumber - 1]
        : '${combatant.cardNumber}';

    final isActed = combatant.hasActed;
    final isAdversary = !combatant.isInvestigator;

    // Card background & border based on state
    Color cardBorder = isAdversary
        ? AppColors.crimson.withAlpha(160)
        : AppColors.goldDim.withAlpha(120);

    Color cardBackground = isAdversary
        ? const Color(0xFF1E1111)
        : const Color(0xFF171717);

    if (isCurrentTurn) {
      cardBorder = AppColors.goldBright;
      cardBackground = const Color(0xFF2A2312);
    }

    if (isSelectedForSwap) {
      cardBorder = const Color(0xFF00E5FF);
      cardBackground = const Color(0xFF0F262E);
    } else if (isActed) {
      cardBackground = const Color(0xFF101010);
      cardBorder = AppColors.border.withAlpha(80);
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder, width: (isCurrentTurn || isSelectedForSwap) ? 2.0 : 1.0),
        boxShadow: isCurrentTurn
            ? [
                BoxShadow(
                  color: AppColors.gold.withAlpha(100),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (initVm.selectedCombatantIdForSwap != null) {
              initVm.selectCombatantForSwap(combatant.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // Ornate Tactile Card Badge with Roman Numeral
                Container(
                  width: 38,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isCurrentTurn
                        ? AppColors.goldBright
                        : isAdversary
                            ? AppColors.crimson.withAlpha(50)
                            : const Color(0xFF221A0C),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isCurrentTurn
                          ? Colors.white
                          : isAdversary
                              ? AppColors.crimsonLight
                              : AppColors.gold,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(120),
                        blurRadius: 3,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      roman,
                      style: AppTypography.statValue.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isCurrentTurn
                            ? Colors.black
                            : isAdversary
                                ? AppColors.crimsonLight
                                : AppColors.goldBright,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Avatar / Icon
                if (combatant.portraitAsset != null && combatant.portraitAsset!.isNotEmpty) ...[
                  GothicPortrait(
                    portraitAsset: combatant.portraitAsset!,
                    width: 34,
                    height: 34,
                    shape: BoxShape.circle,
                    fallbackInitial: combatant.name,
                  ),
                  const SizedBox(width: 10),
                ] else ...[
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isAdversary ? AppColors.crimson.withAlpha(40) : AppColors.gold.withAlpha(30),
                      border: Border.all(
                        color: isAdversary ? AppColors.crimson : AppColors.goldDim,
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      isAdversary ? Icons.dangerous : Icons.person,
                      color: isAdversary ? AppColors.crimsonLight : AppColors.goldBright,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],

                // Combatant Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              combatant.name,
                              style: AppTypography.titleSmall.copyWith(
                                fontSize: 13,
                                color: isActed
                                    ? AppColors.textSecondary
                                    : (isCurrentTurn ? AppColors.goldBright : AppColors.textPrimary),
                                decoration: isActed ? TextDecoration.lineThrough : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrentTurn)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.goldBright,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ACTIVE TURN',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: combatant.archetypeOrType ?? (isAdversary ? 'Adversary' : 'Investigator'),
                              style: TextStyle(
                                color: isAdversary ? AppColors.crimsonLight : AppColors.goldDim,
                              ),
                            ),
                            TextSpan(
                              text: ' • Card #${combatant.cardNumber}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        style: AppTypography.bodySmall.copyWith(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Card Swap Action Button
                IconButton(
                  icon: Icon(
                    Icons.swap_horiz,
                    color: isSelectedForSwap ? const Color(0xFF00E5FF) : AppColors.goldDim,
                    size: 18,
                  ),
                  tooltip: 'Swap initiative card',
                  onPressed: () => initVm.selectCombatantForSwap(combatant.id),
                ),

                // Acted Checkbox Toggle
                IconButton(
                  icon: Icon(
                    isActed ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isActed ? AppColors.gold : AppColors.textSecondary,
                    size: 20,
                  ),
                  tooltip: isActed ? 'Mark as Not Acted' : 'Mark as Acted',
                  onPressed: () => initVm.toggleActed(combatant.id),
                ),

                // Remove adversary button (if not investigator)
                if (isAdversary)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.crimsonLight, size: 18),
                    tooltip: 'Remove from combat',
                    onPressed: () => initVm.removeCombatant(combatant.id),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to display the Initiative Tracker Dialog.
void showInitiativeTrackerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => const InitiativeTrackerDialog(),
  );
}
