import 'package:flutter/material.dart';
import 'package:vaesen_beyond/data/seed/archetypes_data.dart';
import 'package:vaesen_beyond/data/seed/gear_data.dart';
import 'package:vaesen_beyond/data/seed/injuries_data.dart';
import 'package:vaesen_beyond/data/seed/talents_data.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';

class CompendiumScreen extends StatefulWidget {
  const CompendiumScreen({super.key});

  @override
  State<CompendiumScreen> createState() => _CompendiumScreenState();
}

class _CompendiumScreenState extends State<CompendiumScreen> {
  int _selectedTab = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOCIETY COMPENDIUM', style: AppTypography.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _tabChip('ARCHETYPES', 0),
                const SizedBox(width: 8),
                _tabChip('TALENTS', 1),
                const SizedBox(width: 8),
                _tabChip('CRITICAL INJURIES', 2),
                const SizedBox(width: 8),
                _tabChip('WEAPONS & GEAR', 3),
                const SizedBox(width: 8),
                _tabChip('RULES REFERENCE', 4),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search rules, talents, injuries, gear...',
                prefixIcon: Icon(Icons.search, color: AppColors.gold),
                filled: true,
                fillColor: AppColors.surfaceLight,
                border: OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: _buildTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(String label, int index) {
    final isSelected = _selectedTab == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.goldBright,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 11,
      ),
      onSelected: (_) => setState(() => _selectedTab = index),
    );
  }

  List<Widget> _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildArchetypes();
      case 1:
        return _buildTalents();
      case 2:
        return _buildInjuries();
      case 3:
        return _buildGear();
      case 4:
      default:
        return _buildRules();
    }
  }

  List<Widget> _buildArchetypes() {
    final filtered = ArchetypesData.allArchetypes.where((a) {
      return a.name.toLowerCase().contains(_searchQuery) ||
          a.description.toLowerCase().contains(_searchQuery);
    }).toList();

    return filtered.map((arc) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: GothicCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                arc.name.toUpperCase(),
                style: AppTypography.titleLarge.copyWith(fontSize: 16, color: AppColors.goldBright),
              ),
              const SizedBox(height: 2),
              Text(arc.tagline, style: AppTypography.quote.copyWith(fontSize: 13)),
              const SizedBox(height: 6),
              Text(arc.description, style: AppTypography.bodySmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  _pill('Main Attr: ${arc.mainAttribute.label}', AppColors.gold),
                  const SizedBox(width: 6),
                  _pill('Main Skill: ${arc.mainSkill.label}', AppColors.crimsonLight),
                  const SizedBox(width: 6),
                  _pill('Resources: ${arc.startingResources}', AppColors.surfaceOverlay),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildTalents() {
    final filtered = TalentsData.allTalents.where((t) {
      return t.name.toLowerCase().contains(_searchQuery) ||
          t.effect.toLowerCase().contains(_searchQuery) ||
          (t.archetypeName ?? '').toLowerCase().contains(_searchQuery);
    }).toList();

    return filtered.map((t) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: GothicCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.name, style: AppTypography.titleSmall),
                  _pill(t.archetypeName ?? 'General', AppColors.goldDim),
                ],
              ),
              const SizedBox(height: 4),
              Text(t.effect, style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildInjuries() {
    final all = [...InjuriesData.physicalInjuries, ...InjuriesData.mentalInjuries];
    final filtered = all.where((i) {
      return i.name.toLowerCase().contains(_searchQuery) ||
          i.effect.toLowerCase().contains(_searchQuery);
    }).toList();

    return filtered.map((i) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: GothicCard(
          padding: const EdgeInsets.all(10),
          borderColor: i.isLethal ? AppColors.lethal : AppColors.surfaceOverlay,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        '${i.d66}: ${i.name}',
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 13,
                          color: i.isLethal ? AppColors.lethal : AppColors.goldBright,
                        ),
                      ),
                      if (i.isLethal)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: _pill('LETHAL', AppColors.lethal),
                        ),
                    ],
                  ),
                  _pill(i.isPhysical ? 'Physical' : 'Mental', AppColors.surfaceOverlay),
                ],
              ),
              const SizedBox(height: 4),
              Text(i.effect, style: AppTypography.bodySmall),
              const SizedBox(height: 4),
              Text(
                'Treatment: ${i.treatmentSkill.label} • Healing: ${i.healingTime} • Time Limit: ${i.timeLimit}',
                style: AppTypography.bodySmall.copyWith(fontSize: 11, color: AppColors.goldDim),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildGear() {
    final weapons = GearData.standardWeapons;
    final armor = GearData.standardArmor;
    final equipment = GearData.commonEquipment;

    return [
      Text('WEAPONS', style: AppTypography.titleSmall),
      const SizedBox(height: 6),
      ...weapons.map((w) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: GothicCard(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(w.name, style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                  Row(
                    children: [
                      _pill('Dmg ${w.damage}', AppColors.surfaceOverlay),
                      const SizedBox(width: 4),
                      _pill(w.range.label, AppColors.goldDim),
                    ],
                  ),
                ],
              ),
            ),
          )),
      const SizedBox(height: 14),
      Text('ARMOR & PROTECTION', style: AppTypography.titleSmall),
      const SizedBox(height: 6),
      ...armor.map((a) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: GothicCard(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(a.name, style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                  _pill('Protection ${a.protection}', AppColors.gold),
                ],
              ),
            ),
          )),
      const SizedBox(height: 14),
      Text('COMMON EQUIPMENT', style: AppTypography.titleSmall),
      const SizedBox(height: 6),
      ...equipment.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: GothicCard(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.name, style: AppTypography.titleSmall.copyWith(fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(e.description, style: AppTypography.bodySmall),
                ],
              ),
            ),
          )),
    ];
  }

  List<Widget> _buildRules() {
    return [
      _ruleCard(
        'PUSHING THE ROLL',
        'If you fail a skill test or want more successes (6s), you can Push the roll once. You immediately take 1 Condition (Physical or Mental matching the attribute tested), keep all 6s, and re-roll all other dice.',
      ),
      _ruleCard(
        'FEAR TESTS',
        'When encountering a vaesen or experiencing horror, roll Logic or Empathy + allies in your zone (max +3) - Mental conditions vs the monster’s Fear Value. Failure causes you to become Terrified for 1D6 rounds.',
      ),
      _ruleCard(
        'CONDITIONS & BECOMING BROKEN',
        'Each physical condition inflicts -1 die on all Physical checks. Each mental condition inflicts -1 die on all Mental checks. Taking a 4th condition breaks your investigator and requires rolling on the Critical Injury table.',
      ),
      _ruleCard(
        'MEMENTO SOLACE',
        'Once per mystery, you can hold your Memento to steady your resolve. This immediately clears 1 Physical or Mental condition.',
      ),
      _ruleCard(
        'EXPERIENCE & ADVANCEMENT',
        'At the end of each session, answer the end-of-session questions. Each "Yes" grants 1 XP. 5 XP can be spent to increase a Skill by +1 (max 5) or learn a new Talent. Attributes never increase through XP.',
      ),
    ];
  }

  Widget _ruleCard(String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GothicCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright)),
            const SizedBox(height: 6),
            Text(body, style: AppTypography.bodyMedium),
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
