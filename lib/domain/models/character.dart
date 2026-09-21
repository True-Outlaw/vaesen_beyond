import 'package:vaesen_beyond/domain/models/advantage.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/condition.dart';
import 'package:vaesen_beyond/domain/models/critical_injury.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/domain/models/talent.dart';

enum AgeCategory {
  young('Young (17–25)', 17, 25, 15, 10),
  middleAged('Middle-aged (26–50)', 26, 50, 14, 12),
  old('Old (51+)', 51, 80, 13, 14);

  const AgeCategory(
    this.label,
    this.minAge,
    this.maxAge,
    this.attributePoints,
    this.skillPoints,
  );

  final String label;
  final int minAge;
  final int maxAge;
  final int attributePoints;
  final int skillPoints;
}

class Character {
  final String id;
  final String name;
  final String archetypeName;
  final AgeCategory ageCategory;
  final int actualAge;
  final String motivation;
  final String trauma;
  final String darkSecret;
  final String memento;
  final bool isMementoUsed;

  final Map<AttributeType, int> attributes;
  final Map<SkillType, int> skills;
  final ConditionsState conditions;

  final List<Talent> talents;
  final List<Weapon> weapons;
  final List<Armor> armor;
  final List<EquipmentItem> equipment;
  final List<Advantage> advantages;

  final int resources;
  final int capital;
  final int experiencePoints;
  final Map<String, String> relationships;
  final List<ActiveInjury> activeInjuries;
  final String notes;

  const Character({
    required this.id,
    required this.name,
    required this.archetypeName,
    this.ageCategory = AgeCategory.middleAged,
    this.actualAge = 35,
    this.motivation = '',
    this.trauma = '',
    this.darkSecret = '',
    this.memento = '',
    this.isMementoUsed = false,
    required this.attributes,
    required this.skills,
    this.conditions = const ConditionsState(),
    this.talents = const [],
    this.weapons = const [],
    this.armor = const [],
    this.equipment = const [],
    this.advantages = const [],
    this.resources = 3,
    this.capital = 1,
    this.experiencePoints = 0,
    this.relationships = const {},
    this.activeInjuries = const [],
    this.notes = '',
  });

  Advantage? get activeAdvantage {
    for (final a in advantages) {
      if (!a.isUsed) return a;
    }
    return null;
  }

  bool get hasActiveAdvantage => activeAdvantage != null;

  int getAttribute(AttributeType type) => attributes[type] ?? 2;
  int getSkill(SkillType type) => skills[type] ?? 0;

  int get effectivePhysique =>
      (getAttribute(AttributeType.physique) - conditions.physicalPenalty).clamp(0, 10);
  int get effectivePrecision =>
      (getAttribute(AttributeType.precision) - conditions.physicalPenalty).clamp(0, 10);
  int get effectiveLogic =>
      (getAttribute(AttributeType.logic) - conditions.mentalPenalty).clamp(0, 10);
  int get effectiveEmpathy =>
      (getAttribute(AttributeType.empathy) - conditions.mentalPenalty).clamp(0, 10);

  int getEffectiveAttribute(AttributeType type) {
    switch (type) {
      case AttributeType.physique:
        return effectivePhysique;
      case AttributeType.precision:
        return effectivePrecision;
      case AttributeType.logic:
        return effectiveLogic;
      case AttributeType.empathy:
        return effectiveEmpathy;
    }
  }

  int getEffectiveSkillPool(SkillType skill, {int gearBonus = 0, int extraBonus = 0}) {
    final attrVal = getEffectiveAttribute(skill.attribute);
    final skillVal = getSkill(skill);
    return (attrVal + skillVal + gearBonus + extraBonus).clamp(0, 30);
  }

  int getEffectiveSkill(SkillType skill) => getEffectiveSkillPool(skill);

  int get maxCarrySlots => getAttribute(AttributeType.physique) + 2;

  int get currentCarryWeight {
    int total = 0;
    for (final eq in equipment) {
      total += eq.isHeavy ? 2 : eq.slots;
    }
    for (final w in weapons) {
      if (w.qualities.contains('Heavy')) {
        total += 2;
      } else {
        total += 1;
      }
    }
    total += armor.length;
    return total;
  }

  bool get isEncumbered => currentCarryWeight > maxCarrySlots;

  int get totalArmorProtection {
    return armor
        .where((a) => a.isEquipped)
        .fold<int>(0, (sum, item) => sum + item.protection);
  }

  Character copyWith({
    String? id,
    String? name,
    String? archetypeName,
    AgeCategory? ageCategory,
    int? actualAge,
    String? motivation,
    String? trauma,
    String? darkSecret,
    String? memento,
    bool? isMementoUsed,
    Map<AttributeType, int>? attributes,
    Map<SkillType, int>? skills,
    ConditionsState? conditions,
    List<Talent>? talents,
    List<Weapon>? weapons,
    List<Armor>? armor,
    List<EquipmentItem>? equipment,
    List<Advantage>? advantages,
    int? resources,
    int? capital,
    int? experiencePoints,
    Map<String, String>? relationships,
    List<ActiveInjury>? activeInjuries,
    String? notes,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      archetypeName: archetypeName ?? this.archetypeName,
      ageCategory: ageCategory ?? this.ageCategory,
      actualAge: actualAge ?? this.actualAge,
      motivation: motivation ?? this.motivation,
      trauma: trauma ?? this.trauma,
      darkSecret: darkSecret ?? this.darkSecret,
      memento: memento ?? this.memento,
      isMementoUsed: isMementoUsed ?? this.isMementoUsed,
      attributes: attributes ?? this.attributes,
      skills: skills ?? this.skills,
      conditions: conditions ?? this.conditions,
      talents: talents ?? this.talents,
      weapons: weapons ?? this.weapons,
      armor: armor ?? this.armor,
      equipment: equipment ?? this.equipment,
      advantages: advantages ?? this.advantages,
      resources: resources ?? this.resources,
      capital: capital ?? this.capital,
      experiencePoints: experiencePoints ?? this.experiencePoints,
      relationships: relationships ?? this.relationships,
      activeInjuries: activeInjuries ?? this.activeInjuries,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'archetypeName': archetypeName,
        'ageCategory': ageCategory.name,
        'actualAge': actualAge,
        'motivation': motivation,
        'trauma': trauma,
        'darkSecret': darkSecret,
        'memento': memento,
        'isMementoUsed': isMementoUsed,
        'attributes': attributes.map((k, v) => MapEntry(k.name, v)),
        'skills': skills.map((k, v) => MapEntry(k.name, v)),
        'conditions': conditions.toJson(),
        'talents': talents.map((t) => t.toJson()).toList(),
        'weapons': weapons.map((w) => w.toJson()).toList(),
        'armor': armor.map((a) => a.toJson()).toList(),
        'equipment': equipment.map((e) => e.toJson()).toList(),
        'advantages': advantages.map((a) => a.toJson()).toList(),
        'resources': resources,
        'capital': capital,
        'experiencePoints': experiencePoints,
        'relationships': relationships,
        'activeInjuries': activeInjuries.map((i) => i.toJson()).toList(),
        'notes': notes,
      };

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      archetypeName: json['archetypeName'] as String,
      ageCategory: AgeCategory.values.firstWhere(
        (a) => a.name == json['ageCategory'],
        orElse: () => AgeCategory.middleAged,
      ),
      actualAge: json['actualAge'] as int? ?? 35,
      motivation: json['motivation'] as String? ?? '',
      trauma: json['trauma'] as String? ?? '',
      darkSecret: json['darkSecret'] as String? ?? '',
      memento: json['memento'] as String? ?? '',
      isMementoUsed: json['isMementoUsed'] as bool? ?? false,
      attributes: (json['attributes'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(
          AttributeType.values.firstWhere((a) => a.name == k),
          v as int,
        ),
      ),
      skills: (json['skills'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(
          SkillType.values.firstWhere((s) => s.name == k),
          v as int,
        ),
      ),
      conditions: json['conditions'] != null
          ? ConditionsState.fromJson(json['conditions'] as Map<String, dynamic>)
          : const ConditionsState(),
      talents: (json['talents'] as List<dynamic>? ?? [])
          .map((t) => Talent.fromJson(t as Map<String, dynamic>))
          .toList(),
      weapons: (json['weapons'] as List<dynamic>? ?? [])
          .map((w) => Weapon.fromJson(w as Map<String, dynamic>))
          .toList(),
      armor: (json['armor'] as List<dynamic>? ?? [])
          .map((a) => Armor.fromJson(a as Map<String, dynamic>))
          .toList(),
      equipment: (json['equipment'] as List<dynamic>? ?? [])
          .map((e) => EquipmentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      advantages: (json['advantages'] as List<dynamic>? ?? [])
          .map((a) => Advantage.fromJson(a as Map<String, dynamic>))
          .toList(),
      resources: json['resources'] as int? ?? 3,
      capital: json['capital'] as int? ?? 1,
      experiencePoints: json['experiencePoints'] as int? ?? 0,
      relationships: (json['relationships'] as Map<String, dynamic>? ?? {})
          .map((k, v) => MapEntry(k, v.toString())),
      activeInjuries: (json['activeInjuries'] as List<dynamic>? ?? [])
          .map((i) => ActiveInjury.fromJson(i as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String? ?? '',
    );
  }
}
