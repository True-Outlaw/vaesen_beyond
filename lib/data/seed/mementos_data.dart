import 'dart:math';

/// Official D66 Mementos Table from Vaesen Core Rulebook (Chapter 2, p. 23).
class MementosData {
  static const Map<int, String> d66Mementos = {
    11: 'Dried red rose',
    12: 'Photo of someone close to you',
    13: 'Seal ring with a secret chamber',
    14: 'Your father’s cane',
    15: 'Hat with a secret compartment',
    16: 'Book in a foreign language',
    21: 'Hip flask with inscription',
    22: 'Old love letter',
    23: 'A scruffy cat',
    24: 'A monkey’s skull',
    25: 'Bloodstained promissory note',
    26: 'Gold jewelry worn by your mother',
    31: 'Silver cross on a chain',
    32: 'Beautiful fiddle passed down in the family',
    33: 'Journal (yours or someone else’s)',
    34: 'Newspaper from a date that means something to you',
    35: 'Ragged doll',
    36: 'Tame pigeon',
    41: 'Well-thumbed novel with dedication',
    42: 'Plans for a family tomb',
    43: 'Map with notes in the margin',
    44: 'Strange animal preserved in a glass jar',
    45: 'Music box from your childhood',
    46: 'Sunstone (cut mineral)',
    51: 'Small bottle of perfume that reminds you of someone',
    52: 'Hymnbook passed down in the family',
    53: 'Pocket watch with a photo inside',
    54: 'An unsigned will',
    55: 'Golden box from a foreign land',
    56: 'Sheet music from a forgotten master',
    61: 'Powder compact with sleeping pills',
    62: 'Beautifully ornamented pipe',
    63: 'Rabbit’s foot or some other lucky charm',
    64: 'Syringe with needle in a box',
    65: 'Worn dice made of bone',
    66: 'A manuscript passed down in the family',
  };

  /// Roll two six-sided dice to generate a random official memento.
  static (int d66, String item) rollMemento([Random? random]) {
    final rng = random ?? Random();
    final tens = rng.nextInt(6) + 1;
    final ones = rng.nextInt(6) + 1;
    final roll = (tens * 10) + ones;
    final item = d66Mementos[roll] ?? 'Silver cross on a chain';
    return (roll, item);
  }

  /// Official Standard of Living Table from Chapter 2 (p. 22).
  static const Map<int, StandardOfLiving> standardOfLiving = {
    1: StandardOfLiving(
      title: 'Destitute',
      description:
          'You are completely dependent on others for your survival. Every day is a struggle for food and you have few, if any, belongings. This may have caused you to contract diseases, starve, or turn to drugs or alcohol for relief.',
      lodging: 'Flophouse, park bench, barn, or workhouse',
      clothes: 'Rags and worn boots',
    ),
    2: StandardOfLiving(
      title: 'Poor',
      description:
          'You live very simply. Most days there is food on the table, but far too little. If you have children, they are forced to live in squalor. You might own a change of clothes and a few possessions. Loss of income would be disastrous for you and your family.',
      lodging: 'Cramped slum tenement or damp basement room',
      clothes: 'Simple patched work clothes, worn shoes',
    ),
    3: StandardOfLiving(
      title: 'Struggling',
      description:
          'You have a humble home and a fixed income. You have no money for savings, but you can dress your family for special occasions and your children have some access to education – at least for a few years.',
      lodging: 'Modest rented apartment or humble cottage',
      clothes: 'Plain woolen suit or dress, decent shoes',
    ),
    4: StandardOfLiving(
      title: 'Financially Stable',
      description:
          'You own your own home and have a job that provides a steady income. Most likely you have some money stashed away. Occasionally you may treat yourself to some sweets, a trip, or a beautiful object. In times of crisis there are people to lend you money.',
      lodging: 'Small town house or comfortable farmstead',
      clothes: 'Clean, respectable tailored clothing',
    ),
    5: StandardOfLiving(
      title: 'Middle-Class',
      description:
          'You own a home and a business. You may have one or several employees and know how to invest for the future. You have savings and access to loans. You and your family are living well.',
      lodging: 'Spacious city apartment or pleasant villa',
      clothes: 'Fashionable outfits, evening wear, pocket watch',
    ),
    6: StandardOfLiving(
      title: 'Well-Off',
      description:
          'You have a big house or apartment. You probably have multiple sources of income and several employees. You do not think of money as a scarce resource, but as a game to increase your capital and influence. You keep fine company and have little contact with the poor. Your family can go on vacations and you can afford all the latest innovations.',
      lodging: 'Grand townhouse in an affluent district',
      clothes: 'Tailor-made suits, silk dresses, fine jewelry',
    ),
    7: StandardOfLiving(
      title: 'Wealthy',
      description:
          'You have large amounts of inherited money and real estate. You probably own multiple properties, keep lots of servants, and have many sources of income. There are few things you cannot afford. You are well-connected with the city’s and country’s elite, and on good terms with senior officials, politicians, and nobles. The only time you see any poor people is through your carriage window.',
      lodging: 'Manor house or country estate with domestic staff',
      clothes: 'Bespoke wardrobe, imported silks, heirloom jewels',
    ),
    8: StandardOfLiving(
      title: 'Filthy Rich',
      description:
          'You are one of the richest people in the country and have direct contact with its rulers. You own one or several castles or mansions. There is no expense too great. You can treat yourself to lavish extravagance without ever worrying about the cost.',
      lodging: 'Palatial estates, castles, and lavish country retreats',
      clothes: 'Haute couture, gold embroidery, precious gems',
    ),
  };
}

/// Rich domain model representing an investigator's Standard of Living tier (1–8).
class StandardOfLiving {
  final String title;
  final String description;
  final String lodging;
  final String clothes;

  const StandardOfLiving({
    required this.title,
    required this.description,
    required this.lodging,
    required this.clothes,
  });

  String get label => title;
}
