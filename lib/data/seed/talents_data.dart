import '../../domain/models/talent.dart';

/// Official Talents from Vaesen Core Rulebook (Chapter 4, pp. 49–55).
/// Contains 30 Archetype-Specific Talents (3 per archetype) and 24 General Talents.
class TalentsData {
  static const List<Talent> allTalents = [
    // ── ACADEMIC (pp. 26, 50) ────────────────────────────────────────────────
    Talent(
      id: 'acad_bookworm',
      name: 'Bookworm',
      archetypeName: 'Academic',
      description: 'Gain +2 to LEARNING when looking for clues in books or libraries.',
      effect: '+2 to Learning when looking for clues in books or libraries.',
    ),
    Talent(
      id: 'acad_erudite',
      name: 'Erudite',
      archetypeName: 'Academic',
      description:
          'You can pass a LEARNING test to establish truths about places and phenomena in the game. The Gamemaster judges what is appropriate, and what is reasonable for you to know.',
      effect:
          'Pass a Learning test to establish truths about places and phenomena (GM judges appropriateness; cannot make up things about vaesen).',
    ),
    Talent(
      id: 'acad_knowledge_is_reassuring',
      name: 'Knowledge is Reassuring',
      archetypeName: 'Academic',
      description: 'Ignore Conditions when making LEARNING tests.',
      effect: 'Ignore Conditions when making Learning tests.',
    ),

    // ── DOCTOR (pp. 27, 50) ──────────────────────────────────────────────────
    Talent(
      id: 'doc_army_medic',
      name: 'Army Medic',
      archetypeName: 'Doctor',
      description: 'Gain +2 to Fear tests when frightened by dead or damaged human bodies.',
      effect: '+2 to Fear tests when frightened by dead or damaged human bodies.',
    ),
    Talent(
      id: 'doc_chief_physician',
      name: 'Chief Physician',
      archetypeName: 'Doctor',
      description:
          'When you use MEDICINE to treat the other player characters, they can heal a total of four Conditions instead of three. The same applies to extra successes.',
      effect:
          'Treated allies heal a total of 4 Conditions instead of 3 (also applies to extra successes).',
    ),
    Talent(
      id: 'doc_emergency_medicine',
      name: 'Emergency Medicine',
      archetypeName: 'Doctor',
      description: 'Ignore physical Conditions when using MEDICINE.',
      effect: 'Ignore physical Conditions when using Medicine.',
    ),

    // ── HUNTER (pp. 28, 50) ──────────────────────────────────────────────────
    Talent(
      id: 'hunt_bloodhound',
      name: 'Bloodhound',
      archetypeName: 'Hunter',
      description: 'Gain +2 to VIGILANCE when tracking your prey.',
      effect: '+2 to Vigilance when tracking your prey.',
    ),
    Talent(
      id: 'hunt_herbalist',
      name: 'Herbalist',
      archetypeName: 'Hunter',
      description:
          'By utilizing wild herbs, you can use MEDICINE without having access to medical supplies.',
      effect: 'Use Medicine without medical supplies by utilizing wild herbs.',
    ),
    Talent(
      id: 'hunt_marksman',
      name: 'Marksman',
      archetypeName: 'Hunter',
      description:
          'Gain +2 to RANGED COMBAT on your first round when successfully ambushing or attacking your enemy.',
      effect:
          '+2 to Ranged Combat on your first round when successfully ambushing or attacking your enemy.',
    ),

    // ── OCCULTIST (pp. 29, 51) ───────────────────────────────────────────────
    Talent(
      id: 'occ_conjuring_tricks',
      name: 'Conjuring Tricks',
      archetypeName: 'Occultist',
      description:
          'You can use STEALTH instead of MANIPULATION when performing conjuring tricks to influence people.',
      effect:
          'Use Stealth instead of Manipulation when performing conjuring tricks to influence people.',
    ),
    Talent(
      id: 'occ_medium',
      name: 'Medium',
      archetypeName: 'Occultist',
      description:
          'You can use OBSERVATION to perform seances where you predict people’s futures and contact the dead. Extra successes provide more information, prolong contact, or cause spirits to materialize. On failure you are given inaccurate information, attacked, or suffer a Condition.',
      effect:
          'Use Observation to perform seances to predict futures and contact the dead (extra successes reveal more, failure risks attack or Condition).',
    ),
    Talent(
      id: 'occ_strike_fear',
      name: 'Strike Fear',
      archetypeName: 'Occultist',
      description:
          'You can strike fear with Fear 1. It counts as a slow action and does not work against vaesen. Choose a victim in your zone. Targeted NPCs must pass a Logic or Empathy test. Their roll gains bonus dice equal to the number of friendly individuals in the same zone.',
      effect:
          'Slow action: Target NPC in your zone must pass a Logic or Empathy test against Fear 1 (roll gains +1 die per ally in their zone; does not affect vaesen).',
    ),

    // ── OFFICER (pp. 30, 52) ─────────────────────────────────────────────────
    Talent(
      id: 'off_battle_hardened',
      name: 'Battle-Hardened',
      archetypeName: 'Officer',
      description:
          'You are used to battle. When drawing for initiative, draw two cards and pick one of them.',
      effect: 'When drawing for initiative, draw two cards and pick one of them.',
    ),
    Talent(
      id: 'off_gentleman',
      name: 'Gentleman',
      archetypeName: 'Officer',
      description:
          'You were raised to control your emotions and behavior in social situations, even under pressure. Ignore penalties from mental Conditions when making MANIPULATION tests.',
      effect: 'Ignore penalties from mental Conditions when making Manipulation tests.',
    ),
    Talent(
      id: 'off_tactician',
      name: 'Tactician',
      archetypeName: 'Officer',
      description:
          'When you pass a RANGED COMBAT test during combat and get extra successes, you may – in addition to the usual alternatives – issue an order to a friend. Doing so costs one success. If they follow your order, they gain +2 to their next test.',
      effect:
          'Spend extra successes on Ranged Combat to issue orders to allies, granting +2 to their next test.',
    ),

    // ── PRIEST (pp. 31, 52) ──────────────────────────────────────────────────
    Talent(
      id: 'priest_absolution',
      name: 'Absolution',
      archetypeName: 'Priest',
      description:
          'A player character who confesses to you during resting heals three Conditions instead of two.',
      effect: 'Allies who confess to you during resting heal 3 Conditions instead of 2.',
    ),
    Talent(
      id: 'priest_blessing',
      name: 'Blessing',
      archetypeName: 'Priest',
      description:
          'Once per session you can bless an object or another player character. The player character, or anyone using the object, gains the Blessed Advantage, adding +2 to a test of their choice. The Advantage expires upon use or when the mystery is over. You can only bless the same character or object once per mystery.',
      effect:
          'Once per session: bless a character or object, granting +2 to a test of choice (expires upon use or end of mystery).',
    ),
    Talent(
      id: 'priest_confessor',
      name: 'Confessor',
      archetypeName: 'Priest',
      description:
          'You may use OBSERVATION instead of MANIPULATION when having a confidential conversation.',
      effect: 'Use Observation instead of Manipulation when having a confidential conversation.',
    ),

    // ── PRIVATE DETECTIVE (pp. 32, 53) ───────────────────────────────────────
    Talent(
      id: 'det_eagle_eye',
      name: 'Eagle Eye',
      archetypeName: 'Private Detective',
      description:
          'You gain +2 to VIGILANCE when trying to interpret a situation you are not involved in.',
      effect: '+2 to Vigilance when trying to interpret a situation you are not involved in.',
    ),
    Talent(
      id: 'det_elementary',
      name: 'Elementary',
      archetypeName: 'Private Detective',
      description:
          'Once per session you can ask the Gamemaster to explain how clues are connected.',
      effect: 'Once per session, ask the Gamemaster to explain how clues are connected.',
    ),
    Talent(
      id: 'det_focused',
      name: 'Focused',
      archetypeName: 'Private Detective',
      description: 'Ignore penalties from Conditions when making INVESTIGATION tests.',
      effect: 'Ignore penalties from Conditions when making Investigation tests.',
    ),

    // ── SERVANT (pp. 33, 53) ─────────────────────────────────────────────────
    Talent(
      id: 'serv_loyal',
      name: 'Loyal',
      archetypeName: 'Servant',
      description:
          'Gain +2 on Fear tests in the presence of someone you have sworn to protect.',
      effect: '+2 on Fear tests in the presence of someone you have sworn to protect.',
    ),
    Talent(
      id: 'serv_robust',
      name: 'Robust',
      archetypeName: 'Servant',
      description:
          'You may ignore penalties for physical Conditions on one roll per gaming session.',
      effect: 'Once per session, ignore penalties from physical Conditions on any one roll.',
    ),
    Talent(
      id: 'serv_tough_as_nails',
      name: 'Tough as Nails',
      archetypeName: 'Servant',
      description: 'Gain +2 to FORCE when fighting unarmed.',
      effect: '+2 to Force when fighting unarmed.',
    ),

    // ── VAGABOND (pp. 34, 53) ────────────────────────────────────────────────
    Talent(
      id: 'vag_hobo_tricks',
      name: 'Hobo Tricks',
      archetypeName: 'Vagabond',
      description:
          'Gain +2 to STEALTH when trying to hide yourself or an object from a wealthy human.',
      effect:
          '+2 to Stealth when trying to hide yourself or an object from a wealthy human.',
    ),
    Talent(
      id: 'vag_suspicious',
      name: 'Suspicious',
      archetypeName: 'Vagabond',
      description: 'Ignore mental Conditions when making VIGILANCE tests.',
      effect: 'Ignore mental Conditions when making Vigilance tests.',
    ),
    Talent(
      id: 'vag_well_traveled',
      name: 'Well-Traveled',
      archetypeName: 'Vagabond',
      description:
          'Once per mystery you can make a MANIPULATION test to create an NPC who is situated in the area, and who you have met before. The Gamemaster decides how they have changed since you last met, and what they think of you now. If the test fails, they are either hostile or in great need of your help.',
      effect:
          'Once per mystery: pass Manipulation to introduce a known NPC in the area (GM determines their disposition).',
    ),

    // ── WRITER (pp. 35, 53) ──────────────────────────────────────────────────
    Talent(
      id: 'writ_automatic_writing',
      name: 'Automatic Writing',
      archetypeName: 'Writer',
      description:
          'When channeling spirits through automatic writing you can use INSPIRATION to gain clues. The Gamemaster provides clues, predictions, or insights. Extra successes reveal more clues. On failure the Gamemaster decides whether you suffer a Condition, become possessed, or undergo a personality change. Can be used once per gaming session.',
      effect:
          'Once per session: use Inspiration to channel spirits for clues and predictions (failure risks Condition or possession).',
    ),
    Talent(
      id: 'writ_journalist',
      name: 'Journalist',
      archetypeName: 'Writer',
      description:
          'You may use INSPIRATION instead of MANIPULATION when charming or deceiving someone to gain information.',
      effect:
          'Use Inspiration instead of Manipulation when charming or deceiving someone to gain information.',
    ),
    Talent(
      id: 'writ_wordsmith',
      name: 'Wordsmith',
      archetypeName: 'Writer',
      description: 'Ignore penalties from Conditions when making INSPIRATION tests.',
      effect: 'Ignore penalties from Conditions when making Inspiration tests.',
    ),

    // ── GENERAL TALENTS (pp. 54–55) ──────────────────────────────────────────
    Talent(
      id: 'gen_battle_experience',
      name: 'Battle Experience',
      description: 'Gain +2 to MEDICINE when treating a physical critical injury.',
      effect: '+2 to Medicine when treating a physical critical injury.',
    ),
    Talent(
      id: 'gen_brave',
      name: 'Brave',
      description: 'Gain +1 to all Fear tests.',
      effect: '+1 to all Fear tests.',
    ),
    Talent(
      id: 'gen_combat_trained',
      name: 'Combat-Trained',
      description: 'Gain +2 to CLOSE COMBAT and FORCE when parrying.',
      effect: '+2 to Close Combat and Force when parrying.',
    ),
    Talent(
      id: 'gen_contacts',
      name: 'Contacts',
      description:
          'Once per session you can decide that you already know a certain NPC, and that your relationship is a positive one. The Gamemaster may disallow it, if the contact would make the mystery less fun.',
      effect:
          'Once per session: declare that you know a certain NPC with a positive relationship (GM discretion).',
    ),
    Talent(
      id: 'gen_coward',
      name: 'Coward',
      description:
          'When wounded in combat, you can make another player character take damage in your stead by passing a STEALTH test. It does not count as an action. If the test fails, you are hit for 1 extra damage. This can be done once per combat encounter.',
      effect:
          'Once per combat: when wounded, pass Stealth to have an ally take the hit instead (failure inflicts +1 extra damage to you).',
    ),
    Talent(
      id: 'gen_deceptive',
      name: 'Deceptive',
      description: 'Gain +2 to MANIPULATION when cheating and deceiving.',
      effect: '+2 to Manipulation when cheating and deceiving.',
    ),
    Talent(
      id: 'gen_dedicated',
      name: 'Dedicated',
      description: 'Once per session you can ignore a mental Condition from pushing a skill test.',
      effect: 'Once per session: ignore a mental Condition from pushing a skill test.',
    ),
    Talent(
      id: 'gen_defensive',
      name: 'Defensive',
      description:
          'Each round you get one extra fast action that may only be used to dodge or parry.',
      effect: 'Each round gain one extra fast action usable only to dodge or parry.',
    ),
    Talent(
      id: 'gen_dual_weapons',
      name: 'Dual Weapons',
      description:
          'When using dual weapons in close combat, you can use extra successes to hit an additional enemy in the same zone. If you use more successes to increase damage, you may choose which attack deals more damage.',
      effect:
          'When dual-wielding in close combat, extra successes can strike an additional enemy in your zone or amplify damage.',
    ),
    Talent(
      id: 'gen_dynamiter',
      name: 'Dynamiter',
      description: 'Gain +2 to RANGED COMBAT when using explosives.',
      effect: '+2 to Ranged Combat when using explosives.',
    ),
    Talent(
      id: 'gen_empathetic',
      name: 'Empathetic',
      description: 'Ignore penalties from Conditions when making OBSERVATION tests.',
      effect: 'Ignore penalties from Conditions when making Observation tests.',
    ),
    Talent(
      id: 'gen_escape_artist',
      name: 'Escape Artist',
      description: 'Ignore penalties from Conditions when using AGILITY to flee.',
      effect: 'Ignore penalties from Conditions when using Agility to flee.',
    ),
    Talent(
      id: 'gen_famous',
      name: 'Famous',
      description:
          'Gain +2 to MANIPULATION when trying to influence someone who has heard of you.',
      effect:
          '+2 to Manipulation when trying to influence someone who has heard of you.',
    ),
    Talent(
      id: 'gen_fleet_footed',
      name: 'Fleet-Footed',
      description: 'During combat you may move within your own zone without using actions.',
      effect: 'During combat, move within your own zone without expending actions.',
    ),
    Talent(
      id: 'gen_holy_symbol',
      name: 'Holy Symbol',
      description:
          'You have a religious item that allows you to use INSPIRATION to attack vaesen in close combat, dealing 1 damage.',
      effect:
          'Use Inspiration to attack vaesen in close combat with a holy relic, dealing 1 damage.',
    ),
    Talent(
      id: 'gen_lightning_reflexes',
      name: 'Lightning Reflexes',
      description: 'You can draw weapons without using an action.',
      effect: 'Draw weapons freely without spending an action.',
    ),
    Talent(
      id: 'gen_nine_lives',
      name: 'Nine Lives',
      description:
          'When rolling for a critical injury, you may decide which of the dice represents the tens and which represents the ones.',
      effect:
          'When rolling on the critical injury table, choose which die represents the tens and which represents the ones.',
    ),
    Talent(
      id: 'gen_pet',
      name: 'Pet',
      description:
          'You have a pet that you can use once per session to gain +1 to a test of your choice in a situation where your pet is clearly of use.',
      effect:
          'Once per session: gain +1 to a test of your choice where your animal companion is clearly useful.',
    ),
    Talent(
      id: 'gen_pugilist',
      name: 'Pugilist',
      description: 'Deal 1 extra damage when fighting unarmed.',
      effect: 'Deal +1 extra damage when fighting unarmed in Close Combat.',
    ),
    Talent(
      id: 'gen_safety_in_numbers',
      name: 'Safety in Numbers',
      description:
          'Gain +2 to Fear tests when accompanied by at least two other player characters. In combat this only applies if you are in the same zone.',
      effect:
          '+2 to Fear tests when accompanied by at least two other player characters in your zone.',
    ),
    Talent(
      id: 'gen_sixth_sense',
      name: 'Sixth Sense',
      description:
          'When making INVESTIGATION tests you may spend extra successes to learn if a vaesen has been in the area, gain more or less vague impressions of what kind of vaesen it is, and find out if magic has been used.',
      effect:
          'Spend extra Investigation successes to detect if a vaesen was present, glean impressions, and detect magic.',
    ),
    Talent(
      id: 'gen_sprinter',
      name: 'Sprinter',
      description: 'Gain +2 to AGILITY when trying to outrun or chase down someone.',
      effect: '+2 to Agility when trying to outrun or chase down someone.',
    ),
    Talent(
      id: 'gen_the_lords_shepherd',
      name: 'The Lord’s Shepherd',
      description: 'Gain +2 when using INSPIRATION to treat a mental critical injury.',
      effect: '+2 to Inspiration when treating a mental critical injury.',
    ),
    Talent(
      id: 'gen_wealthy',
      name: 'Wealthy',
      description: 'Increase Resources by 1 (can be purchased multiple times).',
      effect: 'Permanently increase your Resources rating by 1 (can be purchased multiple times).',
    ),
  ];
}
