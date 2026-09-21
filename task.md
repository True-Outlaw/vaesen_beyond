# Phase 3 Tasks

## A — Character Model & Persistence
- [ ] Add `portraitAsset` to `Character` model with `effectivePortraitAsset` fallback
- [ ] Update `Character.toJson`, `fromJson`, `copyWith`
- [ ] Add `exportCharacterJson` and `importCharacterFromJson` to `PlayViewModel`
- [ ] Ensure `deleteCharacter` allows deleting down to 0 characters (clean empty state)

## B — Character Creation Enforcement & Portrait Picker
- [ ] Add `portraitAsset` to `BuilderViewModel`
- [ ] Add step-by-step validation to `BuilderViewModel`:
  - Step 0 (Identity): Non-empty name required to proceed
  - Step 2 (Attributes & Skills): Exact attribute and skill budget matching Age Category required to proceed
  - Step 5 (Review): All validations must pass to enroll
- [ ] Add Gothic Portrait Picker in Step 0 (Astrid, Birger, Elias, Johan)
- [ ] Update `CharacterBuilderScreen` navigation: disable/prevent "NEXT STEP" when current step validation fails, with clear Gothic guidance banners
- [ ] Update Step 5 with point allocation status banner and chosen portrait display

## C — Party & Roster Management UI
- [ ] Create `party_management_dialog.dart`:
  - List all investigators with portraits, archetypes, and conditions
  - Switch active investigator
  - Delete / Retire investigator (including last investigator)
  - Export investigator JSON (copy to clipboard & view)
  - Import investigator JSON (paste from clipboard or type JSON)
  - Button to enroll new investigator
- [ ] Wire "Manage Roster" button into `InvestigatorPartyBar`
- [ ] Wire "Society Roster", "Export Active", "Import" into `main.dart` AppBar menu
- [ ] Upgrade empty state in `PlayScreen` to Gothic aesthetic with "Enroll", "Import", and "Load Pregen" buttons

## D — Portrait References Cleanup
- [ ] Use `character.effectivePortraitAsset` across `identity_header.dart`, `condition_arc_hud.dart`, `investigator_party_bar.dart`, and `play_screen.dart`

## Final
- [ ] Add tests in `test/party_management_test.dart`
- [ ] `flutter analyze --no-fatal-infos` clean
- [ ] `flutter test` all passing
- [ ] Hot reload via DTD with 0 runtime errors
- [ ] Update README roadmap Phase 3 checkboxes
