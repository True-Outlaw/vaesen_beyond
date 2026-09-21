import 'package:flutter_test/flutter_test.dart';
import 'package:vaesen_beyond/data/seed/pregen_characters.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/condition.dart';

void main() {
  group('Character and Conditions Tests', () {
    test('pre-generated characters have valid pools and attributes', () {
      final characters = PregenCharacters.characters;
      expect(characters.length, greaterThanOrEqualTo(4));

      for (final char in characters) {
        expect(char.name.isNotEmpty, isTrue);
        expect(char.archetypeName.isNotEmpty, isTrue);
        expect(char.memento.isNotEmpty, isTrue);

        // Attributes should all be between 2 and 5
        for (final attr in AttributeType.values) {
          expect(char.getAttribute(attr), inInclusiveRange(2, 5));
        }

        // Base carry slots is Physique + 2
        expect(char.maxCarrySlots, equals(char.getAttribute(AttributeType.physique) + 2));
      }
    });

    test('ConditionsState correctly calculates dice penalties', () {
      const healthy = ConditionsState();
      expect(healthy.physicalPenalty, equals(0));
      expect(healthy.mentalPenalty, equals(0));
      expect(healthy.brokenPhysical, isFalse);
      expect(healthy.brokenMental, isFalse);

      final onePhysical = healthy.copyWith(exhausted: true);
      expect(onePhysical.physicalPenalty, equals(1));
      expect(onePhysical.brokenPhysical, isFalse);

      final twoPhysical = onePhysical.copyWith(battered: true);
      expect(twoPhysical.physicalPenalty, equals(2));

      final threePhysical = twoPhysical.copyWith(wounded: true, brokenPhysical: true);
      expect(threePhysical.physicalPenalty, equals(3));
      expect(threePhysical.brokenPhysical, isTrue);

      final mental = healthy.copyWith(angry: true, frightened: true);
      expect(mental.mentalPenalty, equals(2));
      expect(mental.brokenMental, isFalse);

      final allMental = mental.copyWith(hopeless: true, brokenMental: true);
      expect(allMental.mentalPenalty, equals(3));
      expect(allMental.brokenMental, isTrue);
    });

    test('Character effective attribute pool accounts for condition penalties', () {
      final doc = PregenCharacters.characters.first;
      final basePhysique = doc.getAttribute(AttributeType.physique);

      // When exhausted, effective physique should drop by 1
      final injuredDoc = doc.copyWith(
        conditions: doc.conditions.copyWith(exhausted: true),
      );
      expect(injuredDoc.getEffectiveAttribute(AttributeType.physique), equals(basePhysique - 1));

      // Skills also reflect the penalty
      final effectiveAgility = injuredDoc.getEffectiveSkillPool(SkillType.agility);
      final rawAgility = injuredDoc.getAttribute(AttributeType.physique) + injuredDoc.getSkill(SkillType.agility);
      expect(effectiveAgility, equals(rawAgility - 1));
    });
  });
}
