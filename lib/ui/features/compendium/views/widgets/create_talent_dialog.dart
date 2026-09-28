import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/talent.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/data/repositories/character_repository.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class CreateTalentDialog extends StatefulWidget {
  final PlayViewModel? playViewModel;
  final String? initialArchetype;

  const CreateTalentDialog({
    super.key,
    this.playViewModel,
    this.initialArchetype,
  });

  @override
  State<CreateTalentDialog> createState() => _CreateTalentDialogState();
}

class _CreateTalentDialogState extends State<CreateTalentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _effectController = TextEditingController();

  late String _selectedArchetype;

  static const List<String> _archetypeOptions = [
    'General (Any Archetype)',
    'Academic',
    'Doctor',
    'Hunter',
    'Occultist',
    'Officer',
    'Priest',
    'Private Detective',
    'Servant',
    'Vagabond',
    'Writer',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialArchetype != null && _archetypeOptions.contains(widget.initialArchetype)) {
      _selectedArchetype = widget.initialArchetype!;
    } else {
      _selectedArchetype = _archetypeOptions.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _effectController.dispose();
    super.dispose();
  }

  void _saveTalent() async {
    if (!_formKey.currentState!.validate()) return;

    final String? archetypeName = _selectedArchetype == 'General (Any Archetype)'
        ? null
        : _selectedArchetype;

    final newTalent = Talent(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      archetypeName: archetypeName,
      description: _descController.text.trim().isEmpty
          ? _effectController.text.trim()
          : _descController.text.trim(),
      effect: _effectController.text.trim(),
      isCustom: true,
    );

    if (widget.playViewModel != null) {
      await widget.playViewModel!.addCustomTalent(newTalent);
    } else {
      final repo = CharacterRepository();
      final existing = await repo.loadCustomTalents();
      existing.removeWhere((t) => t.id == newTalent.id);
      existing.add(newTalent);
      await repo.saveCustomTalents(existing);
    }

    if (mounted) {
      Navigator.of(context).pop(newTalent);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.gold),
          ),
          content: Text(
            'Homebrew talent "${newTalent.name}" forged into the Society Compendium!',
            style: const TextStyle(color: AppColors.goldBright, fontSize: 12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.gold, width: 1.2),
      ),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: double.maxFinite,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_fix_high, color: AppColors.goldBright),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'FORGE HOMEBREW TALENT',
                          style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: AppColors.textMuted),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  Text(
                    'Record a unique homebrew talent for your investigators or chapter house.',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  const OrnateDivider(height: 12),
                  const SizedBox(height: 12),

                  // Talent Name
                  Text('TALENT NAME', style: AppTypography.titleSmall.copyWith(fontSize: 11)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'e.g., Bloodhound of the Moors',
                      hintStyle: TextStyle(color: AppColors.textMuted.withAlpha(160), fontSize: 13),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.gold),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter a talent name.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Archetype requirement
                  Text('ARCHETYPE REQUIREMENT', style: AppTypography.titleSmall.copyWith(fontSize: 11)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedArchetype,
                        isExpanded: true,
                        dropdownColor: AppColors.surfaceOverlay,
                        icon: const Icon(Icons.arrow_drop_down, color: AppColors.gold),
                        items: _archetypeOptions.map((opt) {
                          return DropdownMenuItem<String>(
                            value: opt,
                            child: Text(
                              opt,
                              style: TextStyle(
                                color: opt == 'General (Any Archetype)'
                                    ? AppColors.goldBright
                                    : AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedArchetype = val);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Mechanical Effect
                  Text('MECHANICAL EFFECT / RULE BENEFIT', style: AppTypography.titleSmall.copyWith(fontSize: 11)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _effectController,
                    maxLines: 2,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'e.g., +2 dice to Vigilance when stalking beasts in dark forests.',
                      hintStyle: TextStyle(color: AppColors.textMuted.withAlpha(160), fontSize: 12),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.gold),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please define the mechanical rules benefit.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Flavor Description
                  Text('NARRATIVE FLAVOR / DESCRIPTION (OPTIONAL)', style: AppTypography.titleSmall.copyWith(fontSize: 11)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descController,
                    maxLines: 2,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Atmospheric lore or narrative origin of this talent...',
                      hintStyle: TextStyle(color: AppColors.textMuted.withAlpha(160), fontSize: 12),
                      filled: true,
                      fillColor: AppColors.surfaceLight,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.gold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _saveTalent,
                        icon: const Icon(Icons.check, size: 16, color: Colors.black),
                        label: const Text(
                          'FORGE TALENT',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
