import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaesen_beyond/data/datasources/local_storage_service.dart';
import 'package:vaesen_beyond/data/seed/archetypes_data.dart';
import 'package:vaesen_beyond/data/seed/gear_data.dart';
import 'package:vaesen_beyond/data/seed/injuries_data.dart';
import 'package:vaesen_beyond/data/seed/talents_data.dart';
import 'package:vaesen_beyond/data/seed/vaesen_bestiary_data.dart';
import 'package:vaesen_beyond/domain/models/archetype.dart';
import 'package:vaesen_beyond/domain/models/critical_injury.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/domain/models/talent.dart';
import 'package:vaesen_beyond/domain/models/vaesen_creature.dart';
import 'package:vaesen_beyond/l10n/app_localizations.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/utils/responsive.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:vaesen_beyond/ui/features/compendium/views/widgets/create_talent_dialog.dart';

class _CompendiumRule {
  final String title;
  final String body;
  const _CompendiumRule(this.title, this.body);
}

class CompendiumScreen extends StatefulWidget {
  final bool? initialBestiaryEnabled;
  final String? initialBestiaryMode;
  final int? initialTabIndex;

  const CompendiumScreen({
    super.key,
    this.initialBestiaryEnabled,
    this.initialBestiaryMode,
    this.initialTabIndex,
  });

  @override
  State<CompendiumScreen> createState() => _CompendiumScreenState();
}

class _CompendiumScreenState extends State<CompendiumScreen> {
  // Tabs: -1 = ALL (when search active), 0 = Bestiary, 1 = Archetypes, 2 = Talents, 3 = Critical Injuries, 4 = Weapons & Gear, 5 = Rules
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialTabIndex != null) {
      _selectedTab = widget.initialTabIndex!;
    }
  }
  String _searchQuery = '';
  String _selectedBestiaryCategory = 'All';
  String _selectedInjuryFilter = 'All';
  String _selectedGearFilter = 'All';

  String _localBestiaryMode = 'locked';
  bool _initializedBestiarySetting = false;
  List<Talent> _customTalentsList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initializedBestiarySetting) {
      _initializedBestiarySetting = true;
      if (widget.initialBestiaryMode != null) {
        _localBestiaryMode = widget.initialBestiaryMode!;
        try {
          final playVm = Provider.of<PlayViewModel>(context, listen: false);
          playVm.setBestiaryMode(widget.initialBestiaryMode!);
        } catch (_) {}
      } else if (widget.initialBestiaryEnabled != null) {
        _localBestiaryMode = widget.initialBestiaryEnabled! ? 'gamemaster' : 'locked';
        try {
          final playVm = Provider.of<PlayViewModel>(context, listen: false);
          playVm.setBestiaryEnabled(widget.initialBestiaryEnabled!);
        } catch (_) {}
      } else {
        try {
          final playVm = Provider.of<PlayViewModel>(context, listen: false);
          _localBestiaryMode = playVm.bestiaryMode;
        } catch (_) {
          _loadBestiarySettingFromStorage();
        }
      }
    }
  }

  Future<void> _loadBestiarySettingFromStorage() async {
    final mode = await LocalStorageService().getBestiaryMode();
    final customTalents = await LocalStorageService().loadCustomTalents();
    if (mounted) {
      setState(() {
        _localBestiaryMode = mode;
        _customTalentsList = customTalents;
      });
    }
  }

  String get _bestiaryMode {
    try {
      final playVm = Provider.of<PlayViewModel>(context);
      return playVm.bestiaryMode;
    } catch (_) {
      return _localBestiaryMode;
    }
  }

  List<Talent> get _allAvailableTalents {
    try {
      final playVm = Provider.of<PlayViewModel>(context);
      return playVm.allAvailableTalents;
    } catch (_) {
      final customIds = _customTalentsList.map((t) => t.id).toSet();
      return [
        ...TalentsData.allTalents.where((t) => !customIds.contains(t.id)),
        ..._customTalentsList,
      ];
    }
  }

  bool get _isBestiaryActive {
    return _bestiaryMode == 'gamemaster' || _bestiaryMode == 'playerLore';
  }

  bool get _isGamemaster {
    return _bestiaryMode == 'gamemaster';
  }

  Future<void> _setBestiaryMode(String mode) async {
    setState(() {
      _localBestiaryMode = mode;
    });
    try {
      final playVm = Provider.of<PlayViewModel>(context, listen: false);
      await playVm.setBestiaryMode(mode);
    } catch (_) {
      await LocalStorageService().setBestiaryMode(mode);
    }
    if (mounted) {
      final String msg = mode == 'gamemaster'
          ? 'Gamemaster Mode enabled: Society Bestiary unlocked.'
          : mode == 'playerLore'
              ? 'Player Folklore Archive enabled: Creature lore unlocked with fog-of-war.'
              : 'Gamemaster Mode disabled: Bestiary locked (spoiler protection active).';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: AppColors.gold),
          ),
          content: Text(
            msg,
            style: const TextStyle(color: AppColors.goldBright, fontSize: 12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _toggleBestiary(bool enabled) async {
    await _setBestiaryMode(enabled ? 'gamemaster' : 'locked');
  }

  void _openCreateTalentDialog() async {
    PlayViewModel? playVm;
    try {
      playVm = Provider.of<PlayViewModel>(context, listen: false);
    } catch (_) {}
    final created = await showDialog<Talent>(
      context: context,
      builder: (_) => CreateTalentDialog(playViewModel: playVm),
    );
    if (created != null && mounted) {
      final customTalents = await LocalStorageService().loadCustomTalents();
      setState(() {
        _customTalentsList = customTalents;
      });
    }
  }

  void _deleteHomebrewTalent(Talent talent) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.crimsonLight),
        ),
        title: Text(AppLocalizations.of(context)?.deleteHomebrewTalentTitle ?? 'Delete Homebrew Talent?', style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright)),
        content: Text(AppLocalizations.of(context)?.deleteHomebrewTalentPrompt(talent.name) ?? 'Are you sure you want to permanently remove "${talent.name}" from the Compendium?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(context)?.cancel ?? 'CANCEL', style: const TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.crimson),
            child: Text(AppLocalizations.of(context)?.delete ?? 'DELETE', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        final playVm = Provider.of<PlayViewModel>(context, listen: false);
        await playVm.deleteCustomTalent(talent.id);
      } catch (_) {
        final list = await LocalStorageService().loadCustomTalents();
        list.removeWhere((t) => t.id == talent.id);
        await LocalStorageService().saveCustomTalents(list);
      }
      final customTalents = await LocalStorageService().loadCustomTalents();
      if (mounted) {
        setState(() {
          _customTalentsList = customTalents;
        });
      }
    }
  }

  static const List<_CompendiumRule> _rulesList = [
    _CompendiumRule(
      'PUSHING THE ROLL',
      'If you fail a skill test or want more successes (6s), you can Push the roll once. You immediately take 1 Condition (Physical or Mental matching the attribute tested), keep all 6s, and re-roll all other dice.',
    ),
    _CompendiumRule(
      'FEAR TESTS',
      'When encountering a vaesen or experiencing horror, roll Logic or Empathy + allies in your zone (max +3) - Mental conditions vs the monster’s Fear Value. Failure causes you to become Terrified for 1D6 rounds.',
    ),
    _CompendiumRule(
      'CONDITIONS & BECOMING BROKEN',
      'Each physical condition inflicts -1 die on all Physical checks. Each mental condition inflicts -1 die on all Mental checks. Taking a 4th condition breaks your investigator and requires rolling on the Critical Injury table.',
    ),
    _CompendiumRule(
      'MEMENTO SOLACE',
      'Once per mystery, you can hold your Memento to steady your resolve. This immediately clears 1 Physical or Mental condition.',
    ),
    _CompendiumRule(
      'EXPERIENCE & ADVANCEMENT',
      'At the end of each session, answer the end-of-session questions. Each "Yes" grants 1 XP. 5 XP can be spent to increase a Skill by +1 (max 5) or learn a new Talent. Attributes never increase through XP.',
    ),
    _CompendiumRule(
      'COMBAT TURNS & INITIATIVE',
      'Combat takes place in rounds. At the start of combat, 10 unique cards numbered 1–10 are dealt to participants. Lowest number acts first. On your turn you get 1 Fast action and 1 Slow action, or 2 Fast actions.',
    ),
    _CompendiumRule(
      'ZONES & RANGE',
      'Combat distances are divided into four categories: Arm’s Length (hand-to-hand), Near (same zone), Short (adjacent zone), and Long (up to two zones away). Moving between zones requires a fast action.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.trim().toLowerCase();
    final isSearching = query.isNotEmpty;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = Responsive.isWide(context);
    final isDesktop = screenWidth >= 1400;

    // Filtered lists for all categories
    final bestiaryMatches = _filterBestiary(query);
    final archetypeMatches = _filterArchetypes(query);
    final talentMatches = _filterTalents(query);
    final injuryMatches = _filterInjuries(query);
    final weaponsMatches = _filterWeapons(query);
    final armorMatches = _filterArmor(query);
    final equipmentMatches = _filterEquipment(query);
    final gearMatchesCount = weaponsMatches.length + armorMatches.length + equipmentMatches.length;
    final ruleMatches = _filterRules(query);

    final totalMatches = bestiaryMatches.length +
        archetypeMatches.length +
        talentMatches.length +
        injuryMatches.length +
        gearMatchesCount +
        ruleMatches.length;

    // Responsive column distribution
    final bestiaryColumns = isWide ? 2 : 1;
    final archetypeColumns = isDesktop ? 3 : (isWide ? 2 : 1);
    final talentColumns = isDesktop ? 3 : (isWide ? 2 : 1);
    final injuryColumns = isDesktop ? 3 : (isWide ? 2 : 1);
    final gearColumns = isDesktop ? 3 : (isWide ? 2 : 1);
    final rulesColumns = isWide ? 2 : 1;

    return Scaffold(
      appBar: AppBar(
        title: isWide
            ? Row(
                children: [
                  const Icon(Icons.auto_stories, color: AppColors.goldBright, size: 22),
                  const SizedBox(width: 10),
                  Text(AppLocalizations.of(context)?.societyCompendium ?? 'SOCIETY COMPENDIUM', style: AppTypography.titleLarge),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Text(
                      'REFERENCE ARCHIVE',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.gold,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              )
            : Text(AppLocalizations.of(context)?.societyCompendium ?? 'SOCIETY COMPENDIUM', style: AppTypography.titleLarge),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Compendium Access Level: ${_bestiaryMode == "gamemaster" ? "Gamemaster" : _bestiaryMode == "playerLore" ? "Player Lore" : "Locked"}',
            initialValue: _bestiaryMode,
            onSelected: (mode) => _setBestiaryMode(mode),
            color: AppColors.surface,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: AppColors.gold, width: 0.8),
            ),
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _bestiaryMode == 'gamemaster'
                      ? Icons.lock_open
                      : _bestiaryMode == 'playerLore'
                          ? Icons.auto_stories
                          : Icons.lock_outline,
                  color: _bestiaryMode == 'gamemaster'
                      ? AppColors.goldBright
                      : _bestiaryMode == 'playerLore'
                          ? AppColors.gold
                          : AppColors.crimsonLight,
                  size: 20,
                ),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_drop_down, color: AppColors.goldDim, size: 16),
              ],
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'gamemaster',
                child: Row(
                  children: [
                    const Icon(Icons.shield, color: AppColors.goldBright, size: 18),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GAMEMASTER (FULL ACCESS)',
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.goldBright,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Full stats, attacks, secrets & player reveals',
                          style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'playerLore',
                child: Row(
                  children: [
                    const Icon(Icons.auto_stories, color: AppColors.gold, size: 18),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PLAYER LORE (FOLKLORE ARCHIVE)',
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Folklore & habitats; combat stats redacted',
                          style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'locked',
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: AppColors.crimsonLight, size: 18),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOCKED (CONFIDENTIAL VAULT)',
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.crimsonLight,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Bestiary locked with spoiler warning gatekeeper',
                          style: AppTypography.bodySmall.copyWith(fontSize: 10, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 16,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    if (isSearching) ...[
                      _tabChip('ALL ($totalMatches)', -1, isSelected: _selectedTab == -1),
                      const SizedBox(width: 8),
                    ],
                    _tabChip(
                      isSearching
                          ? '${AppLocalizations.of(context)?.tabBestiary ?? "BESTIARY"} (${bestiaryMatches.length})'
                          : (AppLocalizations.of(context)?.tabBestiary ?? 'BESTIARY'),
                      0,
                      isSelected: _selectedTab == 0,
                      isLocked: !_isBestiaryActive,
                    ),
                    const SizedBox(width: 8),
                    _tabChip(
                      isSearching
                          ? '${AppLocalizations.of(context)?.tabArchetypes ?? "ARCHETYPES"} (${archetypeMatches.length})'
                          : (AppLocalizations.of(context)?.tabArchetypes ?? 'ARCHETYPES'),
                      1,
                      isSelected: _selectedTab == 1,
                    ),
                    const SizedBox(width: 8),
                    _tabChip(
                      isSearching
                          ? '${AppLocalizations.of(context)?.tabTalents ?? "TALENTS"} (${talentMatches.length})'
                          : (AppLocalizations.of(context)?.tabTalents ?? 'TALENTS'),
                      2,
                      isSelected: _selectedTab == 2,
                    ),
                    const SizedBox(width: 8),
                    _tabChip(
                      isSearching
                          ? '${AppLocalizations.of(context)?.tabInjuries ?? "CRITICAL INJURIES"} (${injuryMatches.length})'
                          : (AppLocalizations.of(context)?.tabInjuries ?? 'CRITICAL INJURIES'),
                      3,
                      isSelected: _selectedTab == 3,
                    ),
                    const SizedBox(width: 8),
                    _tabChip(
                      isSearching
                          ? '${AppLocalizations.of(context)?.tabGear ?? "WEAPONS & GEAR"} ($gearMatchesCount)'
                          : (AppLocalizations.of(context)?.tabGear ?? 'WEAPONS & GEAR'),
                      4,
                      isSelected: _selectedTab == 4,
                    ),
                    const SizedBox(width: 8),
                    _tabChip(
                      isSearching
                          ? '${AppLocalizations.of(context)?.tabRules ?? "RULES REFERENCE"} (${ruleMatches.length})'
                          : (AppLocalizations.of(context)?.tabRules ?? 'RULES REFERENCE'),
                      5,
                      isSelected: _selectedTab == 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Column(
            children: [
              // Global Search Input
              Padding(
                padding: EdgeInsets.fromLTRB(isWide ? 24 : 16, 12, isWide ? 24 : 16, 8),
                child: TextField(
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search bestiary, archetypes, talents, injuries, gear, rules...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: AppColors.gold),
                    suffixIcon: isSearching
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.goldDim, size: 18),
                            onPressed: () => setState(() {
                              _searchQuery = '';
                              if (_selectedTab == -1) _selectedTab = 0;
                            }),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.goldBright, width: 1.2),
                    ),
                    isDense: true,
                  ),
                  onChanged: (val) => setState(() {
                    _searchQuery = val;
                  }),
                ),
              ),

              // Sub-category filters for Bestiary tab
              if (_selectedTab == 0 && _isBestiaryActive) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16, vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: VaesenBestiaryData.categories.map((cat) {
                        final isSelected = _selectedBestiaryCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(cat),
                            selected: isSelected,
                            selectedColor: AppColors.goldBright,
                            backgroundColor: AppColors.surfaceLight,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (_) => setState(() => _selectedBestiaryCategory = cat),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],

              // Sub-category filters for Critical Injuries tab
              if (_selectedTab == 3) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16, vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Physical', 'Mental', 'Lethal'].map((filter) {
                        final isSelected = _selectedInjuryFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            selectedColor: AppColors.goldBright,
                            backgroundColor: AppColors.surfaceLight,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (_) => setState(() => _selectedInjuryFilter = filter),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],

              // Sub-category filters for Weapons & Gear tab
              if (_selectedTab == 4) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 24 : 16, vertical: 4),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Weapons', 'Armor & Protection', 'Common Equipment'].map((filter) {
                        final isSelected = _selectedGearFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            selectedColor: AppColors.goldBright,
                            backgroundColor: AppColors.surfaceLight,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.black : AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (_) => setState(() => _selectedGearFilter = filter),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],

              // Content List
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 24 : 16,
                    vertical: 8,
                  ),
                  children: _buildTabContent(
                    bestiaryMatches: bestiaryMatches,
                    archetypeMatches: archetypeMatches,
                    talentMatches: talentMatches,
                    injuryMatches: injuryMatches,
                    weaponsMatches: weaponsMatches,
                    armorMatches: armorMatches,
                    equipmentMatches: equipmentMatches,
                    ruleMatches: ruleMatches,
                    totalMatches: totalMatches,
                    bestiaryColumns: bestiaryColumns,
                    archetypeColumns: archetypeColumns,
                    talentColumns: talentColumns,
                    injuryColumns: injuryColumns,
                    gearColumns: gearColumns,
                    rulesColumns: rulesColumns,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabChip(String label, int index, {required bool isSelected, bool isLocked = false}) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (isLocked) ...[
            const SizedBox(width: 4),
            const Icon(Icons.lock_outline, size: 12, color: AppColors.crimsonLight),
          ],
        ],
      ),
      selected: isSelected,
      selectedColor: AppColors.goldBright,
      backgroundColor: AppColors.surfaceLight,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
      onSelected: (_) => setState(() => _selectedTab = index),
    );
  }

  // --- Grid / Column Helpers ---

  /// Distributes items across [columnCount] vertical columns within a single Row
  /// for optimal responsive masonry flow without unconstrained height errors.
  List<Widget> _wrapInColumns(
    List<Widget> items,
    int columnCount, {
    double spacing = 16,
  }) {
    if (items.isEmpty) return const <Widget>[];
    if (columnCount <= 1 || items.length <= 1) return items;

    final columns = List.generate(columnCount, (_) => <Widget>[]);
    for (int i = 0; i < items.length; i++) {
      columns[i % columnCount].add(items[i]);
    }

    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < columnCount; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: columns[i],
              ),
            ),
          ],
        ],
      ),
    ];
  }

  // --- Search Filter Helpers ---

  List<VaesenCreature> _filterBestiary(String query) {
    if (!_isBestiaryActive) return [];
    var list = VaesenBestiaryData.allCreatures;
    if (_selectedTab == 0 && _selectedBestiaryCategory != 'All') {
      list = list.where((c) => c.category == _selectedBestiaryCategory).toList();
    }
    if (query.isEmpty) return list;
    final clean = query.trim().toLowerCase();

    final isGM = _isGamemaster;
    PlayViewModel? playVm;
    try {
      playVm = Provider.of<PlayViewModel>(context, listen: false);
    } catch (_) {}

    return list.where((c) {
      if (c.name.toLowerCase().contains(clean) ||
          c.swedishName.toLowerCase().contains(clean) ||
          c.category.toLowerCase().contains(clean) ||
          c.description.toLowerCase().contains(clean) ||
          c.habitat.toLowerCase().contains(clean)) {
        return true;
      }
      if (isGM || (playVm?.isSectionRevealed(c.name, 'weaknesses') ?? false)) {
        if (c.weaknesses.any((w) => w.toLowerCase().contains(clean))) return true;
      }
      if (isGM || (playVm?.isSectionRevealed(c.name, 'rituals') ?? false)) {
        if (c.ritualsOfBanishment.any((r) => r.toLowerCase().contains(clean))) return true;
      }
      if (isGM || (playVm?.isSectionRevealed(c.name, 'enchantments') ?? false)) {
        if (c.enchantments.any((e) => e.name.toLowerCase().contains(clean) || e.effect.toLowerCase().contains(clean))) return true;
      }
      if (isGM || (playVm?.isSectionRevealed(c.name, 'attacks') ?? false)) {
        if (c.attacks.any((a) => a.name.toLowerCase().contains(clean) || a.description.toLowerCase().contains(clean))) return true;
      }
      if (isGM || (playVm?.isSectionRevealed(c.name, 'secrets') ?? false)) {
        if (c.secrets.toLowerCase().contains(clean)) return true;
      }
      return false;
    }).toList();
  }

  List<Archetype> _filterArchetypes(String query) {
    if (query.isEmpty) return ArchetypesData.allArchetypes;
    return ArchetypesData.allArchetypes.where((a) {
      return a.name.toLowerCase().contains(query) ||
          a.description.toLowerCase().contains(query) ||
          a.tagline.toLowerCase().contains(query) ||
          a.mainAttribute.label.toLowerCase().contains(query) ||
          a.mainSkill.label.toLowerCase().contains(query);
    }).toList();
  }

  List<Talent> _filterTalents(String query) {
    final all = _allAvailableTalents;
    if (query.isEmpty) return all;
    final clean = query.trim().toLowerCase();
    return all.where((t) {
      return t.name.toLowerCase().contains(clean) ||
          t.effect.toLowerCase().contains(clean) ||
          (t.archetypeName ?? '').toLowerCase().contains(clean) ||
          (t.isCustom && 'homebrew'.contains(clean));
    }).toList();
  }

  List<CriticalInjury> _filterInjuries(String query) {
    var all = [...InjuriesData.physicalInjuries, ...InjuriesData.mentalInjuries];
    if (_selectedTab == 3) {
      if (_selectedInjuryFilter == 'Physical') {
        all = all.where((i) => i.isPhysical).toList();
      } else if (_selectedInjuryFilter == 'Mental') {
        all = all.where((i) => !i.isPhysical).toList();
      } else if (_selectedInjuryFilter == 'Lethal') {
        all = all.where((i) => i.isLethal).toList();
      }
    }
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return all;
    final numericOnly = cleanQuery.replaceAll(RegExp(r'[^0-9]'), '');
    return all.where((i) {
      final matchesName = i.name.toLowerCase().contains(cleanQuery);
      final matchesEffect = i.effect.toLowerCase().contains(cleanQuery);
      final matchesTreatment = i.treatmentSkill.label.toLowerCase().contains(cleanQuery);
      final matchesD66 = (numericOnly.isNotEmpty && i.d66.toString() == numericOnly) ||
          i.d66.toString() == cleanQuery ||
          i.d66.toString().contains(cleanQuery) ||
          'd66: ${i.d66}'.contains(cleanQuery);
      return matchesName || matchesEffect || matchesTreatment || matchesD66;
    }).toList();
  }

  List<Weapon> _filterWeapons(String query) {
    if (query.isEmpty) return GearData.standardWeapons;
    return GearData.standardWeapons.where((w) => w.name.toLowerCase().contains(query)).toList();
  }

  List<Armor> _filterArmor(String query) {
    if (query.isEmpty) return GearData.standardArmor;
    return GearData.standardArmor.where((a) => a.name.toLowerCase().contains(query)).toList();
  }

  List<EquipmentItem> _filterEquipment(String query) {
    if (query.isEmpty) return GearData.commonEquipment;
    return GearData.commonEquipment.where((e) {
      return e.name.toLowerCase().contains(query) ||
          e.description.toLowerCase().contains(query);
    }).toList();
  }

  List<_CompendiumRule> _filterRules(String query) {
    if (query.isEmpty) return _rulesList;
    return _rulesList.where((r) {
      return r.title.toLowerCase().contains(query) ||
          r.body.toLowerCase().contains(query);
    }).toList();
  }

  // --- Content Builders ---

  List<Widget> _buildTabContent({
    required List<VaesenCreature> bestiaryMatches,
    required List<Archetype> archetypeMatches,
    required List<Talent> talentMatches,
    required List<CriticalInjury> injuryMatches,
    required List<Weapon> weaponsMatches,
    required List<Armor> armorMatches,
    required List<EquipmentItem> equipmentMatches,
    required List<_CompendiumRule> ruleMatches,
    required int totalMatches,
    required int bestiaryColumns,
    required int archetypeColumns,
    required int talentColumns,
    required int injuryColumns,
    required int gearColumns,
    required int rulesColumns,
  }) {
    switch (_selectedTab) {
      case -1:
        return _buildAllSearchResults(
          bestiaryMatches: bestiaryMatches,
          archetypeMatches: archetypeMatches,
          talentMatches: talentMatches,
          injuryMatches: injuryMatches,
          weaponsMatches: weaponsMatches,
          armorMatches: armorMatches,
          equipmentMatches: equipmentMatches,
          ruleMatches: ruleMatches,
          totalMatches: totalMatches,
          bestiaryColumns: bestiaryColumns,
          archetypeColumns: archetypeColumns,
          talentColumns: talentColumns,
          injuryColumns: injuryColumns,
          gearColumns: gearColumns,
          rulesColumns: rulesColumns,
        );
      case 0:
        return _buildBestiary(bestiaryMatches, bestiaryColumns);
      case 1:
        return _buildArchetypes(archetypeMatches, archetypeColumns);
      case 2:
        return _buildTalents(talentMatches, talentColumns);
      case 3:
        return _buildInjuries(injuryMatches, injuryColumns);
      case 4:
        return _buildGear(
          weapons: weaponsMatches,
          armor: armorMatches,
          equipment: equipmentMatches,
          columns: gearColumns,
        );
      case 5:
      default:
        return _buildRules(ruleMatches, rulesColumns);
    }
  }

  List<Widget> _buildAllSearchResults({
    required List<VaesenCreature> bestiaryMatches,
    required List<Archetype> archetypeMatches,
    required List<Talent> talentMatches,
    required List<CriticalInjury> injuryMatches,
    required List<Weapon> weaponsMatches,
    required List<Armor> armorMatches,
    required List<EquipmentItem> equipmentMatches,
    required List<_CompendiumRule> ruleMatches,
    required int totalMatches,
    required int bestiaryColumns,
    required int archetypeColumns,
    required int talentColumns,
    required int injuryColumns,
    required int gearColumns,
    required int rulesColumns,
  }) {
    if (totalMatches == 0) {
      return [
        const SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              const Icon(Icons.search_off, size: 48, color: AppColors.goldDim),
              const SizedBox(height: 12),
              Text(
                'No entries found matching "$_searchQuery"',
                style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright),
              ),
              const SizedBox(height: 6),
              Text(
                'Try searching for creature names (Askfrun, Troll), weapons, talents, or rules.',
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ];
    }

    final widgets = <Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          '$totalMatches SEARCH RESULTS ACROSS THE COMPENDIUM',
          style: AppTypography.statValue.copyWith(fontSize: 12, color: AppColors.goldBright),
        ),
      ),
    ];

    if (bestiaryMatches.isNotEmpty) {
      widgets.add(_sectionHeader('VAESEN BESTIARY (${bestiaryMatches.length})', Icons.pets));
      widgets.addAll(_buildBestiary(bestiaryMatches, bestiaryColumns));
      widgets.add(const SizedBox(height: 16));
    }

    if (archetypeMatches.isNotEmpty) {
      widgets.add(_sectionHeader('ARCHETYPES (${archetypeMatches.length})', Icons.badge));
      widgets.addAll(_buildArchetypes(archetypeMatches, archetypeColumns));
      widgets.add(const SizedBox(height: 16));
    }

    if (talentMatches.isNotEmpty) {
      widgets.add(_sectionHeader('TALENTS (${talentMatches.length})', Icons.star));
      widgets.addAll(_buildTalents(talentMatches, talentColumns));
      widgets.add(const SizedBox(height: 16));
    }

    if (injuryMatches.isNotEmpty) {
      widgets.add(_sectionHeader('CRITICAL INJURIES (${injuryMatches.length})', Icons.healing));
      widgets.addAll(_buildInjuries(injuryMatches, injuryColumns));
      widgets.add(const SizedBox(height: 16));
    }

    final gearTotal = weaponsMatches.length + armorMatches.length + equipmentMatches.length;
    if (gearTotal > 0) {
      widgets.add(_sectionHeader('WEAPONS & GEAR ($gearTotal)', Icons.shield));
      widgets.addAll(_buildGear(
        weapons: weaponsMatches,
        armor: armorMatches,
        equipment: equipmentMatches,
        columns: gearColumns,
      ));
      widgets.add(const SizedBox(height: 16));
    }

    if (ruleMatches.isNotEmpty) {
      widgets.add(_sectionHeader('RULES REFERENCE (${ruleMatches.length})', Icons.menu_book));
      widgets.addAll(_buildRules(ruleMatches, rulesColumns));
    }

    return widgets;
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldBright, size: 16),
          const SizedBox(width: 6),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontSize: 13,
              color: AppColors.goldBright,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: AppColors.border, height: 1)),
        ],
      ),
    );
  }

  Widget _sectionSubHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldDim, size: 14),
          const SizedBox(width: 6),
          Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              fontSize: 12,
              color: AppColors.goldBright,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: AppColors.border, height: 1)),
        ],
      ),
    );
  }

  // --- Bestiary UI ---

  List<Widget> _buildBestiary(List<VaesenCreature> creatures, int columns) {
    if (!_isBestiaryActive) {
      return [_buildBestiaryGatekeeper()];
    }

    if (creatures.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              'No creatures found in this folklore category.',
              style: AppTypography.bodySmall,
            ),
          ),
        ),
      ];
    }

    return _wrapInColumns(creatures.map((c) => _buildCreatureCard(c)).toList(), columns);
  }

  Widget _buildBestiaryGatekeeper() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: GothicCard(
            padding: const EdgeInsets.all(28),
            borderColor: AppColors.crimsonLight.withAlpha(160),
            borderWidth: 1.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.crimson.withAlpha(40),
                    border: Border.all(color: AppColors.crimsonLight, width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock_outline,
                      color: AppColors.goldBright,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'CONFIDENTIAL ARCHIVES',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.goldBright,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.crimson.withAlpha(60),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.crimsonLight, width: 0.8),
                  ),
                  child: Text(
                    'GAMEMASTER ACCESS ONLY • SPOILER WARNING',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const OrnateDivider(height: 28),
                Text(
                  'The Society Bestiary details classified supernatural entities, secret weaknesses, magic actions, and sacred banishing rituals.\n\n'
                  'In Vaesen, discovering the truth behind each haunting through investigation, scholarly study, and bravery is the core of the mystery. Reading creature stats in advance will diminish the horror of the unknown.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.gold, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Are you running this mystery as the Gamemaster or preparing an encounter?',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _toggleBestiary(true),
                  icon: const Icon(Icons.lock_open, color: Colors.white, size: 18),
                  label: const Text(
                    'UNLOCK GAMEMASTER BESTIARY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.crimson,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: AppColors.goldBright, width: 1.2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _setBestiaryMode('playerLore'),
                  icon: const Icon(Icons.auto_stories, color: AppColors.goldBright, size: 18),
                  label: const Text(
                    'UNLOCK PLAYER FOLKLORE ARCHIVE',
                    style: TextStyle(
                      color: AppColors.goldBright,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.goldBright,
                    side: const BorderSide(color: AppColors.gold, width: 1.2),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Player Folklore Mode reveals creature descriptions & habitats while redacting combat stats, attacks, and rituals behind GM Fog-of-War.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'You can switch access modes at any time using the lock button in the top bar.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreatureCard(VaesenCreature c) {
    final fearSkulls = '💀 ' * c.fear;
    final isGM = _isGamemaster;
    PlayViewModel? playVm;
    try {
      playVm = Provider.of<PlayViewModel>(context);
    } catch (_) {}

    bool isRevealed(String sectionKey) {
      if (isGM) return true;
      return playVm?.isSectionRevealed(c.name, sectionKey) ?? false;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: GothicCard(
        padding: const EdgeInsets.all(14),
        borderColor: AppColors.border,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Name, Swedish Name, Category & Fear
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name.toUpperCase(),
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 17,
                          color: AppColors.goldBright,
                        ),
                      ),
                      Text(
                        '(${c.swedishName})',
                        style: AppTypography.quote.copyWith(
                          fontSize: 12,
                          color: AppColors.goldDim,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _pill(c.category, AppColors.gold),
                    const SizedBox(height: 4),
                    if (isRevealed('stats'))
                      Wrap(
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 2,
                        children: [
                          Text(
                            'Fear ${c.fear} $fearSkulls'.trim(),
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                              color: AppColors.crimsonLight,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isGM)
                            _revealToggle(c.name, 'stats', playVm?.isSectionRevealed(c.name, 'stats') ?? false),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceOverlay,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.border, width: 0.8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_outline, size: 10, color: AppColors.goldDim),
                            const SizedBox(width: 4),
                            Text(
                              'FEAR: CLASSIFIED',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.goldDim,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Habitat (Always unredacted folkloric knowledge)
            Row(
              children: [
                const Icon(Icons.place_outlined, size: 14, color: AppColors.goldDim),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    c.habitat,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 11,
                      color: AppColors.goldDim,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(c.description, style: AppTypography.bodySmall.copyWith(height: 1.35)),

            const SizedBox(height: 10),

            // 4 Attribute Matrix (Might, Body, Mind, Magic)
            if (isRevealed('stats'))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF141009),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border.withAlpha(120), width: 0.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statBox('MIGHT', c.might),
                    _statBox('BODY', c.body),
                    _statBox('MIND', c.mind),
                    _statBox('MAGIC', c.magic),
                  ],
                ),
              )
            else
              _buildRedactedSection('COMBAT ATTRIBUTES', 'Might, Body, Mind, and Magic ratings remain classified by the Society.'),

            // Supernatural Enchantments (if any)
            if (c.enchantments.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.goldBright, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'ENCHANTMENTS',
                      style: AppTypography.titleSmall.copyWith(fontSize: 12, color: AppColors.goldBright),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isGM)
                    _revealToggle(c.name, 'enchantments', playVm?.isSectionRevealed(c.name, 'enchantments') ?? false)
                  else if (isRevealed('enchantments'))
                    _revealedBadge(),
                ],
              ),
              const SizedBox(height: 6),
              if (isRevealed('enchantments'))
                ...c.enchantments.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              Text(e.name, style: AppTypography.titleSmall.copyWith(fontSize: 12)),
                              _pill(e.costOrTrigger, AppColors.surfaceOverlay),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            e.effect,
                            style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                          ),
                        ],
                      ),
                    ))
              else
                _buildRedactedSection('ENCHANTMENTS', 'Supernatural powers and magical triggers have not been encountered.'),
            ],

            // Attacks (if any)
            if (c.attacks.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.flash_on, color: AppColors.crimsonLight, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'ATTACKS',
                      style: AppTypography.titleSmall.copyWith(fontSize: 12, color: AppColors.crimsonLight),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isGM)
                    _revealToggle(c.name, 'attacks', playVm?.isSectionRevealed(c.name, 'attacks') ?? false)
                  else if (isRevealed('attacks'))
                    _revealedBadge(),
                ],
              ),
              const SizedBox(height: 6),
              if (isRevealed('attacks'))
                ...c.attacks.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a.name, style: AppTypography.titleSmall.copyWith(fontSize: 12)),
                                Text(
                                  a.description,
                                  style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          _pill('Dmg ${a.damage}', AppColors.crimson),
                          const SizedBox(width: 4),
                          _pill(a.range, AppColors.goldDim),
                        ],
                      ),
                    ))
              else
                _buildRedactedSection('ATTACKS', 'Combat forms, damage ratings, and ranges remain undocumented.'),
            ],

            // Weaknesses
            if (c.weaknesses.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.lethal, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'FOLKLORIC WEAKNESSES',
                      style: AppTypography.titleSmall.copyWith(fontSize: 12, color: AppColors.lethal),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isGM)
                    _revealToggle(c.name, 'weaknesses', playVm?.isSectionRevealed(c.name, 'weaknesses') ?? false)
                  else if (isRevealed('weaknesses'))
                    _revealedBadge(),
                ],
              ),
              const SizedBox(height: 4),
              if (isRevealed('weaknesses'))
                ...c.weaknesses.map((w) => Padding(
                      padding: const EdgeInsets.only(left: 6, bottom: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(color: AppColors.lethal, fontSize: 13)),
                          Expanded(
                            child: Text(
                              w,
                              style: AppTypography.bodySmall.copyWith(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ))
              else
                _buildRedactedSection('FOLKLORIC WEAKNESSES', 'Vulnerabilities must be deduced through investigation and ancient tomes.'),
            ],

            // Rituals of Banishment
            if (c.ritualsOfBanishment.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.menu_book, color: AppColors.goldBright, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'BANISHMENT RITUALS',
                      style: AppTypography.titleSmall.copyWith(fontSize: 12, color: AppColors.goldBright),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (isGM)
                    _revealToggle(c.name, 'rituals', playVm?.isSectionRevealed(c.name, 'rituals') ?? false)
                  else if (isRevealed('rituals'))
                    _revealedBadge(),
                ],
              ),
              const SizedBox(height: 4),
              if (isRevealed('rituals'))
                ...c.ritualsOfBanishment.asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(left: 6, bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${entry.key + 1}. ',
                              style: const TextStyle(color: AppColors.goldBright, fontSize: 11, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ))
              else
                _buildRedactedSection('BANISHMENT RITUALS', 'Sacred rituals of peace and banishment require scholarly research.'),
            ],

            // Secrets & Lore
            if (c.secrets.isNotEmpty) ...[
              if (isGM) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.goldDim, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'SECRETS & LORE',
                        style: AppTypography.titleSmall.copyWith(fontSize: 12, color: AppColors.goldDim),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _revealToggle(c.name, 'secrets', playVm?.isSectionRevealed(c.name, 'secrets') ?? false),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOverlay.withAlpha(40),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.goldDim.withAlpha(70), width: 0.8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.goldDim, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          c.secrets,
                          style: AppTypography.quote.copyWith(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (isRevealed('secrets')) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.goldDim, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'SECRETS & LORE',
                        style: AppTypography.titleSmall.copyWith(fontSize: 12, color: AppColors.goldDim),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _revealedBadge(),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOverlay.withAlpha(40),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.goldDim.withAlpha(70), width: 0.8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.goldDim, size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          c.secrets,
                          style: AppTypography.quote.copyWith(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRedactedSection(String title, String explanation) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(50),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border.withAlpha(80), width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, color: AppColors.goldDim, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$title • [CLASSIFIED BY GM]',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.goldDim,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  explanation,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _revealToggle(String creatureName, String sectionKey, bool isRevealed) {
    return InkWell(
      onTap: () async {
        try {
          final playVm = Provider.of<PlayViewModel>(context, listen: false);
          await playVm.toggleSectionReveal(creatureName, sectionKey);
          setState(() {});
        } catch (_) {}
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isRevealed ? AppColors.gold.withAlpha(40) : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isRevealed ? AppColors.gold : AppColors.border,
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isRevealed ? Icons.visibility : Icons.visibility_off,
              size: 11,
              color: isRevealed ? AppColors.goldBright : AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              isRevealed ? 'REVEALED' : 'CONCEAL',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: isRevealed ? AppColors.goldBright : AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _revealedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.gold.withAlpha(40),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.gold, width: 0.8),
      ),
      child: const Text(
        'GM REVEALED',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: AppColors.goldBright,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _statBox(String label, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(fontSize: 9, color: AppColors.goldDim),
        ),
        const SizedBox(height: 2),
        Text(
          '$value',
          style: AppTypography.statValue.copyWith(
            fontSize: 15,
            color: AppColors.goldBright,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // --- Archetypes UI ---

  List<Widget> _buildArchetypes(List<Archetype> archetypes, int columns) {
    if (archetypes.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(AppLocalizations.of(context)?.noArchetypesFoundMatching ?? 'No archetypes found matching query.', style: AppTypography.bodySmall),
          ),
        ),
      ];
    }

    return _wrapInColumns(archetypes.map(_buildArchetypeCard).toList(), columns);
  }

  Widget _buildArchetypeCard(Archetype arc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GothicCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        arc.name.toUpperCase(),
                        style: AppTypography.titleLarge.copyWith(fontSize: 16, color: AppColors.goldBright),
                      ),
                      const SizedBox(height: 2),
                      Text(arc.tagline, style: AppTypography.quote.copyWith(fontSize: 12, color: AppColors.goldDim)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _pill(arc.mainAttribute.label.toUpperCase(), AppColors.gold),
              ],
            ),
            const SizedBox(height: 8),
            Text(arc.description, style: AppTypography.bodySmall.copyWith(height: 1.35)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _pill('Main Skill: ${arc.mainSkill.label}', AppColors.crimsonLight),
                _pill('Resources: ${arc.startingResources}', AppColors.surfaceOverlay),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Talents UI ---

  List<Widget> _buildTalents(List<Talent> talents, int columns) {
    final headerButton = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: _openCreateTalentDialog,
          icon: const Icon(Icons.add, size: 16, color: AppColors.goldBright),
          label: const Text(
            'FORGE HOMEBREW TALENT',
            style: TextStyle(
              color: AppColors.goldBright,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceLight,
            side: const BorderSide(color: AppColors.gold, width: 1.0),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ),
    );

    if (talents.isEmpty) {
      return [
        headerButton,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(AppLocalizations.of(context)?.noTalentsFoundMatching ?? 'No talents found matching query.', style: AppTypography.bodySmall),
          ),
        ),
      ];
    }

    return [
      headerButton,
      ..._wrapInColumns(talents.map(_buildTalentCard).toList(), columns),
    ];
  }

  Widget _buildTalentCard(Talent t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GothicCard(
        padding: const EdgeInsets.all(12),
        borderColor: t.isCustom ? AppColors.gold.withAlpha(160) : AppColors.border,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          t.name,
                          style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright, fontSize: 13),
                        ),
                      ),
                      if (t.isCustom) ...[
                        const SizedBox(width: 6),
                        _pill('HOMEBREW', AppColors.gold),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _pill(t.archetypeName ?? 'General', AppColors.goldDim),
                if (t.isCustom) ...[
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.crimsonLight),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Delete Homebrew Talent',
                    onPressed: () => _deleteHomebrewTalent(t),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(
              t.effect,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }

  // --- Injuries UI ---

  List<Widget> _buildInjuries(List<CriticalInjury> injuries, int columns) {
    if (injuries.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(AppLocalizations.of(context)?.noInjuriesFoundMatching ?? 'No critical injuries found matching query.', style: AppTypography.bodySmall),
          ),
        ),
      ];
    }

    return _wrapInColumns(injuries.map(_buildInjuryCard).toList(), columns);
  }

  Widget _buildInjuryCard(CriticalInjury i) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GothicCard(
        padding: const EdgeInsets.all(12),
        borderColor: i.isLethal ? AppColors.lethal : AppColors.border,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: i.isLethal ? AppColors.lethal.withAlpha(40) : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: i.isLethal ? AppColors.lethal : AppColors.goldDim,
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          '${i.d66}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: i.isLethal ? AppColors.lethal : AppColors.goldBright,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          i.name,
                          style: AppTypography.titleSmall.copyWith(
                            fontSize: 13,
                            color: i.isLethal ? AppColors.lethal : AppColors.goldBright,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (i.isLethal) ...[
                      _pill('LETHAL', AppColors.lethal),
                      const SizedBox(width: 4),
                    ],
                    _pill(i.isPhysical ? 'Physical' : 'Mental', AppColors.surfaceOverlay),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(i.effect, style: AppTypography.bodySmall.copyWith(height: 1.3)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.healing, size: 12, color: AppColors.goldDim),
                    const SizedBox(width: 4),
                    Text(
                      'Treatment: ${i.treatmentSkill.label}',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.goldDim),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 12, color: AppColors.goldDim),
                    const SizedBox(width: 4),
                    Text(
                      'Healing: ${i.healingTime}',
                      style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.goldDim),
                    ),
                  ],
                ),
                if (i.timeLimit != '-')
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 12, color: AppColors.lethal),
                      const SizedBox(width: 4),
                      Text(
                        'Limit: ${i.timeLimit}',
                        style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.lethal),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Gear UI ---

  List<Widget> _buildGear({
    required List<Weapon> weapons,
    required List<Armor> armor,
    required List<EquipmentItem> equipment,
    required int columns,
  }) {
    final isAllSearch = _selectedTab == -1;
    final showWeapons = isAllSearch || _selectedGearFilter == 'All' || _selectedGearFilter == 'Weapons';
    final showArmor = isAllSearch || _selectedGearFilter == 'All' || _selectedGearFilter == 'Armor & Protection';
    final showEquipment = isAllSearch || _selectedGearFilter == 'All' || _selectedGearFilter == 'Common Equipment';

    final filteredWeapons = showWeapons ? weapons : <Weapon>[];
    final filteredArmor = showArmor ? armor : <Armor>[];
    final filteredEquipment = showEquipment ? equipment : <EquipmentItem>[];

    if (filteredWeapons.isEmpty && filteredArmor.isEmpty && filteredEquipment.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(AppLocalizations.of(context)?.noGearFoundInCategory ?? 'No gear found in this category.', style: AppTypography.bodySmall),
          ),
        ),
      ];
    }

    return [
      if (filteredWeapons.isNotEmpty) ...[
        _sectionSubHeader('WEAPONS (${filteredWeapons.length})', Icons.colorize),
        ..._wrapInColumns(filteredWeapons.map(_buildWeaponCard).toList(), columns),
        const SizedBox(height: 14),
      ],
      if (filteredArmor.isNotEmpty) ...[
        _sectionSubHeader('ARMOR & PROTECTION (${filteredArmor.length})', Icons.shield),
        ..._wrapInColumns(filteredArmor.map(_buildArmorCard).toList(), columns),
        const SizedBox(height: 14),
      ],
      if (filteredEquipment.isNotEmpty) ...[
        _sectionSubHeader('COMMON EQUIPMENT (${filteredEquipment.length})', Icons.backpack_outlined),
        ..._wrapInColumns(filteredEquipment.map(_buildEquipmentCard).toList(), columns),
      ],
    ];
  }

  Widget _buildWeaponCard(Weapon w) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GothicCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.colorize, size: 16, color: AppColors.crimsonLight),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      w.name,
                      style: AppTypography.titleSmall.copyWith(fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _pill('Dmg ${w.damage}', AppColors.crimson),
                const SizedBox(width: 4),
                _pill(w.range.label, AppColors.goldDim),
                if (w.bonus > 0) ...[
                  const SizedBox(width: 4),
                  _pill('+${w.bonus}', AppColors.gold),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArmorCard(Armor a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GothicCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.shield, size: 16, color: AppColors.gold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      a.name,
                      style: AppTypography.titleSmall.copyWith(fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _pill('Protection ${a.protection}', AppColors.gold),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentCard(EquipmentItem e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GothicCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.backpack_outlined, size: 15, color: AppColors.goldDim),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    e.name,
                    style: AppTypography.titleSmall.copyWith(fontSize: 13, color: AppColors.goldBright),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(e.description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3)),
          ],
        ),
      ),
    );
  }

  // --- Rules UI ---

  List<Widget> _buildRules(List<_CompendiumRule> rules, int columns) {
    if (rules.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(AppLocalizations.of(context)?.noRulesFoundMatching ?? 'No rules found matching query.', style: AppTypography.bodySmall),
          ),
        ),
      ];
    }
    return _wrapInColumns(rules.map((r) => _ruleCard(r.title, r.body)).toList(), columns);
  }

  Widget _ruleCard(String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GothicCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_stories, size: 16, color: AppColors.goldBright),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body, style: AppTypography.bodyMedium.copyWith(height: 1.4)),
          ],
        ),
      ),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          fontSize: 10,
          color: color == AppColors.surfaceOverlay ? AppColors.textPrimary : color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
