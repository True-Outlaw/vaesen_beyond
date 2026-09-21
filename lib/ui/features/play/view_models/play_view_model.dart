import 'package:flutter/foundation.dart';
import 'package:vaesen_beyond/data/repositories/character_repository.dart';
import 'package:vaesen_beyond/domain/models/advantage.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/castle.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/condition.dart';
import 'package:vaesen_beyond/domain/models/critical_injury.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/domain/models/talent.dart';
import 'package:vaesen_beyond/domain/services/dice_engine.dart';

class PlayViewModel extends ChangeNotifier {
  final CharacterRepository _repository;
  final DiceEngine _diceEngine;

  PlayViewModel({
    CharacterRepository? repository,
    DiceEngine? diceEngine,
  })  : _repository = repository ?? CharacterRepository(),
        _diceEngine = diceEngine ?? DiceEngine();

  List<Character> _characters = [];
  List<Character> get characters => _characters;

  Character? _activeCharacter;
  Character? get activeCharacter => _activeCharacter;

  CastleState _castle = const CastleState();
  CastleState get castle => _castle;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DiceEngine get diceEngine => _diceEngine;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _characters = await _repository.loadCharacters();
    final activeId = await _repository.getActiveCharacterId();

    if (activeId != null && _characters.any((c) => c.id == activeId)) {
      _activeCharacter = _characters.firstWhere((c) => c.id == activeId);
    } else if (_characters.isNotEmpty) {
      _activeCharacter = _characters.first;
      await _repository.setActiveCharacterId(_activeCharacter!.id);
    }

    _castle = await _repository.loadCastleState();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> switchCharacter(String characterId) async {
    final found = _characters.firstWhere((c) => c.id == characterId, orElse: () => _characters.first);
    _activeCharacter = found;
    await _repository.setActiveCharacterId(found.id);
    notifyListeners();
  }

  Future<void> updateCharacter(Character updated) async {
    _activeCharacter = updated;
    final index = _characters.indexWhere((c) => c.id == updated.id);
    if (index >= 0) {
      _characters[index] = updated;
    } else {
      _characters.add(updated);
    }
    notifyListeners();
    await _repository.saveCharacter(updated);
  }

  Future<void> deleteCharacter(String id) async {
    await _repository.deleteCharacter(id);
    _characters.removeWhere((c) => c.id == id);
    if (_activeCharacter?.id == id) {
      _activeCharacter = _characters.isNotEmpty ? _characters.first : null;
      if (_activeCharacter != null) {
        await _repository.setActiveCharacterId(_activeCharacter!.id);
      }
    }
    notifyListeners();
  }

  Future<void> toggleCondition({
    bool? exhausted,
    bool? battered,
    bool? wounded,
    bool? angry,
    bool? frightened,
    bool? hopeless,
  }) async {
    if (_activeCharacter == null) return;

    final current = _activeCharacter!.conditions;
    var newCond = current.copyWith(
      exhausted: exhausted,
      battered: battered,
      wounded: wounded,
      angry: angry,
      frightened: frightened,
      hopeless: hopeless,
    );

    final physCount = (newCond.exhausted ? 1 : 0) +
        (newCond.battered ? 1 : 0) +
        (newCond.wounded ? 1 : 0);
    final mentCount = (newCond.angry ? 1 : 0) +
        (newCond.frightened ? 1 : 0) +
        (newCond.hopeless ? 1 : 0);

    newCond = newCond.copyWith(
      brokenPhysical: physCount >= 3 && current.brokenPhysical,
      brokenMental: mentCount >= 3 && current.brokenMental,
    );

    final updated = _activeCharacter!.copyWith(conditions: newCond);
    await updateCharacter(updated);
  }

  Future<void> setBroken({required bool isPhysical, required bool broken}) async {
    if (_activeCharacter == null) return;
    final current = _activeCharacter!.conditions;
    final newCond = isPhysical
        ? current.copyWith(brokenPhysical: broken)
        : current.copyWith(brokenMental: broken);

    await updateCharacter(_activeCharacter!.copyWith(conditions: newCond));
  }

  Future<bool> useMemento() => drawSolaceFromMemento(healPhysical: false);

  Future<bool> drawSolaceFromMemento({required bool healPhysical}) async {
    if (_activeCharacter == null || _activeCharacter!.isMementoUsed) {
      return false;
    }

    final cond = _activeCharacter!.conditions;
    ConditionsState newCond = cond;

    if (healPhysical) {
      if (cond.wounded) {
        newCond = cond.copyWith(wounded: false);
      } else if (cond.battered) {
        newCond = cond.copyWith(battered: false);
      } else if (cond.exhausted) {
        newCond = cond.copyWith(exhausted: false);
      } else if (cond.brokenPhysical) {
        newCond = cond.copyWith(brokenPhysical: false);
      }
    } else {
      if (cond.hopeless) {
        newCond = cond.copyWith(hopeless: false);
      } else if (cond.frightened) {
        newCond = cond.copyWith(frightened: false);
      } else if (cond.angry) {
        newCond = cond.copyWith(angry: false);
      } else if (cond.brokenMental) {
        newCond = cond.copyWith(brokenMental: false);
      }
    }

    final updated = _activeCharacter!.copyWith(
      conditions: newCond,
      isMementoUsed: true,
    );
    await updateCharacter(updated);
    return true;
  }

  Future<void> resetMystery() async {
    if (_activeCharacter == null) return;
    final updated = _activeCharacter!.copyWith(isMementoUsed: false);
    await updateCharacter(updated);
  }

  Future<void> addCriticalInjury(CriticalInjury injury) async {
    if (_activeCharacter == null) return;
    final newInjuries = List<ActiveInjury>.from(_activeCharacter!.activeInjuries);
    newInjuries.add(
      ActiveInjury(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        injury: injury,
        sustainedAt: 'In current mystery',
      ),
    );
    await updateCharacter(_activeCharacter!.copyWith(activeInjuries: newInjuries));
  }

  Future<void> removeCriticalInjury(String injuryId) async {
    if (_activeCharacter == null) return;
    final newInjuries = List<ActiveInjury>.from(_activeCharacter!.activeInjuries)
      ..removeWhere((i) => i.id == injuryId);
    await updateCharacter(_activeCharacter!.copyWith(activeInjuries: newInjuries));
  }

  Future<void> treatCriticalInjury(String injuryId) async {
    if (_activeCharacter == null) return;
    final newInjuries = _activeCharacter!.activeInjuries.map((i) {
      if (i.id == injuryId) {
        return i.copyWith(isTreated: true);
      }
      return i;
    }).toList();
    await updateCharacter(_activeCharacter!.copyWith(activeInjuries: newInjuries));
  }

  Future<void> toggleFacility(String facilityId) async {
    final updatedList = _castle.facilities.map((f) {
      if (f.id == facilityId) {
        final willBuild = !f.isBuilt;
        return f.copyWith(isBuilt: willBuild);
      }
      return f;
    }).toList();

    _castle = _castle.copyWith(facilities: updatedList);
    await _repository.saveCastleState(_castle);
    notifyListeners();
  }

  Future<void> toggleStaff(String staffId) async {
    final updatedStaff = _castle.staff.map((s) {
      if (s.id == staffId) {
        return s.copyWith(isHired: !s.isHired);
      }
      return s;
    }).toList();

    _castle = _castle.copyWith(staff: updatedStaff);
    await _repository.saveCastleState(_castle);
    notifyListeners();
  }

  // ── INVENTORY MANAGEMENT ───────────────────────────────────────────────
  Future<void> addWeapon(Weapon weapon) async {
    if (_activeCharacter == null) return;
    final weapons = List<Weapon>.from(_activeCharacter!.weapons)..add(weapon);
    await updateCharacter(_activeCharacter!.copyWith(weapons: weapons));
  }

  Future<void> removeWeapon(String weaponId) async {
    if (_activeCharacter == null) return;
    final weapons = List<Weapon>.from(_activeCharacter!.weapons)
      ..removeWhere((w) => w.id == weaponId);
    await updateCharacter(_activeCharacter!.copyWith(weapons: weapons));
  }

  Future<void> toggleEquipWeapon(String weaponId) async {
    if (_activeCharacter == null) return;
    final weapons = _activeCharacter!.weapons.map((w) {
      if (w.id == weaponId) {
        return w.copyWith(isEquipped: !w.isEquipped);
      }
      return w;
    }).toList();
    await updateCharacter(_activeCharacter!.copyWith(weapons: weapons));
  }

  Future<void> addArmor(Armor armor) async {
    if (_activeCharacter == null) return;
    final list = List<Armor>.from(_activeCharacter!.armor)..add(armor);
    await updateCharacter(_activeCharacter!.copyWith(armor: list));
  }

  Future<void> removeArmor(String armorId) async {
    if (_activeCharacter == null) return;
    final list = List<Armor>.from(_activeCharacter!.armor)
      ..removeWhere((a) => a.id == armorId);
    await updateCharacter(_activeCharacter!.copyWith(armor: list));
  }

  Future<void> toggleEquipArmor(String armorId) async {
    if (_activeCharacter == null) return;
    final list = _activeCharacter!.armor.map((a) {
      if (a.id == armorId) {
        return a.copyWith(isEquipped: !a.isEquipped);
      }
      return a;
    }).toList();
    await updateCharacter(_activeCharacter!.copyWith(armor: list));
  }

  Future<void> addEquipment(EquipmentItem item) async {
    if (_activeCharacter == null) return;
    final list = List<EquipmentItem>.from(_activeCharacter!.equipment)..add(item);
    await updateCharacter(_activeCharacter!.copyWith(equipment: list));
  }

  Future<void> removeEquipment(String itemId) async {
    if (_activeCharacter == null) return;
    final list = List<EquipmentItem>.from(_activeCharacter!.equipment)
      ..removeWhere((e) => e.id == itemId);
    await updateCharacter(_activeCharacter!.copyWith(equipment: list));
  }

  Future<void> updateEquipmentQuantity(String itemId, int delta) async {
    if (_activeCharacter == null) return;
    final list = _activeCharacter!.equipment.map((e) {
      if (e.id == itemId) {
        final newQty = (e.quantity + delta).clamp(1, 99);
        return e.copyWith(quantity: newQty);
      }
      return e;
    }).toList();
    await updateCharacter(_activeCharacter!.copyWith(equipment: list));
  }

  Future<void> updateWealth({int? resources, int? capital}) async {
    if (_activeCharacter == null) return;
    final newRes = resources != null ? resources.clamp(0, 10) : _activeCharacter!.resources;
    final newCap = capital != null ? capital.clamp(0, 99) : _activeCharacter!.capital;
    await updateCharacter(_activeCharacter!.copyWith(resources: newRes, capital: newCap));
  }

  // ── ADVANCEMENT & LEVEL UP (VAESEN RULES) ──────────────────────────────
  Future<void> addExperience(int xp) async {
    if (_activeCharacter == null) return;
    final newXp = (_activeCharacter!.experiencePoints + xp).clamp(0, 999);
    await updateCharacter(_activeCharacter!.copyWith(experiencePoints: newXp));
  }

  Future<bool> raiseSkill(SkillType skill, {bool spendXp = true}) async {
    if (_activeCharacter == null) return false;
    final currentVal = _activeCharacter!.getSkill(skill);
    if (currentVal >= 5) return false;
    if (spendXp && _activeCharacter!.experiencePoints < 5) return false;

    final newSkills = Map<SkillType, int>.from(_activeCharacter!.skills);
    newSkills[skill] = currentVal + 1;
    final newXp = spendXp
        ? _activeCharacter!.experiencePoints - 5
        : _activeCharacter!.experiencePoints;

    await updateCharacter(
      _activeCharacter!.copyWith(
        skills: newSkills,
        experiencePoints: newXp,
      ),
    );
    return true;
  }

  Future<void> freeAdjustSkill(SkillType skill, int delta) async {
    if (_activeCharacter == null) return;
    final currentVal = _activeCharacter!.getSkill(skill);
    final newVal = (currentVal + delta).clamp(0, 5);
    final newSkills = Map<SkillType, int>.from(_activeCharacter!.skills);
    newSkills[skill] = newVal;
    await updateCharacter(_activeCharacter!.copyWith(skills: newSkills));
  }

  Future<bool> learnTalent(Talent talent, {bool spendXp = true}) async {
    if (_activeCharacter == null) return false;
    if (_activeCharacter!.talents.any((t) => t.id == talent.id || t.name == talent.name)) {
      return false;
    }
    if (spendXp && _activeCharacter!.experiencePoints < 5) return false;

    final newTalents = List<Talent>.from(_activeCharacter!.talents)..add(talent);
    final newXp = spendXp
        ? _activeCharacter!.experiencePoints - 5
        : _activeCharacter!.experiencePoints;

    await updateCharacter(
      _activeCharacter!.copyWith(
        talents: newTalents,
        experiencePoints: newXp,
      ),
    );
    return true;
  }

  // ── MYSTERY PREPARATIONS & ADVANTAGES ──────────────────────────────────
  Future<void> makePreparation({
    required String title,
    required String effect,
    SkillType? targetSkill,
  }) async {
    if (_activeCharacter == null) return;
    final activeAdv = Advantage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      effect: effect,
      targetSkill: targetSkill,
      isUsed: false,
    );
    final current = List<Advantage>.from(_activeCharacter!.advantages)
      ..removeWhere((a) => !a.isUsed)
      ..add(activeAdv);

    await updateCharacter(_activeCharacter!.copyWith(advantages: current));
  }

  Future<void> spendAdvantage(String advantageId) async {
    if (_activeCharacter == null) return;
    final updated = _activeCharacter!.advantages.map((a) {
      if (a.id == advantageId) {
        return a.copyWith(isUsed: true);
      }
      return a;
    }).toList();
    await updateCharacter(_activeCharacter!.copyWith(advantages: updated));
  }

  Future<void> resetMysteryPrep() async {
    if (_activeCharacter == null) return;
    final updated = _activeCharacter!.copyWith(
      isMementoUsed: false,
      advantages: [],
    );
    await updateCharacter(updated);
  }
}
