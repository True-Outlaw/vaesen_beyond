enum PhysicalCondition {
  exhausted('Exhausted', 'Overwhelmed by fatigue, breathlessness, and physical strain.'),
  battered('Battered', 'Bruised, aching, and physically battered by force or impact.'),
  wounded('Wounded', 'Deep cuts, bleeding wounds, or fractured tissue.');

  const PhysicalCondition(this.label, this.description);
  final String label;
  final String description;
}

enum MentalCondition {
  angry('Angry', 'Lashing out with frustration, wrath, and unstable irritation.'),
  frightened('Frightened', 'Trembling in cold terror, paralyzed with horror and shock.'),
  hopeless('Hopeless', 'Despair sets in, losing the will to fight or press forward.');

  const MentalCondition(this.label, this.description);
  final String label;
  final String description;
}

class ConditionsState {
  final bool exhausted;
  final bool battered;
  final bool wounded;
  final bool brokenPhysical;

  final bool angry;
  final bool frightened;
  final bool hopeless;
  final bool brokenMental;

  const ConditionsState({
    this.exhausted = false,
    this.battered = false,
    this.wounded = false,
    this.brokenPhysical = false,
    this.angry = false,
    this.frightened = false,
    this.hopeless = false,
    this.brokenMental = false,
  });

  int get physicalPenalty {
    int count = 0;
    if (exhausted) count++;
    if (battered) count++;
    if (wounded) count++;
    return count;
  }

  int get mentalPenalty {
    int count = 0;
    if (angry) count++;
    if (frightened) count++;
    if (hopeless) count++;
    return count;
  }

  bool get isBroken => brokenPhysical || brokenMental;

  ConditionsState copyWith({
    bool? exhausted,
    bool? battered,
    bool? wounded,
    bool? brokenPhysical,
    bool? angry,
    bool? frightened,
    bool? hopeless,
    bool? brokenMental,
  }) {
    return ConditionsState(
      exhausted: exhausted ?? this.exhausted,
      battered: battered ?? this.battered,
      wounded: wounded ?? this.wounded,
      brokenPhysical: brokenPhysical ?? this.brokenPhysical,
      angry: angry ?? this.angry,
      frightened: frightened ?? this.frightened,
      hopeless: hopeless ?? this.hopeless,
      brokenMental: brokenMental ?? this.brokenMental,
    );
  }

  Map<String, dynamic> toJson() => {
        'exhausted': exhausted,
        'battered': battered,
        'wounded': wounded,
        'brokenPhysical': brokenPhysical,
        'angry': angry,
        'frightened': frightened,
        'hopeless': hopeless,
        'brokenMental': brokenMental,
      };

  factory ConditionsState.fromJson(Map<String, dynamic> json) {
    return ConditionsState(
      exhausted: json['exhausted'] as bool? ?? false,
      battered: json['battered'] as bool? ?? false,
      wounded: json['wounded'] as bool? ?? false,
      brokenPhysical: json['brokenPhysical'] as bool? ?? false,
      angry: json['angry'] as bool? ?? false,
      frightened: json['frightened'] as bool? ?? false,
      hopeless: json['hopeless'] as bool? ?? false,
      brokenMental: json['brokenMental'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConditionsState &&
          runtimeType == other.runtimeType &&
          exhausted == other.exhausted &&
          battered == other.battered &&
          wounded == other.wounded &&
          brokenPhysical == other.brokenPhysical &&
          angry == other.angry &&
          frightened == other.frightened &&
          hopeless == other.hopeless &&
          brokenMental == other.brokenMental;

  @override
  int get hashCode => Object.hash(
        exhausted,
        battered,
        wounded,
        brokenPhysical,
        angry,
        frightened,
        hopeless,
        brokenMental,
      );
}
