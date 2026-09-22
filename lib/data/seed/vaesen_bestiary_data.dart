import '../../domain/models/vaesen_creature.dart';

/// Authentic Scandinavian folklore bestiary data for Vaesen.
class VaesenBestiaryData {
  static const List<String> categories = [
    'All',
    'Nature Spirits',
    'Undead',
    'Fae',
    'Monstrosities',
  ];

  static const List<VaesenCreature> allCreatures = [
    // 1. Ash Tree Wife (Askfrun)
    VaesenCreature(
      id: 'bestiary_ash_tree_wife',
      name: 'Ash Tree Wife',
      swedishName: 'Askfrun',
      category: 'Nature Spirits',
      description:
          'A stern, vengeful guardian spirit inhabiting ancient ash trees. If woodcutters wound her sacred branches or fail to pour milk and water upon her roots every Ash Wednesday, she visits their homestead with wasting sickness, fevers, and creeping roots through floorboards.',
      habitat: 'Solitary ash trees on ancient farm boundaries or village greens',
      might: 8,
      body: 6,
      mind: 8,
      magic: 9,
      fear: 1,
      enchantments: [
        VaesenEnchantment(
          name: 'The Withering Touch',
          costOrTrigger: '1 Magic action',
          effect: 'Inflicts 1 Physical condition (Exhausted or Battered) on any investigator touching her roots without an offering.',
        ),
        VaesenEnchantment(
          name: 'Root Entanglement',
          costOrTrigger: 'Free reaction',
          effect: 'Twisting ash roots snare targets at Near range; escaping requires an Agility or Force check (2 successes).',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Branch Lash', damage: 2, range: 'Near', description: 'Heavy whipping branch weighted with knots.'),
      ],
      weaknesses: ['Pure iron nails driven into her trunk', 'Fire and burning embers', 'Consecrated oil'],
      ritualsOfBanishment: [
        'Anoint the trunk with sweet goat milk and morning spring water while reciting an apology in ancient Swedish.',
        'If corrupted by malice, the central taproot must be severed with an axe forged without coal, then salted and burned before dawn.',
      ],
      secrets: 'She can be appeased and turned into an ally by offering clean freshwater and never breaking fresh boughs.',
    ),

    // 2. Brook Horse (Bäckahästen)
    VaesenCreature(
      id: 'bestiary_brook_horse',
      name: 'Brook Horse',
      swedishName: 'Bäckahästen',
      category: 'Nature Spirits',
      description:
          'A majestic, misty-grey stallion found grazing near rushing brooks and misty riverbeds. Its long, silken back magically lengthens to accommodate as many riders as dare mount it, whereupon it bolts into deep water to drown and devour its victims.',
      habitat: 'Frothing mill streams, foaming rapids, and river fords',
      might: 12,
      body: 9,
      mind: 6,
      magic: 9,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'Lengthening Spine',
          costOrTrigger: 'Passive',
          effect: 'The horse’s back can stretch to seat up to eight riders simultaneously, charming them into climbing aboard.',
        ),
        VaesenEnchantment(
          name: 'Watery Gallop',
          costOrTrigger: 'Fast action',
          effect: 'Can sprint across water surfaces without sinking and drag submerged victims at double speed.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Shattering Hoof', damage: 3, range: 'Arm’s Length', description: 'Crushing blow that shatters bone.'),
        VaesenAttack(name: 'Dragging Drown', damage: 2, range: 'Arm’s Length', description: 'Pulls victim beneath murky waters.'),
      ],
      weaknesses: ['Ploughshares of cold iron', 'Calling its true Christian name or speaking the word of Christ', 'A bridle adorned with a cross'],
      ritualsOfBanishment: [
        'Trick the beast into a harness connected to an iron plough and force it to till an entire field between sundown and sunrise. Once exhausted, it dissolves into foam.',
      ],
      secrets: 'If a rider utters "Cross" or "Jesus", the horse throws its riders and vanishes in a thunder of river spray.',
    ),

    // 3. Church Grim (Kyrkogrim)
    VaesenCreature(
      id: 'bestiary_church_grim',
      name: 'Church Grim',
      swedishName: 'Kyrkogrim',
      category: 'Undead',
      description:
          'A spectral black bull, ram, or hound born from ancient pagan sacrifices buried beneath the cornerstones of medieval churches. It patrols churchyards by midnight, protecting hallowed graves from graverobbers, witches, and profane defilement.',
      habitat: 'Consecrated churchyards, belfries, and crypt entrances',
      might: 10,
      body: 8,
      mind: 7,
      magic: 7,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'Death Knell Howl',
          costOrTrigger: 'Slow action',
          effect: 'Emits an eerie toll that induces a Fear test (Fear 2). Those who fail suffer the Frightened condition.',
        ),
        VaesenEnchantment(
          name: 'Phantom Guardian',
          costOrTrigger: 'Passive',
          effect: 'Cannot be wounded by non-consecrated weapons while standing upon church ground.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Spectral Horns / Bite', damage: 2, range: 'Arm’s Length', description: 'Freezing bite of grave frost.'),
      ],
      weaknesses: ['Graverobber’s silver', 'Unconsecrated ground', 'Toll of a newly blessed brass church bell'],
      ritualsOfBanishment: [
        'The Grim cannot be truly destroyed while the church stands; but it can be put to rest by replacing stolen church relics or repairing violated graves.',
      ],
      secrets: 'The Grim will ignore investigators who bow before the altar and carry no stolen earth from the graveyard.',
    ),

    // 4. Fairy (Älva)
    VaesenCreature(
      id: 'bestiary_fairy',
      name: 'Fairy',
      swedishName: 'Älva',
      category: 'Fae',
      description:
          'Ethereal, semi-translucent beings of morning dew and twilight mist. They gather in circles known as fairy rings across meadows and damp bogs, dancing so hypnotically that any who gaze upon them lose their youth, sanity, or the memory of their home.',
      habitat: 'Misty heathlands, fairy rings in mossy clearings, and autumn bogs',
      might: 5,
      body: 4,
      mind: 9,
      magic: 10,
      fear: 1,
      enchantments: [
        VaesenEnchantment(
          name: 'The Ring Dance',
          costOrTrigger: 'Slow action',
          effect: 'Targets within Near range must roll Logic (difficulty 2) or be compelled to step into the ring and dance until exhausted.',
        ),
        VaesenEnchantment(
          name: 'Fairy Breath (Älvblåst)',
          costOrTrigger: 'Fast action',
          effect: 'A blowing mist causing boils, painful rashes, and the Exhausted physical condition.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Needle Prick', damage: 1, range: 'Near', description: 'Tiny thorn coated in fairy venom.'),
      ],
      weaknesses: ['Cold-forged steel knives', 'Spitting into fire three times', 'Wearing clothes turned inside out'],
      ritualsOfBanishment: [
        'Dig up the center of the fairy ring with a silver spade and scatter salt over the exposed roots, reciting the Lord’s Prayer backward.',
      ],
      secrets: 'Never eat food offered by fairies or step with both boots inside a mushroom circle.',
    ),

    // 5. Ghost (Spöke / Gast)
    VaesenCreature(
      id: 'bestiary_ghost',
      name: 'Ghost',
      swedishName: 'Spöke / Gast',
      category: 'Undead',
      description:
          'The sorrowful or spiteful remnants of a soul bound to the earthly plane by violent murder, suicide, hidden wealth, or an unfulfilled oath. Gasts appear as chilling apparitions or disembodied moans rattling through floorboards.',
      habitat: 'Manor houses, attics, crossroads, and sites of tragic demise',
      might: 6,
      body: 6,
      mind: 8,
      magic: 8,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'Chilling Apparition',
          costOrTrigger: 'Trigger on manifest',
          effect: 'Causes ambient temperature to drop below freezing. Extinguishes candles and forces Fear test (Fear 2).',
        ),
        VaesenEnchantment(
          name: 'Incorporeal Drift',
          costOrTrigger: 'Passive',
          effect: 'Immune to all non-magical physical weapons. Moves unimpeded through solid walls and doors.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Grave Chill', damage: 2, range: 'Arm’s Length', description: 'Freezing touch draining life energy.'),
        VaesenAttack(name: 'Poltergeist Barrage', damage: 2, range: 'Near', description: 'Hurled books, candlesticks, or teacups.'),
      ],
      weaknesses: ['Salt lines across thresholds', 'Holy scripture read aloud', 'Sunlight and morning rooster crows'],
      ritualsOfBanishment: [
        'Exhume the restless bones and bury them in consecrated church soil with a silver coin placed under the tongue.',
        'Fulfill the dying request or reveal the murderer whose secret keeps the soul chained to the mortal world.',
      ],
      secrets: 'Ghosts cannot cross lines of table salt or running water without dispelling their ethereal form.',
    ),

    // 6. Giant (Jätte)
    VaesenCreature(
      id: 'bestiary_giant',
      name: 'Giant',
      swedishName: 'Jätte',
      category: 'Monstrosities',
      description:
          'Ancient, primordial beings of rock and lichen who retreated into remote Scandinavian mountains when the sound of church bells spread across the valleys. Colossal and slow of thought, they can hurl church boulders and level timber barns in single strokes.',
      habitat: 'Granite peaks, deep cavern vaults, and uninhabited northern fells',
      might: 15,
      body: 12,
      mind: 4,
      magic: 6,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'Tremor Stomp',
          costOrTrigger: 'Slow action',
          effect: 'Slams the earth; all creatures within Near range must succeed on Agility or be knocked prone.',
        ),
        VaesenEnchantment(
          name: 'Petrifying Light',
          costOrTrigger: 'Passive vulnerability',
          effect: 'Direct exposure to midday sunlight turns the giant into solid stone over three turns.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Boulder Throw', damage: 4, range: 'Far', description: 'Hurls a massive boulder crushing everything in its path.'),
        VaesenAttack(name: 'Tree Club', damage: 4, range: 'Arm’s Length', description: 'An uprooted pine tree sweeping wide arcs.'),
      ],
      weaknesses: ['The sound of consecrated church bells (causes excruciating pain)', 'Direct midday sunlight', 'Lightning and steel'],
      ritualsOfBanishment: [
        'Outsmart the giant in a contest of wits or riddle-game; giants cannot refuse an archaic bet, and when outwitted, they retreat deep beneath the mountain.',
      ],
      secrets: 'Giants possess immense treasure hoard collections of unworked silver and prehistoric gold hidden in mountain clefts.',
    ),

    // 7. Lindworm (Lindorm)
    VaesenCreature(
      id: 'bestiary_lindworm',
      name: 'Lindworm',
      swedishName: 'Lindorm',
      category: 'Monstrosities',
      description:
          'A monstrous wingless dragon or giant serpent covered in shimmering viridian scales. It lurks beneath barrows and hollow tree trunks, spitting venom that corrodes iron and rolling across hills by biting its own tail like a scythe wheel.',
      habitat: 'Viking barrows, limestone caves, and ancient burial mounds',
      might: 14,
      body: 11,
      mind: 7,
      magic: 8,
      fear: 3,
      enchantments: [
        VaesenEnchantment(
          name: 'Corrosive Acid Spit',
          costOrTrigger: 'Slow action',
          effect: 'Spits venom (Near range); deals 2 damage and melts 1 point of Armor Protection permanently.',
        ),
        VaesenEnchantment(
          name: 'Hoop Roll',
          costOrTrigger: 'Fast action',
          effect: 'Bites tail and rolls at triple movement speed, bowling over investigators.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Venomous Bite', damage: 3, range: 'Arm’s Length', description: 'Needle-fanged bite injecting lethal venom.'),
        VaesenAttack(name: 'Tail Constriction', damage: 2, range: 'Arm’s Length', description: 'Crushes torso and cracks ribs.'),
      ],
      weaknesses: ['Burning sulfur and tar', 'A mirror reflecting its own gaze', 'Lye and alder wood ashes'],
      ritualsOfBanishment: [
        'Set nine shirts woven from flax and steeped in lye before the creature; as it sloughs off each layer of skin to reach its prize, plunge an alder stake through its heart.',
      ],
      secrets: 'The shed skin of a Lindworm confers knowledge of healing herbs and beast-speech if consumed with boiled milk.',
    ),

    // 8. Mermaid (Sjörå / Havsrå)
    VaesenCreature(
      id: 'bestiary_mermaid',
      name: 'Mermaid / Sea Wife',
      swedishName: 'Sjörå / Havsrå',
      category: 'Nature Spirits',
      description:
          'A beautiful, captivating maiden who rules over coastal archipelagos and outer skerries. She combs her emerald-green hair on wave-washed reefs, capable of granting fishermen bountiful herring catches or summoning hurricane squalls that dash schooners upon rocks.',
      habitat: 'Coastal skerries, lighthouses, and brackish Baltic inlets',
      might: 9,
      body: 7,
      mind: 8,
      magic: 10,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'Siren Tempest',
          costOrTrigger: 'Slow action',
          effect: 'Summons blinding coastal gales and churning swells that capsize small boats within minutes.',
        ),
        VaesenEnchantment(
          name: 'Alluring Gaze',
          costOrTrigger: 'Passive',
          effect: 'Sailors gazing upon her must test Logic; failure means jumping overboard to swim toward her reef.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Wave Surge', damage: 2, range: 'Near', description: 'A cresting wall of icy seawater.'),
      ],
      weaknesses: ['Steel hooks dipped in sealing wax', 'Speaking the true name of the ship', 'Bread baked with caraway seed'],
      ritualsOfBanishment: [
        'Cast three pewter buttons into the wave while cursing her lineage with the name of St. Olaf, turning the boat back to safe harbor.',
      ],
      secrets: 'She can be won over by throwing a copper coin or a woolen mitten into the water before casting fishing nets.',
    ),

    // 9. Myling
    VaesenCreature(
      id: 'bestiary_myling',
      name: 'Myling',
      swedishName: 'Myling',
      category: 'Undead',
      description:
          'The tragic, vengeful ghost of an unbaptized infant murdered by its impoverished mother and hidden under floorboards or in the peat bog. It climbs onto lone travelers’ backs along deserted forest roads, growing heavier with every step until the victim sinks into the muck and dies of exhaustion.',
      habitat: 'Peat bogs, lonely crossroads, and beneath old timber floorboards',
      might: 8,
      body: 6,
      mind: 5,
      magic: 8,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'The Crushing Weight',
          costOrTrigger: 'Upon leaping onto a carrier',
          effect: 'The victim must make a Force check every round; failure inflicts 1 Physical condition as the Myling doubles in weight.',
        ),
        VaesenEnchantment(
          name: 'Mournful Wail',
          costOrTrigger: 'Slow action',
          effect: 'A piercing infant screech that induces Fear test (Fear 2) and causes horses to bolt in panic.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Freezing Claw', damage: 2, range: 'Arm’s Length', description: 'Pale, icy fingers digging into flesh.'),
      ],
      weaknesses: ['Naming the child with a Christian name', 'Carrying the child toward church ground', 'Consecrated baptismal water'],
      ritualsOfBanishment: [
        'Locate its concealed skeletal remains, carry them to church ground without letting them touch the earth, and baptize the soul with holy water and a name.',
      ],
      secrets: 'If an investigator asks the Myling "What is your name?", it weeps and clings tighter until given a proper name.',
    ),

    // 10. Night Raven (Nattramn)
    VaesenCreature(
      id: 'bestiary_night_raven',
      name: 'Night Raven',
      swedishName: 'Nattramn',
      category: 'Undead',
      description:
          'A giant, shadowy raven whose hollow breast carries a hole through which stars can be seen. Born from the soul of an unburied suicide or executed criminal, it flies at twilight from east to west, croaking an omen of death that curses anyone who looks through its hollow chest.',
      habitat: 'Gallows hills, ruined windmills, and evening skies over heathlands',
      might: 7,
      body: 6,
      mind: 7,
      magic: 9,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'Death Omen Croak',
          costOrTrigger: 'Slow action',
          effect: 'All who hear its croak suffer 1 Mental condition (Hopeless or Upset) unless passing an Empathy check.',
        ),
        VaesenEnchantment(
          name: 'Hole of Emptiness',
          costOrTrigger: 'Passive',
          effect: 'Looking through the hole in its chest induces instantaneous paralysis for 1D6 rounds.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Beak Strike', damage: 2, range: 'Arm’s Length', description: 'Razor-sharp iron beak aimed at the eyes.'),
      ],
      weaknesses: ['Silver birdshot', 'Churchyard soil thrown upward', 'Singing hymn verses before it passes overhead'],
      ritualsOfBanishment: [
        'Find the unhallowed resting place of the executed soul and hammer an aspen stake into the ground with three blows of a wooden mallet.',
      ],
      secrets: 'It always flies strictly from East to West and cannot alter its flight path if blinding lantern light strikes its eyes.',
    ),

    // 11. Nixie (Näcken)
    VaesenCreature(
      id: 'bestiary_nixie',
      name: 'Nixie',
      swedishName: 'Näcken',
      category: 'Nature Spirits',
      description:
          'A naked, handsome man sitting on a river rock or submerged log playing enchanting tunes upon a silver violin. His spellbinding melodies compel men, women, and beasts to dance uncontrollably into the deep pools where they drown.',
      habitat: 'Millponds, dark river bends, and churning waterfall pools',
      might: 10,
      body: 8,
      mind: 9,
      magic: 11,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'Fiddle of the Drowned',
          costOrTrigger: 'Slow action',
          effect: 'All within hearing must test Logic or Empathy (difficulty 2); failure forces targets to walk directly into the river.',
        ),
        VaesenEnchantment(
          name: 'Shapeshifting',
          costOrTrigger: 'Fast action',
          effect: 'Can assume the form of a golden horse, a swimming log, or a handsome bearded violinist.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Drowning Clasp', damage: 2, range: 'Arm’s Length', description: 'Drags target underwater with icy grip.'),
      ],
      weaknesses: ['Dropping steel into the water before swimming', 'Calling out his name ("Näcken!")', 'Carrying garlic or valerian root'],
      ritualsOfBanishment: [
        'Snap all four strings of his violin with an iron blade, or throw an iron nail into the pool while loudly declaring that Christ walked upon the waters.',
      ],
      secrets: 'He will teach a willing mortal master-level violin playing in exchange for three drops of blood or a black lamb sacrifice.',
    ),

    // 12. Revenant (Gengångare)
    VaesenCreature(
      id: 'bestiary_revenant',
      name: 'Revenant',
      swedishName: 'Gengångare',
      category: 'Undead',
      description:
          'A rotting, heavy corpse driven from its coffin by an unatoned crime, a curse, or sheer spite toward the living. Unlike frail ghosts, the Revenant possesses terrible physical strength, breaking into its former home at midnight to strangle unfaithful spouses or kin.',
      habitat: 'Graveyards, family crypts, and farmhouses visited by tragedy',
      might: 13,
      body: 10,
      mind: 4,
      magic: 5,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'Terror Stride',
          costOrTrigger: 'Passive',
          effect: 'Immune to pain, stun, and mental fear conditions. Shrugs off 2 points of physical damage from mundane weapons.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Grave Stragle', damage: 3, range: 'Arm’s Length', description: 'Crushes windpipe with rigor-mortis hands.'),
        VaesenAttack(name: 'Coffin-Timber Strike', damage: 2, range: 'Arm’s Length', description: 'Heavy blow with splintered wood.'),
      ],
      weaknesses: ['Fire and burning embers', 'Decapitation with a consecrated spade', 'Iron needles stuck through the soles of its feet'],
      ritualsOfBanishment: [
        'Re-open the grave, sever the head, place the skull between the corpse’s thighs, and drive an ash stake through the breastbone.',
      ],
      secrets: 'Scattering peas or flax seeds behind you causes the revenant to stop and count every single seed before continuing pursuit.',
    ),

    // 13. Spertus (Bjära / Bära)
    VaesenCreature(
      id: 'bestiary_spertus',
      name: 'Spertus',
      swedishName: 'Bjära / Bära',
      category: 'Monstrosities',
      description:
          'A grotesque, ball-shaped construct of moss, tangled hair, twigs, and wax, brought to life through blood pacts by a malevolent witch. It rolls or scuttles between dairy barns under cover of night, siphoning cream and butter from neighbors’ cows to vomit into its master’s churn.',
      habitat: 'Cow sheds, dairy cellars, and haylofts',
      might: 6,
      body: 5,
      mind: 3,
      magic: 7,
      fear: 1,
      enchantments: [
        VaesenEnchantment(
          name: 'Milk Siphon',
          costOrTrigger: 'Passive',
          effect: 'Drains milk and fertility from livestock, causing cows to yield bloody broth and drying up farm resources.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Acid Vomit', damage: 2, range: 'Near', description: 'Spews boiling sour milk and bile.'),
        VaesenAttack(name: 'Needle Scratch', damage: 1, range: 'Arm’s Length', description: 'Tears skin with concealed bone needles.'),
      ],
      weaknesses: ['Striking it with an alder broom', 'Shooting it with a silver button', 'Burning it in a wood stove'],
      ritualsOfBanishment: [
        'Capture the construct and throw it into a hearth of blazing birch wood. The witch who birthed it will suffer the same burns on her own body.',
      ],
      secrets: 'If you whip the Bjära with a rowan branch, it will lead you directly back to the cottage of the witch who created it.',
    ),

    // 14. Troll
    VaesenCreature(
      id: 'bestiary_troll',
      name: 'Troll',
      swedishName: 'Troll',
      category: 'Fae',
      description:
          'Ancient, hairy dwellers of the deep mossy forests and boulder-strewn hills. Trolls hoard vast halls of gold and silver beneath hollow hills, dress in rich garments, and practice powerful illusions (troll-glamour) to steal human babies in exchange for changelings.',
      habitat: 'Hollow mountains, ancient pine forests, and mossy caves',
      might: 12,
      body: 10,
      mind: 7,
      magic: 8,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'Troll Glamour (Trollskott)',
          costOrTrigger: 'Slow action',
          effect: 'Disguises gold as dried leaves, horse dung as warm loaves, or their hideous forms as charming forest folk.',
        ),
        VaesenEnchantment(
          name: 'Changeling Theft',
          costOrTrigger: 'Story trigger',
          effect: 'Swaps human newborn infants with aged, voracious troll children who devour all farm grain without growing.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Stone Fist', damage: 3, range: 'Arm’s Length', description: 'Crushing punch with thick gnarled fingers.'),
        VaesenAttack(name: 'Iron Poker', damage: 2, range: 'Arm’s Length', description: 'A red-hot hearth tool.'),
      ],
      weaknesses: ['Sound of church bells (induces panic and flight)', 'Cold-forged steel and pure iron', 'Smell of burning Christian fat'],
      ritualsOfBanishment: [
        'Hang a pair of iron scissors over the infant cradle; to banish an adult troll, corner it and recite its genealogy until church bells toll.',
      ],
      secrets: 'Trolls are extraordinarily susceptible to flattery and will give away gold coins if praised for their brewing skill.',
    ),

    // 15. Vaettir (Vätte / Tomte)
    VaesenCreature(
      id: 'bestiary_vaettir',
      name: 'Vaettir / Tomte',
      swedishName: 'Vätte / Tomte',
      category: 'Fae',
      description:
          'Diminutive, bearded house spirits standing no taller than a toddler, wearing coarse grey tunics and red wool caps. They oversee the prosperity, horses, and livestock of the farmstead. While beneficial when respected, neglect or cruelty provokes devastating retribution and barn fires.',
      habitat: 'Haylofts, stables, under house foundations, and beneath the hearth',
      might: 6,
      body: 5,
      mind: 9,
      magic: 8,
      fear: 1,
      enchantments: [
        VaesenEnchantment(
          name: 'House Blessing',
          costOrTrigger: 'Passive',
          effect: 'When offered Christmas porridge with real butter, grants +1 Resource bonus to the homestead.',
        ),
        VaesenEnchantment(
          name: 'Biting Slap',
          costOrTrigger: 'Fast action',
          effect: 'Delivers a stinging unseen slap that inflicts 1 condition and knocks tools from hands.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Iron Pitchfork', damage: 2, range: 'Arm’s Length', description: 'A miniature iron fork swung with surprising force.'),
      ],
      weaknesses: ['Silver coins left in porridge', 'Profanity and disrespectful speech (drives him away forever)', 'Moving the homestead hearth'],
      ritualsOfBanishment: [
        'To rid a home of an angry Tomte, you must give him a suit of fine silk clothes; his pride will compel him to refuse menial farm work and leave.',
      ],
      secrets: 'Never forget to place a large pat of real churned butter on top of his Christmas Eve porridge bowl, or he will kill the best horse.',
    ),

    // 16. Werewolf (Varulv)
    VaesenCreature(
      id: 'bestiary_werewolf',
      name: 'Werewolf',
      swedishName: 'Varulv',
      category: 'Monstrosities',
      description:
          'A cursed human who has either willingly donned a wolf belt sewn from executed wolf-hide, or been cursed by a scorned lover or malevolent spellcaster. Under moonlight, they transform into a hulking, bloodthirsty predator hunting kin and livestock.',
      habitat: 'Dense pine forests, snowdrifts, and lonely hunting cabins',
      might: 14,
      body: 10,
      mind: 5,
      magic: 6,
      fear: 3,
      enchantments: [
        VaesenEnchantment(
          name: 'Blood Frenzy',
          costOrTrigger: 'When taking damage',
          effect: 'Gains +2 dice to all Close Combat attacks when any physical condition is checked.',
        ),
        VaesenEnchantment(
          name: 'Supernatural Regeneration',
          costOrTrigger: 'End of round',
          effect: 'Heals 1 physical damage per round unless the damage was inflicted by silver or fire.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Ripping Jaws', damage: 3, range: 'Arm’s Length', description: 'Bone-crushing wolf bite.'),
        VaesenAttack(name: 'Gutting Claws', damage: 2, range: 'Arm’s Length', description: 'Swipe tearing clothes and armor.'),
      ],
      weaknesses: ['Silver bullets and silver-tipped blades', 'Calling the werewolf by their true baptized human name', 'Throwing an iron tool over its back'],
      ritualsOfBanishment: [
        'Call the werewolf out by its real human name three times while it charges, or burn its concealed wolf skin belt in a consecrated hearth fire.',
      ],
      secrets: 'If wounded by silver, the human form will bear the exact same scar on the following morning.',
    ),

    // 17. Will-o'-the-Wisp (Irrbloss)
    VaesenCreature(
      id: 'bestiary_will_o_the_wisp',
      name: 'Will-o\'-the-Wisp',
      swedishName: 'Irrbloss',
      category: 'Nature Spirits',
      description:
          'Flickering pale blue, greenish, or golden lanterns drifting over dark marshes and bottomless peat quagmires. They are the souls of greedy surveyors who moved boundary stones in life, doomed to wander and lead lost travelers into watery graves.',
      habitat: 'Peat marshes, treacherous bogs, and misty marshlands',
      might: 4,
      body: 4,
      mind: 6,
      magic: 9,
      fear: 1,
      enchantments: [
        VaesenEnchantment(
          name: 'Hypnotic Lantern',
          costOrTrigger: 'Passive',
          effect: 'Investigators following its light must test Vigilance or become completely disoriented, wandering deeper into the swamp.',
        ),
        VaesenEnchantment(
          name: 'Cold Fire Shock',
          costOrTrigger: 'Fast action',
          effect: 'Discharges phantom lightning dealing 1 damage and extinguishing real lanterns.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Ghostly Spark', damage: 1, range: 'Near', description: 'Chilling jolt of marsh-fire.'),
      ],
      weaknesses: ['Carrying a compass or dry rowan twig', 'Throwing a coin into the marsh', 'Moving boundary stones back to their true locations'],
      ritualsOfBanishment: [
        'Find the displaced boundary stone, lift it, and carry it back to its original survey spot, proclaiming: "Here is your rightful mark!"',
      ],
      secrets: 'They cannot cross dry gravel or paved roads, vanishing if brought within range of street lamps.',
    ),

    // 18. Wood Wife (Skogsrå)
    VaesenCreature(
      id: 'bestiary_wood_wife',
      name: 'Wood Wife / Forest Spirit',
      swedishName: 'Skogsrå',
      category: 'Nature Spirits',
      description:
          'Ruler of the deep ancient boreal forests. From the front, she appears as a stunning, irresistible woman with cascading hair; from behind, her back is a hollow rotten tree trunk or ends in a fox tail. She protects wild game and seduces solitary charcoal burners and hunters.',
      habitat: 'Deep pine ridges, charcoal kilns, and primeval spruce forests',
      might: 11,
      body: 8,
      mind: 9,
      magic: 10,
      fear: 2,
      enchantments: [
        VaesenEnchantment(
          name: 'The Forest Glamour',
          costOrTrigger: 'Passive',
          effect: 'Hunters observing her front must test Logic; failure leaves them smitten, eager to abandon their friends in the woods.',
        ),
        VaesenEnchantment(
          name: 'Master of Beasts',
          costOrTrigger: 'Slow action',
          effect: 'Can summon a pack of wild wolves or a raging brown bear to defend her sacred grove.',
        ),
      ],
      attacks: [
        VaesenAttack(name: 'Grave Branch Blow', damage: 2, range: 'Arm’s Length', description: 'Strike with splintered timber.'),
      ],
      weaknesses: ['Glimpsing her hollow back or fox tail (breaks her charm instantly)', 'Steel knife stuck in a tree trunk', 'Offering bread and tobacco on an ant hill'],
      ritualsOfBanishment: [
        'Politely address her as "Madam" and point out her tail with courtesy: "Pardon, Madame, but your petticoat is showing." She will blush with shame and vanish peacefully.',
      ],
      secrets: 'Hunters who leave a silver coin in her hollow tree receive extraordinary luck on their next hunt, never missing a shot.',
    ),
  ];
}
