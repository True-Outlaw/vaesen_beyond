import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/utils/responsive.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/advancement_card.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/combat_action_dial.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/condition_arc_hud.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/conditions_card.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/dossier_compact_header.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/inventory_card.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/investigator_party_bar.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/prep_and_lore_card.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/tactile_weapon_cards.dart';

class ActScreen extends StatefulWidget {
  final Character character;
  final PlayViewModel playViewModel;
  final DiceRollerViewModel diceViewModel;

  const ActScreen({
    super.key,
    required this.character,
    required this.playViewModel,
    required this.diceViewModel,
  });

  @override
  State<ActScreen> createState() => _ActScreenState();
}

class _ActScreenState extends State<ActScreen> {
  int _rightTabIndex = 0; // 0: INVENTORY, 1: PREP & LORE

  @override
  Widget build(BuildContext context) {
    final isWide = Responsive.isWide(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundDark,
      ),
      child: isWide ? _buildDesktopLayout(context) : _buildMobileLayout(context),
    );
  }

  // ── Mobile Layout (< 900px): Preserved exact single-column cockpit ─────────
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // 1. Top Investigator Party Strip with Initiative Roller
        InvestigatorPartyBar(
          viewModel: widget.playViewModel,
          diceViewModel: widget.diceViewModel,
        ),

        // 2. Main Scrollable Action Cockpit
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 6),

                // Character HUD with 6-Arc Condition Gauge & Armor Shield
                ConditionArcHud(
                  character: widget.character,
                  viewModel: widget.playViewModel,
                  diceViewModel: widget.diceViewModel,
                ),

                const SizedBox(height: 4),

                // Centerpiece: The Sculpted 4-Attribute Action Dial
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: CombatActionDial(
                    character: widget.character,
                    playViewModel: widget.playViewModel,
                    diceViewModel: widget.diceViewModel,
                  ),
                ),

                const SizedBox(height: 6),

                // Bottom Docked Tactile Weapon Cards & Memento Ribbon
                TactileWeaponCards(
                  character: widget.character,
                  playViewModel: widget.playViewModel,
                  diceViewModel: widget.diceViewModel,
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Desktop / Web Layout (>= 900px): 3 Columns with Sheet Data flanking Dial ─
  Widget _buildDesktopLayout(BuildContext context) {
    return Column(
      children: [
        // 1. Top Investigator Party Strip
        InvestigatorPartyBar(
          viewModel: widget.playViewModel,
          diceViewModel: widget.diceViewModel,
        ),

        // 2. 3-Column Workstation: Left (Dossier & Skills) | Center (Dial & Actions) | Right (Gear & Lore)
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double sideColWidth = (constraints.maxWidth * 0.28).clamp(350.0, 420.0);

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── LEFT COLUMN: Pinned to Left Edge ──
                  SizedBox(
                    width: sideColWidth,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: AppColors.border, width: 0.8),
                        ),
                      ),
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                        children: [
                          DossierCompactHeader(character: widget.character),
                          const SizedBox(height: 12),
                          ConditionsCard(
                            character: widget.character,
                            viewModel: widget.playViewModel,
                          ),
                          const SizedBox(height: 12),
                          AdvancementCard(
                            character: widget.character,
                            playViewModel: widget.playViewModel,
                            diceViewModel: widget.diceViewModel,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── CENTER COLUMN: Live Cockpit with Giant Action Dial ──────────
                  Expanded(
                    child: Column(
                      children: [
                        // Giant Wheel in Center (Clean, no duplicate portrait)
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: CombatActionDial(
                                character: widget.character,
                                playViewModel: widget.playViewModel,
                                diceViewModel: widget.diceViewModel,
                                maxDialSize: 620.0,
                              ),
                            ),
                          ),
                        ),

                        // Docked at Bottom of Screen
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.border, width: 0.6),
                            ),
                          ),
                          child: TactileWeaponCards(
                            character: widget.character,
                            playViewModel: widget.playViewModel,
                            diceViewModel: widget.diceViewModel,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── RIGHT COLUMN: Pinned to Right Edge ──────────
                  SizedBox(
                    width: sideColWidth,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(color: AppColors.border, width: 0.8),
                        ),
                      ),
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 20),
                        children: [
                          _buildRightTabControl(widget.character),
                          const SizedBox(height: 8),
                          if (_rightTabIndex == 0)
                            InventoryCard(
                              character: widget.character,
                              playViewModel: widget.playViewModel,
                              diceViewModel: widget.diceViewModel,
                            )
                          else
                            PrepAndLoreCard(
                              character: widget.character,
                              playViewModel: widget.playViewModel,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRightTabControl(Character character) {
    final tabs = ['INVENTORY', 'PREP & LORE'];

    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.goldDim.withAlpha(70), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _rightTabIndex == index;
          final label = tabs[index];
          String badgeText = '';
          if (label == 'INVENTORY') {
            final total = character.equipment.length + character.weapons.length + character.armor.length;
            badgeText = '$total';
          } else if (label == 'PREP & LORE' && character.hasActiveAdvantage) {
            badgeText = '+2';
          }

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _rightTabIndex = index);
              },
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surfaceOverlay : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: isSelected ? AppColors.gold.withAlpha(160) : Colors.transparent,
                    width: 0.8,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.gold.withAlpha(30),
                            blurRadius: 6,
                          )
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? AppColors.goldBright : AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badgeText.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.gold.withAlpha(40) : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.gold : AppColors.goldDim.withAlpha(80),
                            width: 0.6,
                          ),
                        ),
                        child: Text(
                          badgeText,
                          style: TextStyle(
                            color: isSelected ? AppColors.goldBright : AppColors.goldDim,
                            fontSize: 8,
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
        }),
      ),
    );
  }
}
