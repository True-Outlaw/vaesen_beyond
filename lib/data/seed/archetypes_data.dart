import 'package:vaesen_beyond/domain/models/archetype.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';

class ArchetypesData {
  static const List<Archetype> allArchetypes = [
    Archetype(
      name: 'Academic',
      tagline: 'Scholar of ancient tomes, natural sciences, and esoteric lore.',
      description:
          'You have spent your adult life in dusty libraries and lecture halls, studying history, medicine, biology, or the arts. When the supernatural intruded into your rational world, you realized that forgotten folklore contains terrifying truths.',
      mainAttribute: AttributeType.logic,
      mainSkill: SkillType.learning,
      startingResources: 4,
      talentIds: ['acad_bookworm', 'acad_erudite', 'acad_focused'],
      startingGear: [
        'Leather satchel with reference books',
        'Magnifying glass & notebook',
        'Fountain pen & bottle of ink',
        'Walking cane with hidden compass',
      ],
    ),
    Archetype(
      name: 'Doctor',
      tagline: 'Healer of wounded bodies and anatomist of the strange.',
      description:
          'Trained in dissection, pharmacology, and battlefield triage. You have witnessed injuries that medical textbooks cannot explain: necrotic bites that rot in minutes and corpses with frozen smiles.',
      mainAttribute: AttributeType.precision,
      mainSkill: SkillType.medicine,
      startingResources: 5,
      talentIds: ['doc_field_surgeon', 'doc_calm_demeanor', 'doc_anatomist'],
      startingGear: [
        'Doctor’s medical bag with scalpels & bandages',
        'Vial of smelling salts & chloroform',
        'Stethoscope & reflex hammer',
        'Pocket watch with silver chain',
      ],
    ),
    Archetype(
      name: 'Hunter',
      tagline: 'Tracker of the wilderness and master of firearms.',
      description:
          'The deep Nordic spruce forests are your home. You know which tracks in the snow belong to wolves and which belong to creatures with backward-facing feet that leave no scent for hounds.',
      mainAttribute: AttributeType.precision,
      mainSkill: SkillType.rangedCombat,
      startingResources: 2,
      talentIds: ['hunt_marksman', 'hunt_tracker', 'hunt_trapper'],
      startingGear: [
        'Double-barreled hunting rifle with 10 cartridges',
        'Sturdy hunting knife in leather sheath',
        'Trapping wire & cold-iron spikes',
        'Fur coat & snowshoes',
      ],
    ),
    Archetype(
      name: 'Occultist',
      tagline: 'Investigator of seances, tarot, and ancient grimoires.',
      description:
          'Long before the Society was reborn, you held seances in candle-lit parlors, deciphered forbidden Latin texts, and smelled brimstone in the dark. You know that spirits whisper to those willing to listen.',
      mainAttribute: AttributeType.logic,
      mainSkill: SkillType.observation,
      startingResources: 3,
      talentIds: ['occ_sixth_sense', 'occ_seance', 'occ_banisher'],
      startingGear: [
        'Handwritten occult grimoire',
        'Set of carved wooden runes or tarot deck',
        'Pouch of ritual salt & sage herbs',
        'Silver pendulum on velvet ribbon',
      ],
    ),
    Archetype(
      name: 'Officer',
      tagline: 'Disciplined leader trained in battlefield tactics and swordsmanship.',
      description:
          'A veteran of military skirmishes or aristocratic naval campaigns. You bring rigid discipline, tactical foresight, and unflinching resolve when facing terrifying odds in the dead of night.',
      mainAttribute: AttributeType.empathy,
      mainSkill: SkillType.inspiration,
      startingResources: 5,
      talentIds: ['off_lead_from_front', 'off_tactician', 'off_fencing'],
      startingGear: [
        'Military officer’s sabre & scabbard',
        'Service revolver with 6 silver-tipped rounds',
        'Brass field binoculars',
        'Dress uniform with polished brass buttons',
      ],
    ),
    Archetype(
      name: 'Priest',
      tagline: 'Spiritual shepherd wielding sacred faith against the darkness.',
      description:
          'Ordained minister or parish vicar who knows that old gods and pagan spirits lurk beneath church foundations. Your prayers bring solace to terrified souls and burn restless phantoms.',
      mainAttribute: AttributeType.empathy,
      mainSkill: SkillType.inspiration,
      startingResources: 3,
      talentIds: ['priest_absolution', 'priest_holy_aura', 'priest_confessor'],
      startingGear: [
        'Heavy leather-bound Bible',
        'Silver crucifix & vial of consecrated holy water',
        'Vestments & communion cup',
        'Rosary beads of polished olive wood',
      ],
    ),
    Archetype(
      name: 'Private Detective',
      tagline: 'Urban sleuth navigating gaslit alleys and crime scenes.',
      description:
          'You look for footprints, broken window latches, and forged signatures. But lately, missing persons cases in the slums lead to sewer gratings where moss grows in unnatural patterns.',
      mainAttribute: AttributeType.logic,
      mainSkill: SkillType.investigation,
      startingResources: 3,
      talentIds: ['det_sherlock', 'det_shadow', 'det_interrogator'],
      startingGear: [
        'Pocket revolver with 6 rounds',
        'Lockpicking kit in leather roll',
        'Investigator’s notebook & pencil',
        'Dark trench coat & felt fedora',
      ],
    ),
    Archetype(
      name: 'Servant',
      tagline: 'Observant aide who hears everything and moves unseen.',
      description:
          'You have served in grand manor houses, polishing silver and pouring wine. You know the secrets nobles bury, and you can slip through corridors and pantry doors without making a floorboard creak.',
      mainAttribute: AttributeType.physique,
      mainSkill: SkillType.force,
      startingResources: 2,
      talentIds: ['serv_unnoticed', 'serv_packmule', 'serv_loyal'],
      startingGear: [
        'Heavy iron lantern & flask of whale oil',
        'Sturdy leather work gloves',
        'Skeleton keys & sewing kit',
        'Heavy cudgel or cleaver',
      ],
    ),
    Archetype(
      name: 'Vagabond',
      tagline: 'Restless drifter hardened by winters, taverns, and highways.',
      description:
          'You have no permanent home and no master. You ride the freight wagons, sleep around campfire embers, and know which crossroads are haunted and which barrows should never be opened.',
      mainAttribute: AttributeType.physique,
      mainSkill: SkillType.stealth,
      startingResources: 1,
      talentIds: ['vag_survivor', 'vag_gutter_fighter', 'vag_contacts'],
      startingGear: [
        'Folding pocketknife & knuckleduster',
        'Weathered canvas knapsack & tinderbox',
        'Flask of cheap moonshine liquor',
        'Ragged wool blanket & heavy boots',
      ],
    ),
    Archetype(
      name: 'Writer',
      tagline: 'Romantic chronicler of human passion and uncanny mysteries.',
      description:
          'You write serialized gothic novels, poetry, or newspaper journalism. You seek out the uncanny not just to survive it, but to capture its haunting beauty on paper before the industrial world erases it.',
      mainAttribute: AttributeType.empathy,
      mainSkill: SkillType.learning,
      startingResources: 4,
      talentIds: ['writ_eloquent', 'writ_chronicler', 'writ_tragic_muse'],
      startingGear: [
        'Leather-bound journal & quill pens',
        'Bottle of black gall ink & blotting paper',
        'Small derringer pistol in velvet pouch',
        'Silver cigarette case & matches',
      ],
    ),
  ];
}
