import 'package:vaesen_beyond/domain/models/attribute_skill.dart';

class CriticalInjury {
  final int d66;
  final String name;
  final bool isPhysical;
  final bool isLethal;
  final String timeLimit;
  final SkillType treatmentSkill;
  final String healingTime;
  final String effect;

  const CriticalInjury({
    required this.d66,
    required this.name,
    required this.isPhysical,
    required this.isLethal,
    required this.timeLimit,
    required this.treatmentSkill,
    required this.healingTime,
    required this.effect,
  });

  Map<String, dynamic> toJson() => {
        'd66': d66,
        'name': name,
        'isPhysical': isPhysical,
        'isLethal': isLethal,
        'timeLimit': timeLimit,
        'treatmentSkill': treatmentSkill.name,
        'healingTime': healingTime,
        'effect': effect,
      };

  factory CriticalInjury.fromJson(Map<String, dynamic> json) => CriticalInjury(
        d66: json['d66'] as int,
        name: json['name'] as String,
        isPhysical: json['isPhysical'] as bool? ?? true,
        isLethal: json['isLethal'] as bool? ?? false,
        timeLimit: json['timeLimit'] as String? ?? 'None',
        treatmentSkill: SkillType.values.firstWhere(
          (s) => s.name == json['treatmentSkill'],
          orElse: () => json['isPhysical'] == false ? SkillType.inspiration : SkillType.medicine,
        ),
        healingTime: json['healingTime'] as String? ?? '1D6 days',
        effect: json['effect'] as String? ?? '',
      );
}

class ActiveInjury {
  final String id;
  final CriticalInjury injury;
  final String sustainedAt;
  final bool isTreated;

  const ActiveInjury({
    required this.id,
    required this.injury,
    required this.sustainedAt,
    this.isTreated = false,
  });

  ActiveInjury copyWith({
    String? id,
    CriticalInjury? injury,
    String? sustainedAt,
    bool? isTreated,
  }) {
    return ActiveInjury(
      id: id ?? this.id,
      injury: injury ?? this.injury,
      sustainedAt: sustainedAt ?? this.sustainedAt,
      isTreated: isTreated ?? this.isTreated,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'injury': injury.toJson(),
        'sustainedAt': sustainedAt,
        'isTreated': isTreated,
      };

  factory ActiveInjury.fromJson(Map<String, dynamic> json) => ActiveInjury(
        id: json['id'] as String,
        injury: CriticalInjury.fromJson(json['injury'] as Map<String, dynamic>),
        sustainedAt: json['sustainedAt'] as String? ?? '',
        isTreated: json['isTreated'] as bool? ?? false,
      );
}
