import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaesen_beyond/data/datasources/local_storage_service.dart';
import 'package:vaesen_beyond/data/repositories/character_repository.dart';
import 'package:vaesen_beyond/main.dart';
import 'package:vaesen_beyond/ui/core/widgets/legal_disclaimer_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Legal & Copyright Disclaimer', () {
    test('LocalStorageService gets and sets disclaimer acceptance status', () async {
      SharedPreferences.setMockInitialValues({});
      final storage = LocalStorageService();

      expect(await storage.hasAcceptedDisclaimer(), isFalse);

      await storage.setDisclaimerAccepted(true);
      expect(await storage.hasAcceptedDisclaimer(), isTrue);

      final repo = CharacterRepository(storage: storage);
      expect(await repo.hasAcceptedDisclaimer(), isTrue);
    });

    testWidgets('LegalDisclaimerDialog renders all required copyright notices',
        (WidgetTester tester) async {
      bool acknowledged = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LegalDisclaimerDialog(
              onAcknowledge: () => acknowledged = true,
            ),
          ),
        ),
      );

      // Verify header and branding
      expect(find.text('LEGAL & COPYRIGHT NOTICE'), findsOneWidget);
      expect(find.text('The Society Archives · Upsala Chapter'), findsOneWidget);

      // Verify Fria Ligan AB / Free League Publishing
      expect(find.text('Vaesen – Nordic Horror Roleplaying'), findsOneWidget);
      expect(
        find.textContaining('Fria Ligan AB (Free League Publishing)'),
        findsOneWidget,
      );

      // Verify Johan Egerkrans
      expect(find.text('Original Work & Concept'), findsOneWidget);
      expect(
        find.textContaining('Johan Egerkrans'),
        findsNWidgets(2),
      );

      // Verify Unofficial fan companion & Year Zero Engine
      expect(find.text('Unofficial Fan Companion'), findsOneWidget);
      expect(find.text('Year Zero Engine'), findsOneWidget);
      expect(
        find.textContaining('community and workshop guidelines'),
        findsOneWidget,
      );

      // Verify action button and callback
      final acceptButton = find.text('I UNDERSTAND & ENTER SOCIETY');
      expect(acceptButton, findsOneWidget);

      await tester.tap(acceptButton);
      await tester.pump();
      expect(acknowledged, isTrue);
    });

    testWidgets('App opens disclaimer popup on first launch and saves acceptance on dismissal',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(const VaesenBeyondApp());
      // Pump frames for post-frame callback and async storage check
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Popup should be visible on first launch
      expect(find.text('LEGAL & COPYRIGHT NOTICE'), findsOneWidget);
      expect(find.text('I UNDERSTAND & ENTER SOCIETY'), findsOneWidget);

      // Tap to accept and enter
      await tester.tap(find.text('I UNDERSTAND & ENTER SOCIETY'));
      await tester.pumpAndSettle();

      // Popup should be dismissed
      expect(find.text('LEGAL & COPYRIGHT NOTICE'), findsNothing);

      // Verify SharedPreferences persisted the accepted state
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('vaesen_disclaimer_accepted_v1'), isTrue);
    });

    testWidgets('App does not show disclaimer popup on subsequent launches if already accepted',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vaesen_disclaimer_accepted_v1': true,
      });

      await tester.pumpWidget(const VaesenBeyondApp());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Popup should NOT be visible
      expect(find.text('LEGAL & COPYRIGHT NOTICE'), findsNothing);
      expect(find.text('TABLE'), findsOneWidget);
    });

    testWidgets('Legal & Copyright Notice can be opened from the app menu',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({
        'vaesen_disclaimer_accepted_v1': true,
      });

      await tester.pumpWidget(const VaesenBeyondApp());
      await tester.pumpAndSettle();

      // Open popup menu via 3 dots icon
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Legal & Copyright Notice'), findsOneWidget);

      // Tap the legal menu item
      await tester.tap(find.text('Legal & Copyright Notice'));
      await tester.pumpAndSettle();

      // Popup should now be open
      expect(find.text('LEGAL & COPYRIGHT NOTICE'), findsOneWidget);
      expect(find.text('I UNDERSTAND & ENTER SOCIETY'), findsOneWidget);

      // Dismiss via close icon
      await tester.tap(find.byTooltip('Close notice'));
      await tester.pumpAndSettle();

      expect(find.text('LEGAL & COPYRIGHT NOTICE'), findsNothing);
    });
  });
}
