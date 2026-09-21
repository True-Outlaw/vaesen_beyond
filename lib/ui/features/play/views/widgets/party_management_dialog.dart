import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_portrait.dart';
import 'package:vaesen_beyond/ui/features/builder/views/character_builder_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

/// Shows the [PartyManagementDialog] modal bottom sheet or dialog.
void showPartyManagementDialog(BuildContext context, PlayViewModel viewModel) {
  showDialog(
    context: context,
    builder: (_) => PartyManagementDialog(viewModel: viewModel),
  );
}

class PartyManagementDialog extends StatelessWidget {
  final PlayViewModel viewModel;

  const PartyManagementDialog({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final characters = viewModel.characters;
        final activeChar = viewModel.activeCharacter;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580, maxHeight: 680),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(220),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: AppColors.gold.withAlpha(30),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // ── Header ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.goldDim),
                          ),
                          child: const Icon(Icons.groups_outlined, color: AppColors.goldBright, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SOCIETY ROSTER',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.goldBright,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${characters.length} Investigator${characters.length != 1 ? "s" : ""} Enrolled • Castle Gyllencreutz',
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
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: AppColors.border, height: 1),

                  // ── Investigator List ────────────────────────────────────
                  Expanded(
                    child: characters.isEmpty
                        ? _buildEmptyRoster(context)
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: characters.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final char = characters[index];
                              final isActive = char.id == activeChar?.id;
                              return _buildInvestigatorCard(context, char, isActive);
                            },
                          ),
                  ),

                  // ── Bottom Action Bar ────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                      border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Import JSON Button
                        OutlinedButton.icon(
                          onPressed: () => _openImportDialog(context),
                          icon: const Icon(Icons.file_download_outlined, size: 14, color: AppColors.gold),
                          label: const Text('IMPORT JSON', style: TextStyle(color: AppColors.gold, fontSize: 11)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.goldDim),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),

                        // Enroll New Investigator Button
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CharacterBuilderScreen(
                                  playViewModel: viewModel,
                                  onFinished: () => Navigator.pop(context),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.person_add, size: 14, color: Colors.black),
                          label: const Text(
                            'NEW INVESTIGATOR',
                            style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.goldBright,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
      },
    );
  }

  Widget _buildEmptyRoster(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.folder_open, color: AppColors.goldDim, size: 48),
            const SizedBox(height: 12),
            Text(
              'No Investigators Enrolled',
              style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright),
            ),
            const SizedBox(height: 6),
            Text(
              'The Society archives are currently vacant. Enroll a new investigator or reload the pregenerated roster to begin.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () async {
                await viewModel.loadPregenCharacters();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Standard pregenerated investigators restored.')),
                  );
                }
              },
              icon: const Icon(Icons.restart_alt, size: 16, color: AppColors.gold),
              label: const Text('RESTORE PREGENERATED ROSTER', style: TextStyle(color: AppColors.gold, fontSize: 11)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.gold),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvestigatorCard(BuildContext context, Character char, bool isActive) {
    final isBroken = char.conditions.isBroken;
    final hasConditions = char.conditions.physicalPenalty > 0 || char.conditions.mentalPenalty > 0;

    return GothicCard(
      padding: const EdgeInsets.all(12),
      borderColor: isActive ? AppColors.goldBright : AppColors.border,
      borderWidth: isActive ? 1.5 : 0.8,
      backgroundColor: isActive ? AppColors.surfaceLight : AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          GothicPortrait(
            portraitAsset: char.effectivePortraitAsset,
            width: 48,
            height: 48,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? AppColors.goldBright : AppColors.goldDim,
              width: isActive ? 2.0 : 1.0,
            ),
            fallbackInitial: char.name,
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        char.name,
                        style: AppTypography.titleSmall.copyWith(
                          color: isActive ? AppColors.goldBright : AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withAlpha(40),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.gold),
                        ),
                        child: const Text(
                          'ACTIVE',
                          style: TextStyle(color: AppColors.goldBright, fontSize: 8.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${char.archetypeName} • Age ${char.actualAge} (${char.ageCategory.label.split(" ")[0]}) • ${char.experiencePoints} XP',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.goldDim, fontSize: 11),
                ),
                const SizedBox(height: 6),

                // Status Chips
                Wrap(
                  spacing: 6,
                  children: [
                    if (isBroken)
                      _statusChip('BROKEN', AppColors.crimsonLight, AppColors.crimsonDark)
                    else if (hasConditions)
                      _statusChip(
                        'P: -${char.conditions.physicalPenalty} / M: -${char.conditions.mentalPenalty}',
                        AppColors.gold,
                        AppColors.surfaceLight,
                      )
                    else
                      _statusChip('HEALTHY', AppColors.goldDim, AppColors.surfaceLight),
                    if (char.activeInjuries.isNotEmpty)
                      _statusChip('${char.activeInjuries.length} INJURIES', AppColors.crimsonLight, AppColors.surfaceLight),
                  ],
                ),

                const SizedBox(height: 8),

                // Actions row
                Row(
                  children: [
                    if (!isActive)
                      TextButton.icon(
                        onPressed: () => viewModel.switchCharacter(char.id),
                        icon: const Icon(Icons.check_circle_outline, size: 13, color: AppColors.gold),
                        label: const Text('ACTIVATE', style: TextStyle(color: AppColors.gold, fontSize: 10.5, fontWeight: FontWeight.bold)),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () => _exportCharacter(context, char),
                      icon: const Icon(Icons.copy_outlined, size: 13, color: AppColors.textMuted),
                      label: const Text('EXPORT', style: TextStyle(color: AppColors.textMuted, fontSize: 10.5)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.crimsonLight),
                      tooltip: 'Retire / Delete Investigator',
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      padding: EdgeInsets.zero,
                      onPressed: () => _confirmRetirement(context, char),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: fg.withAlpha(120), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _exportCharacter(BuildContext context, Character char) {
    final jsonStr = viewModel.exportCharacterJson(char.id);
    if (jsonStr == null) return;

    Clipboard.setData(ClipboardData(text: jsonStr));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.gold),
        ),
        content: Row(
          children: [
            const Icon(Icons.check, color: AppColors.goldBright, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${char.name} exported! JSON copied to clipboard.',
                style: const TextStyle(color: AppColors.goldBright, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRetirement(BuildContext context, Character char) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.crimson, width: 1.2),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.crimsonLight, size: 20),
            const SizedBox(width: 8),
            const Text('RETIRE INVESTIGATOR', style: TextStyle(color: AppColors.crimsonLight, fontSize: 16)),
          ],
        ),
        content: Text(
          'Are you certain you wish to retire ${char.name}?\n\n'
          'This will permanently remove their records, gear, and field notes from the Society archives.',
          style: AppTypography.bodyMedium.copyWith(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await viewModel.deleteCharacter(char.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${char.name} has been retired from the Society.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.crimson,
              foregroundColor: Colors.white,
            ),
            child: const Text('RETIRE INVESTIGATOR'),
          ),
        ],
      ),
    );
  }

  void _openImportDialog(BuildContext context) {
    final ctrl = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.gold, width: 1.2),
          ),
          title: Row(
            children: [
              const Icon(Icons.file_download_outlined, color: AppColors.goldBright, size: 20),
              const SizedBox(width: 8),
              Text('IMPORT INVESTIGATOR JSON', style: AppTypography.titleMedium),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paste a valid Vaesen Beyond character JSON export below:',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ctrl,
                  maxLines: 7,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: '{\n  "name": "Johan Falck",\n  "archetypeName": "Occultist",\n  ...\n}',
                    hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                    errorText: errorText,
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () async {
                      final data = await Clipboard.getData(Clipboard.kTextPlain);
                      if (data?.text != null) {
                        setState(() {
                          ctrl.text = data!.text!;
                          errorText = null;
                        });
                      }
                    },
                    icon: const Icon(Icons.paste, size: 13, color: AppColors.gold),
                    label: const Text('PASTE FROM CLIPBOARD', style: TextStyle(color: AppColors.gold, fontSize: 10)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () async {
                final text = ctrl.text.trim();
                if (text.isEmpty) {
                  setState(() => errorText = 'Please enter or paste character JSON.');
                  return;
                }
                try {
                  final imported = await viewModel.importCharacterFromJson(text);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: AppColors.gold),
                        ),
                        content: Text('Imported and activated ${imported.name}!'),
                      ),
                    );
                  }
                } catch (e) {
                  setState(() => errorText = 'Invalid character JSON format: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceOverlay,
                foregroundColor: AppColors.goldBright,
                side: const BorderSide(color: AppColors.gold),
              ),
              child: const Text('IMPORT INVESTIGATOR'),
            ),
          ],
        ),
      ),
    );
  }
}
