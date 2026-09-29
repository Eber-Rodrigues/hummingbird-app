import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hummingbird/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('welcome leads to alarms, and Stop dismisses a test ring', (tester) async {
    await tester.pumpWidget(const HummingbirdApp());
    await tester.pump();
    await tester.pump();

    expect(find.text('Wake up to your own melody'), findsOneWidget);

    await tester.tap(find.text('Create Account'));
    await tester.pump();
    expect(find.text('Skip for now'), findsOneWidget);

    await tester.tap(find.text('Skip for now'));
    await tester.pump();
    await tester.pump();

    expect(find.text('My Alarms'), findsOneWidget);
    expect(find.text('Morning Light'), findsOneWidget);

    await tester.tap(find.byTooltip('Test ring').first);
    await tester.pump();
    expect(find.text('Stop'), findsOneWidget);

    await tester.tap(find.text('Stop'));
    await tester.pump();
    expect(find.text('Stop'), findsNothing);
    expect(find.text('My Alarms'), findsOneWidget);
  });
}
