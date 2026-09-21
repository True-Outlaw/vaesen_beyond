import '../../domain/models/talent.dart';

class TalentsData {
  static const List<Talent> allTalents = [
    // Academic
    Talent(
      id: 'acad_bookworm',
      name: 'Bookworm',
      archetypeName: 'Academic',
      description: 'You have read extensive historical, linguistic, and scientific texts.',
      effect: '+2 dice to Learning tests when consulting books, archives, or university records.',
    ),
    Talent(
      id: 'acad_erudite',
      name: 'Erudite',
      archetypeName: 'Academic',
      description: 'You can identify the origin and folklore of rare artifacts and symbols.',
      effect: '+2 dice to Investigation tests when examining ancient ruins, inscriptions, or occult symbols.',
    ),
    Talent(
      id: 'acad_focused',
      name: 'Know-It-All',
      archetypeName: 'Academic',
      description: 'Your sharp logical deduction grants clarity in moments of panic.',
      effect: 'Once per mystery, you can use Logic instead of Empathy when making a Fear Test.',
    ),

    // Doctor
    Talent(
      id: 'doc_field_surgeon',
      name: 'Army Medic',
      archetypeName: 'Doctor',
      description: 'You are accustomed to treating severe wounds under fire.',
      effect: '+2 dice to Medicine tests when treating lethal Critical Injuries in the field.',
    ),
    Talent(
      id: 'doc_calm_demeanor',
      name: 'Calm Demeanor',
      archetypeName: 'Doctor',
      description: 'Your scientific training shields you from losing your composure.',
      effect: 'You ignore the dice penalty from one Mental Condition of your choice.',
    ),
    Talent(
      id: 'doc_anatomist',
      name: 'Autopsy Specialist',
      archetypeName: 'Doctor',
      description: 'Examining corpses reveals supernatural poisons, curses, and weaknesses.',
      effect: '+2 dice to Investigation or Medicine when examining remains or corpses of victims.',
    ),

    // Hunter
    Talent(
      id: 'hunt_marksman',
      name: 'Marksman',
      archetypeName: 'Hunter',
      description: 'Your aim is steady and lethal from long range.',
      effect: '+2 dice to Ranged Combat when aiming at Short or Long range before firing.',
    ),
    Talent(
      id: 'hunt_tracker',
      name: 'Bloodhound',
      archetypeName: 'Hunter',
      description: 'No beast can conceal its tracks from your keen wilderness senses.',
      effect: '+2 dice to Vigilance when tracking beasts or vaesen through wilderness terrain.',
    ),
    Talent(
      id: 'hunt_trapper',
      name: 'Trapper',
      archetypeName: 'Hunter',
      description: 'You know how to construct snares, cold-iron traps, and deadfalls.',
      effect: '+2 dice to Force or Agility when setting or disarming snares and traps.',
    ),

    // Occultist
    Talent(
      id: 'occ_sixth_sense',
      name: 'Sixth Sense',
      archetypeName: 'Occultist',
      description: 'You feel a cold tingle at the nape of your neck when supernatural evil is near.',
      effect: 'The GM must inform you if a Vaesen is hiding in your immediate vicinity before an ambush.',
    ),
    Talent(
      id: 'occ_seance',
      name: 'Medium',
      archetypeName: 'Occultist',
      description: 'You can communicate with lingering ghosts and restless spirits.',
      effect: '+2 dice to Observation when attempting to speak to or perceive spiritual manifestations.',
    ),
    Talent(
      id: 'occ_banisher',
      name: 'Ritualist',
      archetypeName: 'Occultist',
      description: 'You know the precise incantations and symbols required for banishing rituals.',
      effect: '+2 dice to Learning or Inspiration during the execution of a Vaesen banishment ritual.',
    ),

    // Officer
    Talent(
      id: 'off_lead_from_front',
      name: 'Lead from the Front',
      archetypeName: 'Officer',
      description: 'Your commanding presence inspires courage in your fellow investigators.',
      effect: 'When you succeed at an Inspiration test, you can heal 1 Mental Condition on two allies at once.',
    ),
    Talent(
      id: 'off_tactician',
      name: 'Tactician',
      archetypeName: 'Officer',
      description: 'You quickly read the battlefield and deploy allies effectively.',
      effect: '+2 dice to Vigilance when drawing initiative cards in tactical encounters.',
    ),
    Talent(
      id: 'off_fencing',
      name: 'Duelist',
      archetypeName: 'Officer',
      description: 'Mastery of sabres, rapiers, and dueling blades.',
      effect: '+2 dice to Close Combat when wielding a single-handed blade in a one-on-one duel.',
    ),

    // Priest
    Talent(
      id: 'priest_absolution',
      name: 'Absolution',
      archetypeName: 'Priest',
      description: 'You offer soothing spiritual grace to souls in deep despair.',
      effect: 'Once per session, you can remove the Hopeless or Broken (Mental) condition from an ally with a prayer.',
    ),
    Talent(
      id: 'priest_holy_aura',
      name: 'Holy Ward',
      archetypeName: 'Priest',
      description: 'Holding your crucifix or sacred symbol cowers unholy spirits.',
      effect: '+2 dice to Fear tests for you and all allies in your immediate zone.',
    ),
    Talent(
      id: 'priest_confessor',
      name: 'Confessor',
      archetypeName: 'Priest',
      description: 'People naturally feel compelled to bare their souls and secrets to you.',
      effect: '+2 dice to Manipulation when encouraging people to confess truths or secret guilt.',
    ),

    // Private Detective
    Talent(
      id: 'det_sherlock',
      name: 'Deductive Leap',
      archetypeName: 'Private Detective',
      description: 'You spot tiny details—mud splatters, ash types, scuffed shoe leather.',
      effect: 'Extra successes (stunts) on Investigation grant two clues instead of one.',
    ),
    Talent(
      id: 'det_shadow',
      name: 'Tail / Shadow',
      archetypeName: 'Private Detective',
      description: 'You blend into crowds and city alleys without drawing attention.',
      effect: '+2 dice to Stealth when shadowing a suspect through populated streets or markets.',
    ),
    Talent(
      id: 'det_interrogator',
      name: 'Hard-Boiled Interrogator',
      archetypeName: 'Private Detective',
      description: 'You know exactly when a suspect is lying through their teeth.',
      effect: '+2 dice to Observation when questioning suspects and detecting deception.',
    ),

    // Servant
    Talent(
      id: 'serv_unnoticed',
      name: 'Blends In',
      archetypeName: 'Servant',
      description: 'Aristocrats, guards, and society disregard you as mere help.',
      effect: '+2 dice to Stealth and Observation in high-society manors, balls, and hotels.',
    ),
    Talent(
      id: 'serv_packmule',
      name: 'Pack Mule',
      archetypeName: 'Servant',
      description: 'You know how to pack and balance satchels with effortless poise.',
      effect: 'Your carrying capacity is Physique + 5 instead of Physique + 2.',
    ),
    Talent(
      id: 'serv_loyal',
      name: 'Loyal Guardian',
      archetypeName: 'Servant',
      description: 'You will take a blow meant for your master or companion.',
      effect: 'Once per combat, you can intercept an attack directed at an ally in your zone, taking the hit yourself.',
    ),

    // Vagabond
    Talent(
      id: 'vag_survivor',
      name: 'Hardened Survivor',
      archetypeName: 'Vagabond',
      description: 'Cold nights, starvation, and beatings have forged iron resilience.',
      effect: 'You ignore the dice penalty from one Physical Condition of your choice.',
    ),
    Talent(
      id: 'vag_gutter_fighter',
      name: 'Dirty Fighting',
      archetypeName: 'Vagabond',
      description: 'Sand in the eyes, broken bottles, and low blows.',
      effect: '+2 dice to Close Combat when fighting unarmed or using improvised weapons.',
    ),
    Talent(
      id: 'vag_contacts',
      name: 'Underworld Network',
      archetypeName: 'Vagabond',
      description: 'You know smugglers, pickpockets, and fences in every town port.',
      effect: '+2 dice to Manipulation when seeking shelter, black-market goods, or street rumors.',
    ),

    // Writer
    Talent(
      id: 'writ_eloquent',
      name: 'Eloquent Prose',
      archetypeName: 'Writer',
      description: 'Your letters, petitions, and speech command prestige and rapt attention.',
      effect: '+2 dice to Manipulation or Inspiration when delivering formal speeches or written documents.',
    ),
    Talent(
      id: 'writ_chronicler',
      name: 'Folklore Chronicler',
      archetypeName: 'Writer',
      description: 'You have compiled endless accounts of local fireside ghost stories.',
      effect: '+2 dice to Learning tests regarding local myths, ballads, and fairy tales.',
    ),
    Talent(
      id: 'writ_tragic_muse',
      name: 'Tragic Muse',
      archetypeName: 'Writer',
      description: 'You find poetic beauty in melancholy and dark secrets.',
      effect: 'Whenever you bring your Dark Secret into play, you earn +1 extra Experience Point.',
    ),

    // General Talents
    Talent(
      id: 'gen_tough',
      name: 'Tough as Nails',
      description: 'Your body endures extraordinary punishment.',
      effect: 'You can sustain a 4th physical condition before becoming Broken (requires 5 conditions to break).',
    ),
    Talent(
      id: 'gen_iron_will',
      name: 'Iron Will',
      description: 'Your mind is an unyielding fortress.',
      effect: 'You can sustain a 4th mental condition before becoming Broken (requires 5 conditions to break).',
    ),
    Talent(
      id: 'gen_wealthy',
      name: 'Wealthy Patron',
      description: 'Inherited fortune or lucrative investments bolster your credit.',
      effect: 'Your starting Resources rating is permanently increased by +2.',
    ),
    Talent(
      id: 'gen_fleet_footed',
      name: 'Fleet-Footed',
      description: 'Quick on your feet across obstacles and rooftops.',
      effect: '+2 dice to Agility when sprinting, escaping pursuit, or crossing treacherous ground.',
    ),
    Talent(
      id: 'gen_pugilist',
      name: 'Bare-Knuckle Boxer',
      description: 'Trained in Queensberry rules and tavern brawl conditioning.',
      effect: 'Your unarmed strikes deal 2 base damage instead of 1 in Close Combat.',
    ),
  ];
}
