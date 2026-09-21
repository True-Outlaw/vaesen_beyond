import 'dart:math';

class RollResult {
  final String title;
  final String breakdown;
  final List<int> dice;
  final bool isPushed;
  final List<int>? previousDice;
  final String? pushCondition;

  const RollResult({
    required this.title,
    required this.breakdown,
    required this.dice,
    this.isPushed = false,
    this.previousDice,
    this.pushCondition,
  });

  int get successes => dice.where((d) => d == 6).length;
  int get stunts => successes > 1 ? successes - 1 : 0;
  bool get isSuccess => successes >= 1;
}

class FearTestResult {
  final int fearValue;
  final RollResult rollResult;
  final bool passed;
  final int conditionsSuffered;
  final int panickedRounds;
  final String panickedAction;

  const FearTestResult({
    required this.fearValue,
    required this.rollResult,
    required this.passed,
    required this.conditionsSuffered,
    required this.panickedRounds,
    required this.panickedAction,
  });
}

class DiceEngine {
  final Random _random;

  DiceEngine({Random? random}) : _random = random ?? Random();

  RollResult rollPool({
    required int diceCount,
    required String title,
    required String breakdown,
  }) {
    final count = diceCount.clamp(1, 40);
    final dice = List.generate(count, (_) => _random.nextInt(6) + 1);
    return RollResult(
      title: title,
      breakdown: breakdown,
      dice: dice,
      isPushed: false,
    );
  }

  RollResult pushRoll(RollResult previous, {required String conditionName}) {
    if (previous.isPushed) return previous;

    final newDice = <int>[];
    for (final die in previous.dice) {
      if (die == 6) {
        newDice.add(6); // Successes are kept
      } else {
        newDice.add(_random.nextInt(6) + 1); // Reroll failure
      }
    }

    return RollResult(
      title: '${previous.title} (Pushed!)',
      breakdown: '${previous.breakdown} • Pushed with [$conditionName]',
      dice: newDice,
      isPushed: true,
      previousDice: previous.dice,
      pushCondition: conditionName,
    );
  }

  FearTestResult evaluateFearTest({
    required int fearValue,
    required int diceCount,
    required String attributeUsed,
    required int companionsCount,
    required int mentalPenalty,
  }) {
    final companionBonus = companionsCount.clamp(0, 3);
    final totalPool = (diceCount + companionBonus - mentalPenalty).clamp(1, 30);

    final breakdown =
        '$attributeUsed $diceCount + Companions (+$companionBonus) - Mental Penalty ($mentalPenalty) = $totalPool dice vs Fear $fearValue';

    final roll = rollPool(
      diceCount: totalPool,
      title: 'Fear Test (vs Fear $fearValue)',
      breakdown: breakdown,
    );

    final passed = roll.successes >= fearValue;
    final conditionsSuffered = passed ? 0 : (fearValue - roll.successes).clamp(1, 3);
    final panickedRounds = passed ? 0 : (_random.nextInt(6) + 1);

    final panickedActions = [
      'Flee in blinding terror to the nearest safe location.',
      'Freeze motionless in shock, unable to take active actions.',
      'Scream or faint dead away, falling prone.',
      'Lash out blindly in a panicked frenzy, attacking recklessly.',
    ];
    final panickedAction =
        passed ? 'Steeled your nerves and withstood the horror.' : panickedActions[_random.nextInt(panickedActions.length)];

    return FearTestResult(
      fearValue: fearValue,
      rollResult: roll,
      passed: passed,
      conditionsSuffered: conditionsSuffered,
      panickedRounds: panickedRounds,
      panickedAction: panickedAction,
    );
  }

  int rollD66() {
    final tens = _random.nextInt(6) + 1;
    final ones = _random.nextInt(6) + 1;
    return tens * 10 + ones;
  }
}
