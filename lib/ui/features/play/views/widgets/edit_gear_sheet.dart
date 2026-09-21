import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

/// Shows the [EditGearSheet] as a modal bottom sheet for a [Weapon].
void showEditWeaponSheet(BuildContext context, Weapon weapon, PlayViewModel vm) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => EditGearSheet.weapon(weapon: weapon, viewModel: vm),
  );
}

/// Shows the [EditGearSheet] as a modal bottom sheet for an [Armor].
void showEditArmorSheet(BuildContext context, Armor armor, PlayViewModel vm) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => EditGearSheet.armor(armor: armor, viewModel: vm),
  );
}

/// Shows the [EditGearSheet] as a modal bottom sheet for an [EquipmentItem].
void showEditEquipmentSheet(BuildContext context, EquipmentItem item, PlayViewModel vm) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => EditGearSheet.equipment(item: item, viewModel: vm),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

enum _GearType { weapon, armor, equipment }

class EditGearSheet extends StatefulWidget {
  final _GearType _type;
  final Weapon? weapon;
  final Armor? armor;
  final EquipmentItem? item;
  final PlayViewModel viewModel;

  const EditGearSheet.weapon({super.key, required this.weapon, required this.viewModel})
      : _type = _GearType.weapon,
        armor = null,
        item = null;

  const EditGearSheet.armor({super.key, required this.armor, required this.viewModel})
      : _type = _GearType.armor,
        weapon = null,
        item = null;

  const EditGearSheet.equipment({super.key, required this.item, required this.viewModel})
      : _type = _GearType.equipment,
        weapon = null,
        armor = null;

  @override
  State<EditGearSheet> createState() => _EditGearSheetState();
}

class _EditGearSheetState extends State<EditGearSheet> {
  // Common
  late final TextEditingController _nameCtrl;

  // Weapon
  int _damage = 1;
  int _bonus = 0;
  WeaponRange _range = WeaponRange.engaged;
  final TextEditingController _qualitiesCtrl = TextEditingController();

  // Armor
  int _protection = 0;
  int _agilityPenalty = 0;

  // Equipment
  late final TextEditingController _descCtrl;
  int _slots = 1;
  bool _isHeavy = false;

  @override
  void initState() {
    super.initState();
    switch (widget._type) {
      case _GearType.weapon:
        final w = widget.weapon!;
        _nameCtrl = TextEditingController(text: w.name);
        _descCtrl = TextEditingController();
        _damage = w.damage;
        _bonus = w.bonus;
        _range = w.range;
        _qualitiesCtrl.text = w.qualities.join(', ');
      case _GearType.armor:
        final a = widget.armor!;
        _nameCtrl = TextEditingController(text: a.name);
        _descCtrl = TextEditingController();
        _protection = a.protection;
        _agilityPenalty = a.agilityPenalty;
      case _GearType.equipment:
        final e = widget.item!;
        _nameCtrl = TextEditingController(text: e.name);
        _descCtrl = TextEditingController(text: e.description);
        _slots = e.slots;
        _isHeavy = e.isHeavy;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qualitiesCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    switch (widget._type) {
      case _GearType.weapon:
        final updated = widget.weapon!.copyWith(
          name: _nameCtrl.text.trim(),
          damage: _damage,
          bonus: _bonus,
          range: _range,
          qualities: _qualitiesCtrl.text
              .split(',')
              .map((q) => q.trim())
              .where((q) => q.isNotEmpty)
              .toList(),
        );
        await widget.viewModel.updateWeapon(updated);
      case _GearType.armor:
        final updated = widget.armor!.copyWith(
          name: _nameCtrl.text.trim(),
          protection: _protection,
          agilityPenalty: _agilityPenalty,
        );
        await widget.viewModel.updateArmor(updated);
      case _GearType.equipment:
        final updated = widget.item!.copyWith(
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          slots: _slots,
          isHeavy: _isHeavy,
        );
        await widget.viewModel.updateEquipmentItem(updated);
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          border: Border(top: BorderSide(color: AppColors.gold, width: 1.5)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.goldDim,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title
              Row(
                children: [
                  Icon(_typeIcon, color: AppColors.gold, size: 18),
                  const SizedBox(width: 8),
                  Text('EDIT ${_typeLabel.toUpperCase()}', style: AppTypography.titleMedium),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name field (all types)
              _FieldLabel('NAME'),
              _inputField(_nameCtrl, hint: 'Item name'),
              const SizedBox(height: 14),

              // Type-specific fields
              ..._typeFields(),

              const SizedBox(height: 24),

              // Save
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceOverlay,
                    foregroundColor: AppColors.goldBright,
                    side: const BorderSide(color: AppColors.gold),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('SAVE CHANGES', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _typeLabel {
    switch (widget._type) {
      case _GearType.weapon:
        return 'Weapon';
      case _GearType.armor:
        return 'Armor';
      case _GearType.equipment:
        return 'Equipment';
    }
  }

  IconData get _typeIcon {
    switch (widget._type) {
      case _GearType.weapon:
        return Icons.shield_outlined;
      case _GearType.armor:
        return Icons.security;
      case _GearType.equipment:
        return Icons.inventory_2_outlined;
    }
  }

  List<Widget> _typeFields() {
    switch (widget._type) {
      case _GearType.weapon:
        return _weaponFields();
      case _GearType.armor:
        return _armorFields();
      case _GearType.equipment:
        return _equipmentFields();
    }
  }

  List<Widget> _weaponFields() => [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('DAMAGE'),
                  _Stepper(
                    value: _damage,
                    min: 1,
                    max: 10,
                    onChanged: (v) => setState(() => _damage = v),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('BONUS'),
                  _Stepper(
                    value: _bonus,
                    min: 0,
                    max: 6,
                    onChanged: (v) => setState(() => _bonus = v),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _FieldLabel('RANGE'),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: DropdownButton<WeaponRange>(
            value: _range,
            isExpanded: true,
            dropdownColor: AppColors.surfaceLight,
            underline: const SizedBox.shrink(),
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
            items: WeaponRange.values.map((r) {
              return DropdownMenuItem(value: r, child: Text(r.label));
            }).toList(),
            onChanged: (v) => setState(() => _range = v ?? _range),
          ),
        ),
        const SizedBox(height: 14),
        _FieldLabel('QUALITIES (comma-separated)'),
        _inputField(_qualitiesCtrl, hint: 'e.g. Heavy, Blunt, Silent'),
      ];

  List<Widget> _armorFields() => [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('PROTECTION'),
                  _Stepper(
                    value: _protection,
                    min: 0,
                    max: 8,
                    onChanged: (v) => setState(() => _protection = v),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('AGILITY PENALTY'),
                  _Stepper(
                    value: _agilityPenalty,
                    min: 0,
                    max: 4,
                    onChanged: (v) => setState(() => _agilityPenalty = v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ];

  List<Widget> _equipmentFields() => [
        _FieldLabel('DESCRIPTION'),
        _inputField(_descCtrl, hint: 'Optional description', maxLines: 3),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('SLOTS'),
                  _Stepper(
                    value: _slots,
                    min: 1,
                    max: 6,
                    onChanged: (v) => setState(() => _slots = v),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Switch(
                    value: _isHeavy,
                    onChanged: (v) => setState(() => _isHeavy = v),
                    activeThumbColor: AppColors.gold,
                    activeTrackColor: AppColors.gold.withAlpha(120),
                  ),
                  const SizedBox(width: 6),
                  Text('Heavy', style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      ];

  Widget _inputField(TextEditingController ctrl, {String hint = '', int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.gold),
        ),
      ),
    );
  }
}

// ── Field Label ───────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.goldDim,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// ── Stepper ───────────────────────────────────────────────────────────────────

class _Stepper extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _Stepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 14, color: AppColors.textMuted),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          Text(
            '$value',
            style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 14, color: AppColors.gold),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
