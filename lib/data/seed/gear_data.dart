import '../../domain/models/gear.dart';

class GearData {
  static const List<Weapon> standardWeapons = [
    Weapon(
      id: 'w_unarmed',
      name: 'Unarmed Strike / Brawling',
      damage: 1,
      bonus: 0,
      range: WeaponRange.engaged,
      qualities: ['Blunt'],
    ),
    Weapon(
      id: 'w_knife',
      name: 'Hunting Knife',
      damage: 1,
      bonus: 1,
      range: WeaponRange.engaged,
      qualities: ['Pointed', 'Concealable'],
    ),
    Weapon(
      id: 'w_cane_sword',
      name: 'Cane Sword',
      damage: 2,
      bonus: 1,
      range: WeaponRange.engaged,
      qualities: ['Pointed', 'Concealable'],
    ),
    Weapon(
      id: 'w_sabre',
      name: 'Cavalry Sabre',
      damage: 2,
      bonus: 2,
      range: WeaponRange.engaged,
      qualities: ['Edged', 'Parrying'],
    ),
    Weapon(
      id: 'w_sledgehammer',
      name: 'Heavy Sledgehammer / Axe',
      damage: 3,
      bonus: 1,
      range: WeaponRange.engaged,
      qualities: ['Blunt', 'Heavy', 'Two-handed'],
    ),
    Weapon(
      id: 'w_revolver',
      name: 'Service Revolver (.44)',
      damage: 2,
      bonus: 1,
      range: WeaponRange.near,
      qualities: ['Firearm', 'Loud'],
    ),
    Weapon(
      id: 'w_derringer',
      name: 'Pocket Derringer',
      damage: 1,
      bonus: 0,
      range: WeaponRange.near,
      qualities: ['Firearm', 'Concealable', 'Slow reload'],
    ),
    Weapon(
      id: 'w_rifle',
      name: 'Hunting Rifle',
      damage: 3,
      bonus: 2,
      range: WeaponRange.long,
      qualities: ['Firearm', 'Two-handed', 'Heavy'],
    ),
    Weapon(
      id: 'w_shotgun',
      name: 'Double-Barreled Shotgun',
      damage: 3,
      bonus: 1,
      range: WeaponRange.short,
      qualities: ['Firearm', 'Two-handed', 'Spread'],
    ),
  ];

  static const List<Armor> standardArmor = [
    Armor(
      id: 'a_none',
      name: 'Ordinary Clothing',
      protection: 0,
      agilityPenalty: 0,
    ),
    Armor(
      id: 'a_leather_coat',
      name: 'Reinforced Leather Coat',
      protection: 1,
      agilityPenalty: 0,
    ),
    Armor(
      id: 'a_winter_greatcoat',
      name: 'Heavy Winter Fur Coat',
      protection: 1,
      agilityPenalty: 1,
    ),
    Armor(
      id: 'a_breastplate',
      name: 'Concealed Steel Vest',
      protection: 2,
      agilityPenalty: 1,
    ),
  ];

  static const List<EquipmentItem> commonEquipment = [
    EquipmentItem(
      id: 'eq_lantern',
      name: 'Brass Bullseye Lantern & Oil',
      description: 'Casts a beam of illumination up to Near range for 4 hours.',
      slots: 1,
    ),
    EquipmentItem(
      id: 'eq_medkit',
      name: 'Physician’s Medical Bag',
      description: 'Grants +1 bonus die to Medicine tests when treating injuries.',
      slots: 1,
    ),
    EquipmentItem(
      id: 'eq_magnifier',
      name: 'Brass Magnifying Glass',
      description: 'Reveals minute fibers, prints, and microscopic details.',
      slots: 1,
    ),
    EquipmentItem(
      id: 'eq_lockpicks',
      name: 'Set of Fine Lockpicks',
      description: 'Essential for opening locked padlocks and manor doors.',
      slots: 1,
    ),
    EquipmentItem(
      id: 'eq_rope',
      name: 'Hemp Rope & Grappling Hook',
      description: '50 feet of sturdy rope for climbing cliffs or ruins.',
      slots: 1,
    ),
    EquipmentItem(
      id: 'eq_holy_symbol',
      name: 'Consecrated Silver Crucifix',
      description: 'Used in sacred prayers to ward off ghosts and demons.',
      slots: 1,
    ),
    EquipmentItem(
      id: 'eq_camera',
      name: 'Plate Camera & Flash Powder',
      description: 'Heavy photographic apparatus to document apparitions.',
      slots: 2,
      isHeavy: true,
    ),
  ];
}
