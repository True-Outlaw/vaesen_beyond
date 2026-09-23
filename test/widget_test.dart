import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaesen_beyond/main.dart';

void main() {
  testWidgets('VaesenBeyondApp smoke test and navigation verification', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const VaesenBeyondApp());
    await tester.pump(); // allow microtasks to finish

    // Verify 3-tab navigation exists on mobile (TABLE, ACT, SHEET)
    expect(find.text('TABLE'), findsOneWidget);
    expect(find.text('ACT'), findsOneWidget);
    expect(find.text('SHEET'), findsOneWidget);

    // Verify Castle is NOT in the top bar on mobile
    expect(find.byTooltip('Castle Gyllencreutz Headquarters'), findsNothing);

    // Verify Castle IS in the top bar on desktop viewport
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const VaesenBeyondApp());
    await tester.pump();
    expect(find.byTooltip('Castle Gyllencreutz Headquarters'), findsOneWidget);
  });
}
