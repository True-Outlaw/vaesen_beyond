import 'package:flutter/material.dart';
import 'package:vaesen_beyond/data/seed/archetypes_data.dart';
import 'package:vaesen_beyond/data/seed/talents_data.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_card.dart';
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

  @override
  Widget build(BuildContext context) {
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
              _buildStepProgress(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildCurrentStepContent(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.surfaceOverlay)),
                ),
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
                        onPressed: _builderVm.nextStep,
                        child: const Text('NEXT STEP'),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: () async {
                          final newChar = _builderVm.buildCharacter();
                          await widget.playViewModel.updateCharacter(newChar);
                          await widget.playViewModel.switchCharacter(newChar.id);
                          widget.onFinished();
                        },
                        icon: const Icon(Icons.check, color: AppColors.goldBright),
                        label: const Text('ENROLL INVESTIGATOR'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.crimson,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepProgress() {
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
            onTap: () => _builderVm.setStep(index),
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

  Widget _buildCurrentStepContent() {
    switch (_builderVm.currentStep) {
      case 0:
        return _step0Archetype();
      case 1:
        return _step1Age();
      case 2:
        return _step2AttributesAndSkills();
      case 3:
        return _step3Talent();
      case 4:
        return _step4Lore();
      case 5:
      default:
        return _step5Review();
    }
  }

  Widget _step0Archetype() {
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

        TextField(
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

  Widget _step1Age() {
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

  Widget _step2AttributesAndSkills() {
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
                      '$remAttr Remaining',
                      style: AppTypography.titleMedium.copyWith(
                        color: remAttr == 0 ? AppColors.gold : AppColors.goldBright,
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
                      '$remSkill Remaining',
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

  Widget _step3Talent() {
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

  Widget _step4Lore() {
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

        _textField('MOTIVATION', 'Why do you risk death to investigate the vaesen?', _builderVm.setMotivation),
        const SizedBox(height: 14),
        _textField('TRAUMA (THE SIGHT)', 'What terrifying supernatural incident awakened your Sight?', _builderVm.setTrauma),
        const SizedBox(height: 14),
        _textField('DARK SECRET', 'What guilt, crime, or forbidden secret do you conceal?', _builderVm.setDarkSecret),
        const SizedBox(height: 14),
        _textField('MEMENTO', 'What physical heirloom brings comfort to heal conditions once per mystery?', _builderVm.setMemento),
      ],
    );
  }

  Widget _step5Review() {
    final arc = _builderVm.archetype;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Final Step: Review & Enroll', style: AppTypography.titleLarge),
        const SizedBox(height: 12),
        GothicCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _builderVm.name.isNotEmpty ? _builderVm.name : 'Unknown Investigator',
                style: AppTypography.displayMedium.copyWith(color: AppColors.goldBright),
              ),
              Text(
                '${arc.name} • ${_builderVm.actualAge} years old • ${_builderVm.ageCategory.label}',
                style: AppTypography.bodySmall.copyWith(color: AppColors.gold),
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

  Widget _textField(String label, String hint, ValueChanged<String> onChanged) {
    return TextField(
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
