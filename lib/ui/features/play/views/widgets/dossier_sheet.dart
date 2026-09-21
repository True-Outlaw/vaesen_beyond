import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

/// Shows the [DossierSheet] modal bottom sheet.
void showDossierSheet(BuildContext context, Character character, PlayViewModel vm) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DossierSheet(character: character, viewModel: vm),
  );
}

/// Full-screen bottom sheet for viewing and editing the investigator's
/// narrative dossier (Motivation, Trauma, Dark Secret, Memento) and
/// their Field Notes / Expedition Journal.
class DossierSheet extends StatefulWidget {
  final Character character;
  final PlayViewModel viewModel;

  const DossierSheet({
    super.key,
    required this.character,
    required this.viewModel,
  });

  @override
  State<DossierSheet> createState() => _DossierSheetState();
}

class _DossierSheetState extends State<DossierSheet> {
  late final TextEditingController _motivationCtrl;
  late final TextEditingController _traumaCtrl;
  late final TextEditingController _darkSecretCtrl;
  late final TextEditingController _mementoCtrl;

  /// Which field key is currently open for editing; null = read-only view.
  String? _editing;

  @override
  void initState() {
    super.initState();
    final c = widget.character;
    _motivationCtrl = TextEditingController(text: c.motivation);
    _traumaCtrl = TextEditingController(text: c.trauma);
    _darkSecretCtrl = TextEditingController(text: c.darkSecret);
    _mementoCtrl = TextEditingController(text: c.memento);
  }

  @override
  void dispose() {
    _motivationCtrl.dispose();
    _traumaCtrl.dispose();
    _darkSecretCtrl.dispose();
    _mementoCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveField(String field) async {
    await widget.viewModel.updateDossier(
      motivation: field == 'motivation' ? _motivationCtrl.text : null,
      trauma: field == 'trauma' ? _traumaCtrl.text : null,
      darkSecret: field == 'darkSecret' ? _darkSecretCtrl.text : null,
      memento: field == 'memento' ? _mementoCtrl.text : null,
    );
    setState(() => _editing = null);
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.viewModel.getJournalEntries();

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      expand: false,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(top: BorderSide(color: AppColors.gold, width: 1.5)),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.goldDim,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  children: [
                    const Icon(Icons.book_outlined, color: AppColors.gold, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('INVESTIGATOR DOSSIER',
                              style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright)),
                          Text(widget.character.name,
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(color: AppColors.border, height: 1),

              // Scrollable body
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _SectionTitle(icon: Icons.person_outlined, label: 'NARRATIVE FOUNDATIONS'),
                    const SizedBox(height: 8),

                    _DossierField(
                      label: 'MOTIVATION',
                      icon: Icons.star_outline,
                      controller: _motivationCtrl,
                      isEditing: _editing == 'motivation',
                      placeholder: 'What drives this investigator?',
                      onEdit: () => setState(() => _editing = 'motivation'),
                      onSave: () => _saveField('motivation'),
                      onCancel: () {
                        _motivationCtrl.text = widget.character.motivation;
                        setState(() => _editing = null);
                      },
                    ),
                    const SizedBox(height: 8),

                    _DossierField(
                      label: 'TRAUMA',
                      icon: Icons.psychology_outlined,
                      controller: _traumaCtrl,
                      isEditing: _editing == 'trauma',
                      placeholder: 'A wound that never fully healed\u2026',
                      accentColor: AppColors.violet,
                      onEdit: () => setState(() => _editing = 'trauma'),
                      onSave: () => _saveField('trauma'),
                      onCancel: () {
                        _traumaCtrl.text = widget.character.trauma;
                        setState(() => _editing = null);
                      },
                    ),
                    const SizedBox(height: 8),

                    _DossierField(
                      label: 'DARK SECRET',
                      icon: Icons.lock_outline,
                      controller: _darkSecretCtrl,
                      isEditing: _editing == 'darkSecret',
                      placeholder: 'Something you dare not speak aloud\u2026',
                      accentColor: AppColors.crimson,
                      onEdit: () => setState(() => _editing = 'darkSecret'),
                      onSave: () => _saveField('darkSecret'),
                      onCancel: () {
                        _darkSecretCtrl.text = widget.character.darkSecret;
                        setState(() => _editing = null);
                      },
                    ),
                    const SizedBox(height: 8),

                    _DossierField(
                      label: 'MEMENTO',
                      icon: Icons.auto_awesome_outlined,
                      controller: _mementoCtrl,
                      isEditing: _editing == 'memento',
                      placeholder: 'A cherished keepsake\u2026',
                      accentColor: AppColors.gold,
                      onEdit: () => setState(() => _editing = 'memento'),
                      onSave: () => _saveField('memento'),
                      onCancel: () {
                        _mementoCtrl.text = widget.character.memento;
                        setState(() => _editing = null);
                      },
                    ),

                    const SizedBox(height: 20),
                    const OrnateDivider(height: 20),

                    // Field Notes header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _SectionTitle(icon: Icons.edit_note_outlined, label: 'FIELD NOTES'),
                        ElevatedButton.icon(
                          onPressed: () => _addEntryDialog(context),
                          icon: const Icon(Icons.add, size: 13, color: AppColors.goldBright),
                          label: const Text('ADD NOTE',
                              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceOverlay,
                            foregroundColor: AppColors.goldBright,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            visualDensity: VisualDensity.compact,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: const BorderSide(color: AppColors.gold, width: 0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (entries.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.book_outlined, color: AppColors.textMuted, size: 32),
                              const SizedBox(height: 8),
                              Text(
                                'No field notes yet.\nRecord clues, rumours, and NPC details here.',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...entries.asMap().entries.map((e) => _JournalEntryRow(
                            index: e.key,
                            text: e.value,
                            onDelete: () async {
                              await widget.viewModel.removeJournalEntry(e.key);
                              setState(() {});
                            },
                          )),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _addEntryDialog(BuildContext context) async {
    final ctrl = TextEditingController();
    final saved = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.gold, width: 1),
        ),
        title: Row(
          children: [
            const Icon(Icons.edit_note, color: AppColors.gold, size: 20),
            const SizedBox(width: 8),
            Text('ADD FIELD NOTE', style: AppTypography.titleSmall),
          ],
        ),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 5,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Record clues, rumours, NPC details\u2026',
            hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surfaceLight,
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
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('CANCEL', style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(ctrl.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceOverlay,
              side: const BorderSide(color: AppColors.gold),
            ),
            child: const Text('SAVE', style: TextStyle(color: AppColors.goldBright)),
          ),
        ],
      ),
    );
    if (saved != null && saved.isNotEmpty) {
      await widget.viewModel.addJournalEntry(saved);
      setState(() {});
    }
  }
}

// ── Section Title ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 16),
        const SizedBox(width: 6),
        Text(label,
            style: AppTypography.titleSmall.copyWith(fontSize: 12, color: AppColors.gold)),
      ],
    );
  }
}

// ── Dossier Field ─────────────────────────────────────────────────────────────

class _DossierField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool isEditing;
  final String placeholder;
  final Color accentColor;
  final VoidCallback onEdit;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const _DossierField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.isEditing,
    required this.placeholder,
    this.accentColor = AppColors.goldBright,
    required this.onEdit,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GothicCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: accentColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: accentColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              if (!isEditing)
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(Icons.edit_outlined, size: 14, color: AppColors.textMuted),
                )
              else ...[
                GestureDetector(
                  onTap: onCancel,
                  child: const Icon(Icons.close, size: 14, color: AppColors.textMuted),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onSave,
                  child: Icon(Icons.check, size: 16, color: accentColor),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          if (isEditing)
            TextField(
              controller: controller,
              autofocus: true,
              maxLines: null,
              style: AppTypography.bodyMedium.copyWith(fontSize: 13, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceLight,
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: accentColor.withAlpha(100)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
            )
          else
            Text(
              controller.text.isNotEmpty ? controller.text : placeholder,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 13,
                color: controller.text.isNotEmpty ? AppColors.textPrimary : AppColors.textMuted,
                fontStyle: controller.text.isEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Journal Entry Row ─────────────────────────────────────────────────────────

class _JournalEntryRow extends StatelessWidget {
  final int index;
  final String text;
  final VoidCallback onDelete;

  const _JournalEntryRow({
    required this.index,
    required this.text,
    required this.onDelete,
  });

  String _prefixLabel() {
    if (text.startsWith('[')) {
      final end = text.indexOf(']');
      if (end > 0) return text.substring(1, end);
    }
    return 'Note ${index + 1}';
  }

  String _bodyText() {
    if (text.startsWith('[')) {
      final end = text.indexOf(']');
      if (end > 0 && end + 2 < text.length) return text.substring(end + 2);
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final isAutoLog = text.contains('Mystery Concluded');

    return Dismissible(
      key: ValueKey('journal_${index}_${text.hashCode}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.crimsonDark,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.crimsonLight, size: 20),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isAutoLog ? AppColors.goldSubtle : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isAutoLog ? AppColors.goldDim : AppColors.border,
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isAutoLog ? Icons.auto_stories : Icons.notes,
                  size: 11,
                  color: isAutoLog ? AppColors.goldDim : AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _prefixLabel(),
                    style: AppTypography.labelSmall.copyWith(
                      fontSize: 9,
                      color: isAutoLog ? AppColors.gold : AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(Icons.delete_outline, size: 14, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _bodyText(),
              style: AppTypography.bodySmall.copyWith(fontSize: 12, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
