import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vaesen_beyond/main.dart';

void main() {
  testWidgets('VaesenBeyondApp smoke test and navigation verification', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const VaesenBeyondApp());
    await tester.pump(); // allow microtasks to finish

    // Verify 3-tab navigation exists (TABLE, ACT, SHEET)
    expect(find.text('TABLE'), findsOneWidget);
    expect(find.text('ACT'), findsOneWidget);
    expect(find.text('SHEET'), findsOneWidget);
  });
}
