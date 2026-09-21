import 'package:flutter/foundation.dart';
import 'package:vaesen_beyond/data/seed/archetypes_data.dart';
import 'package:vaesen_beyond/data/seed/gear_data.dart';
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

  void setArchetype(Archetype arc) {
    _archetype = arc;
    _selectedTalents = [
      TalentsData.allTalents.firstWhere(
        (t) => arc.talentIds.contains(t.id),
        orElse: () => TalentsData.allTalents.first,
      )
    ];
    _equipment = arc.startingGear
        .map((g) => EquipmentItem(id: UniqueKey().toString(), name: g))
        .toList();
    notifyListeners();
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

  void setAttribute(AttributeType type, int val) {
    final maxAllowed = (type == _archetype.mainAttribute) ? 5 : 4;
    _attributes[type] = val.clamp(2, maxAllowed);
    notifyListeners();
  }

  void setSkill(SkillType type, int val) {
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

  int get remainingSkillPoints =>
      _ageCategory.skillPoints - totalSkillPointsSpent;

  Character buildCharacter() {
    return Character(
      id: 'char_${DateTime.now().millisecondsSinceEpoch}',
      name: _name.trim().isEmpty ? 'Investigator' : _name.trim(),
      archetypeName: _archetype.name,
      ageCategory: _ageCategory,
      actualAge: _actualAge,
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
      resources: _archetype.startingResources,
      capital: 1,
      experiencePoints: 0,
      notes: 'Formed at Castle Gyllencreutz.',
    );
  }
}
