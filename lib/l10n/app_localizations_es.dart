// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Hummingbird';

  @override
  String get wakeUpMelody => 'Despierta con tu propia melodía';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get alreadyHaveAccount => 'Ya tengo una cuenta';

  @override
  String get voiceRangeTitle => 'Tu tesitura';

  @override
  String get testYourVoice => 'Probemos tu voz';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String voiceTestStep(int current, int total) {
    return 'Prueba de voz  $current/$total';
  }

  @override
  String get voiceRangeBody =>
      'Mantén pulsada el área y traza una melodía. La tesitura sugiere una dificultad para las próximas alarmas.';

  @override
  String get voiceTestBody =>
      'Mantén pulsada el área y sigue la forma. Un tarareo parecido puede parar la alarma.';

  @override
  String get detectedRange => 'Tesitura detectada';

  @override
  String get rangePending => 'Tararea en el área para medir tu tesitura';

  @override
  String recommendedDifficulty(String difficulty) {
    return 'Dificultad recomendada  ·  $difficulty';
  }

  @override
  String get continueAction => 'Continuar';

  @override
  String get next => 'Siguiente';

  @override
  String get myAlarms => 'Mis alarmas';

  @override
  String get createAlarm => 'Crear alarma';

  @override
  String get noAlarms => 'Todavía no hay alarmas.';

  @override
  String get testRing => 'Probar tono';

  @override
  String get editAlarmTitle => 'Editar alarma';

  @override
  String get repeat => 'Repetir';

  @override
  String get ringsOnce => 'Suena una vez y se apaga.';

  @override
  String get repeatsOnDays => 'Se repite en los días elegidos.';

  @override
  String get melody => 'Melodía';

  @override
  String get difficulty => 'Dificultad';

  @override
  String get tolerance => 'Tolerancia';

  @override
  String get hummingSavedHint =>
      'La dificultad define cuánto de la melodía tienes que tararear. La tolerancia define lo cerca que debe estar el tono. Tras varios fallos la melodía se acorta y, al final, sacudir el teléfono detiene la alarma.';

  @override
  String get saveAlarm => 'Guardar alarma';

  @override
  String get deleteAlarm => 'Eliminar alarma';

  @override
  String get navAlarms => 'Alarmas';

  @override
  String get navVoice => 'Voz';

  @override
  String get navProfile => 'Perfil';

  @override
  String get voiceHeadline => 'Encuentra tu voz';

  @override
  String get voiceBody =>
      'Tararea las notas que oigas. Hummingbird guarda la zona cómoda y la usa en cada melodía.';

  @override
  String get holdToHum => 'Mantén y traza';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get saveName => 'Guardar nombre';

  @override
  String get settings => 'Ajustes';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageSpanish => 'Español';

  @override
  String get savedOnDevice =>
      'Tu tipo de voz y tus alarmas se quedan en este teléfono.';

  @override
  String get wakeWithMelody => 'Despierta con tu melodía';

  @override
  String get stop => 'Parar';

  @override
  String get humToStop => 'O tararea la forma encima del botón.';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get melodyMorning => 'Luz de la mañana';

  @override
  String get melodyMorningDetail => 'Suave y clara';

  @override
  String get melodyOcean => 'Brisa del mar';

  @override
  String get melodyOceanDetail => 'Ligera y ondulante';

  @override
  String get melodySunrise => 'Amanecer';

  @override
  String get melodySunriseDetail => 'Clara y firme';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Media';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get toleranceRelaxed => 'Relajada';

  @override
  String get toleranceNormal => 'Normal';

  @override
  String get toleranceStrict => 'Estricta';

  @override
  String humMatched(String melody) {
    return 'Coincide con $melody.';
  }

  @override
  String humMissed(String tolerance) {
    return 'No está lo bastante cerca para $tolerance. Sigue la forma con más cuidado.';
  }

  @override
  String get humTooShort => 'Tararea un poco más.';

  @override
  String practiceTarget(String melody, String difficulty, String tolerance) {
    return 'Practicar  ·  $melody  ·  $difficulty  ·  $tolerance';
  }

  @override
  String rangeSpan(String low, String high) {
    return '$low a $high';
  }

  @override
  String get email => 'Correo';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get logIn => 'Entrar';

  @override
  String get invalidEmail => 'Escribe un correo válido.';

  @override
  String get shortPassword => 'Usa al menos 6 caracteres.';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get accountExists =>
      'Ya existe una cuenta con ese correo. Entra en su lugar.';

  @override
  String get wrongLogin => 'Ese correo o contraseña no coincide.';

  @override
  String get genderTitle => '¿Cómo afinamos tus melodías?';

  @override
  String get genderBody =>
      'Esto se queda en tu teléfono y ayuda a elegir un registro cómodo.';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Femenino';

  @override
  String get voiceListenBody =>
      'Suena cada nota y la tarareas. Una marca significa que te oímos. Pulsa Siguiente para la nota que sigue.';

  @override
  String get startVoiceTest => 'Empezar prueba de voz';

  @override
  String get listening => 'Escuchando...';

  @override
  String get couldNotHear =>
      'No oímos una nota clara. Inténtalo de nuevo en un lugar más silencioso.';

  @override
  String get yourVoiceType => 'Tu tipo de voz';

  @override
  String get voiceSoprano => 'Soprano';

  @override
  String get voiceAlto => 'Contralto';

  @override
  String get voiceTenor => 'Tenor';

  @override
  String get voiceBass => 'Bajo';

  @override
  String get permissionsTitle => 'Deja que suene la alarma';

  @override
  String get permissionsBody =>
      'Hummingbird necesita permiso para sonar con el teléfono cerrado o bloqueado, con alarmas exactas y una alerta a pantalla completa.';

  @override
  String get permissionsAlarm => 'Sonar con el teléfono cerrado';

  @override
  String get permissionsNotification =>
      'Mostrar la alarma en la pantalla de bloqueo';

  @override
  String get permissionsMicrophone => 'Oír tu tarareo';

  @override
  String get allowAndContinue => 'Permitir y continuar';

  @override
  String get melodyPlaying => 'Tu melodía está sonando';

  @override
  String get humItBack => 'Tararéala de vuelta';

  @override
  String choiceIn(int seconds) {
    return 'Posponer y cancelar aparecen en ${seconds}s';
  }

  @override
  String get snooze => 'Posponer';

  @override
  String get cancelAlarm => 'Cancelar';

  @override
  String get snoozeLength => 'Duración de la posposición';

  @override
  String snoozeMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String melodyForVoice(String voice) {
    return 'Melodías para $voice';
  }

  @override
  String get logOut => 'Salir';

  @override
  String voiceOnProfile(String gender, String voice) {
    return '$gender · $voice';
  }

  @override
  String get introTitle => 'Una pregunta rápida';

  @override
  String get introBody =>
      'Responde una pregunta corta para que las alarmas usen melodías que encajen con tu voz.';

  @override
  String get hourSystem => 'Sistema de horas';

  @override
  String get hour24 => '24 horas';

  @override
  String get hour12 => 'AM/PM';

  @override
  String get alarmName => 'Nombre de la alarma';

  @override
  String get alarmNameHint => 'Mañana';

  @override
  String get micPermissionTitle => 'Micrófono';

  @override
  String get micPermissionBody =>
      'Hummingbird usa el micrófono para una prueba corta de voz y, después, para oír cómo tarareas la melodía de la alarma.';

  @override
  String get allowMicrophone => 'Permitir micrófono';

  @override
  String get editDetails => 'Editar';

  @override
  String get alarmOn => 'Alarma activada';

  @override
  String get alarmOff => 'Alarma desactivada';

  @override
  String get findYourVoice => 'Encuentra tu voz';

  @override
  String get humTheNote => 'Tararea la nota que oigas.';

  @override
  String get yourVoiceProfile => 'Tu perfil de voz';

  @override
  String comfortableRange(String low, String high) {
    return 'Rango cómodo: $low–$high';
  }

  @override
  String get adaptedToRange => 'Tus melodías se adaptarán a este rango.';

  @override
  String get retakeVoiceTest => 'Repetir la prueba de voz';

  @override
  String voiceTypeLine(String voice) {
    return 'Tipo de voz: $voice';
  }

  @override
  String genderLine(String gender) {
    return 'Género: $gender';
  }

  @override
  String lastTested(String date) {
    return 'Última prueba: $date';
  }

  @override
  String get voiceProfile => 'Perfil de voz';

  @override
  String get voiceTestNeeded =>
      'Haz la prueba de voz para que las melodías queden en un rango cómodo.';

  @override
  String get shakeToStop =>
      '¿Te está costando despertar? Agita el teléfono durante 4 segundos.';

  @override
  String get holdToStop => 'Mantén pulsado durante 4 segundos';

  @override
  String get whatsYourName => '¿Cómo te llamas?';

  @override
  String get nameHint => 'Tu nombre';

  @override
  String get changeScene => 'Cambiar imagen';

  @override
  String get shakeOnboardTitle => 'Otra forma de parar';

  @override
  String get shakeOnboardBody =>
      'Siempre puedes parar una alarma agitando el teléfono durante 4 segundos seguidos. Tararear también funciona.';

  @override
  String get shakeAlways => 'O agita el teléfono durante 4 segundos';

  @override
  String get easierMelody => 'Probando una melodía más corta.';

  @override
  String get vibrateWithAlarm => 'Vibrar cuando suene la alarma';

  @override
  String get tryAgain => 'Intentar de nuevo';
}
