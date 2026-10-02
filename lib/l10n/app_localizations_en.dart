// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hummingbird';

  @override
  String get wakeUpMelody => 'Wake up to your own melody';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'I Already Have an Account';

  @override
  String get voiceRangeTitle => 'Your voice range';

  @override
  String get testYourVoice => 'Let\'s test your voice';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String voiceTestStep(int current, int total) {
    return 'Voice test  $current/$total';
  }

  @override
  String get voiceRangeBody =>
      'Hold the pad and trace a melody. The span suggests a difficulty for later alarms.';

  @override
  String get voiceTestBody =>
      'Hold the pad and follow the shape. A close hum can stop an alarm.';

  @override
  String get detectedRange => 'Detected range';

  @override
  String get rangePending => 'Hum on the pad to measure your range';

  @override
  String recommendedDifficulty(String difficulty) {
    return 'Recommended difficulty  ·  $difficulty';
  }

  @override
  String get continueAction => 'Continue';

  @override
  String get next => 'Next';

  @override
  String get myAlarms => 'My Alarms';

  @override
  String get createAlarm => 'Create Alarm';

  @override
  String get noAlarms => 'No alarms yet.';

  @override
  String get testRing => 'Test ring';

  @override
  String get editAlarmTitle => 'Edit Alarm';

  @override
  String get repeat => 'Repeat';

  @override
  String get ringsOnce => 'Rings once, then turns off.';

  @override
  String get repeatsOnDays => 'Repeats on the selected days.';

  @override
  String get melody => 'Melody';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get tolerance => 'Tolerance';

  @override
  String get hummingSavedHint =>
      'Difficulty sets how much of the melody you must hum. Tolerance sets how close the pitch must be. After several misses the melody gets shorter, then a shake stops the alarm.';

  @override
  String get saveAlarm => 'Save Alarm';

  @override
  String get deleteAlarm => 'Delete alarm';

  @override
  String get navAlarms => 'Alarms';

  @override
  String get navVoice => 'Voice';

  @override
  String get navProfile => 'Profile';

  @override
  String get voiceHeadline => 'Find your voice';

  @override
  String get voiceBody =>
      'Hum the notes you hear. Hummingbird keeps the comfortable range and uses it for every alarm melody.';

  @override
  String get holdToHum => 'Hold and trace';

  @override
  String get profileTitle => 'Profile';

  @override
  String get nameLabel => 'Name';

  @override
  String get saveName => 'Save name';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageSpanish => 'Español';

  @override
  String get savedOnDevice => 'Your voice type and alarms stay on this phone.';

  @override
  String get wakeWithMelody => 'Wake up with your melody';

  @override
  String get stop => 'Stop';

  @override
  String get humToStop => 'Or hum the shape above the button.';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get melodyMorning => 'Morning Light';

  @override
  String get melodyMorningDetail => 'Soft and bright';

  @override
  String get melodyOcean => 'Ocean Breeze';

  @override
  String get melodyOceanDetail => 'Easy and rolling';

  @override
  String get melodySunrise => 'Sunrise';

  @override
  String get melodySunriseDetail => 'Bright and steady';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get toleranceRelaxed => 'Relaxed';

  @override
  String get toleranceNormal => 'Normal';

  @override
  String get toleranceStrict => 'Strict';

  @override
  String humMatched(String melody) {
    return 'That matches $melody.';
  }

  @override
  String humMissed(String tolerance) {
    return 'Not close enough for $tolerance. Follow the shape a little more carefully.';
  }

  @override
  String get humTooShort => 'Hum a little longer.';

  @override
  String practiceTarget(String melody, String difficulty, String tolerance) {
    return 'Practice  ·  $melody  ·  $difficulty  ·  $tolerance';
  }

  @override
  String rangeSpan(String low, String high) {
    return '$low to $high';
  }

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get logIn => 'Log in';

  @override
  String get invalidEmail => 'Enter a valid email.';

  @override
  String get shortPassword => 'Use at least 6 characters.';

  @override
  String get passwordMismatch => 'Those passwords do not match.';

  @override
  String get accountExists =>
      'An account with that email already exists. Log in instead.';

  @override
  String get wrongLogin => 'That email or password does not match.';

  @override
  String get genderTitle => 'How should we tune your melodies?';

  @override
  String get genderBody =>
      'This stays on your phone and helps pick a comfortable range.';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get voiceListenBody =>
      'Each note plays, then you hum it back. A checkmark means we heard you. Tap Next for the following note.';

  @override
  String get startVoiceTest => 'Start voice test';

  @override
  String get listening => 'Listening...';

  @override
  String get couldNotHear =>
      'We could not hear a clear note. Try again in a quieter spot.';

  @override
  String get yourVoiceType => 'Your voice type';

  @override
  String get voiceSoprano => 'Soprano';

  @override
  String get voiceAlto => 'Alto';

  @override
  String get voiceTenor => 'Tenor';

  @override
  String get voiceBass => 'Bass';

  @override
  String get permissionsTitle => 'Let the alarm ring';

  @override
  String get permissionsBody =>
      'Hummingbird needs permission to ring when the phone is closed or locked, with exact alarms and a full-screen alert.';

  @override
  String get permissionsAlarm => 'Play with the phone closed';

  @override
  String get permissionsNotification => 'Show the alarm on the lock screen';

  @override
  String get permissionsMicrophone => 'Hear your hum';

  @override
  String get allowAndContinue => 'Allow and continue';

  @override
  String get melodyPlaying => 'Your melody is playing';

  @override
  String get humItBack => 'Hum it back';

  @override
  String choiceIn(int seconds) {
    return 'Snooze and cancel appear in ${seconds}s';
  }

  @override
  String get snooze => 'Snooze';

  @override
  String get cancelAlarm => 'Cancel';

  @override
  String get snoozeLength => 'Snooze length';

  @override
  String snoozeMinutes(int minutes) {
    return '$minutes minutes';
  }

  @override
  String melodyForVoice(String voice) {
    return 'Melodies for $voice';
  }

  @override
  String get logOut => 'Log out';

  @override
  String voiceOnProfile(String gender, String voice) {
    return '$gender · $voice';
  }

  @override
  String get introTitle => 'A quick question';

  @override
  String get introBody =>
      'Answer one short question so your alarms use melodies that fit your voice.';

  @override
  String get hourSystem => 'Hour system';

  @override
  String get hour24 => '24-hour';

  @override
  String get hour12 => 'AM/PM';

  @override
  String get alarmName => 'Alarm name';

  @override
  String get alarmNameHint => 'Morning';

  @override
  String get micPermissionTitle => 'Microphone';

  @override
  String get micPermissionBody =>
      'Hummingbird uses the microphone for a short voice test, and later to hear you hum the alarm melody.';

  @override
  String get allowMicrophone => 'Allow microphone';

  @override
  String get editDetails => 'Edit';

  @override
  String get alarmOn => 'Alarm on';

  @override
  String get alarmOff => 'Alarm off';

  @override
  String get findYourVoice => 'Find your voice';

  @override
  String get humTheNote => 'Hum the note you hear.';

  @override
  String get yourVoiceProfile => 'Your voice profile';

  @override
  String comfortableRange(String low, String high) {
    return 'Comfortable range: $low–$high';
  }

  @override
  String get adaptedToRange => 'Your melodies will be adapted to this range.';

  @override
  String get retakeVoiceTest => 'Retake Voice Test';

  @override
  String voiceTypeLine(String voice) {
    return 'Voice type: $voice';
  }

  @override
  String genderLine(String gender) {
    return 'Gender: $gender';
  }

  @override
  String lastTested(String date) {
    return 'Last tested: $date';
  }

  @override
  String get voiceProfile => 'Voice profile';

  @override
  String get voiceTestNeeded =>
      'Take the voice test so melodies stay in a comfortable range.';

  @override
  String get shakeToStop =>
      'Having trouble waking up? Shake the phone for 4 seconds.';

  @override
  String get holdToStop => 'Press and hold for 4 seconds';

  @override
  String get whatsYourName => 'What\'s your name?';

  @override
  String get nameHint => 'Your name';

  @override
  String get changeScene => 'Change picture';

  @override
  String get shakeOnboardTitle => 'Another way to stop';

  @override
  String get shakeOnboardBody =>
      'You can always stop an alarm by shaking the phone for 4 seconds straight. Humming still works too.';

  @override
  String get shakeAlways => 'Or shake the phone for 4 seconds';

  @override
  String get easierMelody => 'Trying a shorter melody.';

  @override
  String get vibrateWithAlarm => 'Vibrate when the alarm rings';

  @override
  String get tryAgain => 'Try again';
}
