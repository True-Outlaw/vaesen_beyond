import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

/// Shows the multi-step [ConcludeMysteryDialog].
void showConcludeMysteryDialog(
  BuildContext context, {
  required PlayViewModel viewModel,
  required Character character,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => ConcludeMysteryDialog(
      viewModel: viewModel,
      character: character,
    ),
  );
}

/// A 3-step modal dialog for concluding a mystery:
/// 1. Debrief Questionnaire (Vaesen core questions -> XP)
/// 2. Castle Rewards & Solace Recovery (Dev Points + Memento)
/// 3. Summary & Confirmation (Expedition Log entry committed)
class ConcludeMysteryDialog extends StatefulWidget {
  final PlayViewModel viewModel;
  final Character character;

  const ConcludeMysteryDialog({
    super.key,
    required this.viewModel,
    required this.character,
  });

  @override
  State<ConcludeMysteryDialog> createState() => _ConcludeMysteryDialogState();
}

class _ConcludeMysteryDialogState extends State<ConcludeMysteryDialog> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Debrief Questions (Standard Vaesen debrief)
  final List<String> _questions = const [
    '1. Did you participate in the mystery? (+1 XP)',
    '2. Did you confront or discover a vaesen? (+1 XP)',
    '3. Did you use your archetype talent? (+1 XP)',
    '4. Were you affected or held back by your Dark Secret? (+1 XP)',
    '5. Did you suffer from a condition or critical injury? (+1 XP)',
  ];
  late final List<bool> _answers;

  // Step 2: Castle & Solace
  int _devPointsEarned = 2;
  bool _restoreMemento = true;
  final TextEditingController _logCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _answers = List.filled(_questions.length, true);
    _restoreMemento = widget.character.isMementoUsed;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _logCtrl.dispose();
    super.dispose();
  }

  int get _xpEarned => _answers.where((a) => a).length;

  void _goToStep(int step) {
    setState(() => _currentStep = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _commitConclude() async {
    final xp = _xpEarned;
    final dev = _devPointsEarned;
    final logText = _logCtrl.text.trim();

    await widget.viewModel.concludeMystery(
      xpEarned: xp,
      devPointsEarned: dev,
      restoreMemento: _restoreMemento,
      logEntry: logText.isNotEmpty ? logText : null,
    );

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.gold, width: 1),
          ),
          content: Row(
            children: [
              const Icon(Icons.auto_stories, color: AppColors.goldBright, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Mystery Concluded! +$xp XP awarded to ${widget.character.name} · +$dev Castle Dev Points added.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.goldBright),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 660),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gold, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(200),
                blurRadius: 24,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: AppColors.gold.withAlpha(25),
                blurRadius: 16,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.goldDim),
                      ),
                      child: const Icon(Icons.auto_stories, color: AppColors.goldBright, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONCLUDE MYSTERY',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.goldBright,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Step ${_currentStep + 1} of 3: ${_stepTitle(_currentStep)}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.goldDim,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                      tooltip: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Step progress bar
              Row(
                children: List.generate(3, (i) {
                  final isActive = i <= _currentStep;
                  return Expanded(
                    child: Container(
                      height: 3,
                      margin: EdgeInsets.only(
                        left: i == 0 ? 16 : 4,
                        right: i == 2 ? 16 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.gold : AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),

              // ── Step Pages ──────────────────────────────────────────────
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1Debrief(),
                    _buildStep2Castle(),
                    _buildStep3Summary(),
                  ],
                ),
              ),

              // ── Footer Navigation ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      TextButton.icon(
                        onPressed: () => _goToStep(_currentStep - 1),
                        icon: const Icon(Icons.arrow_back, size: 14, color: AppColors.textMuted),
                        label: const Text('BACK', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      )
                    else
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                      ),

                    if (_currentStep < 2)
                      ElevatedButton.icon(
                        onPressed: () => _goToStep(_currentStep + 1),
                        icon: const Icon(Icons.arrow_forward, size: 14, color: Colors.black),
                        label: const Text(
                          'NEXT',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldBright,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: _commitConclude,
                        icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.black),
                        label: const Text(
                          'FINALIZE EXPEDITION',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.goldBright,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _stepTitle(int step) {
    switch (step) {
      case 0:
        return 'Debrief Questionnaire';
      case 1:
        return 'Headquarters & Solace';
      case 2:
        return 'Review & Commit';
      default:
        return '';
    }
  }

  // ── Step 1: Debrief ────────────────────────────────────────────────────────
  Widget _buildStep1Debrief() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      children: [
        Text(
          'Answer the 5 official Vaesen session questions. Each affirmative answer awards +1 Advancement Point (XP) to ${widget.character.name}:',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, height: 1.4),
        ),
        const SizedBox(height: 12),

        ...List.generate(_questions.length, (i) {
          final isChecked = _answers[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isChecked ? AppColors.gold.withAlpha(15) : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isChecked ? AppColors.gold : AppColors.border,
                width: isChecked ? 1.0 : 0.6,
              ),
            ),
            child: CheckboxListTile(
              dense: true,
              value: isChecked,
              activeColor: AppColors.goldBright,
              checkColor: Colors.black,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              title: Text(
                _questions[i],
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isChecked ? FontWeight.w600 : FontWeight.normal,
                  color: isChecked ? AppColors.goldBright : AppColors.textPrimary,
                ),
              ),
              onChanged: (val) {
                setState(() => _answers[i] = val ?? false);
              },
            ),
          );
        }),

        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.goldDim),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('XP TO BE AWARDED:', style: AppTypography.labelSmall.copyWith(color: AppColors.goldDim)),
              Text(
                '+$_xpEarned ADVANCEMENT POINTS',
                style: const TextStyle(
                  color: AppColors.goldBright,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Step 2: Castle & Solace ────────────────────────────────────────────────
  Widget _buildStep2Castle() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      children: [
        // Castle Dev Points
        GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.castle_outlined, color: AppColors.gold, size: 18),
                  const SizedBox(width: 8),
                  Text('CASTLE GYLLENCREUTZ DEVELOPMENT', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Headquarters gains Development Points upon completing a mystery, enabling new facilities, upgrades, and contacts.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Points Awarded:', style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16, color: AppColors.textMuted),
                        onPressed: _devPointsEarned > 0 ? () => setState(() => _devPointsEarned--) : null,
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 32),
                        alignment: Alignment.center,
                        child: Text(
                          '+$_devPointsEarned',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.goldBright,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16, color: AppColors.gold),
                        onPressed: _devPointsEarned < 20 ? () => setState(() => _devPointsEarned++) : null,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Solace / Memento Restoration
        GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.card_giftcard, color: AppColors.gold, size: 18),
                  const SizedBox(width: 8),
                  Text('PERSONAL MEMENTO SOLACE', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                widget.character.memento.isNotEmpty
                    ? 'Memento: "${widget.character.memento}"'
                    : 'Personal token of comfort and healing.',
                style: AppTypography.bodySmall.copyWith(color: AppColors.goldDim, fontSize: 11),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _restoreMemento,
                activeThumbColor: AppColors.goldBright,
                activeTrackColor: AppColors.gold.withAlpha(120),
                title: Text(
                  'Restore Memento for Next Mystery',
                  style: AppTypography.bodyMedium.copyWith(fontSize: 13, color: AppColors.textPrimary),
                ),
                subtitle: Text(
                  widget.character.isMementoUsed
                      ? 'Currently spent. Restores ability to draw solace next mystery.'
                      : 'Memento is already ready to use.',
                  style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                ),
                onChanged: (v) => setState(() => _restoreMemento = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Expedition Log Note
        GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.history_edu_outlined, color: AppColors.gold, size: 18),
                  const SizedBox(width: 8),
                  Text('EXPEDITION LOG SYNOPSIS', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Optional summary to record in ${widget.character.name}\'s Field Notes journal:',
                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _logCtrl,
                maxLines: 2,
                style: AppTypography.bodyMedium.copyWith(fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'e.g. Banished the Grim at Lake Mälaren. Discovered the cursed amulet.',
                  hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.gold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Step 3: Summary ────────────────────────────────────────────────────────
  Widget _buildStep3Summary() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      children: [
        Text(
          'Confirm mystery conclusion. The following rewards and records will be finalized:',
          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, height: 1.4),
        ),
        const SizedBox(height: 14),

        GothicCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _summaryRow(
                icon: Icons.person_outline,
                label: 'Investigator',
                value: widget.character.name,
                valueColor: AppColors.goldBright,
              ),
              const OrnateDivider(height: 16),
              _summaryRow(
                icon: Icons.military_tech_outlined,
                label: 'Advancement Points',
                value: '+$_xpEarned XP (Total: ${widget.character.experiencePoints + _xpEarned})',
                valueColor: AppColors.goldBright,
              ),
              const OrnateDivider(height: 16),
              _summaryRow(
                icon: Icons.castle_outlined,
                label: 'Headquarters Dev Points',
                value: '+$_devPointsEarned Dev Points',
                valueColor: AppColors.gold,
              ),
              const OrnateDivider(height: 16),
              _summaryRow(
                icon: Icons.card_giftcard,
                label: 'Memento Solace',
                value: _restoreMemento ? 'Restored & Ready' : (widget.character.isMementoUsed ? 'Spent' : 'Ready'),
                valueColor: _restoreMemento || !widget.character.isMementoUsed ? AppColors.gold : AppColors.crimsonLight,
              ),
              if (_logCtrl.text.trim().isNotEmpty) ...[
                const OrnateDivider(height: 16),
                _summaryRow(
                  icon: Icons.edit_note,
                  label: 'Journal Note',
                  value: _logCtrl.text.trim(),
                  valueColor: AppColors.textPrimary,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.gold.withAlpha(20),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.goldDim),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.gold, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Advancement points can be spent on Skills and Talents in the Experience tab at any time.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.goldBright, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.goldDim),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTypography.bodyMedium.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 12.5,
            ),
          ),
        ),
      ],
    );
  }
}
