import 'package:flutter/widgets.dart';
import 'package:hummingbird/l10n/app_localizations.dart';

String melodyTitle(AppLocalizations l10n, String id) {
  return switch (id) {
    'ocean_breeze' => l10n.melodyOcean,
    'sunrise' => l10n.melodySunrise,
    _ => l10n.melodyMorning,
  };
}

String melodyDetail(AppLocalizations l10n, String id) {
  return switch (id) {
    'ocean_breeze' => l10n.melodyOceanDetail,
    'sunrise' => l10n.melodySunriseDetail,
    _ => l10n.melodyMorningDetail,
  };
}

String difficultyLabel(AppLocalizations l10n, String key) {
  return switch (key) {
    'Easy' => l10n.difficultyEasy,
    'Hard' => l10n.difficultyHard,
    _ => l10n.difficultyMedium,
  };
}

String toleranceLabel(AppLocalizations l10n, String key) {
  return switch (key) {
    'Relaxed' => l10n.toleranceRelaxed,
    'Strict' => l10n.toleranceStrict,
    _ => l10n.toleranceNormal,
  };
}

String voiceLabel(AppLocalizations l10n, String category) {
  return switch (category) {
    'alto' => l10n.voiceAlto,
    'tenor' => l10n.voiceTenor,
    'bass' => l10n.voiceBass,
    _ => l10n.voiceSoprano,
  };
}

String genderLabel(AppLocalizations l10n, String gender) {
  return gender == 'male' ? l10n.male : l10n.female;
}

String formatClockLocalized(AppLocalizations l10n, int hour, int minute, {required bool use24Hour}) {
  final minutes = minute.toString().padLeft(2, '0');
  if (use24Hour) return '${hour.toString().padLeft(2, '0')}:$minutes';
  final period = hour >= 12 ? l10n.pm : l10n.am;
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;
  return '$hour12:$minutes $period';
}

List<String> dayLettersFor(Locale locale) {
  return switch (locale.languageCode) {
    'pt' => const ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'],
    'es' => const ['L', 'M', 'X', 'J', 'V', 'S', 'D'],
    _ => const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
  };
}
