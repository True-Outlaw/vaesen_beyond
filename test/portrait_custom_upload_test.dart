import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaesen_beyond/data/seed/archetypes_data.dart';
import 'package:vaesen_beyond/data/seed/pregen_characters.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/ui/core/theme/app_theme.dart';
import 'package:vaesen_beyond/ui/core/widgets/gothic_portrait.dart';
import 'package:vaesen_beyond/ui/features/builder/view_models/builder_view_model.dart';
import 'package:vaesen_beyond/ui/features/builder/views/character_builder_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  // A minimal valid 1x1 transparent PNG encoded in base64
  const sample1x1PngBase64 =
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';
  const sampleDataUri = 'data:image/png;base64,$sample1x1PngBase64';

  test('Character with custom Base64 Data URI serializes to JSON and restores', () {
    final character = PregenCharacters.characters.first.copyWith(
      portraitAsset: sampleDataUri,
    );

    expect(character.effectivePortraitAsset, sampleDataUri);

    final json = character.toJson();
    expect(json['portraitAsset'], sampleDataUri);

    final restored = Character.fromJson(json);
    expect(restored.portraitAsset, sampleDataUri);
    expect(restored.effectivePortraitAsset, sampleDataUri);
  });

  test('BuilderViewModel handles custom portrait setting, clearing, and preservation', () {
    final vm = BuilderViewModel();

    // Default portrait for Doctor
    expect(vm.portraitAsset, 'assets/images/portraits/astrid.jpg');
    expect(vm.hasCustomPortrait, isFalse);

    // Set custom portrait
    vm.setCustomPortrait(sampleDataUri);
    expect(vm.hasCustomPortrait, isTrue);
    expect(vm.customPortraitDataUri, sampleDataUri);
    expect(vm.portraitAsset, sampleDataUri);

    // Changing archetype preserves custom portrait if already set
    final officer = ArchetypesData.allArchetypes.firstWhere((a) => a.name == 'Officer');
    vm.setArchetype(officer);
    expect(vm.portraitAsset, sampleDataUri);
    expect(vm.hasCustomPortrait, isTrue);

    // User selects bundled portrait
    vm.setPortraitAsset('assets/images/portraits/birger.jpg');
    expect(vm.portraitAsset, 'assets/images/portraits/birger.jpg');
    // Custom portrait is still cached for quick reselection
    expect(vm.customPortraitDataUri, sampleDataUri);

    // Clear custom portrait reverts to archetype default
    vm.clearCustomPortrait();
    expect(vm.hasCustomPortrait, isFalse);
    expect(vm.customPortraitDataUri, isNull);
    expect(vm.portraitAsset, 'assets/images/portraits/birger.jpg');
  });

  testWidgets('GothicPortrait renders Base64 Data URI without throwing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: const Scaffold(
          body: Center(
            child: GothicPortrait(
              portraitAsset: sampleDataUri,
              width: 80,
              height: 80,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GothicPortrait), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('GothicPortrait falls back gracefully on empty string', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: const Scaffold(
          body: Center(
            child: GothicPortrait(
              portraitAsset: '',
              fallbackInitial: 'Astrid',
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('CharacterBuilderScreen displays bundled portraits and custom upload tile', (WidgetTester tester) async {
    final playVm = PlayViewModel();
    await playVm.initialize();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        home: Scaffold(
          body: CharacterBuilderScreen(
            playViewModel: playVm,
            onFinished: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('SELECT GOTHIC PORTRAIT'), findsOneWidget);
    expect(find.text('Astrid'), findsOneWidget);
    expect(find.text('Birger'), findsOneWidget);
    expect(find.text('Elias'), findsOneWidget);
    expect(find.text('Johan'), findsOneWidget);
    expect(find.text('Upload'), findsOneWidget);
    expect(find.byIcon(Icons.add_photo_alternate_outlined), findsOneWidget);
  });
}
