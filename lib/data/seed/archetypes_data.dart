import 'package:vaesen_beyond/domain/models/archetype.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';

/// Official Archetype definitions from Vaesen Core Rulebook (Chapter 2, pp. 26–35).
class ArchetypesData {
  static const List<Archetype> allArchetypes = [
    // ── 1. ACADEMIC (p. 26) ──────────────────────────────────────────────────
    Archetype(
      name: 'Academic',
      tagline: 'Scholar of ancient tomes, natural sciences, and esoteric lore.',
      description:
          'We all agreed that it was theoretically possible to give those who are not verum videntes the ability to see vaesen. For me, the issue became an obsession. If people around us could see the truth, we would become the leaders of the new world.',
      mainAttribute: AttributeType.logic,
      mainSkill: SkillType.learning,
      minResources: 4,
      maxResources: 6,
      talentIds: [
        'acad_bookworm',
        'acad_erudite',
        'acad_knowledge_is_reassuring',
      ],
      suggestedFirstNames: ['Albert', 'Astrid', 'Elin', 'Isaac', 'Louis', 'Praskoviya'],
      suggestedLastNames: ['Brugge', 'Gregorius', 'Taaltinen'],
      suggestedMotivations: [
        'Charting the unknown',
        'Proving my critics wrong',
        'Becoming famous',
      ],
      suggestedTraumas: [
        'Vaettir turned you into a rat',
        'Aged by the magic of a mermaid',
        'Watched your partner being torn apart by a giant',
      ],
      suggestedDarkSecrets: [
        'Addicted to drugs',
        'Stole or falsified documents to get research results',
        'Hunted by a vaesen',
      ],
      suggestedRelationships: [
        'A tool for my purposes',
        'I cannot stay calm in your presence',
        'A good friend',
      ],
      startingGear: [
        'Book collection or map book',
        'Writing utensils',
        'Liquor or slide rule',
      ],
    ),

    // ── 2. DOCTOR (p. 27) ────────────────────────────────────────────────────
    Archetype(
      name: 'Doctor',
      tagline: 'Healer of wounded bodies and anatomist of the strange.',
      description:
          'There are electrical signals moving through our bodies. The brain can remember more things than anyone could possibly write down. Yet my colleagues question the supernatural. The creature I dissected was not one of God’s creations. My oath includes the threats of Hell.',
      mainAttribute: AttributeType.logic,
      mainSkill: SkillType.medicine,
      minResources: 4,
      maxResources: 6,
      talentIds: [
        'doc_army_medic',
        'doc_chief_physician',
        'doc_emergency_medicine',
      ],
      suggestedFirstNames: ['Alfred', 'Dorotea', 'Friedrich', 'Karl', 'Margit', 'Vilhelmina'],
      suggestedLastNames: ['Borelius', 'Köningsmark', 'Luukonen'],
      suggestedMotivations: [
        'Exploring and describing the world',
        'Aiding the weak and afflicted',
        'Strengthening the Society and becoming its leader',
      ],
      suggestedTraumas: [
        'A corpse came back to life during an autopsy',
        'Operated on a person with donkey’s ears and hooves',
        'Saw your destiny in the eyes of a dying mermaid',
      ],
      suggestedDarkSecrets: [
        'Has two separate personalities',
        'Involved in illicit affairs',
        'Unnatural lust',
      ],
      suggestedRelationships: [
        'I trust you with my secrets',
        'You annoy me',
        'I dream of you at night',
      ],
      startingGear: [
        'Doctor’s bag with medical equipment',
        'Liquor or fine wine',
        'Weak horse or strong poison',
      ],
    ),

    // ── 3. HUNTER (p. 28) ────────────────────────────────────────────────────
    Archetype(
      name: 'Hunter',
      tagline: 'Tracker of the wilderness and master of firearms.',
      description:
          'The countess had come to our island to hunt a creature she called “the hairy one.” That night, we tracked it to the abandoned cabin. Only when a creature rose from the debris with fur and fangs did I understand: she was hunting those cursed to change beneath the full moon.',
      mainAttribute: AttributeType.precision,
      mainSkill: SkillType.rangedCombat,
      minResources: 2,
      maxResources: 4,
      talentIds: [
        'hunt_bloodhound',
        'hunt_herbalist',
        'hunt_marksman',
      ],
      suggestedFirstNames: ['Algot', 'Blenda', 'Egil', 'Maj', 'Malte', 'Torun'],
      suggestedLastNames: ['Ek', 'Lindberg', 'Sigridsson'],
      suggestedMotivations: [
        'The thing that attacked my family must be destroyed',
        'Live in tune with nature',
        'Wants to bag some fantastic game',
      ],
      suggestedTraumas: [
        'Attacked by the branches of an ash tree wife',
        'Broke your leg in the forest, but was guided home by a will o’ the wisp',
        'Captured at dawn by a mountain troll and was stuck in its petrified arms',
      ],
      suggestedDarkSecrets: [
        'I sold my soul',
        'I cannot control my fits of rage',
        'Has children with a vaesen',
      ],
      suggestedRelationships: [
        'I am attracted to you',
        'I hate bullies like you',
        'You’re a townie weakling',
      ],
      startingGear: [
        'Rifle',
        'Hunting knife or hunting dog',
        'Hunting trap or hunting equipment',
      ],
    ),

    // ── 4. OCCULTIST (p. 29) ─────────────────────────────────────────────────
    Archetype(
      name: 'Occultist',
      tagline: 'Investigator of seances, tarot, and ancient grimoires.',
      description:
          'I had to know the truth. How did I acquire the power of foresight, and how could I make men collapse in pain just by imagining their beating hearts? Mother kept coming back to the same words: “Your cradle. I woke up and looked in your cradle. You were swapped for another.”',
      mainAttribute: AttributeType.precision,
      mainSkill: SkillType.stealth,
      minResources: 1,
      maxResources: 4,
      talentIds: [
        'occ_conjuring_tricks',
        'occ_medium',
        'occ_strike_fear',
      ],
      suggestedFirstNames: ['Aleksander', 'Niklas', 'Thomas', 'Ingrid', 'Ulrika', 'Valentina'],
      suggestedLastNames: ['Bäcklund', 'Konradsson', 'Mörk'],
      suggestedMotivations: [
        'Learning about vaesen',
        'Understanding myself',
        'Power',
      ],
      suggestedTraumas: [
        'Was hit by corrosive venom while trying to steal a lindworm egg',
        'The family farm is being run by a grumpy house nisse',
        'Was attacked by a night raven who infected you with a febrile disease',
      ],
      suggestedDarkSecrets: [
        'Guilty of a heinous crime',
        'My powers control me',
        'Changeling',
      ],
      suggestedRelationships: [
        'You are hiding something from the rest of us',
        'You bring me peace',
        'You will save us all one day',
      ],
      startingGear: [
        'Crystal ball',
        'Powdered stag’s horn or tinder box',
        'Dagger or cooking pot',
      ],
    ),

    // ── 5. OFFICER (p. 30) ───────────────────────────────────────────────────
    Archetype(
      name: 'Officer',
      tagline: 'Disciplined leader trained in battlefield tactics and swordsmanship.',
      description:
          'As I rode toward the battlefront, I fantasized about my spectacular return. Among screaming bodies, I was hit by a bullet from one of my own. When I woke up, I was on a cart of corpses cared for by strange-looking trolls. I lose my speech when I think of the next summons to battle.',
      mainAttribute: AttributeType.precision,
      mainSkill: SkillType.rangedCombat,
      minResources: 3,
      maxResources: 7,
      talentIds: [
        'off_battle_hardened',
        'off_gentleman',
        'off_tactician',
      ],
      suggestedFirstNames: ['Alexandra', 'Franz', 'Jarmo', 'Johan', 'Klara', 'Kristina'],
      suggestedLastNames: ['Almklint', 'Lidén', 'Nordenflycht'],
      suggestedMotivations: [
        'Make my father proud',
        'My friends need me',
        'Seek out danger and death',
      ],
      suggestedTraumas: [
        'Almost drowned when your ship was dragged down by a sea monster',
        'Lost all your men to an angry giant',
        'Saw dead warriors rise again on the battlefield',
      ],
      suggestedDarkSecrets: [
        'Deserter',
        'Cannot cope with filth and disorder',
        'Killed a defenseless enemy',
      ],
      suggestedRelationships: [
        'Protects you at any cost',
        'My leader',
        'Distrusts you',
      ],
      startingGear: [
        'Rifle or pistol',
        'Compass or bayonet',
        'Map book or saber',
      ],
    ),

    // ── 6. PRIEST (p. 31) ────────────────────────────────────────────────────
    Archetype(
      name: 'Priest',
      tagline: 'Spiritual shepherd wielding sacred faith against the darkness.',
      description:
          'I was a skeptic talking about the symbolic messages of the bible. But I saw revenants crawling out of the fjord near Vestnes on the Norwegian coast. We hid inside the church and let bells ring until morning drove them off. Now I know the scriptures are true!',
      mainAttribute: AttributeType.empathy,
      mainSkill: SkillType.observation,
      minResources: 4,
      maxResources: 6,
      talentIds: [
        'priest_absolution',
        'priest_blessing',
        'priest_confessor',
      ],
      suggestedFirstNames: ['Elizabeth', 'Erik', 'Lydia', 'Maria', 'Otto', 'Viktor'],
      suggestedLastNames: ['af Blacke', 'Forsmark', 'Nyström'],
      suggestedMotivations: [
        'Performing a sacred mission',
        'Cleansing my tarnished soul',
        'Understanding God’s creation',
      ],
      suggestedTraumas: [
        'Hurt someone after being enthralled by a witch',
        'Watched a church grim tear apart some thieves trying to steal church silver',
        'The third owner of a spertus, serving the church to avoid being twisted',
      ],
      suggestedDarkSecrets: [
        'The Devil speaks to me',
        'I have stolen my identity',
        'Ensnared by a vaesen',
      ],
      suggestedRelationships: [
        'I am better than you',
        'Secretly in love with you',
        'My disciple',
      ],
      startingGear: [
        'Musical instrument or fine wines',
        'Writing utensils',
        'Holy water or old bible',
      ],
    ),

    // ── 7. PRIVATE DETECTIVE (p. 32) ─────────────────────────────────────────
    Archetype(
      name: 'Private Detective',
      tagline: 'Urban sleuth navigating gaslit alleys and crime scenes.',
      description:
          'They hired me to go all the way to Kristinehamn. What they needed was someone to clean up a slaughterhouse. I banished whatever it was that attacked the von Fleesingen family and turned their bodies inside out. But not before it had slain every soul in the nearby villages.',
      mainAttribute: AttributeType.logic,
      mainSkill: SkillType.investigation,
      minResources: 2,
      maxResources: 5,
      talentIds: [
        'det_eagle_eye',
        'det_elementary',
        'det_focused',
      ],
      suggestedFirstNames: ['Anders', 'Felicia', 'Gabriella', 'Henrik', 'Samuel', 'Stina'],
      suggestedLastNames: ['Bagghult', 'Järv', 'Mäkinen'],
      suggestedMotivations: [
        'Getting away from my family',
        'Uncovering the truth',
        'Thrill-seeking',
      ],
      suggestedTraumas: [
        'Heard the cry of a myling during your search for a missing child',
        'Had nightmares and woke up breathless and mare-ridden',
        'Came face-to-face with a werewolf',
      ],
      suggestedDarkSecrets: [
        'There is a price on my head',
        'Constant adulterer',
        'Drug addict',
      ],
      suggestedRelationships: [
        'You think you can trust me',
        'A good person',
        'Tries to understand you',
      ],
      startingGear: [
        'Magnifying glass or lockpicks',
        'Revolver',
        'Knuckle duster or binoculars',
      ],
    ),

    // ── 8. SERVANT (p. 33) ───────────────────────────────────────────────────
    Archetype(
      name: 'Servant',
      tagline: 'Observant aide who hears everything and moves unseen.',
      description:
          'While out urinating against a tree on Boxing Day evening, an uninvited fiddler showed up at our servants’ party. Through the window I saw them dancing, their faces frozen in desperate grins; limbs moving until they fell apart. When I returned next morning, the music stopped. More than half quit their jobs.',
      mainAttribute: AttributeType.physique,
      mainSkill: SkillType.force,
      minResources: 2,
      maxResources: 4,
      talentIds: [
        'serv_loyal',
        'serv_robust',
        'serv_tough_as_nails',
      ],
      suggestedFirstNames: ['Anna', 'Elsa', 'Joakim', 'Rut', 'Sören', 'Torsten'],
      suggestedLastNames: ['Bäck', 'Rask', 'Änglund'],
      suggestedMotivations: [
        'Protecting my master',
        'Curiosity',
        'An urge to help humans and vaesen alike',
      ],
      suggestedTraumas: [
        'Bitten by a brook horse',
        'Lost a master to the alluring song of the Neck',
        'Served a household plagued by a changeling',
      ],
      suggestedDarkSecrets: [
        'I murdered someone',
        'Persecuted for my religion',
        'Spying for a foreign power',
      ],
      suggestedRelationships: [
        'At your service',
        'I don’t take orders from you',
        'Mutual respect',
      ],
      startingGear: [
        'Revolver',
        'Hurricane lamp or make-up',
        'Field kitchen or simple bandages',
      ],
    ),

    // ── 9. VAGABOND (p. 34) ──────────────────────────────────────────────────
    Archetype(
      name: 'Vagabond',
      tagline: 'Restless drifter hardened by winters, taverns, and highways.',
      description:
          'At fifteen I came across a symbol I’d never seen scratched into the fence of an isolated farm—a star with a distorted guard dog. At night, a bright light rose from the ground and a whistling sound came from the sky. A handsome man with shining eyes made me his servant for ten years. Next time we meet, he will pay.',
      mainAttribute: AttributeType.physique,
      mainSkill: SkillType.manipulation,
      minResources: 1,
      maxResources: 3,
      talentIds: [
        'vag_hobo_tricks',
        'vag_suspicious',
        'vag_well_traveled',
      ],
      suggestedFirstNames: ['Dagmar', 'Oskar', 'Rasmus', 'Rolf', 'Signe', 'Viola'],
      suggestedLastNames: ['Dolk', 'Eriksson', 'Krabbe'],
      suggestedMotivations: [
        'Avenging my family',
        'Exposing supernatural secrets',
        'Being liked',
      ],
      suggestedTraumas: [
        'Saw a revenant rise from its grave',
        'Forever in love with a wood wife',
        'Survived a week inside a troll bag',
      ],
      suggestedDarkSecrets: [
        'Stolen identity',
        'Terminal illness',
        'A vaesen kills anyone I love',
      ],
      suggestedRelationships: [
        'You scratch my back, and I’ll scratch yours',
        'Feigned gratitude',
        'You are my friend',
      ],
      startingGear: [
        'Walking stick',
        'Knife or crowbar',
        'Liquor or pet dog',
      ],
    ),

    // ── 10. WRITER (p. 35) ───────────────────────────────────────────────────
    Archetype(
      name: 'Writer',
      tagline: 'Romantic chronicler of human passion and uncanny mysteries.',
      description:
          'Suddenly there was something beside me in the cold air. It grabbed my pen in a firm grip and wrote. For five days and five nights the creature wrote with my hand. The result was the book everyone is talking about, and the fingers I can no longer use. I never saw its face. But I will find it again.',
      mainAttribute: AttributeType.empathy,
      mainSkill: SkillType.inspiration,
      minResources: 2,
      maxResources: 5,
      talentIds: [
        'writ_automatic_writing',
        'writ_journalist',
        'writ_wordsmith',
      ],
      suggestedFirstNames: ['August', 'Edvard', 'Helena', 'Hugo', 'Maud', 'Selma'],
      suggestedLastNames: ['Johansson', 'Nilsson', 'Skytte'],
      suggestedMotivations: [
        'Finding a certain vaesen',
        'Researching a book',
        'Revenge',
      ],
      suggestedTraumas: [
        'Angered fairies who put you to sleep and sucked your blood',
        'Cursed by a homeless vaettir to write a book in your own blood',
        'Heard the song of the Neck, but failed to write down the lyrics',
      ],
      suggestedDarkSecrets: [
        'I record and use the secrets and weaknesses of my friends',
        'Wanted for revolutionary ideas',
        'My life’s work is a lie',
      ],
      suggestedRelationships: [
        'You inspire me',
        'Tries to win your appreciation',
        'You frighten me',
      ],
      startingGear: [
        'Writing utensils and paper',
        'Camera or opera glasses',
        'Pet dog or book collection',
      ],
    ),
  ];
}
