import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/features/castle/views/castle_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/act_screen.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/advancement_card.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/inventory_card.dart';
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
        if (character == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Investigators Found', style: AppTypography.titleLarge),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => widget.viewModel.initialize(),
                    child: const Text('RELOAD ARCHIVES'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentNavIndex,
            children: [
              // 0: TABLE (Castle Gyllencreutz & Mystery Headquarters)
              _buildTableView(character),

              // 1: ACT (The Scandinavian Gothic Combat Cockpit)
              ActScreen(
                character: character,
                playViewModel: widget.viewModel,
                diceViewModel: widget.diceViewModel,
              ),

              // 2: SHEET (Comprehensive Investigator Dossier)
              _buildSheetView(character),
            ],
          ),

          // ── 3-Tab Bottom Navigation Bar ─────────────────────────────────
          bottomNavigationBar: Container(
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

  String _getPortraitAsset(Character character) {
    final lower = character.archetypeName.toLowerCase();
    if (lower.contains('doctor')) return 'assets/images/portraits/astrid.jpg';
    if (lower.contains('officer')) return 'assets/images/portraits/birger.jpg';
    if (lower.contains('occultist')) return 'assets/images/portraits/elias.jpg';
    if (lower.contains('hunter')) return 'assets/images/portraits/johan.jpg';
    final portraits = [
      'assets/images/portraits/astrid.jpg',
      'assets/images/portraits/birger.jpg',
      'assets/images/portraits/elias.jpg',
      'assets/images/portraits/johan.jpg',
    ];
    return portraits[character.id.hashCode.abs() % portraits.length];
  }

  // ── TABLE View: Castle Gyllencreutz & Mystery Headquarters ────────────────
  Widget _buildTableView(Character character) {
    return CastleScreen(viewModel: widget.viewModel);
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.gold, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(120),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                _getPortraitAsset(character),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.surfaceLight,
                  child: const Icon(Icons.person, color: AppColors.gold, size: 24),
                ),
              ),
            ),
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
