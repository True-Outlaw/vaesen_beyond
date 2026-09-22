/// Represents an enchantment or supernatural magical ability used by a Vaesen creature.
class VaesenEnchantment {
  final String name;
  final String costOrTrigger;
  final String effect;

  const VaesenEnchantment({
    required this.name,
    required this.costOrTrigger,
    required this.effect,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'costOrTrigger': costOrTrigger,
        'effect': effect,
      };

  factory VaesenEnchantment.fromJson(Map<String, dynamic> json) => VaesenEnchantment(
        name: json['name'] as String? ?? '',
        costOrTrigger: json['costOrTrigger'] as String? ?? '',
        effect: json['effect'] as String? ?? '',
      );
}

/// Represents a natural, physical, or magical attack of a creature.
class VaesenAttack {
  final String name;
  final int damage;
  final String range;
  final String description;

  const VaesenAttack({
    required this.name,
    required this.damage,
    required this.range,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'damage': damage,
        'range': range,
        'description': description,
      };

  factory VaesenAttack.fromJson(Map<String, dynamic> json) => VaesenAttack(
        name: json['name'] as String? ?? '',
        damage: json['damage'] as int? ?? 1,
        range: json['range'] as String? ?? 'Arm’s Length',
        description: json['description'] as String? ?? '',
      );
}

/// A mythological creature from Scandinavian folklore featured in Vaesen.
class VaesenCreature {
  final String id;
  final String name;
  final String swedishName;
  final String category; // 'Nature Spirits', 'Undead', 'Fae', 'Monstrosities'
  final String description;
  final String habitat;
  final int might;
  final int body;
  final int mind;
  final int magic;
  final int fear; // Fear Value (1, 2, or 3)
  final List<VaesenEnchantment> enchantments;
  final List<VaesenAttack> attacks;
  final List<String> weaknesses;
  final List<String> ritualsOfBanishment;
  final String secrets;

  const VaesenCreature({
    required this.id,
    required this.name,
    required this.swedishName,
    required this.category,
    required this.description,
    required this.habitat,
    required this.might,
    required this.body,
    required this.mind,
    required this.magic,
    required this.fear,
    this.enchantments = const [],
    this.attacks = const [],
    this.weaknesses = const [],
    this.ritualsOfBanishment = const [],
    this.secrets = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'swedishName': swedishName,
        'category': category,
        'description': description,
        'habitat': habitat,
        'might': might,
        'body': body,
        'mind': mind,
        'magic': magic,
        'fear': fear,
        'enchantments': enchantments.map((e) => e.toJson()).toList(),
        'attacks': attacks.map((a) => a.toJson()).toList(),
        'weaknesses': weaknesses,
        'ritualsOfBanishment': ritualsOfBanishment,
        'secrets': secrets,
      };

  factory VaesenCreature.fromJson(Map<String, dynamic> json) => VaesenCreature(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        swedishName: json['swedishName'] as String? ?? '',
        category: json['category'] as String? ?? 'Nature Spirits',
        description: json['description'] as String? ?? '',
        habitat: json['habitat'] as String? ?? '',
        might: json['might'] as int? ?? 10,
        body: json['body'] as int? ?? 6,
        mind: json['mind'] as int? ?? 6,
        magic: json['magic'] as int? ?? 6,
        fear: json['fear'] as int? ?? 1,
        enchantments: (json['enchantments'] as List<dynamic>?)
                ?.map((e) => VaesenEnchantment.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        attacks: (json['attacks'] as List<dynamic>?)
                ?.map((a) => VaesenAttack.fromJson(a as Map<String, dynamic>))
                .toList() ??
            const [],
        weaknesses: (json['weaknesses'] as List<dynamic>?)?.map((w) => w as String).toList() ?? const [],
        ritualsOfBanishment:
            (json['ritualsOfBanishment'] as List<dynamic>?)?.map((r) => r as String).toList() ?? const [],
        secrets: json['secrets'] as String? ?? '',
      );
}
