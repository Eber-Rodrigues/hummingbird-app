import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hummingbird/main.dart';

Future<void> selectTab(WidgetTester tester, int index) async {
  tester.widget<NavigationBar>(find.byType(NavigationBar)).onDestinationSelected!(index);
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('setup asks gender before the voice test, then alarms use 24-hour time', (tester) async {
    await tester.pumpWidget(const HummingbirdApp());
    await tester.pump();
    await tester.pump();

    expect(find.text("What's your name?"), findsOneWidget);
    expect(find.text('Create Account'), findsNothing);

    await tester.enterText(find.byKey(const Key('onboard-name')), 'Eudo');
    await tester.pump();
    await tester.tap(find.byKey(const Key('name-next')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('gender-female')));
    await tester.pump();
    expect(find.text("Let's test your voice"), findsNothing);

    await tester.tap(find.byKey(const Key('gender-next')));
    await tester.pump();
    await tester.pump();
    expect(find.text('Microphone'), findsOneWidget);

    await tester.tap(find.byKey(const Key('mic-allow')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('start-voice-test')));
    for (var note = 0; note < 8 && find.text('Soprano').evaluate().isEmpty; note++) {
      for (var i = 0; i < 30 && find.byKey(const Key('voice-next')).evaluate().isEmpty; i++) {
        await tester.pump();
      }
      expect(find.byKey(const Key('voice-heard')), findsOneWidget);
      await tester.tap(find.byKey(const Key('voice-next')));
      await tester.pump();
    }
    expect(find.text('Soprano'), findsOneWidget);

    await tester.tap(find.byKey(const Key('voice-continue')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('permissions-continue')));
    await tester.pump();
    expect(find.text('Another way to stop'), findsOneWidget);
    await tester.tap(find.byKey(const Key('shake-continue')));
    await tester.pump();
    await tester.pump();

    expect(find.text('Eudo'), findsOneWidget);
    expect(find.text('06:30'), findsOneWidget);
    expect(find.text('Alarms'), findsWidgets);
    expect(find.byTooltip('Test ring'), findsNothing);
    expect(find.text('Morning Light'), findsWidgets);
    expect(find.text('Snooze length'), findsNothing);

    await tester.tap(find.byKey(const Key('add-alarm')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('alarm-name')), findsOneWidget);
    expect(find.text('Melodies for Soprano'), findsOneWidget);
    expect(find.text('Snooze length', skipOffstage: false), findsNothing);
    expect(find.text('AM'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    await selectTab(tester, 2);
    await tester.ensureVisible(find.byKey(const Key('hour-12')));
    await tester.tap(find.byKey(const Key('hour-12')));
    await tester.pump();
    await selectTab(tester, 0);
    expect(find.text('6:30 AM'), findsOneWidget);
    expect(find.text('06:30'), findsNothing);
  });

  testWidgets('settings switch dark mode and language', (tester) async {
    SharedPreferences.setMockInitialValues({
      'gender.v1': 'female',
      'voice.v1': 'soprano',
      'permissionsAck.v1': true,
    });

    await tester.pumpWidget(const HummingbirdApp());
    await tester.pump();
    await tester.pump();

    await selectTab(tester, 2);
    await tester.ensureVisible(find.byKey(const Key('dark-mode')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('dark-mode')));
    await tester.pumpAndSettle();

    expect(tester.widget<SwitchListTile>(find.byKey(const Key('dark-mode'))).value, isTrue);
    expect(Theme.of(tester.element(find.byKey(const Key('dark-mode')))).brightness, Brightness.dark);

    await tester.ensureVisible(find.byKey(const Key('language-pt')));
    await tester.tap(find.byKey(const Key('language-pt')));
    await tester.pump();
    expect(find.text('Modo escuro', skipOffstage: false), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('language-es')));
    await tester.tap(find.byKey(const Key('language-es')));
    await tester.pump();
    expect(find.text('Modo oscuro', skipOffstage: false), findsOneWidget);
    expect(find.text('Ajustes', skipOffstage: false), findsWidgets);

    await tester.ensureVisible(find.byKey(const Key('language-en')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('language-en')));
    await tester.pump();
    expect(find.text('Dark mode', skipOffstage: false), findsOneWidget);
    expect(find.text('Snooze length'), findsNothing);
  });
}
