import 'package:vaesen_beyond/data/seed/gear_data.dart';
import 'package:vaesen_beyond/data/seed/talents_data.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/condition.dart';

class PregenCharacters {
  static List<Character> get characters => [
        // 1. Dr. Astrid Lindholm
        Character(
          id: 'pregen_astrid',
          name: 'Dr. Astrid Lindholm',
          archetypeName: 'Doctor',
          ageCategory: AgeCategory.middleAged,
          actualAge: 38,
          motivation: 'To scientifically document and inoculate mankind against supernatural diseases.',
          trauma: 'Examined the corpse of a drowned sailor whose lungs were filled with black spruce needles instead of water.',
          darkSecret: 'Addicted to medicinal laudanum to quiet the eerie whispers in her clinic.',
          memento: 'Her father’s engraved silver pocket scalpel, passed down through three generations.',
          isMementoUsed: false,
          attributes: {
            AttributeType.physique: 3,
            AttributeType.precision: 3,
            AttributeType.logic: 5, // Main attribute (max 5)
            AttributeType.empathy: 3,
          },
          skills: {
            SkillType.medicine: 3, // Main skill (max 3)
            SkillType.observation: 2,
            SkillType.learning: 2,
            SkillType.investigation: 2,
            SkillType.vigilance: 1,
            SkillType.agility: 1,
            SkillType.rangedCombat: 1,
          },
          conditions: const ConditionsState(),
          talents: [TalentsData.allTalents.firstWhere((t) => t.id == 'doc_army_medic')],
          weapons: [
            GearData.standardWeapons.firstWhere((w) => w.id == 'w_derringer'),
            GearData.standardWeapons.firstWhere((w) => w.id == 'w_knife'),
          ],
          armor: [GearData.standardArmor.firstWhere((a) => a.id == 'a_leather_coat')],
          equipment: [
            GearData.commonEquipment.firstWhere((e) => e.id == 'eq_medkit'),
            GearData.commonEquipment.firstWhere((e) => e.id == 'eq_magnifier'),
          ],
          resources: 4,
          capital: 2,
          experiencePoints: 2,
          relationships: {
            'Johan Falck': 'A reckless young mind, but his occult insights cannot be dismissed.',
            'Elias Vane': 'A dependable ally in physical danger, though his cynicism is grating.',
          },
          notes: 'Stationed at Castle Gyllencreutz. Maintains the infirmary and chemical laboratory.',
        ),

        // 2. Johan Falck
        Character(
          id: 'pregen_johan',
          name: 'Johan Falck',
          archetypeName: 'Occultist',
          ageCategory: AgeCategory.young,
          actualAge: 22,
          motivation: 'To unveil the forgotten esoteric geometries and commune with higher planes.',
          trauma: 'Attended a dark seance where an unseen entity whispered his true childhood name through cold glass.',
          darkSecret: 'Bound in a pact to leave offerings of honey and silver to a barrow spirit every full moon.',
          memento: 'A scorched fragment of parchment from his late mentor’s burning occult study.',
          isMementoUsed: false,
          attributes: {
            AttributeType.physique: 3,
            AttributeType.precision: 5, // Main attribute (max 5)
            AttributeType.logic: 3,
            AttributeType.empathy: 4,
          },
          skills: {
            SkillType.stealth: 3, // Main skill (max 3)
            SkillType.observation: 2,
            SkillType.investigation: 2,
            SkillType.learning: 2,
            SkillType.inspiration: 1,
          },
          conditions: const ConditionsState(),
          talents: [TalentsData.allTalents.firstWhere((t) => t.id == 'occ_medium')],
          weapons: [
            GearData.standardWeapons.firstWhere((w) => w.id == 'w_cane_sword'),
            GearData.standardWeapons.firstWhere((w) => w.id == 'w_derringer'),
          ],
          armor: [GearData.standardArmor.firstWhere((a) => a.id == 'a_none')],
          equipment: [
            GearData.commonEquipment.firstWhere((e) => e.id == 'eq_holy_symbol'),
            GearData.commonEquipment.firstWhere((e) => e.id == 'eq_lantern'),
          ],
          resources: 2,
          capital: 1,
          experiencePoints: 0,
          relationships: {
            'Dr. Astrid Lindholm': 'Too bound by empirical dogma, but she keeps me alive.',
            'Birger Nygård': 'A man of the wild; he understands spirits far better than he admits.',
          },
          notes: 'Spends nights researching in the castle attic with tarot cards and scrying bowls.',
        ),

        // 3. Elias Vane
        Character(
          id: 'pregen_elias',
          name: 'Elias Vane',
          archetypeName: 'Private Detective',
          ageCategory: AgeCategory.middleAged,
          actualAge: 42,
          motivation: 'To track down the unaccounted missing souls that police write off as runaways.',
          trauma: 'Cornered an assassin in an alley whose chest cracked open like dried pine boughs when shot.',
          darkSecret: 'Falsified evidence in a murder case to prevent mass panic over a troll attack.',
          memento: 'A dented silver thimble that deflected a stiletto during a dockside ambush.',
          isMementoUsed: false,
          attributes: {
            AttributeType.physique: 3,
            AttributeType.precision: 3,
            AttributeType.logic: 5, // Main attribute (max 5)
            AttributeType.empathy: 3,
          },
          skills: {
            SkillType.investigation: 3, // Main skill (max 3)
            SkillType.vigilance: 2,
            SkillType.rangedCombat: 2,
            SkillType.observation: 2,
            SkillType.closeCombat: 1,
            SkillType.stealth: 1,
            SkillType.manipulation: 1,
          },
          conditions: const ConditionsState(),
          talents: [TalentsData.allTalents.firstWhere((t) => t.id == 'det_focused')],
          weapons: [
            GearData.standardWeapons.firstWhere((w) => w.id == 'w_revolver'),
            GearData.standardWeapons.firstWhere((w) => w.id == 'w_knife'),
          ],
          armor: [GearData.standardArmor.firstWhere((a) => a.id == 'a_leather_coat')],
          equipment: [
            GearData.commonEquipment.firstWhere((e) => e.id == 'eq_lockpicks'),
            GearData.commonEquipment.firstWhere((e) => e.id == 'eq_magnifier'),
            GearData.commonEquipment.firstWhere((e) => e.id == 'eq_lantern'),
          ],
          resources: 3,
          capital: 1,
          experiencePoints: 1,
          relationships: {
            'Dr. Astrid Lindholm': 'The only person in Upsala with a spine as rigid as mine.',
          },
          notes: 'Knows every corrupt constable and back-alley informant from Stockholm to Upsala.',
        ),

        // 4. Birger Nygård
        Character(
          id: 'pregen_birger',
          name: 'Birger Nygård',
          archetypeName: 'Hunter',
          ageCategory: AgeCategory.old,
          actualAge: 61,
          motivation: 'To protect secluded frontier settlements from beasts that humanity has forgotten.',
          trauma: 'Followed elk tracks into a frozen cavern and found an ancient horned giant sleeping.',
          darkSecret: 'Fled from a barrow in his youth, leaving his younger brother trapped inside.',
          memento: 'A carved wooden Tomte idol given to him by his grandmother.',
          isMementoUsed: false,
          attributes: {
            AttributeType.physique: 3,
            AttributeType.precision: 4, // Main attribute (max 5)
            AttributeType.logic: 3,
            AttributeType.empathy: 3,
          },
          skills: {
            SkillType.rangedCombat: 3, // Main skill (max 3)
            SkillType.vigilance: 2, // Max 2 at start for non-key skill
            SkillType.stealth: 2,
            SkillType.agility: 2,
            SkillType.closeCombat: 2,
            SkillType.force: 2,
            SkillType.learning: 1,
          },
          conditions: const ConditionsState(),
          talents: [TalentsData.allTalents.firstWhere((t) => t.id == 'hunt_marksman')],
          weapons: [
            GearData.standardWeapons.firstWhere((w) => w.id == 'w_rifle'),
            GearData.standardWeapons.firstWhere((w) => w.id == 'w_knife'),
          ],
          armor: [GearData.standardArmor.firstWhere((a) => a.id == 'a_winter_greatcoat')],
          equipment: [
            GearData.commonEquipment.firstWhere((e) => e.id == 'eq_rope'),
            GearData.commonEquipment.firstWhere((e) => e.id == 'eq_lantern'),
          ],
          resources: 2,
          capital: 1,
          experiencePoints: 3,
          relationships: {
            'Elias Vane': 'A city man, but he keeps his eyes open and won’t scream under pressure.',
          },
          notes: 'Maintains the hounds and equipment stores in the castle stables.',
        ),
      ];
}
