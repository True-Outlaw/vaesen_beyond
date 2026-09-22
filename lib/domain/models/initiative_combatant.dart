/// Represents an investigator or adversary slot in the Vaesen 1–10 card initiative order.
class InitiativeCombatant {
  final String id;
  final String name;
  final int cardNumber; // Card value from 1 to 10. Lowest number acts first.
  final bool isInvestigator;
  final String? characterId;
  final bool hasActed;
  final String? archetypeOrType;
  final String? portraitAsset;

  const InitiativeCombatant({
    required this.id,
    required this.name,
    required this.cardNumber,
    this.isInvestigator = true,
    this.characterId,
    this.hasActed = false,
    this.archetypeOrType,
    this.portraitAsset,
  });

  InitiativeCombatant copyWith({
    String? id,
    String? name,
    int? cardNumber,
    bool? isInvestigator,
    String? characterId,
    bool? hasActed,
    String? archetypeOrType,
    String? portraitAsset,
  }) {
    return InitiativeCombatant(
      id: id ?? this.id,
      name: name ?? this.name,
      cardNumber: cardNumber ?? this.cardNumber,
      isInvestigator: isInvestigator ?? this.isInvestigator,
      characterId: characterId ?? this.characterId,
      hasActed: hasActed ?? this.hasActed,
      archetypeOrType: archetypeOrType ?? this.archetypeOrType,
      portraitAsset: portraitAsset ?? this.portraitAsset,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cardNumber': cardNumber,
        'isInvestigator': isInvestigator,
        'characterId': characterId,
        'hasActed': hasActed,
        'archetypeOrType': archetypeOrType,
        'portraitAsset': portraitAsset,
      };

  factory InitiativeCombatant.fromJson(Map<String, dynamic> json) =>
      InitiativeCombatant(
        id: json['id'] as String,
        name: json['name'] as String,
        cardNumber: json['cardNumber'] as int,
        isInvestigator: json['isInvestigator'] as bool? ?? true,
        characterId: json['characterId'] as String?,
        hasActed: json['hasActed'] as bool? ?? false,
        archetypeOrType: json['archetypeOrType'] as String?,
        portraitAsset: json['portraitAsset'] as String?,
      );
}
