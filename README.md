# Vaesen Beyond — The Society Companion

> *"In the shadows of the ancient forests and cobblestone alleys of nineteenth-century Scandinavia, those with The Sight uncover mysteries the world prefers to forget."*

[![Deploy to GitHub Pages](https://github.com/True-Outlaw/vaesen_beyond/actions/workflows/deploy.yml/badge.svg)](https://github.com/True-Outlaw/vaesen_beyond/actions/workflows/deploy.yml)
[![Live Demo](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-gold?style=flat-square&logo=github)](https://true-outlaw.github.io/vaesen_beyond/)
[![Flutter](https://img.shields.io/badge/Flutter-3.19+-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Windows%20%7C%20Android%20%7C%20iOS-4E6572?style=flat-square)](#)

**Vaesen Beyond** is an authentic, pitch-grade digital folio and tabletop companion application for **Vaesen – Nordic Horror Roleplaying** (Free League Publishing / Fria Ligan). Handcrafted with an immersive Scandinavian Gothic aesthetic, it provides an all-in-one digital command center for investigators and GMs exploring the Mythic North.

🌐 **Try the Live Web App**: [https://true-outlaw.github.io/vaesen_beyond/](https://true-outlaw.github.io/vaesen_beyond/)

---

## 🕯️ Key Features

### 1. Act Cockpit (`ACT` Tab)
- **Sculpted 4-Attribute Action Dial**: High-performance `CustomPainter` obsidian wheel providing one-tap skill & attribute rolls for *Physique*, *Precision*, *Logic*, and *Empathy*, alongside dedicated hubs for *Fear Tests* and *Talents*.
- **6-Segment Condition Arc HUD**: Dual-arc physical (*Exhausted, Battered, Wounded*) and mental (*Upset, Frightened, Hopeless*) biometric ring framing the investigator portrait, complete with pulsing Broken animations and lethality alerts.
- **Tactile Weapon Dock**: Quick-draw weapon cards with damage counters, reach ratings, bonus dice, and equip states.
- **Personal Memento Solace**: Grounding heirloom ribbon enabling one-click emergency condition relief once per mystery.
- **Edge-to-Edge Desktop Cockpit**: 3-column edge-to-edge layout on desktop/web (`>= 1180px`) with the giant action dial flanked by character dossiers, skills, inventory, and lore.
- **Zero-Scroll Mobile Layout**: Perfectly balanced single-column layout on compact screens with docked bottom cards and zero overflow.

### 2. Castle Gyllencreutz Headquarters (`TABLE` Tab)
- **Gothic Headquarters Command Center**: Chapter branding for the Society's ancestral fortress in Upsala, Sweden.
- **4 Real-Time Metric Pods**:
  - **Development Points**: Point bank with inline `+` / `–` quick steppers to invest in or award points.
  - **Facilities Built**: Renovation percentage and operational status tracker.
  - **Retainers Active**: Live headcount of hired staff on duty.
  - **Expeditions Logged**: Total recorded mysteries and cumulative XP awarded.
- **Widescreen 2-Column Split Workstation**:
  - **Facilities & Architecture**: Filter by *All*, *Operational*, *Can Build*, or *Unbuilt*. Includes Grand Library, Restorative Infirmary, Smithy & Workshop, Seance Room, Alchemical Laboratory, and Relic Vault with highlighted mechanical benefit callouts and dev-point economy validation.
  - **Staff Retainers**: Role-specific retainer cards (Head Butler, Carriage Coachman, Housekeeper & Cook, Night Watchman) with duty toggles.
  - **Expedition Chronicles**: Interactive **`+ LOG EXPEDITION`** dialog to record completed mysteries (Title, Date, Summary, and Awarded XP) with persistent archive cards.

### 3. Investigator Folio (`SHEET` Tab)
- **12-Skill Tabletop Roster**: Categorized skill list with live condition penalty adjustments and dice roll shortcuts.
- **Rule-Locked Advancement**: Strict adherence to the official 5 XP rule for increasing skill ranks (max 5) with confirmation and undo dialogs.
- **Session Debrief Wizard**: 5 official end-of-session questions to tally Advancement Points earned.
- **Gear & Encumbrance Engine**: Wealth steppers (Resources & Capital), slot capacity calculations (`Physique + 2`), encumbrance alerts (`-2 Agility`), and armor protection dice roll buttons.
- **Investigator Dossier & Field Journal**: Narrative profile detailing Motivation, Trauma (The Sight), Dark Secret, Personal Memento, and a rich multi-entry Field Journal for clues and notes.

### 4. Society Compendium & Bestiary
- **The Vaesen Bestiary**: 18 authentic Scandinavian folklore creatures (*Ash Tree Wife, Brook Horse, Church Grim, Fairy, Ghost, Giant, Lindworm, Mermaid, Myling, Night Raven, Nixie, Revenant, Spertus, Troll, Vaettir / Tomte, Werewolf, Will-o'-the-Wisp, Wood Wife*).
  - Complete with 4-attribute matrix (*Might, Body, Mind, Magic*), Fear ratings, supernatural Enchantments, combat Attacks, folkloric *Weaknesses*, *Banishment Rituals*, and GM *Folklore Secrets*.
  - Category filters: *All, Nature Spirits, Undead, Fae, Monstrosities*.
- **Global Compendium Search**: Live multi-category instant search across all catalogs with dynamic count badges (*Bestiary, Archetypes, Talents, Critical Injuries, Gear, Rules*).
- **10 Core Archetypes**: Academic, Doctor, Hunter, Occultist, Officer, Priest, Private Detective, Servant, Vagabond, Writer.
- **D66 Critical Injuries**: Physical and mental trauma tables with recovery times, treatment skills, and lethal timers.

### 5. Tactical Initiative Card Rack
- **1–10 Card Rack Dialog**: Tactile card slot tracker adhering to official *Vaesen* turn order rules (lowest card acts first).
- **Roman Numeral Cards (I–X)**: Glowing active turn indicator, investigator vs adversary badge styling.
- **Tactical Card Swapping**: Interactive two-tap card swapping between participants for fast reflexes or coordinated actions.
- **Round Management**: Turn advancing, round counter with re-deal capabilities, and on-the-fly adversary slot generation.

### 6. Investigator Enrollment & Portability
- **Guided Character Builder**: 6-step wizard with strict point-budget enforcement (Attributes: 15 Young / 14 Middle-aged / 13 Old; Skills: 10 Young / 12 Middle-aged / 14 Old).
- **Gothic Portrait Picker & Custom Upload**: Select bundled high-resolution portraits or upload custom images (automatically downsampled to 512px and stored as self-contained Base64 Data URIs).
- **100% Offline Persistence**: Zero external servers or login walls. All state is serialized via `SharedPreferences`.
- **Character JSON Export/Import**: One-tap clipboard export/import with duplicate ID collision protection.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev/) (Web, Windows Desktop, Android, iOS, macOS, Linux).
- **State Management**: Clean MVVM architecture with `ChangeNotifier` and `Provider`.
- **Custom Renderers**: Bespoke `CustomPainter` implementations for the obsidian 4-Attribute Action Dial and 6-Segment Condition Arc Ring.
- **Typography & Aesthetics**: Scandinavian Gothic palette (`Cinzel`, `EB Garamond`, oxidized brass, antique gold accents, and aged parchment cards).
- **Hosting & CI/CD**: Automated deployment to GitHub Pages via GitHub Actions.

---

## 🚀 Getting Started Locally

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.19.0 or higher)
- Dart SDK (v3.3.0 or higher)

---

## ⚖️ Legal & Copyright Disclaimer

* **Vaesen – Nordic Horror Roleplaying** is copyright © [Fria Ligan AB](https://freeleaguepublishing.com/) (Free League Publishing).
* *Vaesen* is based on the illustrated book *Vaesen: Spirits and Monsters of Scandinavian Folklore* by author and illustrator **Johan Egerkrans**.
* **Vaesen Beyond** is an unofficial, non-commercial fan-made companion application created for personal tabletop play in accordance with Free League's community and workshop guidelines.
* This project is not affiliated with, endorsed, sponsored, or specifically approved by Fria Ligan AB or Johan Egerkrans.
* All game mechanics, skill structures, and rules references are based on the Year Zero Engine by Free League Publishing.
