import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/add_item_sheet.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dice_tray_dialog.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/edit_gear_sheet.dart';

class InventoryCard extends StatelessWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  const InventoryCard({
    super.key,
    required this.character,
    required this.playViewModel,
    required this.diceViewModel,
  });

  void _rollArmorProtection(BuildContext context, int protection, {String? title}) {
    if (protection <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No armor protection to absorb damage.'),
          backgroundColor: AppColors.surfaceOverlay,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    diceViewModel.rollCustomPool(
      poolSize: protection,
      title: title ?? 'Armor Protection Roll',
      breakdown: 'Rolling $protection Armor dice. Each 6 absorbs 1 damage.',
    );
    showDialog(
      context: context,
      builder: (_) => DiceTrayDialog(
        diceViewModel: diceViewModel,
        playViewModel: playViewModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carry = character.currentCarryWeight;
    final maxCarry = character.maxCarrySlots;
    final isOver = character.isEncumbered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. WEALTH & FINANCES CARD ───────────────────────────────────────
        GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined, color: AppColors.gold, size: 18),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'GEAR & FINANCES',
                            style: AppTypography.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => AddItemSheet(playViewModel: playViewModel),
                      );
                    },
                    icon: const Icon(Icons.add, size: 13, color: AppColors.goldBright),
                    label: const Text('ADD GEAR', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceOverlay,
                      foregroundColor: AppColors.goldBright,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: const BorderSide(color: AppColors.gold, width: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Wealth Steppers
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.goldDim.withAlpha(80), width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'RESOURCES',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.goldDim,
                              fontSize: 9,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 14, color: AppColors.textMuted),
                                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                padding: EdgeInsets.zero,
                                onPressed: character.resources > 0
                                    ? () => playViewModel.updateWealth(resources: character.resources - 1)
                                    : null,
                              ),
                              Container(
                                constraints: const BoxConstraints(minWidth: 24),
                                alignment: Alignment.center,
                                child: Text(
                                  '${character.resources}',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.goldBright,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 14, color: AppColors.gold),
                                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                padding: EdgeInsets.zero,
                                onPressed: character.resources < 10
                                    ? () => playViewModel.updateWealth(resources: character.resources + 1)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.goldDim.withAlpha(80), width: 0.8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'CAPITAL',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.goldDim,
                              fontSize: 9,
                              letterSpacing: 0.8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 14, color: AppColors.textMuted),
                                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                padding: EdgeInsets.zero,
                                onPressed: character.capital > 0
                                    ? () => playViewModel.updateWealth(capital: character.capital - 1)
                                    : null,
                              ),
                              Container(
                                constraints: const BoxConstraints(minWidth: 24),
                                alignment: Alignment.center,
                                child: Text(
                                  '${character.capital}',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.goldBright,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 14, color: AppColors.gold),
                                constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                padding: EdgeInsets.zero,
                                onPressed: () => playViewModel.updateWealth(capital: character.capital + 1),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Encumbrance Bar
              Row(
                children: [
                  Icon(
                    Icons.backpack_outlined,
                    size: 16,
                    color: isOver ? AppColors.physicalCondition : AppColors.gold,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Carrying: $carry / $maxCarry slots (Physique + 2)',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isOver ? AppColors.physicalCondition : AppColors.textPrimary,
                                  fontWeight: isOver ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isOver) ...[
                              const SizedBox(width: 4),
                              Text(
                                'ENCUMBERED (-2 Agility)',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.physicalCondition,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: (carry / (maxCarry > 0 ? maxCarry : 1)).clamp(0.0, 1.0),
                          backgroundColor: AppColors.surfaceOverlay,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isOver ? AppColors.physicalCondition : AppColors.gold,
                          ),
                          minHeight: 5,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── 2. WEAPONS SECTION ──────────────────────────────────────────────
        GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shield_outlined, color: AppColors.gold, size: 16),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'WEAPONS & ARSENAL',
                            style: AppTypography.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('${character.weapons.length} ITEMS', style: AppTypography.labelSmall.copyWith(color: AppColors.goldDim, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 8),
              if (character.weapons.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('No weapons equipped. Tap "+ ADD GEAR" to equip weapons.', style: AppTypography.bodySmall),
                )
              else
                ...character.weapons.map((w) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: w.isEquipped ? AppColors.gold.withAlpha(120) : AppColors.border,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      w.name,
                                      style: AppTypography.titleSmall.copyWith(
                                        color: w.isEquipped ? AppColors.goldBright : AppColors.textPrimary,
                                        fontSize: 13,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (w.isEquipped) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.gold.withAlpha(40),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: const Text(
                                        'READY',
                                        style: TextStyle(color: AppColors.gold, fontSize: 8, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Dmg: ${w.damage}  •  Bonus: +${w.bonus}  •  Range: ${w.range.label}',
                                style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        // Equip toggle
                        IconButton(
                          icon: Icon(
                            w.isEquipped ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 18,
                            color: w.isEquipped ? AppColors.gold : AppColors.textMuted,
                          ),
                          tooltip: w.isEquipped ? 'Equipped' : 'Stowed',
                          onPressed: () => playViewModel.toggleEquipWeapon(w.id),
                        ),
                        // Roll attack
                        IconButton(
                          icon: const Icon(Icons.casino, size: 18, color: AppColors.goldBright),
                          tooltip: 'Attack Roll',
                          onPressed: () {
                            diceViewModel.rollWeapon(character: character, weapon: w);
                            showDialog(
                              context: context,
                              builder: (_) => DiceTrayDialog(
                                diceViewModel: diceViewModel,
                                playViewModel: playViewModel,
                              ),
                            );
                          },
                        ),
                        // Edit weapon
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.goldDim),
                          tooltip: 'Edit Weapon',
                          onPressed: () => showEditWeaponSheet(context, w, playViewModel),
                        ),
                        // Drop
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.crimsonLight),
                          tooltip: 'Drop Weapon',
                          onPressed: () => playViewModel.removeWeapon(w.id),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── 3. ARMOR SECTION ────────────────────────────────────────────────
        GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.security, color: AppColors.gold, size: 16),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'ARMOR & PROTECTION',
                            style: AppTypography.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => _rollArmorProtection(
                      context,
                      character.totalArmorProtection,
                      title: 'Total Armor Protection Roll',
                    ),
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: character.totalArmorProtection > 0
                              ? AppColors.gold.withAlpha(160)
                              : AppColors.goldDim,
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.casino, size: 12, color: AppColors.goldBright),
                          const SizedBox(width: 4),
                          Text(
                            'ARMOR: ${character.totalArmorProtection}',
                            style: AppTypography.titleSmall.copyWith(
                              fontSize: 9,
                              color: AppColors.goldBright,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (character.armor.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('No armor equipped. Ordinary Clothing (0 Protection).', style: AppTypography.bodySmall),
                )
              else
                ...character.armor.map((a) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: a.isEquipped ? AppColors.gold.withAlpha(120) : AppColors.border,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.name,
                                style: AppTypography.titleSmall.copyWith(
                                  color: a.isEquipped ? AppColors.goldBright : AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Protection: +${a.protection}  •  Agility Penalty: ${a.agilityPenalty}',
                                style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            a.isEquipped ? Icons.check_circle : Icons.radio_button_unchecked,
                            size: 18,
                            color: a.isEquipped ? AppColors.gold : AppColors.textMuted,
                          ),
                          tooltip: a.isEquipped ? 'Worn' : 'Carried',
                          onPressed: () => playViewModel.toggleEquipArmor(a.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.casino, size: 18, color: AppColors.goldBright),
                          tooltip: 'Roll Protection (+${a.protection} D6)',
                          onPressed: () => _rollArmorProtection(
                            context,
                            a.protection,
                            title: '${a.name} Protection Roll',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.goldDim),
                          tooltip: 'Edit Armor',
                          onPressed: () => showEditArmorSheet(context, a, playViewModel),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.crimsonLight),
                          tooltip: 'Drop Armor',
                          onPressed: () => playViewModel.removeArmor(a.id),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── 4. ADVENTURING GEAR ─────────────────────────────────────────────
        GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inventory_2_outlined, color: AppColors.gold, size: 16),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'ADVENTURING GEAR',
                            style: AppTypography.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text('${character.equipment.length} TYPES', style: AppTypography.labelSmall.copyWith(color: AppColors.goldDim, fontSize: 10)),
                ],
              ),
              const SizedBox(height: 8),
              if (character.equipment.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('No general equipment carried. Tap "+ ADD GEAR" to pack items.', style: AppTypography.bodySmall),
                )
              else
                ...character.equipment.map((eq) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border, width: 0.6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(eq.name, style: AppTypography.titleSmall.copyWith(fontSize: 13, color: AppColors.goldBright)),
                              if (eq.description.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(eq.description, style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted)),
                              ],
                              const SizedBox(height: 2),
                              Text('Weight: ${eq.slots} slot${eq.slots > 1 ? "s" : ""} ${eq.isHeavy ? "(Heavy)" : ""}', style: const TextStyle(color: AppColors.goldDim, fontSize: 9)),
                            ],
                          ),
                        ),
                        // Quantity stepper
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 14, color: AppColors.textMuted),
                              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                              padding: EdgeInsets.zero,
                              onPressed: eq.quantity > 1 ? () => playViewModel.updateEquipmentQuantity(eq.id, -1) : null,
                            ),
                            Text('${eq.quantity}', style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12)),
                            IconButton(
                              icon: const Icon(Icons.add, size: 14, color: AppColors.gold),
                              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                              padding: EdgeInsets.zero,
                              onPressed: () => playViewModel.updateEquipmentQuantity(eq.id, 1),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.goldDim),
                          tooltip: 'Edit Item',
                          onPressed: () => showEditEquipmentSheet(context, eq, playViewModel),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.crimsonLight),
                          tooltip: 'Drop Item',
                          onPressed: () => playViewModel.removeEquipment(eq.id),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}
