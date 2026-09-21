import 'package:flutter/material.dart';
import 'package:vaesen_beyond/data/seed/gear_data.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class AddItemSheet extends StatefulWidget {
  final PlayViewModel playViewModel;

  const AddItemSheet({super.key, required this.playViewModel});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Custom Item Form Controllers
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  int _customSlots = 1;
  String _customType = 'Equipment'; // 'Weapon', 'Armor', 'Equipment'
  int _customDamage = 1;
  int _customBonus = 0;
  int _customProtection = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          border: Border.all(
            color: AppColors.gold.withAlpha(140),
            width: 1.0,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.goldDim.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.archive_outlined, color: AppColors.gold, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'ACQUIRE ITEM & GEAR',
                              style: AppTypography.titleMedium.copyWith(letterSpacing: 1.1),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // Category Bar
              Container(
                height: 38,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.goldDim.withAlpha(50)),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: AppColors.surfaceOverlay,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.gold.withAlpha(140), width: 0.8),
                  ),
                  labelColor: AppColors.goldBright,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: AppTypography.tabLabel.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
                  dividerColor: Colors.transparent,
                  padding: const EdgeInsets.all(3),
                  tabs: const [
                    Tab(text: 'WEAPONS'),
                    Tab(text: 'ARMOR'),
                    Tab(text: 'GEAR'),
                    Tab(text: 'CUSTOM'),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildWeaponsTab(),
                    _buildArmorTab(),
                    _buildGearTab(),
                    _buildCustomTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeaponsTab() {
    final weapons = GearData.standardWeapons;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: weapons.length,
      separatorBuilder: (_, _) => const Divider(color: AppColors.border, height: 1),
      itemBuilder: (context, i) {
        final w = weapons[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      w.name,
                      style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Dmg: ${w.damage}  •  Bonus: +${w.bonus}  •  Range: ${w.range.label}  •  ${w.qualities.join(", ")}',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newWeapon = w.copyWith(id: '${w.id}_${DateTime.now().millisecondsSinceEpoch}');
                  widget.playViewModel.addWeapon(newWeapon);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${w.name} to inventory.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: AppColors.gold.withAlpha(100)),
                  ),
                ),
                child: const Text('ADD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArmorTab() {
    final armorList = GearData.standardArmor;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: armorList.length,
      separatorBuilder: (_, _) => const Divider(color: AppColors.border, height: 1),
      itemBuilder: (context, i) {
        final a = armorList[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.name,
                      style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Protection: ${a.protection}  •  Agility Penalty: ${a.agilityPenalty}',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newArmor = a.copyWith(id: '${a.id}_${DateTime.now().millisecondsSinceEpoch}');
                  widget.playViewModel.addArmor(newArmor);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${a.name} to inventory.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: AppColors.gold.withAlpha(100)),
                  ),
                ),
                child: const Text('ADD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGearTab() {
    final items = GearData.commonEquipment;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(color: AppColors.border, height: 1),
      itemBuilder: (context, i) {
        final eq = items[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eq.name,
                      style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Slots: ${eq.slots} ${eq.isHeavy ? "(Heavy)" : ""}  •  ${eq.description}',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newItem = eq.copyWith(id: '${eq.id}_${DateTime.now().millisecondsSinceEpoch}');
                  widget.playViewModel.addEquipment(newItem);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${eq.name} to inventory.'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.gold,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: AppColors.gold.withAlpha(100)),
                  ),
                ),
                child: const Text('ADD', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Item Type selector
        Row(
          children: [
            const Text('Item Type:', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(width: 12),
            ...['Equipment', 'Weapon', 'Armor'].map((type) {
              final isSel = _customType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(type, style: TextStyle(fontSize: 11, color: isSel ? AppColors.goldBright : AppColors.textMuted)),
                  selected: isSel,
                  selectedColor: AppColors.surfaceOverlay,
                  backgroundColor: AppColors.surfaceLight,
                  side: BorderSide(color: isSel ? AppColors.gold : AppColors.border),
                  onSelected: (sel) {
                    if (sel) setState(() => _customType = type);
                  },
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),

        // Name input
        TextField(
          controller: _nameController,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          decoration: const InputDecoration(
            labelText: 'Item Name',
            hintText: 'e.g. Silver Pocket Watch, Wolfskin Cloak',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        // Slots / Weight
        Row(
          children: [
            const Text('Slots / Carry Weight: ', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 18, color: AppColors.goldDim),
              onPressed: () {
                if (_customSlots > 0) setState(() => _customSlots--);
              },
            ),
            Text('$_customSlots', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 14)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 18, color: AppColors.goldDim),
              onPressed: () {
                if (_customSlots < 10) setState(() => _customSlots++);
              },
            ),
          ],
        ),

        // Weapon specific
        if (_customType == 'Weapon') ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('Dmg: ', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    DropdownButton<int>(
                      value: _customDamage,
                      dropdownColor: AppColors.surface,
                      items: [1, 2, 3, 4].map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(),
                      onChanged: (v) => setState(() => _customDamage = v ?? 1),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Text('Bonus: ', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                    DropdownButton<int>(
                      value: _customBonus,
                      dropdownColor: AppColors.surface,
                      items: [0, 1, 2, 3].map((b) => DropdownMenuItem(value: b, child: Text('+$b'))).toList(),
                      onChanged: (v) => setState(() => _customBonus = v ?? 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],

        // Armor specific
        if (_customType == 'Armor') ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Protection Rating: ', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
              DropdownButton<int>(
                value: _customProtection,
                dropdownColor: AppColors.surface,
                items: [1, 2, 3, 4].map((p) => DropdownMenuItem(value: p, child: Text('$p'))).toList(),
                onChanged: (v) => setState(() => _customProtection = v ?? 1),
              ),
            ],
          ),
        ],

        const SizedBox(height: 12),
        // Description
        TextField(
          controller: _descController,
          maxLines: 2,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
          decoration: const InputDecoration(
            labelText: 'Description / Notes',
            hintText: 'Special effects, lore, or provenance',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) return;
            final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';

            if (_customType == 'Weapon') {
              final weapon = Weapon(
                id: id,
                name: name,
                damage: _customDamage,
                bonus: _customBonus,
                range: WeaponRange.engaged,
                qualities: ['Custom'],
                isEquipped: true,
              );
              widget.playViewModel.addWeapon(weapon);
            } else if (_customType == 'Armor') {
              final armor = Armor(
                id: id,
                name: name,
                protection: _customProtection,
                agilityPenalty: 0,
                isEquipped: true,
              );
              widget.playViewModel.addArmor(armor);
            } else {
              final item = EquipmentItem(
                id: id,
                name: name,
                description: _descController.text.trim(),
                slots: _customSlots,
                isHeavy: _customSlots >= 2,
                quantity: 1,
              );
              widget.playViewModel.addEquipment(item);
            }

            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added $name to inventory.')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceOverlay,
            foregroundColor: AppColors.goldBright,
            side: const BorderSide(color: AppColors.gold),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('CREATE & ADD TO INVENTORY', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
      ],
    );
  }
}
