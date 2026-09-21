# Vaesen Beyond — The Society Companion

> *"In the shadows of the ancient forests and cobblestone alleys of nineteenth-century Scandinavia, those with The Sight uncover mysteries the world prefers to forget."*

**Vaesen Beyond** is an authentic, pitch-grade digital folio and companion app for **Vaesen – Nordic Horror Roleplaying** (Free League Publishing / Fria Ligan). Designed with a handcrafted Scandinavian Gothic aesthetic, it serves as an immersive tabletop cockpit for investigators exploring the Mythic North.

---

## 🕯️ Current Feature Set

### 1. Act Cockpit (`ACT` Tab)
- **6-Segment Condition Arc HUD**: Dual-arc physical (Exhausted, Battered, Wounded) and mental (Upset, Frightened, Hopeless) biometric ring surrounding the investigator portrait, with Broken state pulsing animations.
- **Scandinavian 4-Attribute Action Dial**: Custom Canvas-painted wheel providing rapid action resolution for *Physique*, *Precision*, *Logic*, and *Empathy*, alongside specialized hubs for *Fear Tests* and *Talents*.
- **Tactile Weapon Dock**: Quick-draw attack rolls with damage, reach, bonus dice, and equip toggles.
- **Personal Memento Solace**: Grounding heirloom ribbon enabling one-click emergency condition relief once per mystery.
- **Party Carousel**: Quick-switching between active investigators with live condition status indicators.

### 2. Castle Gyllencreutz (`TABLE` Tab)
- **Headquarters Roster**: Manage Society headquarters in Upsala, tracking unlockable Facilities (Infirmary, Library, Laboratory, Stables, Seance Room, Guard Tower).
- **Staff Employment**: Hire and maintain specialized staff members (Archivist, Caretaker, Coachman, Occult Scholar, Field Surgeon).
- **Expedition Chronicles**: Historical logs of past mysteries and investigator accomplishments.

### 3. Investigator Folio (`SHEET` Tab)
- **12-Skill Tabletop Roster**: Full skill list categorized by core attributes with live condition penalty adjustments.
- **Experience & Advancement**: XP tracking with official 5 XP skill rank increases (max 5) and talent acquisition.
- **Session Debrief Wizard**: 5 official end-of-session questions to tally Advancement Points earned.
- **Gear & Encumbrance Engine**: Wealth steppers (Resources & Capital), slot capacity calculations (`Physique + 2`), and encumbrance warnings (`-2 Agility`).
- **Investigator Dossier**: Deep narrative profile detailing Motivation, Trauma (The Sight), Dark Secret, and Personal Memento.

### 4. Society Compendium
- Complete in-app reference library covering:
  - **10 Core Archetypes**: Academic, Doctor, Hunter, Occultist, Officer, Priest, Private Detective, Servant, Vagabond, Writer.
  - **Talent Catalog**: All Archetype and General Talents with mechanical effects.
  - **D66 Critical Injuries**: Full tables for physical and mental trauma, treatment skills, healing durations, and lethal time limits.
  - **Weapons & Equipment**: Damage, bonus, range, and cost listings.
  - **Core Rules Reference**: Combat actions, fear mechanics, healing, and skill test fundamentals.

### 5. Physical D6 Dice Engine
- Realistic wooden and brass D6 visual presentation.
- Automatic calculation of successes (sixes) and extra stunts.
- **Advantage & Situational Modifiers**: Unified modifier engine (+2 dice for Advantage, ±1 to ±5 situational modifiers).
- **Pushing the Roll**: Faithful implementation of pushing failed rolls with condition selection and rerolling non-sixes.
- **Fear Tests**: Dedicated fear tests with Panic effects, panic durations, and mental condition penalties.

### 6. New Investigator Registry (Character Builder)
- 6-step guided wizard for creating investigators: Identity, Age Category, Attribute/Skill Point Distribution, Talent Selection, Narrative Foundations, and Official Enrollment.

---

## 🗺️ Product Roadmap & Identified Issues

The following roadmap synthesizes the current system assessment and outlines upcoming milestones for gameplay integrity, narrative depth, and compendium expansion.

### Phase 1: Gameplay Integrity & Rules Automation ✅
- [x] **Castle Development Points Economy**:
  - Enforce development point balance when building facilities (`devCost`).
  - Deduct development points upon construction and refund when dismantling.
  - Add interactive point adjustment steppers (`[-] PTS [+]`).
- [x] **Fear Test Condition Integration**:
  - Connect `FearTestDialog` directly to `PlayViewModel`.
  - Add a one-tap `"APPLY CONDITIONS"` button to automatically inflict suffered mental conditions upon failing a fear test.
- [x] **Lethal Critical Injury Alert Banner**:
  - Surface active lethal injuries directly on the `ACT` cockpit HUD with prominent countdown timers (e.g. *"LETHAL: Treat within 1 hour"*).

### Phase 2: Player Agency & Narrative Folio ✅
- [x] **Editable Investigator Dossier & Journal**:
  - Add in-place editing for Motivation, Trauma, Dark Secret, and Personal Memento.
  - Implement a dedicated **Field Notes / Mystery Journal** editor for players to record clues, rumors, and NPC interactions.
- [x] **Custom Gear Management**:
  - Allow players to edit custom weapons, armor, and equipment items after creation (name, damage, protection, slots, notes).
- [x] **Unified "Conclude Mystery" Workflow**:
  - Create a single comprehensive end-of-mystery flow that combines:
    1. Debrief questionnaire (+XP)
    2. Castle Development Points reward (+Dev Points)
    3. Memento solace restoration
    4. Auto-generating a new Expedition Log in Castle Gyllencreutz archives.

### Phase 3: Party & Investigator Management 🟢
- [ ] **Investigator Deletion & Retirement**:
  - Expose `deleteCharacter(id)` in the party management UI to retire or delete dead investigators.
- [ ] **Character JSON Portability**:
  - Expose `exportCharacterJson` to copy investigator data to clipboard or export to a file.
  - Expose `importCharacterFromJson` to import shared character sheets from other players or backup files.
- [ ] **Character Builder Point Allocation Enforcement**:
  - Add point-budget validation banners on Step 5 (preventing enrollment if attribute or skill points are overspent or underspent according to Age Category).
- [ ] **Portrait Picker**:
  - Allow custom portrait selection during investigator creation from bundled high-resolution Gothic portraits.

### Phase 4: Lore & Society Compendium Expansion 📜
- [ ] **The Vaesen Bestiary**:
  - Add a dedicated **BESTIARY** tab to the Society Compendium featuring Nordic folklore creatures:
    - *Ash Tree Wife, Brook Horse (Bäckahästen), Church Grim, Fairy, Ghost, Giant, Lindworm, Mermaid (Sjörå), Myling, Night Raven, Nixie (Näcken), Revenant, Spertus, Troll, Vaettir, Werewolf, Will-o'-the-Wisp, Wood Wife*.
  - Include creature ratings (*Might, Body, Mind, Magic*), Fear values, supernatural Enchantments, and folkloric *Weaknesses / Rituals of Banishment*.
- [ ] **Global Compendium Search**:
  - Enhance search to scan across all compendium categories simultaneously, displaying badge counts for matches in Archetypes, Talents, Injuries, Gear, Rules, and Bestiary.
- [ ] **Initiative Card Slot Tracker**:
  - Implement a tactile 1–10 turn order slot tracker for combat rounds, supporting card swapping between investigators and adversaries.

---

## 🛠️ Architecture & Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Targeting Windows Desktop, Android, iOS, macOS, Linux).
- **State Management**: MVVM pattern via `ChangeNotifier` and `Provider`.
- **Custom Graphics**: High-performance `CustomPainter` renderers for the 4-Attribute Action Dial and 6-Segment Condition Arc Ring.
- **Persistence**: Clean repository abstraction with `SharedPreferences` and structured JSON serialization for offline play.
- **Typography & Theme**: Bespoke Scandinavian Gothic palette (`Cinzel`, `EB Garamond`, oxidized gold accents, and aged parchment surfaces).

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.19.0 or higher recommended)
- Dart SDK (v3.3.0 or higher)

### Installation & Run
```bash
# Clone the repository
git clone https://github.com/your-username/vaesen_beyond.git
cd vaesen_beyond

# Install dependencies
flutter pub get

# Run on Desktop (Windows)
flutter run -d windows

# Run on Android Emulator
flutter run -d emulator-5554

# Run test suite
flutter test
```

---

*Vaesen – Nordic Horror Roleplaying is copyright © Free League Publishing (Fria Ligan). This companion app is built for personal tabletop use in adherence with Free League workshop guidelines.*
