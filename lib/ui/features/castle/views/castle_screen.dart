import 'package:flutter/material.dart';
import 'package:vaesen_beyond/domain/models/castle.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/utils/responsive.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class CastleScreen extends StatefulWidget {
  final PlayViewModel viewModel;

  const CastleScreen({super.key, required this.viewModel});

  @override
  State<CastleScreen> createState() => _CastleScreenState();
}

class _CastleScreenState extends State<CastleScreen> {
  int _facilityFilterIndex = 0; // 0: ALL, 1: OPERATIONAL, 2: AVAILABLE, 3: UNBUILT

  IconData _getFacilityIcon(String id) {
    switch (id) {
      case 'fac_library':
        return Icons.menu_book;
      case 'fac_infirmary':
        return Icons.medical_services_outlined;
      case 'fac_workshop':
        return Icons.handyman_outlined;
      case 'fac_seance':
        return Icons.visibility_outlined;
      case 'fac_alchemy':
        return Icons.science_outlined;
      case 'fac_vault':
        return Icons.lock_outline;
      default:
        return Icons.domain;
    }
  }

  IconData _getStaffIcon(String id) {
    switch (id) {
      case 'st_butler':
        return Icons.room_service_outlined;
      case 'st_coachman':
        return Icons.explore_outlined;
      case 'st_cook':
        return Icons.restaurant_outlined;
      case 'st_guard':
        return Icons.security_outlined;
      default:
        return Icons.person_outline;
    }
  }

  void _showAddMysteryDialog(BuildContext context) {
    final titleController = TextEditingController();
    final dateController = TextEditingController(text: 'October 1882');
    final summaryController = TextEditingController();
    int xpAwarded = 3;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.gold, width: 1),
            ),
            title: Row(
              children: [
                const Icon(Icons.history_edu, color: AppColors.goldBright, size: 24),
                const SizedBox(width: 10),
                Text(
                  'RECORD EXPEDITION',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.goldBright,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Log the conclusion of a Vaesen mystery into the Society annals.',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Mystery Title',
                        labelStyle: const TextStyle(color: AppColors.gold),
                        hintText: 'e.g. The Silver Mine of Sala',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.goldBright),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: dateController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Expedition Date',
                        labelStyle: const TextStyle(color: AppColors.gold),
                        hintText: 'e.g. November 14, 1882',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.goldBright),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: summaryController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Expedition Summary & Secrets Unveiled',
                        labelStyle: const TextStyle(color: AppColors.gold),
                        hintText: 'Describe the encounter, rituals performed, or vaesen banished...',
                        hintStyle: const TextStyle(color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.goldBright),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Experience Awarded:',
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: AppColors.gold),
                              onPressed: xpAwarded > 1
                                  ? () => setDialogState(() => xpAwarded--)
                                  : null,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.gold.withAlpha(120)),
                              ),
                              child: Text(
                                '+$xpAwarded XP',
                                style: AppTypography.titleSmall.copyWith(
                                  color: AppColors.goldBright,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: AppColors.gold),
                              onPressed: xpAwarded < 10
                                  ? () => setDialogState(() => xpAwarded++)
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final title = titleController.text.trim();
                  if (title.isEmpty) return;

                  final newLog = MysteryLog(
                    id: 'log_${DateTime.now().millisecondsSinceEpoch}',
                    title: title,
                    date: dateController.text.trim().isEmpty ? 'Late 19th Century' : dateController.text.trim(),
                    summary: summaryController.text.trim().isEmpty
                        ? 'Expedition concluded successfully.'
                        : summaryController.text.trim(),
                    xpAwarded: xpAwarded,
                  );

                  await widget.viewModel.addMysteryLog(newLog);
                  if (context.mounted) Navigator.pop(dialogCtx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceLight,
                  foregroundColor: AppColors.goldBright,
                  side: const BorderSide(color: AppColors.gold),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                icon: const Icon(Icons.bookmark_added, size: 16),
                label: const Text('RECORD EXPEDITION', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDeleteLog(BuildContext context, MysteryLog log) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.crimson, width: 1),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.crimsonBright, size: 22),
            const SizedBox(width: 8),
            Text('REMOVE EXPEDITION LOG', style: AppTypography.titleSmall.copyWith(color: AppColors.crimsonBright)),
          ],
        ),
        content: Text(
          'Are you sure you wish to remove "${log.title}" from the Castle Gyllencreutz chronicles?',
          style: AppTypography.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('CANCEL', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.viewModel.removeMysteryLog(log.id);
              if (context.mounted) Navigator.pop(dialogCtx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.crimsonDark,
              foregroundColor: Colors.white,
            ),
            child: const Text('REMOVE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final castle = widget.viewModel.castle;
        final isWide = Responsive.isWide(context);

        final totalFacilities = castle.facilities.length;
        final builtCount = castle.facilities.where((f) => f.isBuilt).length;
        final canAffordCount = castle.facilities.where((f) => !f.isBuilt && castle.developmentPoints >= f.devCost).length;
        final totalStaff = castle.staff.length;
        final hiredCount = castle.staff.where((s) => s.isHired).length;
        final totalXp = castle.mysteryLogs.fold<int>(0, (sum, l) => sum + l.xpAwarded);

        return Scaffold(
          backgroundColor: AppColors.backgroundDark,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 12,
                  vertical: 16,
                ),
                children: [
                  // 1. Gothic Headquarters Hero & Metric Cockpit
                  _buildHeaderCockpit(
                    castle: castle,
                    builtCount: builtCount,
                    totalFacilities: totalFacilities,
                    hiredCount: hiredCount,
                    totalStaff: totalStaff,
                    totalXp: totalXp,
                  ),

                  const SizedBox(height: 20),

                  // 2. Main Workstation: 2-Column Split on Desktop, 1-Column Stack on Mobile
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Bay: Facilities & Architectural Upgrades (flex: 6)
                        Expanded(
                          flex: 6,
                          child: _buildFacilitiesSection(context, castle, canAffordCount),
                        ),

                        const SizedBox(width: 24),

                        // Right Bay: Staff Retainers & Expedition Chronicles (flex: 5)
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStaffSection(context, castle, hiredCount, totalStaff),
                              const SizedBox(height: 24),
                              _buildMysteryLogsSection(context, castle),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFacilitiesSection(context, castle, canAffordCount),
                        const SizedBox(height: 24),
                        _buildStaffSection(context, castle, hiredCount, totalStaff),
                        const SizedBox(height: 24),
                        _buildMysteryLogsSection(context, castle),
                      ],
                    ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Hero Command Dashboard Card ───────────────────────────────────────────
  Widget _buildHeaderCockpit({
    required CastleState castle,
    required int builtCount,
    required int totalFacilities,
    required int hiredCount,
    required int totalStaff,
    required int totalXp,
  }) {
    return GothicCard(
      padding: const EdgeInsets.all(18),
      borderColor: AppColors.gold.withAlpha(140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceLight,
                  border: Border.all(color: AppColors.goldBright, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withAlpha(60),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(Icons.castle, color: AppColors.goldBright, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            castle.name.toUpperCase(),
                            style: AppTypography.displayMedium.copyWith(
                              fontSize: 20,
                              letterSpacing: 1.4,
                              color: AppColors.goldBright,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.goldDim, width: 0.6),
                          ),
                          child: Text(
                            'CHAPTER HQ',
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.gold,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'SOCIETY HEADQUARTERS • UPSALA, SWEDEN • ESTABLISHED 1882',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            'The ancient Gothic fortress of the Society in Upsala. Here, investigators consult dusty archives, recover from traumatic injuries, craft protective talismans, and plan expeditions across the Scandinavian provinces.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.35),
          ),

          const OrnateDivider(height: 22),

          // 4 Metric Pods
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 720;

              final devPointsPod = _buildStatPod(
                icon: Icons.auto_awesome,
                label: 'DEV POINTS',
                valueWidget: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${castle.developmentPoints}',
                      style: AppTypography.displayMedium.copyWith(
                        fontSize: 22,
                        color: AppColors.goldBright,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.gold.withAlpha(140), width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: castle.developmentPoints > 0
                                ? () => widget.viewModel.adjustDevelopmentPoints(-1)
                                : null,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Icon(Icons.remove, size: 14, color: AppColors.goldBright),
                            ),
                          ),
                          Container(width: 0.8, height: 16, color: AppColors.border),
                          InkWell(
                            onTap: () => widget.viewModel.adjustDevelopmentPoints(1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Icon(Icons.add, size: 14, color: AppColors.goldBright),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                subtext: 'To renovate & expand HQ',
              );

              final facilitiesPod = _buildStatPod(
                icon: Icons.account_balance,
                label: 'FACILITIES',
                value: '$builtCount / $totalFacilities',
                subtext: '$builtCount operational upgrades',
                valueColor: builtCount > 0 ? AppColors.goldBright : AppColors.textPrimary,
              );

              final staffPod = _buildStatPod(
                icon: Icons.people_outline,
                label: 'RETAINERS',
                value: '$hiredCount / $totalStaff',
                subtext: 'Staff active on grounds',
                valueColor: hiredCount > 0 ? AppColors.goldBright : AppColors.textPrimary,
              );

              final expeditionsPod = _buildStatPod(
                icon: Icons.menu_book,
                label: 'EXPEDITIONS',
                value: '${castle.mysteryLogs.length}',
                subtext: '+$totalXp total XP rewarded',
                valueColor: castle.mysteryLogs.isNotEmpty ? AppColors.goldBright : AppColors.textPrimary,
              );

              if (isNarrow) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: devPointsPod),
                        const SizedBox(width: 10),
                        Expanded(child: facilitiesPod),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: staffPod),
                        const SizedBox(width: 10),
                        Expanded(child: expeditionsPod),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: devPointsPod),
                  const SizedBox(width: 12),
                  Expanded(child: facilitiesPod),
                  const SizedBox(width: 12),
                  Expanded(child: staffPod),
                  const SizedBox(width: 12),
                  Expanded(child: expeditionsPod),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatPod({
    required IconData icon,
    required String label,
    String? value,
    Widget? valueWidget,
    required String subtext,
    Color valueColor = AppColors.goldBright,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withAlpha(160),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.gold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              Icon(icon, size: 14, color: AppColors.gold.withAlpha(140)),
            ],
          ),
          const SizedBox(height: 4),
          valueWidget ??
              Text(
                value ?? '',
                style: AppTypography.displayMedium.copyWith(
                  fontSize: 22,
                  color: valueColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
          const SizedBox(height: 2),
          Text(
            subtext,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Facilities Section ───────────────────────────────────────────────────
  Widget _buildFacilitiesSection(BuildContext context, CastleState castle, int canAffordCount) {
    final builtCount = castle.facilities.where((f) => f.isBuilt).length;

    List<Facility> filteredFacilities = castle.facilities;
    if (_facilityFilterIndex == 1) {
      filteredFacilities = castle.facilities.where((f) => f.isBuilt).toList();
    } else if (_facilityFilterIndex == 2) {
      filteredFacilities = castle.facilities.where((f) => !f.isBuilt && castle.developmentPoints >= f.devCost).toList();
    } else if (_facilityFilterIndex == 3) {
      filteredFacilities = castle.facilities.where((f) => !f.isBuilt).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with Filter Chips
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.architecture, color: AppColors.goldBright, size: 20),
                const SizedBox(width: 8),
                Text(
                  'FACILITIES & UPGRADES',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.goldBright,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.gold.withAlpha(100), width: 0.6),
              ),
              child: Text(
                '$builtCount / ${castle.facilities.length} BUILT',
                style: AppTypography.labelSmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Filter Bar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(
                label: 'ALL (${castle.facilities.length})',
                isSelected: _facilityFilterIndex == 0,
                onTap: () => setState(() => _facilityFilterIndex = 0),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'OPERATIONAL ($builtCount)',
                isSelected: _facilityFilterIndex == 1,
                onTap: () => setState(() => _facilityFilterIndex = 1),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'CAN BUILD ($canAffordCount)',
                isSelected: _facilityFilterIndex == 2,
                onTap: () => setState(() => _facilityFilterIndex = 2),
              ),
              const SizedBox(width: 8),
              _buildFilterChip(
                label: 'UNBUILT (${castle.facilities.length - builtCount})',
                isSelected: _facilityFilterIndex == 3,
                onTap: () => setState(() => _facilityFilterIndex = 3),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        if (filteredFacilities.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const Icon(Icons.filter_alt_off, color: AppColors.textMuted, size: 28),
                const SizedBox(height: 8),
                Text('No facilities match this filter.', style: AppTypography.bodyMedium),
              ],
            ),
          )
        else
          ...filteredFacilities.map((fac) {
            final canAfford = castle.developmentPoints >= fac.devCost;
            final canToggle = fac.isBuilt || canAfford;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: GothicCard(
                padding: const EdgeInsets.all(14),
                borderColor: fac.isBuilt
                    ? AppColors.gold.withAlpha(160)
                    : (canAfford ? AppColors.border : AppColors.surfaceOverlay),
                backgroundColor: fac.isBuilt
                    ? AppColors.surfaceLight.withAlpha(200)
                    : AppColors.surface,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Facility Icon Container
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: fac.isBuilt
                            ? AppColors.gold.withAlpha(30)
                            : AppColors.surfaceOverlay.withAlpha(80),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: fac.isBuilt ? AppColors.goldBright : AppColors.border,
                          width: fac.isBuilt ? 1.2 : 0.8,
                        ),
                      ),
                      child: Icon(
                        _getFacilityIcon(fac.id),
                        color: fac.isBuilt ? AppColors.goldBright : AppColors.textMuted,
                        size: 22,
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  fac.name,
                                  style: AppTypography.titleSmall.copyWith(
                                    color: fac.isBuilt ? AppColors.goldBright : AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (fac.isBuilt)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B3828),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: const Color(0xFF2CE8C5).withAlpha(160), width: 0.8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check, size: 10, color: Color(0xFF2CE8C5)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'BUILT',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: const Color(0xFF2CE8C5),
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (!canAfford)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.crimsonDark,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.crimsonLight, width: 0.8),
                                  ),
                                  child: Text(
                                    'COST: ${fac.devCost} PTS',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.crimsonBright,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.gold.withAlpha(120), width: 0.8),
                                  ),
                                  child: Text(
                                    'COST: ${fac.devCost} PTS',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.gold,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 4),
                          Text(fac.description, style: AppTypography.bodySmall),
                          const SizedBox(height: 8),

                          // Benefit Callout Box
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundDark.withAlpha(180),
                              borderRadius: BorderRadius.circular(6),
                              border: Border(
                                left: BorderSide(
                                  color: fac.isBuilt ? AppColors.goldBright : AppColors.goldDim,
                                  width: 2.5,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 13,
                                  color: fac.isBuilt ? AppColors.goldBright : AppColors.goldDim,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    fac.benefit,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: fac.isBuilt ? AppColors.goldBright : AppColors.gold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Toggle Switch
                    Switch(
                      value: fac.isBuilt,
                      activeThumbColor: AppColors.goldBright,
                      activeTrackColor: AppColors.surfaceLight,
                      inactiveThumbColor: canAfford ? null : AppColors.textMuted,
                      onChanged: canToggle
                          ? (_) async {
                              final success = await widget.viewModel.toggleFacility(fac.id);
                              if (!success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Not enough Development Points to build ${fac.name}. Requires ${fac.devCost} PTS.'),
                                    backgroundColor: AppColors.crimsonDark,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceLight : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.goldBright : AppColors.border,
            width: isSelected ? 1.2 : 0.8,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withAlpha(50),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? AppColors.goldBright : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  // ── Staff Retainers Section ──────────────────────────────────────────────
  Widget _buildStaffSection(BuildContext context, CastleState castle, int hiredCount, int totalStaff) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.people_alt_outlined, color: AppColors.goldBright, size: 20),
                const SizedBox(width: 8),
                Text(
                  'HIRED STAFF ROSTER',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.goldBright,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.gold.withAlpha(100), width: 0.6),
              ),
              child: Text(
                '$hiredCount / $totalStaff ON DUTY',
                style: AppTypography.labelSmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...castle.staff.map((st) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: GothicCard(
              padding: const EdgeInsets.all(12),
              borderColor: st.isHired ? AppColors.gold.withAlpha(140) : AppColors.surfaceOverlay,
              backgroundColor: st.isHired ? AppColors.surfaceLight.withAlpha(160) : AppColors.surface,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: st.isHired ? AppColors.gold.withAlpha(30) : AppColors.surfaceOverlay.withAlpha(60),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: st.isHired ? AppColors.goldBright : AppColors.border,
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      _getStaffIcon(st.id),
                      color: st.isHired ? AppColors.goldBright : AppColors.textMuted,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                st.name,
                                style: AppTypography.titleSmall.copyWith(
                                  color: st.isHired ? AppColors.goldBright : AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceOverlay,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.gold.withAlpha(80), width: 0.6),
                              ),
                              child: Text(
                                st.role.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.gold,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          st.benefit,
                          style: AppTypography.bodySmall.copyWith(
                            color: st.isHired ? AppColors.textPrimary : AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Switch(
                    value: st.isHired,
                    activeThumbColor: AppColors.goldBright,
                    activeTrackColor: AppColors.surfaceLight,
                    onChanged: (_) => widget.viewModel.toggleStaff(st.id),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Mystery Logs Section ─────────────────────────────────────────────────
  Widget _buildMysteryLogsSection(BuildContext context, CastleState castle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.menu_book, color: AppColors.goldBright, size: 20),
                const SizedBox(width: 8),
                Text(
                  'EXPEDITION CHRONICLES',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.goldBright,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddMysteryDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surfaceLight,
                foregroundColor: AppColors.goldBright,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                side: const BorderSide(color: AppColors.gold, width: 0.8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              icon: const Icon(Icons.add, size: 14),
              label: Text(
                'LOG EXPEDITION',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.goldBright,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        if (castle.mysteryLogs.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const Icon(Icons.history_edu, color: AppColors.textMuted, size: 28),
                const SizedBox(height: 8),
                Text('No expeditions recorded yet.', style: AppTypography.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  'Tap "Log Expedition" to record your first completed mystery.',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          )
        else
          ...castle.mysteryLogs.map((log) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GothicCard(
                padding: const EdgeInsets.all(14),
                borderColor: AppColors.gold.withAlpha(90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            log.title,
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.goldBright,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.border, width: 0.6),
                              ),
                              child: Text(
                                log.date,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.textMuted),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                              tooltip: 'Remove log',
                              onPressed: () => _confirmDeleteLog(context, log),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Text(
                      log.summary,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),

                    const OrnateDivider(height: 16),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: AppColors.gold.withAlpha(120), width: 0.6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, size: 11, color: AppColors.goldBright),
                              const SizedBox(width: 4),
                              Text(
                                '+${log.xpAwarded} XP AWARDED',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.goldBright,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Awarded to participating Society investigators',
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
            );
          }),
      ],
    );
  }
}
