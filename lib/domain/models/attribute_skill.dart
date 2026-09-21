enum AttributeType {
  physique('Physique', 'Physical endurance, brawn, and resilience.'),
  precision('Precision', 'Motor coordination, dexterity, and fine craftsmanship.'),
  logic('Logic', 'Intellectual capacity, reasoning, and deductive education.'),
  empathy('Empathy', 'Charisma, emotional perception, and spiritual understanding.');

  const AttributeType(this.label, this.description);
  final String label;
  final String description;

  bool get isPhysical => this == AttributeType.physique || this == AttributeType.precision;
  bool get isMental => this == AttributeType.logic || this == AttributeType.empathy;
}

enum SkillType {
  // Physique
  agility('Agility', AttributeType.physique, 'Speed, balance, and acrobatic maneuvering.'),
  closeCombat('Close Combat', AttributeType.physique, 'Melee fighting with brawn, blades, and clubs.'),
  force('Force', AttributeType.physique, 'Raw muscular power, lifting, and breaking barriers.'),

  // Precision
  medicine('Medicine', AttributeType.precision, 'First aid, diagnosis, surgeries, and forensic examination.'),
  rangedCombat('Ranged Combat', AttributeType.precision, 'Shooting guns, throwing weapons, and archery.'),
  stealth('Stealth', AttributeType.precision, 'Moving silently, hiding in shadows, and sleight of hand.'),

  // Logic
  investigation('Investigation', AttributeType.logic, 'Searching crime scenes, analyzing clues, and deduction.'),
  learning('Learning', AttributeType.logic, 'Academic lore, history, languages, and scientific knowledge.'),
  vigilance('Vigilance', AttributeType.logic, 'Alertness, perceiving ambushes, and quick initiative.'),

  // Empathy
  inspiration('Inspiration', AttributeType.empathy, 'Rousing allies, restoring mental morale, and artistic leadership.'),
  manipulation('Manipulation', AttributeType.empathy, 'Persuading, bluffing, bargaining, and intimidating with words.'),
  observation('Observation', AttributeType.empathy, 'Reading facial expressions, detecting lies, and intuitive hunches.');

  const SkillType(this.label, this.attribute, this.description);
  final String label;
  final AttributeType attribute;
  final String description;
}
