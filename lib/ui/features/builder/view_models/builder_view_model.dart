import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:vaesen_beyond/data/seed/archetypes_data.dart';
import 'package:vaesen_beyond/data/seed/gear_data.dart';
import 'package:vaesen_beyond/data/seed/mementos_data.dart';
import 'package:vaesen_beyond/data/seed/talents_data.dart';
import 'package:vaesen_beyond/domain/models/archetype.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/condition.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/domain/models/talent.dart';

class BuilderViewModel extends ChangeNotifier {
  int _step = 0;
  int get currentStep => _step;

  String _name = '';
  String get name => _name;

  String _portraitAsset = 'assets/images/portraits/astrid.jpg';
  String get portraitAsset => _portraitAsset;

  String? _customPortraitDataUri;
  String? get customPortraitDataUri => _customPortraitDataUri;
  bool get hasCustomPortrait => _customPortraitDataUri != null && _customPortraitDataUri!.isNotEmpty;

  Archetype _archetype = ArchetypesData.allArchetypes.first;
  Archetype get archetype => _archetype;

  AgeCategory _ageCategory = AgeCategory.middleAged;
  AgeCategory get ageCategory => _ageCategory;

  int _actualAge = 35;
  int get actualAge => _actualAge;

  String _motivation = '';
  String get motivation => _motivation;

  String _trauma = '';
  String get trauma => _trauma;

  String _darkSecret = '';
  String get darkSecret => _darkSecret;

  String _memento = '';
  String get memento => _memento;

  int _resources = 4;
  int get resources => _resources;

  Map<AttributeType, int> _attributes = {
    AttributeType.physique: 2,
    AttributeType.precision: 2,
    AttributeType.logic: 2,
    AttributeType.empathy: 2,
  };
  Map<AttributeType, int> get attributes => _attributes;

  Map<SkillType, int> _skills = {
    for (final s in SkillType.values) s: 0,
  };
  Map<SkillType, int> get skills => _skills;

  List<Talent> _selectedTalents = [];
  List<Talent> get selectedTalents => _selectedTalents;

  List<Weapon> _weapons = [];
  List<Weapon> get weapons => _weapons;

  List<Armor> _armor = [];
  List<Armor> get armor => _armor;

  List<EquipmentItem> _equipment = [];
  List<EquipmentItem> get equipment => _equipment;

  BuilderViewModel() {
    _resetToDefaults();
  }

  void _resetToDefaults() {
    _archetype = ArchetypesData.allArchetypes.first;
    _ageCategory = AgeCategory.middleAged;
    _actualAge = 35;
    _resources = _archetype.minResources;
    _attributes = {
      AttributeType.physique: 3,
      AttributeType.precision: 3,
      AttributeType.logic: 4,
      AttributeType.empathy: 4,
    };
    _skills = {
      for (final s in SkillType.values) s: 0,
    };
    _skills[SkillType.learning] = 2;
    _skills[SkillType.investigation] = 2;
    _skills[SkillType.observation] = 2;
    _skills[SkillType.vigilance] = 2;
    _skills[SkillType.agility] = 2;
    _skills[SkillType.medicine] = 2;

    _selectedTalents = [
      TalentsData.allTalents.firstWhere((t) => t.id == _archetype.talentIds.first)
    ];

    _equipment = _archetype.startingGear
        .map((g) => EquipmentItem(id: DateTime.now().millisecondsSinceEpoch.toString(), name: g))
        .toList();

    _weapons = [GearData.standardWeapons.firstWhere((w) => w.id == 'w_knife')];
    _armor = [GearData.standardArmor.firstWhere((a) => a.id == 'a_none')];
  }

  void setStep(int s) {
    _step = s.clamp(0, 5);
    notifyListeners();
  }

  void nextStep() {
    if (_step < 5) {
      _step++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_step > 0) {
      _step--;
      notifyListeners();
    }
  }

  void setName(String val) {
    _name = val;
    notifyListeners();
  }

  void setPortraitAsset(String asset) {
    _portraitAsset = asset;
    notifyListeners();
  }

  void setCustomPortrait(String dataUri) {
    _customPortraitDataUri = dataUri;
    _portraitAsset = dataUri;
    notifyListeners();
  }

  void clearCustomPortrait() {
    _customPortraitDataUri = null;
    _applyDefaultArchetypePortrait(_archetype);
    notifyListeners();
  }

  void setArchetype(Archetype arc) {
    _archetype = arc;
    _resources = arc.minResources;
    _selectedTalents = [
      TalentsData.allTalents.firstWhere(
        (t) => arc.talentIds.contains(t.id),
        orElse: () => TalentsData.allTalents.first,
      )
    ];
    _equipment = arc.startingGear
        .map((g) => EquipmentItem(id: UniqueKey().toString(), name: g))
        .toList();

    // Preserve custom portrait if uploaded, otherwise set archetype default
    if (_customPortraitDataUri == null) {
      _applyDefaultArchetypePortrait(arc);
    }
    notifyListeners();
  }

  void _applyDefaultArchetypePortrait(Archetype arc) {
    final lower = arc.name.toLowerCase();
    if (lower.contains('doctor') || lower.contains('academic') || lower.contains('writer')) {
      _portraitAsset = 'assets/images/portraits/astrid.jpg';
    } else if (lower.contains('officer') || lower.contains('private detective') || lower.contains('guard')) {
      _portraitAsset = 'assets/images/portraits/birger.jpg';
    } else if (lower.contains('occultist') || lower.contains('priest')) {
      _portraitAsset = 'assets/images/portraits/elias.jpg';
    } else if (lower.contains('hunter') || lower.contains('servant') || lower.contains('vagabond')) {
      _portraitAsset = 'assets/images/portraits/johan.jpg';
    } else {
      _portraitAsset = 'assets/images/portraits/astrid.jpg';
    }
  }

  void setAgeCategory(AgeCategory cat) {
    _ageCategory = cat;
    _actualAge = (cat.minAge + cat.maxAge) ~/ 2;
    notifyListeners();
  }

  void setActualAge(int age) {
    _actualAge = age;
    notifyListeners();
  }

  void setMotivation(String val) {
    _motivation = val;
    notifyListeners();
  }

  void setTrauma(String val) {
    _trauma = val;
    notifyListeners();
  }

  void setDarkSecret(String val) {
    _darkSecret = val;
    notifyListeners();
  }

  void setMemento(String val) {
    _memento = val;
    notifyListeners();
  }

  void setResources(int val) {
    final current = _resources;
    if (val > current && remainingSkillPoints <= 0) {
      return;
    }
    _resources = val.clamp(_archetype.minResources, _archetype.maxResources);
    notifyListeners();
  }

  void rollRandomMemento() {
    final (_, item) = MementosData.rollMemento();
    _memento = item;
    notifyListeners();
  }

  void rollRandomName() {
    if (_archetype.suggestedFirstNames.isNotEmpty && _archetype.suggestedLastNames.isNotEmpty) {
      final rng = Random();
      final first = _archetype.suggestedFirstNames[rng.nextInt(_archetype.suggestedFirstNames.length)];
      final last = _archetype.suggestedLastNames[rng.nextInt(_archetype.suggestedLastNames.length)];
      _name = '$first $last';
      notifyListeners();
    }
  }

  void rollRandomMotivation() {
    if (_archetype.suggestedMotivations.isNotEmpty) {
      final rng = Random();
      _motivation = _archetype.suggestedMotivations[rng.nextInt(_archetype.suggestedMotivations.length)];
      notifyListeners();
    }
  }

  void rollRandomTrauma() {
    if (_archetype.suggestedTraumas.isNotEmpty) {
      final rng = Random();
      _trauma = _archetype.suggestedTraumas[rng.nextInt(_archetype.suggestedTraumas.length)];
      notifyListeners();
    }
  }

  void rollRandomDarkSecret() {
    if (_archetype.suggestedDarkSecrets.isNotEmpty) {
      final rng = Random();
      _darkSecret = _archetype.suggestedDarkSecrets[rng.nextInt(_archetype.suggestedDarkSecrets.length)];
      notifyListeners();
    }
  }

  void setAttribute(AttributeType type, int val) {
    final current = _attributes[type] ?? 2;
    if (val > current && remainingAttributePoints <= 0) {
      return;
    }
    final maxAllowed = (type == _archetype.mainAttribute) ? 5 : 4;
    _attributes[type] = val.clamp(2, maxAllowed);
    notifyListeners();
  }

  void setSkill(SkillType type, int val) {
    final current = _skills[type] ?? 0;
    if (val > current && remainingSkillPoints <= 0) {
      return;
    }
    final maxAllowed = (type == _archetype.mainSkill) ? 3 : 2;
    _skills[type] = val.clamp(0, maxAllowed);
    notifyListeners();
  }

  void toggleTalent(Talent talent) {
    if (_selectedTalents.any((t) => t.id == talent.id)) {
      if (_selectedTalents.length > 1) {
        _selectedTalents.removeWhere((t) => t.id == talent.id);
      }
    } else {
      _selectedTalents.add(talent);
    }
    notifyListeners();
  }

  int get totalAttributePointsSpent =>
      _attributes.values.fold<int>(0, (sum, val) => sum + val);

  int get remainingAttributePoints =>
      _ageCategory.attributePoints - totalAttributePointsSpent;

  int get totalSkillPointsSpent =>
      _skills.values.fold<int>(0, (sum, val) => sum + val);

  int get extraResourcesPoints => (_resources - _archetype.minResources).clamp(0, 99);

  int get remainingSkillPoints =>
      _ageCategory.skillPoints - totalSkillPointsSpent - extraResourcesPoints;

  bool get isNameValid => _name.trim().isNotEmpty;
  bool get isAttributeBudgetValid => remainingAttributePoints == 0;
  bool get isSkillBudgetValid => remainingSkillPoints == 0;
  bool get isTalentValid => _selectedTalents.isNotEmpty;
  bool get canEnroll =>
      isNameValid && isAttributeBudgetValid && isSkillBudgetValid && isTalentValid;

  /// Returns an error message if the current step is not valid to advance from,
  /// or null if the step is valid.
  String? getStepValidationError(int step) {
    switch (step) {
      case 0:
        if (!isNameValid) return 'Please enter an Investigator name to proceed.';
        return null;
      case 1:
        return null;
      case 2:
        if (remainingAttributePoints > 0) {
          return 'You must allocate all $remainingAttributePoints remaining Attribute points.';
        }
        if (remainingAttributePoints < 0) {
          return 'You have overspent Attribute points by ${-remainingAttributePoints}. Reduce points to balance.';
        }
        if (remainingSkillPoints > 0) {
          return 'You must allocate all $remainingSkillPoints remaining Skill/Resource points.';
        }
        if (remainingSkillPoints < 0) {
          return 'You have overspent Skill/Resource points by ${-remainingSkillPoints}. Reduce points to balance.';
        }
        return null;
      case 3:
        if (!isTalentValid) return 'Please choose at least 1 starting Talent.';
        return null;
      case 4:
        return null;
      case 5:
        if (!isNameValid) return 'Investigator name is required (Step 1).';
        if (!isAttributeBudgetValid) {
          return remainingAttributePoints > 0
              ? 'Attribute points must be fully allocated ($remainingAttributePoints remaining).'
              : 'Attribute points overspent by ${-remainingAttributePoints}.';
        }
        if (!isSkillBudgetValid) {
          return remainingSkillPoints > 0
              ? 'Skill/Resource points must be fully allocated ($remainingSkillPoints remaining).'
              : 'Skill/Resource points overspent by ${-remainingSkillPoints}.';
        }
        if (!isTalentValid) return 'A starting Talent is required (Step 4).';
        return null;
      default:
        return null;
    }
  }

  /// Returns the first validation error in any step from 0 up to [upToStep],
  /// or null if all steps up to [upToStep] are valid.
  String? getFirstValidationErrorUpTo(int upToStep) {
    for (int s = 0; s <= upToStep; s++) {
      final err = getStepValidationError(s);
      if (err != null) return err;
    }
    return null;
  }

  bool isStepValid(int step) => getStepValidationError(step) == null;

  Character buildCharacter() {
    return Character(
      id: 'char_${DateTime.now().millisecondsSinceEpoch}',
      name: _name.trim().isEmpty ? 'Investigator' : _name.trim(),
      archetypeName: _archetype.name,
      ageCategory: _ageCategory,
      actualAge: _actualAge,
      portraitAsset: _portraitAsset,
      motivation: _motivation,
      trauma: _trauma,
      darkSecret: _darkSecret,
      memento: _memento,
      attributes: Map.from(_attributes),
      skills: Map.from(_skills),
      conditions: const ConditionsState(),
      talents: List.from(_selectedTalents),
      weapons: List.from(_weapons),
      armor: List.from(_armor),
      equipment: List.from(_equipment),
      resources: _resources,
      capital: 1,
      experiencePoints: 0,
      notes: 'Formed at Castle Gyllencreutz.',
    );
  }
}
