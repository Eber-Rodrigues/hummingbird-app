import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hummingbird'**
  String get appTitle;

  /// No description provided for @wakeUpMelody.
  ///
  /// In en, this message translates to:
  /// **'Wake up to your own melody'**
  String get wakeUpMelody;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I Already Have an Account'**
  String get alreadyHaveAccount;

  /// No description provided for @voiceRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your voice range'**
  String get voiceRangeTitle;

  /// No description provided for @testYourVoice.
  ///
  /// In en, this message translates to:
  /// **'Let\'s test your voice'**
  String get testYourVoice;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @voiceTestStep.
  ///
  /// In en, this message translates to:
  /// **'Voice test  {current}/{total}'**
  String voiceTestStep(int current, int total);

  /// No description provided for @voiceRangeBody.
  ///
  /// In en, this message translates to:
  /// **'Hold the pad and trace a melody. The span suggests a difficulty for later alarms.'**
  String get voiceRangeBody;

  /// No description provided for @voiceTestBody.
  ///
  /// In en, this message translates to:
  /// **'Hold the pad and follow the shape. A close hum can stop an alarm.'**
  String get voiceTestBody;

  /// No description provided for @detectedRange.
  ///
  /// In en, this message translates to:
  /// **'Detected range'**
  String get detectedRange;

  /// No description provided for @rangePending.
  ///
  /// In en, this message translates to:
  /// **'Hum on the pad to measure your range'**
  String get rangePending;

  /// No description provided for @recommendedDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Recommended difficulty  ·  {difficulty}'**
  String recommendedDifficulty(String difficulty);

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @myAlarms.
  ///
  /// In en, this message translates to:
  /// **'My Alarms'**
  String get myAlarms;

  /// No description provided for @createAlarm.
  ///
  /// In en, this message translates to:
  /// **'Create Alarm'**
  String get createAlarm;

  /// No description provided for @noAlarms.
  ///
  /// In en, this message translates to:
  /// **'No alarms yet.'**
  String get noAlarms;

  /// No description provided for @testRing.
  ///
  /// In en, this message translates to:
  /// **'Test ring'**
  String get testRing;

  /// No description provided for @editAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Alarm'**
  String get editAlarmTitle;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @ringsOnce.
  ///
  /// In en, this message translates to:
  /// **'Rings once, then turns off.'**
  String get ringsOnce;

  /// No description provided for @repeatsOnDays.
  ///
  /// In en, this message translates to:
  /// **'Repeats on the selected days.'**
  String get repeatsOnDays;

  /// No description provided for @melody.
  ///
  /// In en, this message translates to:
  /// **'Melody'**
  String get melody;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @tolerance.
  ///
  /// In en, this message translates to:
  /// **'Tolerance'**
  String get tolerance;

  /// No description provided for @hummingSavedHint.
  ///
  /// In en, this message translates to:
  /// **'Difficulty sets how much of the melody you must hum. Tolerance sets how close the pitch must be. After several misses the melody gets shorter, then a shake stops the alarm.'**
  String get hummingSavedHint;

  /// No description provided for @saveAlarm.
  ///
  /// In en, this message translates to:
  /// **'Save Alarm'**
  String get saveAlarm;

  /// No description provided for @deleteAlarm.
  ///
  /// In en, this message translates to:
  /// **'Delete alarm'**
  String get deleteAlarm;

  /// No description provided for @navAlarms.
  ///
  /// In en, this message translates to:
  /// **'Alarms'**
  String get navAlarms;

  /// No description provided for @navVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get navVoice;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @voiceHeadline.
  ///
  /// In en, this message translates to:
  /// **'Find your voice'**
  String get voiceHeadline;

  /// No description provided for @voiceBody.
  ///
  /// In en, this message translates to:
  /// **'Hum the notes you hear. Hummingbird keeps the comfortable range and uses it for every alarm melody.'**
  String get voiceBody;

  /// No description provided for @holdToHum.
  ///
  /// In en, this message translates to:
  /// **'Hold and trace'**
  String get holdToHum;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @saveName.
  ///
  /// In en, this message translates to:
  /// **'Save name'**
  String get saveName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @savedOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Your voice type and alarms stay on this phone.'**
  String get savedOnDevice;

  /// No description provided for @wakeWithMelody.
  ///
  /// In en, this message translates to:
  /// **'Wake up with your melody'**
  String get wakeWithMelody;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @humToStop.
  ///
  /// In en, this message translates to:
  /// **'Or hum the shape above the button.'**
  String get humToStop;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @melodyMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning Light'**
  String get melodyMorning;

  /// No description provided for @melodyMorningDetail.
  ///
  /// In en, this message translates to:
  /// **'Soft and bright'**
  String get melodyMorningDetail;

  /// No description provided for @melodyOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean Breeze'**
  String get melodyOcean;

  /// No description provided for @melodyOceanDetail.
  ///
  /// In en, this message translates to:
  /// **'Easy and rolling'**
  String get melodyOceanDetail;

  /// No description provided for @melodySunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get melodySunrise;

  /// No description provided for @melodySunriseDetail.
  ///
  /// In en, this message translates to:
  /// **'Bright and steady'**
  String get melodySunriseDetail;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @toleranceRelaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get toleranceRelaxed;

  /// No description provided for @toleranceNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get toleranceNormal;

  /// No description provided for @toleranceStrict.
  ///
  /// In en, this message translates to:
  /// **'Strict'**
  String get toleranceStrict;

  /// No description provided for @humMatched.
  ///
  /// In en, this message translates to:
  /// **'That matches {melody}.'**
  String humMatched(String melody);

  /// No description provided for @humMissed.
  ///
  /// In en, this message translates to:
  /// **'Not close enough for {tolerance}. Follow the shape a little more carefully.'**
  String humMissed(String tolerance);

  /// No description provided for @humTooShort.
  ///
  /// In en, this message translates to:
  /// **'Hum a little longer.'**
  String get humTooShort;

  /// No description provided for @practiceTarget.
  ///
  /// In en, this message translates to:
  /// **'Practice  ·  {melody}  ·  {difficulty}  ·  {tolerance}'**
  String practiceTarget(String melody, String difficulty, String tolerance);

  /// No description provided for @rangeSpan.
  ///
  /// In en, this message translates to:
  /// **'{low} to {high}'**
  String rangeSpan(String low, String high);

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email.'**
  String get invalidEmail;

  /// No description provided for @shortPassword.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get shortPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Those passwords do not match.'**
  String get passwordMismatch;

  /// No description provided for @accountExists.
  ///
  /// In en, this message translates to:
  /// **'An account with that email already exists. Log in instead.'**
  String get accountExists;

  /// No description provided for @wrongLogin.
  ///
  /// In en, this message translates to:
  /// **'That email or password does not match.'**
  String get wrongLogin;

  /// No description provided for @genderTitle.
  ///
  /// In en, this message translates to:
  /// **'How should we tune your melodies?'**
  String get genderTitle;

  /// No description provided for @genderBody.
  ///
  /// In en, this message translates to:
  /// **'This stays on your phone and helps pick a comfortable range.'**
  String get genderBody;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @voiceListenBody.
  ///
  /// In en, this message translates to:
  /// **'Each note plays, then you hum it back. A checkmark means we heard you. Tap Next for the following note.'**
  String get voiceListenBody;

  /// No description provided for @startVoiceTest.
  ///
  /// In en, this message translates to:
  /// **'Start voice test'**
  String get startVoiceTest;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @couldNotHear.
  ///
  /// In en, this message translates to:
  /// **'We could not hear a clear note. Try again in a quieter spot.'**
  String get couldNotHear;

  /// No description provided for @yourVoiceType.
  ///
  /// In en, this message translates to:
  /// **'Your voice type'**
  String get yourVoiceType;

  /// No description provided for @voiceSoprano.
  ///
  /// In en, this message translates to:
  /// **'Soprano'**
  String get voiceSoprano;

  /// No description provided for @voiceAlto.
  ///
  /// In en, this message translates to:
  /// **'Alto'**
  String get voiceAlto;

  /// No description provided for @voiceTenor.
  ///
  /// In en, this message translates to:
  /// **'Tenor'**
  String get voiceTenor;

  /// No description provided for @voiceBass.
  ///
  /// In en, this message translates to:
  /// **'Bass'**
  String get voiceBass;

  /// No description provided for @permissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Let the alarm ring'**
  String get permissionsTitle;

  /// No description provided for @permissionsBody.
  ///
  /// In en, this message translates to:
  /// **'Hummingbird needs permission to ring when the phone is closed or locked, with exact alarms and a full-screen alert.'**
  String get permissionsBody;

  /// No description provided for @permissionsAlarm.
  ///
  /// In en, this message translates to:
  /// **'Play with the phone closed'**
  String get permissionsAlarm;

  /// No description provided for @permissionsNotification.
  ///
  /// In en, this message translates to:
  /// **'Show the alarm on the lock screen'**
  String get permissionsNotification;

  /// No description provided for @permissionsMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Hear your hum'**
  String get permissionsMicrophone;

  /// No description provided for @allowAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Allow and continue'**
  String get allowAndContinue;

  /// No description provided for @melodyPlaying.
  ///
  /// In en, this message translates to:
  /// **'Your melody is playing'**
  String get melodyPlaying;

  /// No description provided for @humItBack.
  ///
  /// In en, this message translates to:
  /// **'Hum it back'**
  String get humItBack;

  /// No description provided for @choiceIn.
  ///
  /// In en, this message translates to:
  /// **'Snooze and cancel appear in {seconds}s'**
  String choiceIn(int seconds);

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// No description provided for @cancelAlarm.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAlarm;

  /// No description provided for @snoozeLength.
  ///
  /// In en, this message translates to:
  /// **'Snooze length'**
  String get snoozeLength;

  /// No description provided for @snoozeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String snoozeMinutes(int minutes);

  /// No description provided for @melodyForVoice.
  ///
  /// In en, this message translates to:
  /// **'Melodies for {voice}'**
  String melodyForVoice(String voice);

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @voiceOnProfile.
  ///
  /// In en, this message translates to:
  /// **'{gender} · {voice}'**
  String voiceOnProfile(String gender, String voice);

  /// No description provided for @introTitle.
  ///
  /// In en, this message translates to:
  /// **'A quick question'**
  String get introTitle;

  /// No description provided for @introBody.
  ///
  /// In en, this message translates to:
  /// **'Answer one short question so your alarms use melodies that fit your voice.'**
  String get introBody;

  /// No description provided for @hourSystem.
  ///
  /// In en, this message translates to:
  /// **'Hour system'**
  String get hourSystem;

  /// No description provided for @hour24.
  ///
  /// In en, this message translates to:
  /// **'24-hour'**
  String get hour24;

  /// No description provided for @hour12.
  ///
  /// In en, this message translates to:
  /// **'AM/PM'**
  String get hour12;

  /// No description provided for @alarmName.
  ///
  /// In en, this message translates to:
  /// **'Alarm name'**
  String get alarmName;

  /// No description provided for @alarmNameHint.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get alarmNameHint;

  /// No description provided for @micPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get micPermissionTitle;

  /// No description provided for @micPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Hummingbird uses the microphone for a short voice test, and later to hear you hum the alarm melody.'**
  String get micPermissionBody;

  /// No description provided for @allowMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone'**
  String get allowMicrophone;

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editDetails;

  /// No description provided for @alarmOn.
  ///
  /// In en, this message translates to:
  /// **'Alarm on'**
  String get alarmOn;

  /// No description provided for @alarmOff.
  ///
  /// In en, this message translates to:
  /// **'Alarm off'**
  String get alarmOff;

  /// No description provided for @findYourVoice.
  ///
  /// In en, this message translates to:
  /// **'Find your voice'**
  String get findYourVoice;

  /// No description provided for @humTheNote.
  ///
  /// In en, this message translates to:
  /// **'Hum the note you hear.'**
  String get humTheNote;

  /// No description provided for @yourVoiceProfile.
  ///
  /// In en, this message translates to:
  /// **'Your voice profile'**
  String get yourVoiceProfile;

  /// No description provided for @comfortableRange.
  ///
  /// In en, this message translates to:
  /// **'Comfortable range: {low}–{high}'**
  String comfortableRange(String low, String high);

  /// No description provided for @adaptedToRange.
  ///
  /// In en, this message translates to:
  /// **'Your melodies will be adapted to this range.'**
  String get adaptedToRange;

  /// No description provided for @retakeVoiceTest.
  ///
  /// In en, this message translates to:
  /// **'Retake Voice Test'**
  String get retakeVoiceTest;

  /// No description provided for @voiceTypeLine.
  ///
  /// In en, this message translates to:
  /// **'Voice type: {voice}'**
  String voiceTypeLine(String voice);

  /// No description provided for @genderLine.
  ///
  /// In en, this message translates to:
  /// **'Gender: {gender}'**
  String genderLine(String gender);

  /// No description provided for @lastTested.
  ///
  /// In en, this message translates to:
  /// **'Last tested: {date}'**
  String lastTested(String date);

  /// No description provided for @voiceProfile.
  ///
  /// In en, this message translates to:
  /// **'Voice profile'**
  String get voiceProfile;

  /// No description provided for @voiceTestNeeded.
  ///
  /// In en, this message translates to:
  /// **'Take the voice test so melodies stay in a comfortable range.'**
  String get voiceTestNeeded;

  /// No description provided for @shakeToStop.
  ///
  /// In en, this message translates to:
  /// **'Having trouble waking up? Shake the phone for 4 seconds.'**
  String get shakeToStop;

  /// No description provided for @holdToStop.
  ///
  /// In en, this message translates to:
  /// **'Press and hold for 4 seconds'**
  String get holdToStop;

  /// No description provided for @whatsYourName.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get whatsYourName;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get nameHint;

  /// No description provided for @changeScene.
  ///
  /// In en, this message translates to:
  /// **'Change picture'**
  String get changeScene;

  /// No description provided for @shakeOnboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Another way to stop'**
  String get shakeOnboardTitle;

  /// No description provided for @shakeOnboardBody.
  ///
  /// In en, this message translates to:
  /// **'You can always stop an alarm by shaking the phone for 4 seconds straight. Humming still works too.'**
  String get shakeOnboardBody;

  /// No description provided for @shakeAlways.
  ///
  /// In en, this message translates to:
  /// **'Or shake the phone for 4 seconds'**
  String get shakeAlways;

  /// No description provided for @easierMelody.
  ///
  /// In en, this message translates to:
  /// **'Trying a shorter melody.'**
  String get easierMelody;

  /// No description provided for @vibrateWithAlarm.
  ///
  /// In en, this message translates to:
  /// **'Vibrate when the alarm rings'**
  String get vibrateWithAlarm;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
