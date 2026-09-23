import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_portrait.dart';
import 'package:vaesen_beyond/ui/core/utils/responsive.dart';
import 'package:vaesen_beyond/ui/features/builder/views/character_builder_screen.dart';
import 'package:vaesen_beyond/ui/features/castle/views/castle_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/act_screen.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/advancement_card.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/inventory_card.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/party_management_dialog.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/prep_and_lore_card.dart';

class PlayScreen extends StatefulWidget {
  final PlayViewModel viewModel;
  final DiceRollerViewModel diceViewModel;

  const PlayScreen({
    super.key,
    required this.viewModel,
    required this.diceViewModel,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin {
  int _currentNavIndex = 1; // Default to ACT (index 1)
  late TabController _sheetTabController;

  final List<String> _sheetTabs = ['INVENTORY', 'ADVANCEMENT', 'PREP & LORE'];

  @override
  void initState() {
    super.initState();
    _sheetTabController = TabController(length: _sheetTabs.length, vsync: this);
    _sheetTabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _sheetTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        if (widget.viewModel.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            ),
          );
        }

        final character = widget.viewModel.activeCharacter;
        final isWide = Responsive.isWide(context);

        return Scaffold(
          body: IndexedStack(
            index: isWide ? 1 : _currentNavIndex,
            children: [
              // 0: TABLE (Castle Gyllencreutz & Mystery Headquarters)
              CastleScreen(viewModel: widget.viewModel),

              // 1: ACT (The Scandinavian Gothic Combat Cockpit)
              character != null
                  ? ActScreen(
                      character: character,
                      playViewModel: widget.viewModel,
                      diceViewModel: widget.diceViewModel,
                    )
                  : _buildEmptyStateView(context),

              // 2: SHEET (Comprehensive Investigator Dossier)
              character != null
                  ? _buildSheetView(character)
                  : _buildEmptyStateView(context),
            ],
          ),

          // ── Bottom Navigation Bar: Only visible on Mobile (< 900px) ─────
          bottomNavigationBar: isWide
              ? null
              : Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 0.8),
                    ),
                  ),
                  child: NavigationBar(
                    selectedIndex: _currentNavIndex,
                    onDestinationSelected: (idx) => setState(() => _currentNavIndex = idx),
                    backgroundColor: AppColors.surface,
                    indicatorColor: AppColors.gold.withAlpha(50),
                    height: 60,
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.castle_outlined, color: AppColors.textSecondary),
                        selectedIcon: Icon(Icons.castle, color: AppColors.goldBright),
                        label: 'TABLE',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.diamond_outlined, color: AppColors.textSecondary),
                        selectedIcon: Icon(Icons.diamond, color: AppColors.goldBright),
                        label: 'ACT',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.badge_outlined, color: AppColors.textSecondary),
                        selectedIcon: Icon(Icons.badge, color: AppColors.goldBright),
                        label: 'SHEET',
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildEmptyStateView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(200),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: AppColors.gold.withAlpha(25),
                  blurRadius: 14,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withAlpha(25),
                    border: Border.all(color: AppColors.gold, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: AppColors.goldBright,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'SOCIETY ARCHIVES',
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 18,
                    color: AppColors.goldBright,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NO INVESTIGATORS REGISTERED',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.goldDim,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'The halls of Castle Gyllencreutz stand silent. Enroll your first investigator into the order, import an existing dossier, or restore the standard pregenerated roster to begin.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CharacterBuilderScreen(
                            playViewModel: widget.viewModel,
                            onFinished: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add, size: 16, color: Colors.black),
                    label: const Text(
                      'CREATE NEW INVESTIGATOR',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldBright,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => showPartyManagementDialog(context, widget.viewModel),
                    icon: const Icon(Icons.file_download_outlined, size: 16, color: AppColors.gold),
                    label: const Text(
                      'IMPORT DOSSIER (JSON)',
                      style: TextStyle(color: AppColors.gold, fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.gold),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      await widget.viewModel.loadPregenCharacters();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Standard pregenerated investigators restored.')),
                        );
                      }
                    },
                    icon: const Icon(Icons.restart_alt, size: 16, color: AppColors.textMuted),
                    label: const Text(
                      'RESTORE SAMPLE INVESTIGATORS',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── SHEET View: Full Investigator Dossier & Inventory ────────────────────
  Widget _buildSheetView(Character character) {
    return Column(
      children: [
        // Compact Gothic Dossier Header (Identity & Finances)
        _buildDossierHeader(character),

        // Handcrafted Gothic Segmented Tab Control
        _buildGothicTabControl(character),

        // Sub-Tab Content: INVENTORY | ADVANCEMENT | PREP & LORE
        Expanded(
          child: TabBarView(
            controller: _sheetTabController,
            children: [
              // 1. INVENTORY & GEAR
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                children: [
                  InventoryCard(
                    character: character,
                    playViewModel: widget.viewModel,
                    diceViewModel: widget.diceViewModel,
                  ),
                  const SizedBox(height: 24),
                ],
              ),

              // 2. ADVANCEMENT & LEVEL UP (XP, SKILLS, TALENTS)
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                children: [
                  AdvancementCard(
                    character: character,
                    playViewModel: widget.viewModel,
                    diceViewModel: widget.diceViewModel,
                  ),
                  const SizedBox(height: 24),
                ],
              ),

              // 3. PREPARATION, ADVANTAGES & NARRATIVE LORE
              ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                children: [
                  PrepAndLoreCard(
                    character: character,
                    playViewModel: widget.viewModel,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGothicTabControl(Character character) {
    return Container(
      height: 44,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
        children: List.generate(_sheetTabs.length, (index) {
          final isSelected = _sheetTabController.index == index;
          final label = _sheetTabs[index];
          String badgeText = '';
          if (label == 'INVENTORY') {
            final total = character.equipment.length + character.weapons.length + character.armor.length;
            badgeText = '$total';
          } else if (label == 'ADVANCEMENT') {
            badgeText = '${character.experiencePoints} XP';
          } else if (label == 'PREP & LORE' && character.hasActiveAdvantage) {
            badgeText = '+2';
          }

          return Expanded(
            child: GestureDetector(
              onTap: () {
                _sheetTabController.animateTo(index);
                setState(() {});
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
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
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

  Widget _buildDossierHeader(Character character) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          GothicPortrait(
            portraitAsset: character.effectivePortraitAsset,
            width: 44,
            height: 44,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.gold, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(120),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            fallbackInitial: character.name,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  character.name,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.goldBright,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.gold.withAlpha(60), width: 0.6),
                      ),
                      child: Text(
                        character.archetypeName.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.gold,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'AGE ${character.actualAge}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _financePill('RES', character.resources),
              const SizedBox(width: 6),
              _financePill('CAP', character.capital),
            ],
          ),
        ],
      ),
    );
  }

  Widget _financePill(String label, int val) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.goldDim, width: 0.8),
      ),
      child: Text(
        '$label: $val',
        style: AppTypography.titleSmall.copyWith(
          fontSize: 10,
          color: AppColors.gold,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
