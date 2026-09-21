import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/solace_dialog.dart';

/// Derives a portrait asset path from the character's archetype name.
String _portraitAsset(Character character) {
  final lower = character.archetypeName.toLowerCase();
  if (lower.contains('doctor') || lower.contains('physician') || lower.contains('astrid')) {
    return 'assets/images/portraits/astrid.jpg';
  } else if (lower.contains('detective') || lower.contains('officer') || lower.contains('johan')) {
    return 'assets/images/portraits/johan.jpg';
  } else if (lower.contains('occult') || lower.contains('scholar') || lower.contains('elias')) {
    return 'assets/images/portraits/elias.jpg';
  } else if (lower.contains('hunter') || lower.contains('woodsman') || lower.contains('birger')) {
    return 'assets/images/portraits/birger.jpg';
  }
  // Fallback: cycle through portraits by ID hash
  final portraits = [
    'assets/images/portraits/astrid.jpg',
    'assets/images/portraits/johan.jpg',
    'assets/images/portraits/elias.jpg',
    'assets/images/portraits/birger.jpg',
  ];
  return portraits[character.id.hashCode.abs() % portraits.length];
}

class IdentityHeader extends StatelessWidget {
  final Character character;
  final PlayViewModel viewModel;

  const IdentityHeader({
    super.key,
    required this.character,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final cond = character.conditions;
    final physPenalty = cond.physicalPenalty;
    final mentPenalty = cond.mentalPenalty;
    final isBroken = cond.isBroken;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Portrait + Name Row ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Sculpted portrait frame
                _PortraitFrame(character: character),
                const SizedBox(width: 14),

                // Name + archetype + status badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        character.name,
                        style: AppTypography.displayMedium.copyWith(
                          fontSize: 18,
                          color: AppColors.goldBright,
                          height: 1.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          // Archetype chip
                          _StatusChip(
                            label: character.archetypeName.toUpperCase(),
                            color: AppColors.gold,
                            bg: AppColors.goldSubtle,
                          ),
                          const SizedBox(width: 6),
                          // Condition status chip
                          _buildStatusChip(isBroken, physPenalty, mentPenalty),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${character.ageCategory.label} · ${character.actualAge} yrs',
                        style: AppTypography.label.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                // Character switcher
                _CharacterSwitcher(character: character, viewModel: viewModel),
              ],
            ),
          ),

          // ── Interactive Condition Track ──────────────────────────────────
          _ConditionTrackBar(character: character, viewModel: viewModel),

          // ── Memento / Solace compact strip ───────────────────────────────
          _MementoStrip(character: character, viewModel: viewModel),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isBroken, int physPenalty, int mentPenalty) {
    if (isBroken) {
      return _StatusChip(
        label: '⚠ BROKEN',
        color: AppColors.lethal,
        bg: AppColors.crimsonSubtle,
      );
    } else if (physPenalty > 0 || mentPenalty > 0) {
      return _StatusChip(
        label: '-${physPenalty + mentPenalty} TRAUMA',
        color: AppColors.physicalCondition,
        bg: AppColors.crimsonSubtle,
      );
    } else {
      return _StatusChip(
        label: '● HEALTHY',
        color: AppColors.emerald,
        bg: AppColors.emeraldSubtle,
      );
    }
  }
}

// ── Portrait Frame ─────────────────────────────────────────────────────────

class _PortraitFrame extends StatelessWidget {
  final Character character;

  const _PortraitFrame({required this.character});

  @override
  Widget build(BuildContext context) {
    final asset = _portraitAsset(character);

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withAlpha(40),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.5),
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Container(
            color: AppColors.surfaceLight,
            alignment: Alignment.center,
            child: Text(
              character.name.isNotEmpty ? character.name[0].toUpperCase() : 'V',
              style: AppTypography.statHero.copyWith(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Condition Track Bar ─────────────────────────────────────────────────────

class _ConditionTrackBar extends StatelessWidget {
  final Character character;
  final PlayViewModel viewModel;

  const _ConditionTrackBar({required this.character, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final cond = character.conditions;
    return Container(
      color: AppColors.surfaceLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        children: [
          // Physical track
          const Icon(Icons.favorite_border, size: 13, color: AppColors.crimson),
          const SizedBox(width: 6),
          Expanded(
            child: Row(
              children: [
                _CondBox(
                  label: 'EXHAUST',
                  active: cond.exhausted,
                  color: AppColors.crimson,
                  onTap: () => viewModel.updateCharacter(
                    character.copyWith(
                      conditions: cond.copyWith(exhausted: !cond.exhausted),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _CondBox(
                  label: 'BATTERED',
                  active: cond.battered,
                  color: AppColors.crimson,
                  onTap: () => viewModel.updateCharacter(
                    character.copyWith(
                      conditions: cond.copyWith(battered: !cond.battered),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _CondBox(
                  label: 'WOUNDED',
                  active: cond.wounded,
                  color: AppColors.lethal,
                  onTap: () => viewModel.updateCharacter(
                    character.copyWith(
                      conditions: cond.copyWith(wounded: !cond.wounded),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Divider
          Container(width: 1, height: 22, color: AppColors.border),
          const SizedBox(width: 10),
          // Mental track
          const Icon(Icons.psychology_outlined, size: 13, color: AppColors.violet),
          const SizedBox(width: 6),
          Expanded(
            child: Row(
              children: [
                _CondBox(
                  label: 'ANGRY',
                  active: cond.angry,
                  color: AppColors.violet,
                  onTap: () => viewModel.updateCharacter(
                    character.copyWith(
                      conditions: cond.copyWith(angry: !cond.angry),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _CondBox(
                  label: 'SCARED',
                  active: cond.frightened,
                  color: AppColors.violet,
                  onTap: () => viewModel.updateCharacter(
                    character.copyWith(
                      conditions: cond.copyWith(frightened: !cond.frightened),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                _CondBox(
                  label: 'HOPELESS',
                  active: cond.hopeless,
                  color: AppColors.violetLight,
                  onTap: () => viewModel.updateCharacter(
                    character.copyWith(
                      conditions: cond.copyWith(hopeless: !cond.hopeless),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CondBox extends StatelessWidget {
  final String label;
  final bool active;
  final Color color;
  final VoidCallback onTap;

  const _CondBox({
    required this.label,
    required this.active,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: active ? color.withAlpha(50) : AppColors.background,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: active ? color : AppColors.border,
              width: active ? 1.2 : 0.8,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.chip.copyWith(
              color: active ? color : AppColors.textMuted,
              fontSize: 8.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

// ── Status Chip ────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _StatusChip({required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha(120), width: 0.8),
      ),
      child: Text(
        label,
        style: AppTypography.chip.copyWith(color: color, fontSize: 9),
      ),
    );
  }
}

// ── Character Switcher ──────────────────────────────────────────────────────

class _CharacterSwitcher extends StatelessWidget {
  final Character character;
  final PlayViewModel viewModel;

  const _CharacterSwitcher({required this.character, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.people_alt_outlined, color: AppColors.goldBright, size: 20),
      tooltip: 'Switch Investigator',
      color: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      onSelected: (id) => viewModel.switchCharacter(id),
      itemBuilder: (context) {
        return viewModel.characters.map((c) {
          final isCurrent = c.id == character.id;
          return PopupMenuItem<String>(
            value: c.id,
            child: Row(
              children: [
                Icon(
                  isCurrent ? Icons.check_circle : Icons.circle_outlined,
                  size: 16,
                  color: isCurrent ? AppColors.gold : AppColors.textMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name,
                        style: AppTypography.titleSmall.copyWith(
                          color: isCurrent ? AppColors.goldBright : AppColors.textPrimary,
                        ),
                      ),
                      Text(c.archetypeName, style: AppTypography.bodySmall.copyWith(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

// ── Memento Strip ───────────────────────────────────────────────────────────

class _MementoStrip extends StatelessWidget {
  final Character character;
  final PlayViewModel viewModel;

  const _MementoStrip({required this.character, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: character.isMementoUsed
          ? null
          : () => showDialog(
                context: context,
                builder: (_) => SolaceDialog(viewModel: viewModel),
              ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 0.8),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 13,
              color: character.isMementoUsed ? AppColors.textMuted : AppColors.gold,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                character.memento.isNotEmpty
                    ? character.memento
                    : 'Cherished Keepsake',
                style: AppTypography.label.copyWith(
                  color: character.isMementoUsed ? AppColors.textMuted : AppColors.textSecondary,
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!character.isMementoUsed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.goldSubtle,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.goldDim, width: 0.8),
                ),
                child: Text(
                  'DRAW SOLACE',
                  style: AppTypography.chip.copyWith(color: AppColors.gold),
                ),
              )
            else
              Text(
                'USED',
                style: AppTypography.chip.copyWith(color: AppColors.textMuted),
              ),
          ],
        ),
      ),
    );
  }
}
