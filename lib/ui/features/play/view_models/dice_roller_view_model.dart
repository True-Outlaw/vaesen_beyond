import 'package:flutter/foundation.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/gear.dart';
import 'package:vaesen_beyond/domain/services/dice_engine.dart';

class DiceRollerViewModel extends ChangeNotifier {
  final DiceEngine _diceEngine;

  DiceRollerViewModel({DiceEngine? diceEngine})
      : _diceEngine = diceEngine ?? DiceEngine();

  RollResult? _currentRoll;
  RollResult? get currentRoll => _currentRoll;

  final List<RollResult> _rollHistory = [];
  List<RollResult> get rollHistory => List.unmodifiable(_rollHistory);

  FearTestResult? _fearResult;
  FearTestResult? get fearResult => _fearResult;

  bool _isRolling = false;
  bool get isRolling => _isRolling;

  void _recordRoll(RollResult result) {
    _currentRoll = result;
    _rollHistory.insert(0, result);
    if (_rollHistory.length > 10) _rollHistory.removeLast();
  }

  void clearRoll() {
    _currentRoll = null;
    _fearResult = null;
    notifyListeners();
  }

  void rollSkill({
    required Character character,
    required SkillType skill,
    int extraBonus = 0,
    int gearBonus = 0,
  }) {
    _isRolling = true;
    _fearResult = null;
    notifyListeners();

    final pool = character.getEffectiveSkillPool(
      skill,
      extraBonus: extraBonus,
      gearBonus: gearBonus,
    );

    final penalty = skill.attribute.isPhysical
        ? character.conditions.physicalPenalty
        : character.conditions.mentalPenalty;

    final breakdown =
        '${skill.attribute.label} (${character.getAttribute(skill.attribute)}) + ${skill.label} (${character.getSkill(skill)})'
        '${gearBonus != 0 ? ' + Gear ($gearBonus)' : ''}'
        '${extraBonus != 0 ? ' + Bonus ($extraBonus)' : ''}'
        '${penalty != 0 ? ' - Penalty ($penalty)' : ''}'
        ' = $pool dice';

    final result = _diceEngine.rollPool(
      diceCount: pool,
      title: '${skill.label} Test',
      breakdown: breakdown,
    );
    _recordRoll(result);

    _isRolling = false;
    notifyListeners();
  }

  void rollAttribute({
    required Character character,
    required AttributeType attribute,
    int extraBonus = 0,
  }) {
    _isRolling = true;
    _fearResult = null;
    notifyListeners();

    final raw = character.getAttribute(attribute);
    final pool = (character.getEffectiveAttribute(attribute) + extraBonus).clamp(1, 30);
    final penalty = attribute.isPhysical
        ? character.conditions.physicalPenalty
        : character.conditions.mentalPenalty;

    final breakdown =
        '${attribute.label} ($raw)'
        '${extraBonus != 0 ? ' + Bonus ($extraBonus)' : ''}'
        '${penalty != 0 ? ' - Penalty ($penalty)' : ''}'
        ' = $pool dice';

    final result = _diceEngine.rollPool(
      diceCount: pool,
      title: '${attribute.label} Check',
      breakdown: breakdown,
    );
    _recordRoll(result);

    _isRolling = false;
    notifyListeners();
  }

  void rollWeaponAttack({
    required Character character,
    required Weapon weapon,
    int extraBonus = 0,
  }) {
    final skill = weapon.isRanged ? SkillType.rangedCombat : SkillType.closeCombat;
    rollSkill(
      character: character,
      skill: skill,
      gearBonus: weapon.bonus,
      extraBonus: extraBonus,
    );
  }

  void rollWeapon({
    required Character character,
    required Weapon weapon,
    int extraBonus = 0,
  }) => rollWeaponAttack(
    character: character,
    weapon: weapon,
    extraBonus: extraBonus,
  );

  void rollCustomPool({
    required int poolSize,
    required String title,
    required String breakdown,
  }) {
    _isRolling = true;
    _fearResult = null;
    notifyListeners();

    final result = _diceEngine.rollPool(
      diceCount: poolSize.clamp(1, 30),
      title: title,
      breakdown: breakdown,
    );
    _recordRoll(result);

    _isRolling = false;
    notifyListeners();
  }

  void pushRoll({required String conditionSuffered}) {
    if (_currentRoll == null || _currentRoll!.isPushed) return;

    _isRolling = true;
    notifyListeners();

    final result = _diceEngine.pushRoll(
      _currentRoll!,
      conditionName: conditionSuffered,
    );
    _recordRoll(result);

    _isRolling = false;
    notifyListeners();
  }

  void executeFearTest({
    required Character character,
    required int fearValue,
    required AttributeType attribute,
    required int companionsCount,
  }) {
    _isRolling = true;
    _currentRoll = null;
    notifyListeners();

    final attrVal = character.getAttribute(attribute);
    final mentalPenalty = character.conditions.mentalPenalty;

    _fearResult = _diceEngine.evaluateFearTest(
      fearValue: fearValue,
      diceCount: attrVal,
      attributeUsed: attribute.label,
      companionsCount: companionsCount,
      mentalPenalty: mentalPenalty,
    );

    _recordRoll(_fearResult!.rollResult);
    _isRolling = false;
    notifyListeners();
  }
}
