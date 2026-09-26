import 'package:vaesen_beyond/domain/models/attribute_skill.dart';

class Archetype {
  final String name;
  final String tagline;
  final String description;
  final AttributeType mainAttribute;
  final SkillType mainSkill;
  final int minResources;
  final int maxResources;
  int get startingResources => minResources;
  final List<String> talentIds;
  final List<String> startingGear;
  final String originRegion;
  final List<String> suggestedFirstNames;
  final List<String> suggestedLastNames;
  final List<String> suggestedMotivations;
  final List<String> suggestedTraumas;
  final List<String> suggestedDarkSecrets;
  final List<String> suggestedRelationships;

  const Archetype({
    required this.name,
    required this.tagline,
    required this.description,
    required this.mainAttribute,
    required this.mainSkill,
    required this.minResources,
    required this.maxResources,
    required this.talentIds,
    required this.startingGear,
    this.originRegion = 'Nordic',
    this.suggestedFirstNames = const [],
    this.suggestedLastNames = const [],
    this.suggestedMotivations = const [],
    this.suggestedTraumas = const [],
    this.suggestedDarkSecrets = const [],
    this.suggestedRelationships = const [],
  });

  String get resourceRange => '$minResources–$maxResources';
}
