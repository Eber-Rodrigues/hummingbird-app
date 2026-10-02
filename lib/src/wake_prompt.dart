import 'package:flutter_tts/flutter_tts.dart';

import 'runtime.dart';

class WakePrompt {
  Future<void> speak(String languageCode) async {
    if (isWidgetTest) return;
    try {
      final tts = FlutterTts();
      final language = switch (languageCode) {
        'pt' => 'pt-BR',
        'es' => 'es-ES',
        _ => 'en-US',
      };
      final line = switch (languageCode) {
        'pt' => 'Está com dificuldade para acordar?',
        'es' => '¿Te está costando despertar?',
        _ => 'Having trouble waking up?',
      };
      await tts.setLanguage(language);
      await tts.setSpeechRate(0.45);
      await tts.speak(line);
    } catch (_) {}
  }
}
