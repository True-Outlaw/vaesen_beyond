class Talent {
  final String id;
  final String name;
  final String? archetypeName;
  final String description;
  final String effect;

  const Talent({
    required this.id,
    required this.name,
    this.archetypeName,
    required this.description,
    required this.effect,
  });

  bool get isGeneral => archetypeName == null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'archetypeName': archetypeName,
        'description': description,
        'effect': effect,
      };

  factory Talent.fromJson(Map<String, dynamic> json) => Talent(
        id: json['id'] as String,
        name: json['name'] as String,
        archetypeName: json['archetypeName'] as String?,
        description: json['description'] as String,
        effect: json['effect'] as String,
      );
}
