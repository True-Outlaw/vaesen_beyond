import '../../domain/models/castle.dart';

class CastleData {
  static CastleState get defaultCastle => CastleState(
        name: 'Castle Gyllencreutz (Upsala)',
        developmentPoints: 3,
        facilities: [
          const Facility(
            id: 'fac_library',
            name: 'Grand Library',
            description: 'Vast shelves of rare folklore, genealogical records, and handwritten memoirs.',
            benefit: '+2 dice to Learning and Investigation checks made at Castle Gyllencreutz.',
            isBuilt: true,
            devCost: 2,
          ),
          const Facility(
            id: 'fac_infirmary',
            name: 'Restorative Infirmary',
            description: 'Sterile cots, apothecary jars, surgical tools, and ether canisters.',
            benefit: 'Healing time for all Critical Injuries is halved when resting here.',
            isBuilt: true,
            devCost: 2,
          ),
          const Facility(
            id: 'fac_workshop',
            name: 'Smithy & Workshop',
            description: 'Cold-iron anvil, silvering crucibles, and carpenter benches.',
            benefit: 'Enables repairing broken items and forging cold-iron weapon coatings.',
            isBuilt: false,
            devCost: 2,
          ),
          const Facility(
            id: 'fac_seance',
            name: 'Attic Seance Room',
            description: 'Heavy velvet curtains, obsidian scrying mirror, and spirit table.',
            benefit: 'Allows contact with the ghosts of deceased Society founders for guidance.',
            isBuilt: false,
            devCost: 3,
          ),
          const Facility(
            id: 'fac_alchemy',
            name: 'Alchemical Laboratory',
            description: 'Distillation retorts, alembics, and sulfur burners.',
            benefit: 'Allows brewing sleeping drafts, blinding flash powder, and protective salts.',
            isBuilt: false,
            devCost: 3,
          ),
          const Facility(
            id: 'fac_vault',
            name: 'Lead-Lined Relic Vault',
            description: 'Reinforced underground vault guarded by heavy brass locks and silver wards.',
            benefit: 'Safely stores radioactive, cursed, or dangerous vaesen artifacts without corruption.',
            isBuilt: false,
            devCost: 3,
          ),
        ],
        staff: [
          const StaffMember(
            id: 'st_butler',
            role: 'Head Butler',
            name: 'Algot Frisk',
            benefit: 'Maintains Castle Gyllencreutz and screens suspicious inquiries from local constables.',
            isHired: true,
          ),
          const StaffMember(
            id: 'st_coachman',
            role: 'Carriage Coachman',
            name: 'Mårten Blom',
            benefit: 'Swift transportation across Uppland province with a pair of sturdy horses.',
            isHired: true,
          ),
          const StaffMember(
            id: 'st_cook',
            role: 'Housekeeper & Cook',
            name: 'Mrs. Sigrid Vester',
            benefit: 'Hot hearty stew and berry tarts immediately heal 1 Mental Condition upon return to HQ.',
            isHired: false,
          ),
          const StaffMember(
            id: 'st_guard',
            role: 'Night Watchman',
            name: 'Gunnar Strid',
            benefit: 'Patrols the grounds with a loaded shotgun and mastiff hound.',
            isHired: false,
          ),
        ],
        mysteryLogs: [
          const MysteryLog(
            id: 'log_01',
            title: 'The Reawakening of Gyllencreutz',
            date: 'October 14, 1882',
            summary:
                'The surviving heirs of the Society unlocked the rusted iron gates of Castle Gyllencreutz in Upsala. The dust of decades cleared; the library opened.',
            xpAwarded: 2,
          ),
        ],
      );
}
