import 'attribute_skill.dart';

class Advantage {
  final String id;
  final String title;
  final String effect;
  final SkillType? targetSkill;
  final bool isUsed;

  const Advantage({
    required this.id,
    required this.title,
    this.effect = '+2 dice to a related skill test',
    this.targetSkill,
    this.isUsed = false,
  });

  Advantage copyWith({
    String? id,
    String? title,
    String? effect,
    SkillType? targetSkill,
    bool? isUsed,
  }) {
    return Advantage(
      id: id ?? this.id,
      title: title ?? this.title,
      effect: effect ?? this.effect,
      targetSkill: targetSkill ?? this.targetSkill,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'effect': effect,
        'targetSkill': targetSkill?.name,
        'isUsed': isUsed,
      };

  factory Advantage.fromJson(Map<String, dynamic> json) {
    return Advantage(
      id: json['id'] as String,
      title: json['title'] as String,
      effect: json['effect'] as String? ?? '+2 dice to a related skill test',
      targetSkill: json['targetSkill'] != null
          ? SkillType.values.firstWhere(
              (s) => s.name == json['targetSkill'],
              orElse: () => SkillType.investigation,
            )
          : null,
      isUsed: json['isUsed'] as bool? ?? false,
    );
  }
}
