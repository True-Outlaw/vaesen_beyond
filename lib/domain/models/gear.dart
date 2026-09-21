enum WeaponRange {
  engaged('Engaged'),
  near('Near'),
  short('Short'),
  long('Long');

  const WeaponRange(this.label);
  final String label;
}

class Weapon {
  final String id;
  final String name;
  final int damage;
  final int bonus;
  final WeaponRange range;
  final List<String> qualities;
  final bool isEquipped;

  const Weapon({
    required this.id,
    required this.name,
    required this.damage,
    required this.bonus,
    required this.range,
    this.qualities = const [],
    this.isEquipped = true,
  });

  bool get isRanged => range != WeaponRange.engaged;

  Weapon copyWith({
    String? id,
    String? name,
    int? damage,
    int? bonus,
    WeaponRange? range,
    List<String>? qualities,
    bool? isEquipped,
  }) {
    return Weapon(
      id: id ?? this.id,
      name: name ?? this.name,
      damage: damage ?? this.damage,
      bonus: bonus ?? this.bonus,
      range: range ?? this.range,
      qualities: qualities ?? this.qualities,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'damage': damage,
        'bonus': bonus,
        'range': range.name,
        'qualities': qualities,
        'isEquipped': isEquipped,
      };

  factory Weapon.fromJson(Map<String, dynamic> json) => Weapon(
        id: json['id'] as String,
        name: json['name'] as String,
        damage: json['damage'] as int? ?? 1,
        bonus: json['bonus'] as int? ?? 0,
        range: WeaponRange.values.firstWhere(
          (r) => r.name == json['range'],
          orElse: () => WeaponRange.engaged,
        ),
        qualities: (json['qualities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        isEquipped: json['isEquipped'] as bool? ?? true,
      );
}

class Armor {
  final String id;
  final String name;
  final int protection;
  final int agilityPenalty;
  final bool isEquipped;

  const Armor({
    required this.id,
    required this.name,
    required this.protection,
    this.agilityPenalty = 0,
    this.isEquipped = true,
  });

  Armor copyWith({
    String? id,
    String? name,
    int? protection,
    int? agilityPenalty,
    bool? isEquipped,
  }) {
    return Armor(
      id: id ?? this.id,
      name: name ?? this.name,
      protection: protection ?? this.protection,
      agilityPenalty: agilityPenalty ?? this.agilityPenalty,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'protection': protection,
        'agilityPenalty': agilityPenalty,
        'isEquipped': isEquipped,
      };

  factory Armor.fromJson(Map<String, dynamic> json) => Armor(
        id: json['id'] as String,
        name: json['name'] as String,
        protection: json['protection'] as int? ?? 0,
        agilityPenalty: json['agilityPenalty'] as int? ?? 0,
        isEquipped: json['isEquipped'] as bool? ?? true,
      );
}

class EquipmentItem {
  final String id;
  final String name;
  final String description;
  final int slots;
  final bool isHeavy;
  final int quantity;

  const EquipmentItem({
    required this.id,
    required this.name,
    this.description = '',
    this.slots = 1,
    this.isHeavy = false,
    this.quantity = 1,
  });

  EquipmentItem copyWith({
    String? id,
    String? name,
    String? description,
    int? slots,
    bool? isHeavy,
    int? quantity,
  }) {
    return EquipmentItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      slots: slots ?? this.slots,
      isHeavy: isHeavy ?? this.isHeavy,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'slots': slots,
        'isHeavy': isHeavy,
        'quantity': quantity,
      };

  factory EquipmentItem.fromJson(Map<String, dynamic> json) => EquipmentItem(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        slots: json['slots'] as int? ?? 1,
        isHeavy: json['isHeavy'] as bool? ?? false,
        quantity: json['quantity'] as int? ?? 1,
      );
}
