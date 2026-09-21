import 'package:vaesen_beyond/domain/models/attribute_skill.dart';

class Archetype {
  final String name;
  final String tagline;
  final String description;
  final AttributeType mainAttribute;
  final SkillType mainSkill;
  final int startingResources;
  final List<String> talentIds;
  final List<String> startingGear;
  final String originRegion;

  const Archetype({
    required this.name,
    required this.tagline,
    required this.description,
    required this.mainAttribute,
    required this.mainSkill,
    required this.startingResources,
    required this.talentIds,
    required this.startingGear,
    this.originRegion = 'Nordic',
  });
}
