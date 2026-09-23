import 'package:flutter/material.dart';
import 'package:vaesen_beyond/data/seed/archetypes_data.dart';
import 'package:vaesen_beyond/data/seed/talents_data.dart';
import 'package:vaesen_beyond/domain/models/archetype.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/talent.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/utils/portrait_image_service.dart';
import 'package:vaesen_beyond/ui/core/utils/responsive.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_portrait.dart';
import 'package:vaesen_beyond/ui/core/widgets/ornate_divider.dart';
import 'package:vaesen_beyond/ui/core/widgets/pip_counter.dart';
import 'package:vaesen_beyond/ui/features/builder/view_models/builder_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

class CharacterBuilderScreen extends StatefulWidget {
  final PlayViewModel playViewModel;
  final VoidCallback onFinished;

  const CharacterBuilderScreen({
    super.key,
    required this.playViewModel,
    required this.onFinished,
  });

  @override
  State<CharacterBuilderScreen> createState() => _CharacterBuilderScreenState();
}

class _CharacterBuilderScreenState extends State<CharacterBuilderScreen> {
  final BuilderViewModel _builderVm = BuilderViewModel();

  static const _availablePortraits = [
    ('assets/images/portraits/astrid.jpg', 'Astrid', 'Doctor / Scholar'),
    ('assets/images/portraits/birger.jpg', 'Birger', 'Officer / Guard'),
    ('assets/images/portraits/elias.jpg', 'Elias', 'Occultist / Priest'),
    ('assets/images/portraits/johan.jpg', 'Johan', 'Hunter / Tracker'),
  ];

  Future<void> _handleUploadPortrait() async {
    final dataUri = await PortraitImageService.pickAndProcessCustomPortrait();
    if (dataUri != null && mounted) {
      _builderVm.setCustomPortrait(dataUri);
    }
  }

  void _handleStepTap(int index) {
    if (index <= _builderVm.currentStep) {
      _builderVm.setStep(index);
    } else {
      for (int s = 0; s < index; s++) {
        final err = _builderVm.getStepValidationError(s);
        if (err != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.crimsonDark,
              content: Text(err, style: const TextStyle(color: Colors.white)),
            ),
          );
          _builderVm.setStep(s);
          return;
        }
      }
      _builderVm.setStep(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = Responsive.isWide(context);

    return ListenableBuilder(
      listenable: _builderVm,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('NEW INVESTIGATOR REGISTRY', style: AppTypography.titleLarge),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (_builderVm.currentStep > 0) {
                  _builderVm.previousStep();
                } else {
                  widget.onFinished();
                }
              },
            ),
          ),
          body: Column(
            children: [
              _buildStepProgress(isWide),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 1320 : double.infinity),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isWide ? 24 : 16),
                      child: isWide ? _buildCurrentStepContentDesktop() : _buildCurrentStepContentMobile(),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.surfaceOverlay)),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isWide ? 1320 : double.infinity),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_builderVm.currentStep > 0)
                          OutlinedButton(
                            onPressed: _builderVm.previousStep,
                            child: const Text('BACK'),
                          )
                        else
                          const SizedBox.shrink(),
                        if (_builderVm.currentStep < 5)
                          ElevatedButton(
                            onPressed: () {
                              final error = _builderVm.getFirstValidationErrorUpTo(_builderVm.currentStep);
                              if (error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.crimsonDark,
                                    content: Text(error, style: const TextStyle(color: Colors.white)),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                                return;
                              }
                              _builderVm.nextStep();
                            },
                            child: const Text('NEXT STEP'),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: _builderVm.canEnroll
                                ? () async {
                                    final newChar = _builderVm.buildCharacter();
                                    await widget.playViewModel.updateCharacter(newChar);
                                    await widget.playViewModel.switchCharacter(newChar.id);
                                    widget.onFinished();
                                  }
                                : () {
                                    final err = _builderVm.getFirstValidationErrorUpTo(5);
                                    if (err != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: AppColors.crimsonDark,
                                          content: Text(err, style: const TextStyle(color: Colors.white)),
                                        ),
                                      );
                                    }
                                  },
                            icon: Icon(
                              _builderVm.canEnroll ? Icons.check : Icons.lock_outline,
                              color: _builderVm.canEnroll ? AppColors.goldBright : AppColors.textMuted,
                            ),
                            label: const Text('ENROLL INVESTIGATOR'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _builderVm.canEnroll ? AppColors.crimson : AppColors.surfaceOverlay,
                              foregroundColor: _builderVm.canEnroll ? Colors.white : AppColors.textMuted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Step Navigation Stepper ───────────────────────────────────────────────
  Widget _buildStepProgress(bool isWide) {
    if (!isWide) {
      return _buildMobileStepProgress();
    }
    return _buildDesktopStepProgress();
  }

  Widget _buildMobileStepProgress() {
    final steps = ['Identity', 'Age', 'Stats', 'Talent', 'Lore', 'Enroll'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppColors.surfaceLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isCurrent = index == _builderVm.currentStep;
          final isPassed = index < _builderVm.currentStep;

          return InkWell(
            onTap: () => _handleStepTap(index),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: isCurrent
                      ? AppColors.goldBright
                      : (isPassed ? AppColors.goldDim : AppColors.surfaceOverlay),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                if (isCurrent) ...[
                  const SizedBox(width: 4),
                  Text(
                    steps[index],
                    style: AppTypography.titleSmall.copyWith(fontSize: 11),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDesktopStepProgress() {
    final steps = [
      ('1. IDENTITY', 'Name & Archetype'),
      ('2. AGE GROUP', 'Vigor vs Wisdom'),
      ('3. ATTRIBUTES & SKILLS', 'Point Budget'),
      ('4. STARTING TALENT', 'Special Power'),
      ('5. NARRATIVE LORE', 'Trauma & Secrets'),
      ('6. REVIEW & ENROLL', 'Final Folio'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(bottom: BorderSide(color: AppColors.surfaceOverlay)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1320),
          child: Row(
            children: List.generate(steps.length, (index) {
              final isCurrent = index == _builderVm.currentStep;
              final isPassed = index < _builderVm.currentStep;
              final (title, subtitle) = steps[index];

              return Expanded(
                child: InkWell(
                  onTap: () => _handleStepTap(index),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrent
                                ? AppColors.goldBright
                                : (isPassed ? AppColors.gold.withAlpha(60) : AppColors.surfaceOverlay),
                            border: Border.all(
                              color: isCurrent
                                  ? AppColors.goldBright
                                  : (isPassed ? AppColors.gold : AppColors.border),
                              width: 1.2,
                            ),
                          ),
                          child: Center(
                            child: isPassed
                                ? const Icon(Icons.check, size: 13, color: AppColors.goldBright)
                                : Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isCurrent ? Colors.black : Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.titleSmall.copyWith(
                                  fontSize: 10.5,
                                  color: isCurrent ? AppColors.goldBright : (isPassed ? AppColors.gold : AppColors.textMuted),
                                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 9.0,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DESKTOP / WIDE WORKSTATION STEP CONTENT (>= 1180px)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCurrentStepContentDesktop() {
    switch (_builderVm.currentStep) {
      case 0:
        return _step0ArchetypeDesktop();
      case 1:
        return _step1AgeDesktop();
      case 2:
        return _step2AttributesAndSkillsDesktop();
      case 3:
        return _step3TalentDesktop();
      case 4:
        return _step4LoreDesktop();
      case 5:
      default:
        return _step5ReviewDesktop();
    }
  }

  Widget _step0ArchetypeDesktop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 1: Choose Archetype & Name', style: AppTypography.displayMedium.copyWith(fontSize: 22, color: AppColors.goldBright)),
        const SizedBox(height: 6),
        Text(
          'Your archetype represents your profession and training before the supernatural tore through the veil of reality.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),

        // Top Row: Name on Left, Portrait Selector on Right with Equal Height
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left: Name field
              Expanded(
                flex: 5,
                child: GothicCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('INVESTIGATOR FULL NAME', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                          const SizedBox(height: 4),
                          Text(
                            'Enter your character\'s name or noble title as it will appear in Society registers.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        initialValue: _builderVm.name,
                        decoration: const InputDecoration(
                          labelText: 'Investigator Full Name',
                          hintText: 'e.g. Inspector Johan Lindgren',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: AppColors.surfaceLight,
                        ),
                        onChanged: _builderVm.setName,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Right: Portrait Picker
              Expanded(
                flex: 6,
                child: GothicCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('GOTHIC PORTRAIT', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                          if (_builderVm.hasCustomPortrait)
                            TextButton.icon(
                              onPressed: _handleUploadPortrait,
                              icon: const Icon(Icons.refresh, size: 14, color: AppColors.gold),
                              label: const Text('REPLACE CUSTOM', style: TextStyle(fontSize: 11, color: AppColors.gold)),
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildPortraitRow(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const OrnateDivider(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SELECT ARCHETYPE', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
            Text('10 Archetypes Available', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
          ],
        ),
        const SizedBox(height: 12),

        // 2-Column Grid of Archetypes with Consistent Row Heights
        ...List.generate((ArchetypesData.allArchetypes.length / 2).ceil(), (rowIndex) {
          final firstIndex = rowIndex * 2;
          final secondIndex = firstIndex + 1;
          final arc1 = ArchetypesData.allArchetypes[firstIndex];
          final arc2 = secondIndex < ArchetypesData.allArchetypes.length
              ? ArchetypesData.allArchetypes[secondIndex]
              : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildArchetypeCardDesktop(arc1)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: arc2 != null
                        ? _buildArchetypeCardDesktop(arc2)
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildArchetypeCardDesktop(Archetype arc) {
    final isSelected = arc.name == _builderVm.archetype.name;

    return Container(
      constraints: const BoxConstraints(minHeight: 142),
      child: GothicCard(
        padding: const EdgeInsets.all(14),
        backgroundColor: isSelected ? AppColors.surfaceLight : AppColors.surface,
        borderColor: isSelected ? AppColors.goldBright : AppColors.surfaceOverlay,
        borderWidth: isSelected ? 1.5 : 1.0,
        onTap: () => _builderVm.setArchetype(arc),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  arc.name.toUpperCase(),
                  style: AppTypography.titleLarge.copyWith(
                    fontSize: 16,
                    color: isSelected ? AppColors.goldBright : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _badge('${arc.mainAttribute.label} • ${arc.mainSkill.label}', AppColors.gold),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              arc.tagline,
              style: AppTypography.quote.copyWith(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                arc.description,
                style: AppTypography.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step1AgeDesktop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 2: Choose Age Group', style: AppTypography.displayMedium.copyWith(fontSize: 22, color: AppColors.goldBright)),
        const SizedBox(height: 6),
        Text(
          'Age represents the balance between physical vigor and life experience. Young investigators have higher attributes; older investigators have higher learned skills.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),

        // 3 Cards Side-by-Side in an Equal-Height Row
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: AgeCategory.values.map((cat) {
              final isSelected = cat == _builderVm.ageCategory;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: GothicCard(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: isSelected ? AppColors.surfaceLight : AppColors.surface,
                    borderColor: isSelected ? AppColors.goldBright : AppColors.surfaceOverlay,
                    borderWidth: isSelected ? 1.5 : 1.0,
                    onTap: () => _builderVm.setAgeCategory(cat),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cat.label.toUpperCase(),
                              style: AppTypography.titleLarge.copyWith(
                                fontSize: 16,
                                color: isSelected ? AppColors.goldBright : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: AppColors.goldBright, size: 18),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _badge('${cat.attributePoints} Attr Pts', AppColors.gold),
                            const SizedBox(width: 6),
                            _badge('${cat.skillPoints} Skill Pts', AppColors.crimsonLight),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Text(
                            cat == AgeCategory.young
                                ? 'Peak physical and mental agility, but less experience facing the unknown.'
                                : cat == AgeCategory.middleAged
                                    ? 'A seasoned investigator balancing physical competence with worldly wisdom.'
                                    : 'Failing physical stamina, compensated by deep academic knowledge or years of survival.',
                            style: AppTypography.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),

        // Exact Age Slider Card
        GothicCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('EXACT INVESTIGATOR AGE', style: AppTypography.titleSmall),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.gold.withAlpha(140)),
                    ),
                    child: Text(
                      '${_builderVm.actualAge} Years Old',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.goldBright,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Slider(
                value: _builderVm.actualAge.toDouble(),
                min: _builderVm.ageCategory.minAge.toDouble(),
                max: _builderVm.ageCategory.maxAge.toDouble(),
                divisions: _builderVm.ageCategory.maxAge - _builderVm.ageCategory.minAge,
                activeColor: AppColors.goldBright,
                onChanged: (v) => _builderVm.setActualAge(v.toInt()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step2AttributesAndSkillsDesktop() {
    final remAttr = _builderVm.remainingAttributePoints;
    final remSkill = _builderVm.remainingSkillPoints;
    final arc = _builderVm.archetype;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 3: Point Allocation', style: AppTypography.displayMedium.copyWith(fontSize: 22, color: AppColors.goldBright)),
        const SizedBox(height: 6),
        Text(
          'Attributes range 2 to 4 (max 5 for your Main Attribute: ${arc.mainAttribute.label}).\n'
          'Skills range 0 to 2 (max 3 for your Main Skill: ${arc.mainSkill.label}).',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),

        // Budget Status Row: Flexes (5 vs 7) and gap (20) match the cards below exactly
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: remAttr == 0 ? AppColors.surfaceLight : AppColors.gold.withAlpha(35),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: remAttr == 0 ? AppColors.goldDim : AppColors.goldBright, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ATTRIBUTE POINTS BUDGET', style: AppTypography.titleSmall.copyWith(fontSize: 11)),
                        Text('${_builderVm.totalAttributePointsSpent} / ${_builderVm.ageCategory.attributePoints} Points Spent', style: AppTypography.bodySmall),
                      ],
                    ),
                    Text(
                      remAttr == 0 ? 'Balanced ✓' : (remAttr > 0 ? '$remAttr Unspent' : '${-remAttr} Overspent ⚠️'),
                      style: AppTypography.titleMedium.copyWith(
                        color: remAttr == 0 ? AppColors.gold : (remAttr > 0 ? AppColors.goldBright : AppColors.crimsonLight),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: remSkill == 0 ? AppColors.surfaceLight : AppColors.crimson.withAlpha(35),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: remSkill == 0 ? AppColors.goldDim : AppColors.crimsonLight, width: 1.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SKILL POINTS BUDGET', style: AppTypography.titleSmall.copyWith(fontSize: 11)),
                        Text('${_builderVm.totalSkillPointsSpent} / ${_builderVm.ageCategory.skillPoints} Points Spent', style: AppTypography.bodySmall),
                      ],
                    ),
                    Text(
                      remSkill == 0 ? 'Balanced ✓' : (remSkill > 0 ? '$remSkill Unspent' : '${-remSkill} Overspent ⚠️'),
                      style: AppTypography.titleMedium.copyWith(
                        color: remSkill == 0 ? AppColors.gold : AppColors.crimsonLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // 2-Column Split: Left Attributes, Right Skills with matching height
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left: Attributes (flex: 5)
              Expanded(
                flex: 5,
                child: GothicCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('CORE ATTRIBUTES', style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright)),
                          Text('Baseline: 2', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      const OrnateDivider(height: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: AttributeType.values.map((attr) {
                            final val = _builderVm.attributes[attr] ?? 2;
                            final isMain = attr == arc.mainAttribute;
                            final maxCap = isMain ? 5 : 4;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(attr.label, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                                      if (isMain)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: _badge('MAIN (max 5)', AppColors.gold),
                                        ),
                                    ],
                                  ),
                                  PipCounter(
                                    value: val,
                                    min: 2,
                                    max: maxCap,
                                    onChanged: (newVal) => _builderVm.setAttribute(attr, newVal),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Right: Skills (flex: 7)
              Expanded(
                flex: 7,
                child: GothicCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('INVESTIGATOR SKILLS', style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright)),
                          Text('Range: 0–2 (Main: 3)', style: AppTypography.labelSmall.copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                      const OrnateDivider(height: 16),
                      Builder(
                        builder: (context) {
                          final allSkills = SkillType.values.toList();
                          final leftSkills = allSkills.sublist(0, 6);
                          final rightSkills = allSkills.sublist(6);

                          Widget buildSkillItem(SkillType skill) {
                            final val = _builderVm.skills[skill] ?? 0;
                            final isMain = skill == arc.mainSkill;
                            final maxCap = isMain ? 3 : 2;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            skill.label,
                                            style: AppTypography.bodyMedium.copyWith(
                                              color: isMain ? AppColors.goldBright : AppColors.textPrimary,
                                              fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isMain) ...[
                                          const SizedBox(width: 4),
                                          _badge('★', AppColors.crimsonLight),
                                        ],
                                      ],
                                    ),
                                  ),
                                  PipCounter(
                                    value: val,
                                    min: 0,
                                    max: maxCap,
                                    onChanged: (newVal) => _builderVm.setSkill(skill, newVal),
                                  ),
                                ],
                              ),
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(children: leftSkills.map(buildSkillItem).toList()),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(children: rightSkills.map(buildSkillItem).toList()),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step3TalentDesktop() {
    final arc = _builderVm.archetype;
    final availableTalents = TalentsData.allTalents
        .where((t) => arc.talentIds.contains(t.id) || t.isGeneral)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 4: Starting Talent', style: AppTypography.displayMedium.copyWith(fontSize: 22, color: AppColors.goldBright)),
        const SizedBox(height: 6),
        Text(
          'Choose 1 starting talent from your archetype (${arc.name}) or the general talents list.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),

        // 2-Column Grid of Talents with Equal Height Rows
        ...List.generate((availableTalents.length / 2).ceil(), (rowIndex) {
          final firstIndex = rowIndex * 2;
          final secondIndex = firstIndex + 1;
          final t1 = availableTalents[firstIndex];
          final t2 = secondIndex < availableTalents.length ? availableTalents[secondIndex] : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _buildTalentCardDesktop(t1)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: t2 != null ? _buildTalentCardDesktop(t2) : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTalentCardDesktop(Talent talent) {
    final isSelected = _builderVm.selectedTalents.any((t) => t.id == talent.id);

    return Container(
      constraints: const BoxConstraints(minHeight: 88),
      child: GothicCard(
        padding: const EdgeInsets.all(14),
        backgroundColor: isSelected ? AppColors.surfaceLight : AppColors.surface,
        borderColor: isSelected ? AppColors.goldBright : AppColors.surfaceOverlay,
        borderWidth: isSelected ? 1.5 : 1.0,
        onTap: () => _builderVm.toggleTalent(talent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    talent.name,
                    style: AppTypography.titleSmall.copyWith(
                      fontSize: 14,
                      color: isSelected ? AppColors.goldBright : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                if (talent.archetypeName != null)
                  _badge(talent.archetypeName!, AppColors.gold)
                else
                  _badge('General', AppColors.surfaceOverlay),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(talent.effect, style: AppTypography.bodySmall),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step4LoreDesktop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 5: Narrative Foundations', style: AppTypography.displayMedium.copyWith(fontSize: 22, color: AppColors.goldBright)),
        const SizedBox(height: 6),
        Text(
          'In Vaesen, characters are driven by personal secrets, traumatic encounters, and grounding memories.',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 20),

        // 2x2 Grid of Lore TextFields with Matching Heights
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _textField('MOTIVATION', 'Why do you risk death to investigate the vaesen?', _builderVm.setMotivation, _builderVm.motivation),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _textField('TRAUMA (THE SIGHT)', 'What terrifying supernatural incident awakened your Sight?', _builderVm.setTrauma, _builderVm.trauma),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _textField('DARK SECRET', 'What guilt, crime, or forbidden secret do you conceal?', _builderVm.setDarkSecret, _builderVm.darkSecret),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _textField('MEMENTO', 'What physical heirloom brings comfort to heal conditions once per mystery?', _builderVm.setMemento, _builderVm.memento),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _step5ReviewDesktop() {
    final arc = _builderVm.archetype;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Final Step: Review & Enroll', style: AppTypography.displayMedium.copyWith(fontSize: 22, color: AppColors.goldBright)),
        const SizedBox(height: 6),
        Text('Verify your investigator folio before signing the Society enrollment register.', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 16),

        _buildReviewValidationBanner(),

        const SizedBox(height: 16),

        // 2-Column Dossier Split with Matching Column Heights
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Column: Identity, Portrait, Gear & Talent
              Expanded(
                flex: 5,
                child: GothicCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GothicPortrait(
                                portraitAsset: _builderVm.portraitAsset,
                                width: 80,
                                height: 80,
                                border: Border.all(color: AppColors.gold, width: 2.0),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black54, blurRadius: 10),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _builderVm.name.isNotEmpty ? _builderVm.name : 'Unknown Investigator',
                                      style: AppTypography.displayMedium.copyWith(color: AppColors.goldBright, fontSize: 20),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${arc.name.toUpperCase()} • ${_builderVm.actualAge} YEARS OLD',
                                      style: AppTypography.titleSmall.copyWith(color: AppColors.gold, fontSize: 12),
                                    ),
                                    Text(
                                      _builderVm.ageCategory.label,
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const OrnateDivider(height: 24),
                          Text('STARTING GEAR PACK', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                          const SizedBox(height: 6),
                          ...arc.startingGear.map((g) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  children: [
                                    const Icon(Icons.circle, size: 5, color: AppColors.gold),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(g, style: AppTypography.bodySmall)),
                                  ],
                                ),
                              )),

                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _badge('Resources: ${arc.startingResources}', AppColors.gold),
                              const SizedBox(width: 8),
                              _badge('Capital: 1', AppColors.surfaceOverlay),
                            ],
                          ),
                        ],
                      ),

                      if (_builderVm.selectedTalents.isNotEmpty) ...[
                        const OrnateDivider(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('STARTING TALENT', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                            const SizedBox(height: 6),
                            Text(
                              _builderVm.selectedTalents.first.name,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(_builderVm.selectedTalents.first.effect, style: AppTypography.bodySmall),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // Right Column: Attributes, Skills & Narrative stretching to match left column
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    GothicCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ATTRIBUTES MATRIX', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                          const OrnateDivider(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: AttributeType.values.map((attr) {
                              final val = _builderVm.attributes[attr] ?? 2;
                              final isMain = attr == arc.mainAttribute;
                              return Column(
                                children: [
                                  Text(
                                    attr.label.toUpperCase(),
                                    style: AppTypography.labelSmall.copyWith(
                                      color: isMain ? AppColors.goldBright : AppColors.textMuted,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isMain ? AppColors.gold.withAlpha(30) : AppColors.surfaceLight,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: isMain ? AppColors.goldBright : AppColors.border),
                                    ),
                                    child: Text(
                                      '$val',
                                      style: AppTypography.titleMedium.copyWith(
                                        color: isMain ? AppColors.goldBright : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    GothicCard(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TRAINED SKILLS', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                          const OrnateDivider(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: SkillType.values.where((s) => (_builderVm.skills[s] ?? 0) > 0).map((skill) {
                              final lvl = _builderVm.skills[skill] ?? 0;
                              final isMain = skill == arc.mainSkill;
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isMain ? AppColors.gold.withAlpha(40) : AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: isMain ? AppColors.goldBright : AppColors.border),
                                ),
                                child: Text(
                                  '${skill.label}: $lvl',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isMain ? AppColors.goldBright : Colors.white,
                                    fontWeight: isMain ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Expanded(
                      child: GothicCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NARRATIVE FOUNDATIONS', style: AppTypography.titleSmall.copyWith(color: AppColors.goldBright)),
                            const OrnateDivider(height: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _narrativeBullet('Motivation', _builderVm.motivation),
                                  _narrativeBullet('The Sight', _builderVm.trauma),
                                  _narrativeBullet('Dark Secret', _builderVm.darkSecret),
                                  _narrativeBullet('Memento', _builderVm.memento),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _narrativeBullet(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title: ', style: AppTypography.bodySmall.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not recorded',
              style: AppTypography.bodySmall.copyWith(color: value.isNotEmpty ? Colors.white : AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MOBILE STEP CONTENT (EXACT ORIGINAL LAYOUT PRESERVED < 1180px)
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCurrentStepContentMobile() {
    switch (_builderVm.currentStep) {
      case 0:
        return _step0ArchetypeMobile();
      case 1:
        return _step1AgeMobile();
      case 2:
        return _step2AttributesAndSkillsMobile();
      case 3:
        return _step3TalentMobile();
      case 4:
        return _step4LoreMobile();
      case 5:
      default:
        return _step5ReviewMobile();
    }
  }

  Widget _buildPortraitRow() {
    return SizedBox(
      height: 94,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ..._availablePortraits.map((p) {
              final isSelected = _builderVm.portraitAsset == p.$1;
              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: GestureDetector(
                  onTap: () => _builderVm.setPortraitAsset(p.$1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.goldBright : AppColors.border,
                            width: isSelected ? 2.5 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.gold.withAlpha(140),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: ClipOval(
                          child: Image.asset(p.$1, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p.$2,
                        style: TextStyle(
                          color: isSelected ? AppColors.goldBright : AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (_builderVm.hasCustomPortrait) ...[
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: GestureDetector(
                  onTap: () => _builderVm.setPortraitAsset(_builderVm.customPortraitDataUri!),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GothicPortrait(
                        portraitAsset: _builderVm.customPortraitDataUri!,
                        width: 58,
                        height: 58,
                        border: Border.all(
                          color: _builderVm.portraitAsset == _builderVm.customPortraitDataUri
                              ? AppColors.goldBright
                              : AppColors.border,
                          width: _builderVm.portraitAsset == _builderVm.customPortraitDataUri ? 2.5 : 1.0,
                        ),
                        boxShadow: _builderVm.portraitAsset == _builderVm.customPortraitDataUri
                            ? [
                                BoxShadow(
                                  color: AppColors.gold.withAlpha(140),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Custom',
                        style: TextStyle(
                          color: _builderVm.portraitAsset == _builderVm.customPortraitDataUri
                              ? AppColors.goldBright
                              : AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: _builderVm.portraitAsset == _builderVm.customPortraitDataUri
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            GestureDetector(
              onTap: _handleUploadPortrait,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceLight,
                      border: Border.all(
                        color: AppColors.gold.withAlpha(140),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.gold,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Upload',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step0ArchetypeMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 1: Choose Archetype & Name', style: AppTypography.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Your archetype represents your profession and training before the supernatural tore through the veil of reality.',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 14),

        TextFormField(
          initialValue: _builderVm.name,
          decoration: const InputDecoration(
            labelText: 'Investigator Full Name',
            hintText: 'e.g. Inspector Johan Lindgren',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: AppColors.surfaceLight,
          ),
          onChanged: _builderVm.setName,
        ),

        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SELECT GOTHIC PORTRAIT', style: AppTypography.titleSmall),
            if (_builderVm.hasCustomPortrait)
              TextButton.icon(
                onPressed: _handleUploadPortrait,
                icon: const Icon(Icons.refresh, size: 14, color: AppColors.gold),
                label: const Text('REPLACE', style: TextStyle(fontSize: 11, color: AppColors.gold)),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
              ),
          ],
        ),
        const SizedBox(height: 8),
        _buildPortraitRow(),

        const SizedBox(height: 18),
        Text('SELECT ARCHETYPE', style: AppTypography.titleSmall),
        const SizedBox(height: 8),

        ...ArchetypesData.allArchetypes.map((arc) {
          final isSelected = arc.name == _builderVm.archetype.name;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: GothicCard(
              backgroundColor: isSelected ? AppColors.surfaceLight : AppColors.surface,
              borderColor: isSelected ? AppColors.goldBright : AppColors.surfaceOverlay,
              borderWidth: isSelected ? 1.5 : 1.0,
              onTap: () => _builderVm.setArchetype(arc),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        arc.name.toUpperCase(),
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 16,
                          color: isSelected ? AppColors.goldBright : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'MAIN: ${arc.mainAttribute.label} / ${arc.mainSkill.label}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(arc.tagline, style: AppTypography.quote.copyWith(fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(arc.description, style: AppTypography.bodySmall),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _step1AgeMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 2: Choose Age Group', style: AppTypography.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Age represents the balance between physical vigor and life experience. Young investigators have higher attributes; older investigators have higher learned skills.',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 16),

        ...AgeCategory.values.map((cat) {
          final isSelected = cat == _builderVm.ageCategory;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: GothicCard(
              backgroundColor: isSelected ? AppColors.surfaceLight : AppColors.surface,
              borderColor: isSelected ? AppColors.goldBright : AppColors.surfaceOverlay,
              borderWidth: isSelected ? 1.5 : 1.0,
              onTap: () => _builderVm.setAgeCategory(cat),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cat.label,
                        style: AppTypography.titleLarge.copyWith(
                          fontSize: 16,
                          color: isSelected ? AppColors.goldBright : AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          _badge('${cat.attributePoints} Attr Pts', AppColors.gold),
                          const SizedBox(width: 6),
                          _badge('${cat.skillPoints} Skill Pts', AppColors.crimsonLight),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat == AgeCategory.young
                        ? 'Peak physical and mental agility, but less experience facing the unknown.'
                        : cat == AgeCategory.middleAged
                            ? 'A seasoned investigator balancing physical competence with worldly wisdom.'
                            : 'Failing physical stamina, compensated by deep academic knowledge or years of survival.',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Exact Age: ${_builderVm.actualAge} years old', style: AppTypography.titleSmall),
            Slider(
              value: _builderVm.actualAge.toDouble(),
              min: _builderVm.ageCategory.minAge.toDouble(),
              max: _builderVm.ageCategory.maxAge.toDouble(),
              divisions: _builderVm.ageCategory.maxAge - _builderVm.ageCategory.minAge,
              activeColor: AppColors.goldBright,
              onChanged: (v) => _builderVm.setActualAge(v.toInt()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _step2AttributesAndSkillsMobile() {
    final remAttr = _builderVm.remainingAttributePoints;
    final remSkill = _builderVm.remainingSkillPoints;
    final arc = _builderVm.archetype;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 3: Point Allocation', style: AppTypography.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Attributes range 2 to 4 (max 5 for your Main Attribute: ${arc.mainAttribute.label}).\n'
          'Skills range 0 to 2 (max 3 for your Main Skill: ${arc.mainSkill.label}).',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: remAttr == 0 ? AppColors.surfaceLight : AppColors.gold.withAlpha(40),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: remAttr == 0 ? AppColors.goldDim : AppColors.goldBright),
                ),
                child: Column(
                  children: [
                    Text('ATTRIBUTE POINTS', style: AppTypography.titleSmall.copyWith(fontSize: 10)),
                    Text(
                      remAttr == 0 ? 'Balanced ✓' : (remAttr > 0 ? '$remAttr Unspent' : '${-remAttr} Overspent ⚠️'),
                      style: AppTypography.titleMedium.copyWith(
                        color: remAttr == 0 ? AppColors.gold : (remAttr > 0 ? AppColors.goldBright : AppColors.crimsonLight),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: remSkill == 0 ? AppColors.surfaceLight : AppColors.crimson.withAlpha(40),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: remSkill == 0 ? AppColors.goldDim : AppColors.crimsonLight),
                ),
                child: Column(
                  children: [
                    Text('SKILL POINTS', style: AppTypography.titleSmall.copyWith(fontSize: 10)),
                    Text(
                      remSkill == 0 ? 'Balanced ✓' : (remSkill > 0 ? '$remSkill Unspent' : '${-remSkill} Overspent ⚠️'),
                      style: AppTypography.titleMedium.copyWith(
                        color: remSkill == 0 ? AppColors.gold : AppColors.crimsonLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        if (remAttr != 0 || remSkill != 0) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.crimson.withAlpha(25),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.crimsonLight.withAlpha(120)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.crimsonLight, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Budget must balance exactly to 0 before proceeding.\n'
                    '${remAttr != 0 ? (remAttr > 0 ? "Spend $remAttr more Attribute pts. " : "Remove ${-remAttr} Attribute pts. ") : ""}'
                    '${remSkill != 0 ? (remSkill > 0 ? "Spend $remSkill more Skill pts." : "Remove ${-remSkill} Skill pts.") : ""}',
                    style: const TextStyle(fontSize: 11, color: AppColors.crimsonLight),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
        Text('ATTRIBUTES', style: AppTypography.titleSmall),
        const SizedBox(height: 8),

        ...AttributeType.values.map((attr) {
          final val = _builderVm.attributes[attr] ?? 2;
          final isMain = attr == arc.mainAttribute;
          final maxCap = isMain ? 5 : 4;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(attr.label, style: AppTypography.bodyLarge),
                    if (isMain)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: _badge('MAIN (max 5)', AppColors.gold),
                      ),
                  ],
                ),
                PipCounter(
                  value: val,
                  min: 2,
                  max: maxCap,
                  onChanged: (newVal) => _builderVm.setAttribute(attr, newVal),
                ),
              ],
            ),
          );
        }),

        const OrnateDivider(height: 20),
        Text('SKILLS', style: AppTypography.titleSmall),
        const SizedBox(height: 8),

        ...SkillType.values.map((skill) {
          final val = _builderVm.skills[skill] ?? 0;
          final isMain = skill == arc.mainSkill;
          final maxCap = isMain ? 3 : 2;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(skill.label, style: AppTypography.bodyMedium),
                    if (isMain)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: _badge('MAIN (max 3)', AppColors.crimsonLight),
                      ),
                  ],
                ),
                PipCounter(
                  value: val,
                  min: 0,
                  max: maxCap,
                  onChanged: (newVal) => _builderVm.setSkill(skill, newVal),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _step3TalentMobile() {
    final arc = _builderVm.archetype;
    final availableTalents = TalentsData.allTalents
        .where((t) => arc.talentIds.contains(t.id) || t.isGeneral)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 4: Starting Talent', style: AppTypography.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Choose 1 starting talent from your archetype (${arc.name}) or the general talents list.',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 14),

        ...availableTalents.map((talent) {
          final isSelected = _builderVm.selectedTalents.any((t) => t.id == talent.id);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: GothicCard(
              backgroundColor: isSelected ? AppColors.surfaceLight : AppColors.surface,
              borderColor: isSelected ? AppColors.goldBright : AppColors.surfaceOverlay,
              borderWidth: isSelected ? 1.5 : 1.0,
              onTap: () => _builderVm.toggleTalent(talent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        talent.name,
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 14,
                          color: isSelected ? AppColors.goldBright : AppColors.textPrimary,
                        ),
                      ),
                      if (talent.archetypeName != null)
                        _badge(talent.archetypeName!, AppColors.gold)
                      else
                        _badge('General', AppColors.surfaceOverlay),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(talent.effect, style: AppTypography.bodySmall),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _step4LoreMobile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Step 5: Narrative Foundations', style: AppTypography.titleLarge),
        const SizedBox(height: 6),
        Text(
          'In Vaesen, characters are driven by personal secrets, traumatic encounters, and grounding memories.',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: 14),

        _textField('MOTIVATION', 'Why do you risk death to investigate the vaesen?', _builderVm.setMotivation, _builderVm.motivation),
        const SizedBox(height: 14),
        _textField('TRAUMA (THE SIGHT)', 'What terrifying supernatural incident awakened your Sight?', _builderVm.setTrauma, _builderVm.trauma),
        const SizedBox(height: 14),
        _textField('DARK SECRET', 'What guilt, crime, or forbidden secret do you conceal?', _builderVm.setDarkSecret, _builderVm.darkSecret),
        const SizedBox(height: 14),
        _textField('MEMENTO', 'What physical heirloom brings comfort to heal conditions once per mystery?', _builderVm.setMemento, _builderVm.memento),
      ],
    );
  }

  Widget _step5ReviewMobile() {
    final arc = _builderVm.archetype;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Final Step: Review & Enroll', style: AppTypography.titleLarge),
        const SizedBox(height: 12),

        _buildReviewValidationBanner(),

        GothicCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GothicPortrait(
                    portraitAsset: _builderVm.portraitAsset,
                    width: 60,
                    height: 60,
                    border: Border.all(color: AppColors.gold, width: 1.5),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _builderVm.name.isNotEmpty ? _builderVm.name : 'Unknown Investigator',
                          style: AppTypography.displayMedium.copyWith(color: AppColors.goldBright, fontSize: 18),
                        ),
                        Text(
                          '${arc.name} • ${_builderVm.actualAge} years old • ${_builderVm.ageCategory.label}',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.gold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const OrnateDivider(height: 16),
              Text('STARTING GEAR PACK', style: AppTypography.titleSmall.copyWith(fontSize: 12)),
              const SizedBox(height: 4),
              ...arc.startingGear.map((g) => Text('• $g', style: AppTypography.bodySmall)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _badge('Resources: ${arc.startingResources}', AppColors.gold),
                  const SizedBox(width: 8),
                  _badge('Capital: 1', AppColors.surfaceOverlay),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewValidationBanner() {
    if (!_builderVm.canEnroll) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.crimson.withAlpha(30),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.crimsonLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: AppColors.crimsonLight, size: 18),
                const SizedBox(width: 8),
                Text(
                  'ENROLLMENT REQUIREMENTS INCOMPLETE',
                  style: AppTypography.titleSmall.copyWith(color: AppColors.crimsonLight, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 6),
            if (!_builderVm.isNameValid)
              const Text('• Investigator Name is required (Step 1)', style: TextStyle(color: Colors.white, fontSize: 11)),
            if (!_builderVm.isAttributeBudgetValid)
              Text(
                '• Attributes: ${_builderVm.totalAttributePointsSpent}/${_builderVm.ageCategory.attributePoints} pts (${_builderVm.remainingAttributePoints > 0 ? "${_builderVm.remainingAttributePoints} unspent" : "${-_builderVm.remainingAttributePoints} overspent"})',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            if (!_builderVm.isSkillBudgetValid)
              Text(
                '• Skills: ${_builderVm.totalSkillPointsSpent}/${_builderVm.ageCategory.skillPoints} pts (${_builderVm.remainingSkillPoints > 0 ? "${_builderVm.remainingSkillPoints} unspent" : "${-_builderVm.remainingSkillPoints} overspent"})',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _builderVm.setStep(!_builderVm.isNameValid ? 0 : 2),
                icon: const Icon(Icons.build, size: 13, color: AppColors.goldBright),
                label: Text(
                  !_builderVm.isNameValid ? 'GO TO STEP 1 (NAME)' : 'GO TO STEP 3 (STATS)',
                  style: const TextStyle(color: AppColors.goldBright, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.gold.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gold),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.goldBright, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Point Budgets Balanced: Attributes (${_builderVm.totalAttributePointsSpent}/${_builderVm.ageCategory.attributePoints}) • Skills (${_builderVm.totalSkillPointsSpent}/${_builderVm.ageCategory.skillPoints}) ✓',
              style: AppTypography.bodySmall.copyWith(color: AppColors.goldBright, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
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
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textField(String label, String hint, ValueChanged<String> onChanged, [String initialValue = '']) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: AppColors.surfaceLight,
      ),
      onChanged: onChanged,
    );
  }
}
