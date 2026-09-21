import 'package:flutter_test/flutter_test.dart';
import 'package:vaesen_beyond/domain/services/dice_engine.dart';

void main() {
  group('DiceEngine Tests', () {
    late DiceEngine engine;

    setUp(() {
      engine = DiceEngine();
    });

    test('rollPool generates correct count and identifies successes', () {
      final result = engine.rollPool(
        diceCount: 5,
        title: 'Investigation Check',
        breakdown: 'Logic 3 + Investigation 2',
      );
      expect(result.dice.length, equals(5));
      for (final die in result.dice) {
        expect(die, inInclusiveRange(1, 6));
      }
      expect(result.isPushed, isFalse);
      expect(result.title, equals('Investigation Check'));
    });

    test('diceCount of 0 or negative clamps to minimum 1 die', () {
      final result = engine.rollPool(
        diceCount: 0,
        title: 'Min Dice',
        breakdown: 'Test',
      );
      expect(result.dice.length, equals(1));
    });

    test('pushRoll retains 6s and re-rolls non-6s', () {
      final original = engine.rollPool(
        diceCount: 6,
        title: 'Force Check',
        breakdown: 'Physique 4 + Force 2',
      );
      final pushed = engine.pushRoll(original, conditionName: 'Exhausted');

      expect(pushed.isPushed, isTrue);
      expect(pushed.dice.length, equals(6));
      expect(pushed.pushCondition, equals('Exhausted'));

      // Any 6 from the original roll that was locked should still be preserved
      int originalSixes = original.successes;
      int pushedSixes = pushed.successes;
      expect(pushedSixes, greaterThanOrEqualTo(originalSixes));
    });

    test('evaluateFearTest evaluates fear and panicking correctly', () {
      final fearResult = engine.evaluateFearTest(
        fearValue: 2,
        diceCount: 4,
        attributeUsed: 'Logic',
        companionsCount: 2,
        mentalPenalty: 1,
      );

      expect(fearResult.fearValue, equals(2));
      expect(fearResult.rollResult.dice.length, equals(5)); // (4 + 2 - 1 = 5)
      if (fearResult.passed) {
        expect(fearResult.conditionsSuffered, equals(0));
        expect(fearResult.panickedRounds, equals(0));
      } else {
        expect(fearResult.conditionsSuffered, greaterThan(0));
        expect(fearResult.panickedRounds, inInclusiveRange(1, 6));
      }
    });

    test('rollD66 produces valid two-digit d66 result', () {
      for (int i = 0; i < 20; i++) {
        final d66 = engine.rollD66();
        final tens = d66 ~/ 10;
        final units = d66 % 10;
        expect(tens, inInclusiveRange(1, 6));
        expect(units, inInclusiveRange(1, 6));
      }
    });
  });
}
