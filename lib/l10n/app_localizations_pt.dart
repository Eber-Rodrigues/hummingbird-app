// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Hummingbird';

  @override
  String get wakeUpMelody => 'Acorde com a sua melodia';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get alreadyHaveAccount => 'Já tenho uma conta';

  @override
  String get voiceRangeTitle => 'Sua extensão vocal';

  @override
  String get testYourVoice => 'Vamos testar sua voz';

  @override
  String get skipForNow => 'Pular por agora';

  @override
  String voiceTestStep(int current, int total) {
    return 'Teste de voz  $current/$total';
  }

  @override
  String get voiceRangeBody =>
      'Segure a área e trace uma melodia. A extensão sugere uma dificuldade para os próximos alarmes.';

  @override
  String get voiceTestBody =>
      'Segure a área e siga o desenho. Um cantarolar parecido pode parar o alarme.';

  @override
  String get detectedRange => 'Extensão detectada';

  @override
  String get rangePending => 'Cantarole na área para medir sua extensão';

  @override
  String recommendedDifficulty(String difficulty) {
    return 'Dificuldade recomendada  ·  $difficulty';
  }

  @override
  String get continueAction => 'Continuar';

  @override
  String get next => 'Avançar';

  @override
  String get myAlarms => 'Meus alarmes';

  @override
  String get createAlarm => 'Criar alarme';

  @override
  String get noAlarms => 'Nenhum alarme ainda.';

  @override
  String get testRing => 'Testar toque';

  @override
  String get editAlarmTitle => 'Editar alarme';

  @override
  String get repeat => 'Repetir';

  @override
  String get ringsOnce => 'Toca uma vez e desliga.';

  @override
  String get repeatsOnDays => 'Repete nos dias escolhidos.';

  @override
  String get melody => 'Melodia';

  @override
  String get difficulty => 'Dificuldade';

  @override
  String get tolerance => 'Tolerância';

  @override
  String get hummingSavedHint =>
      'A dificuldade define quanto da melodia você precisa cantarolar. A tolerância define o quanto o tom precisa chegar perto. Depois de vários erros a melodia fica mais curta e, no fim, sacudir o telefone para o alarme.';

  @override
  String get saveAlarm => 'Salvar alarme';

  @override
  String get deleteAlarm => 'Apagar alarme';

  @override
  String get navAlarms => 'Alarmes';

  @override
  String get navVoice => 'Voz';

  @override
  String get navProfile => 'Perfil';

  @override
  String get voiceHeadline => 'Encontre a sua voz';

  @override
  String get voiceBody =>
      'Cantarole as notas que ouvir. O Hummingbird guarda a região confortável e usa isso em cada melodia.';

  @override
  String get holdToHum => 'Segure e trace';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get nameLabel => 'Nome';

  @override
  String get saveName => 'Salvar nome';

  @override
  String get settings => 'Configurações';

  @override
  String get darkMode => 'Modo escuro';

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
      'Seu tipo de voz e seus alarmes ficam neste telefone.';

  @override
  String get wakeWithMelody => 'Acorde com a sua melodia';

  @override
  String get stop => 'Parar';

  @override
  String get humToStop => 'Ou cantarole a forma acima do botão.';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get melodyMorning => 'Luz da manhã';

  @override
  String get melodyMorningDetail => 'Suave e clara';

  @override
  String get melodyOcean => 'Brisa do mar';

  @override
  String get melodyOceanDetail => 'Leve e ondulante';

  @override
  String get melodySunrise => 'Nascer do sol';

  @override
  String get melodySunriseDetail => 'Clara e firme';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyMedium => 'Médio';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get toleranceRelaxed => 'Relaxada';

  @override
  String get toleranceNormal => 'Normal';

  @override
  String get toleranceStrict => 'Rigorosa';

  @override
  String humMatched(String melody) {
    return 'Combina com $melody.';
  }

  @override
  String humMissed(String tolerance) {
    return 'Não chegou perto o bastante para $tolerance. Siga a forma com mais cuidado.';
  }

  @override
  String get humTooShort => 'Cantarole um pouco mais.';

  @override
  String practiceTarget(String melody, String difficulty, String tolerance) {
    return 'Praticar  ·  $melody  ·  $difficulty  ·  $tolerance';
  }

  @override
  String rangeSpan(String low, String high) {
    return '$low a $high';
  }

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get confirmPassword => 'Confirmar senha';

  @override
  String get logIn => 'Entrar';

  @override
  String get invalidEmail => 'Digite um e-mail válido.';

  @override
  String get shortPassword => 'Use pelo menos 6 caracteres.';

  @override
  String get passwordMismatch => 'As senhas não coincidem.';

  @override
  String get accountExists =>
      'Já existe uma conta com esse e-mail. Entre em vez disso.';

  @override
  String get wrongLogin => 'Esse e-mail ou senha não confere.';

  @override
  String get genderTitle => 'Como afinamos suas melodias?';

  @override
  String get genderBody =>
      'Isso fica no seu telefone e ajuda a escolher uma extensão confortável.';

  @override
  String get male => 'Masculino';

  @override
  String get female => 'Feminino';

  @override
  String get voiceListenBody =>
      'Cada nota toca e você cantarola de volta. Um visto significa que ouvimos. Toque em Avançar para a nota seguinte.';

  @override
  String get startVoiceTest => 'Começar teste de voz';

  @override
  String get listening => 'Ouvindo...';

  @override
  String get couldNotHear =>
      'Não ouvimos uma nota clara. Tente de novo em um lugar mais silencioso.';

  @override
  String get yourVoiceType => 'Seu tipo de voz';

  @override
  String get voiceSoprano => 'Soprano';

  @override
  String get voiceAlto => 'Contralto';

  @override
  String get voiceTenor => 'Tenor';

  @override
  String get voiceBass => 'Baixo';

  @override
  String get permissionsTitle => 'Deixe o alarme tocar';

  @override
  String get permissionsBody =>
      'O Hummingbird precisa de permissão para tocar com o telefone fechado ou bloqueado, com alarmes exatos e um alerta em tela cheia.';

  @override
  String get permissionsAlarm => 'Tocar com o telefone fechado';

  @override
  String get permissionsNotification => 'Mostrar o alarme na tela de bloqueio';

  @override
  String get permissionsMicrophone => 'Ouvir seu cantarolar';

  @override
  String get allowAndContinue => 'Permitir e continuar';

  @override
  String get melodyPlaying => 'Sua melodia está tocando';

  @override
  String get humItBack => 'Cantarole de volta';

  @override
  String choiceIn(int seconds) {
    return 'Soneca e cancelar aparecem em ${seconds}s';
  }

  @override
  String get snooze => 'Soneca';

  @override
  String get cancelAlarm => 'Cancelar';

  @override
  String get snoozeLength => 'Duração da soneca';

  @override
  String snoozeMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String melodyForVoice(String voice) {
    return 'Melodias para $voice';
  }

  @override
  String get logOut => 'Sair';

  @override
  String voiceOnProfile(String gender, String voice) {
    return '$gender · $voice';
  }

  @override
  String get introTitle => 'Uma pergunta rápida';

  @override
  String get introBody =>
      'Responda uma pergunta curta para os alarmes usarem melodias que cabem na sua voz.';

  @override
  String get hourSystem => 'Sistema de horas';

  @override
  String get hour24 => '24 horas';

  @override
  String get hour12 => 'AM/PM';

  @override
  String get alarmName => 'Nome do alarme';

  @override
  String get alarmNameHint => 'Manhã';

  @override
  String get micPermissionTitle => 'Microfone';

  @override
  String get micPermissionBody =>
      'O Hummingbird usa o microfone para um teste curto de voz e, depois, para ouvir você cantarolar a melodia do alarme.';

  @override
  String get allowMicrophone => 'Permitir microfone';

  @override
  String get editDetails => 'Editar';

  @override
  String get alarmOn => 'Alarme ligado';

  @override
  String get alarmOff => 'Alarme desligado';

  @override
  String get findYourVoice => 'Encontre a sua voz';

  @override
  String get humTheNote => 'Cantarole a nota que ouvir.';

  @override
  String get yourVoiceProfile => 'O seu perfil de voz';

  @override
  String comfortableRange(String low, String high) {
    return 'Região confortável: $low–$high';
  }

  @override
  String get adaptedToRange =>
      'As suas melodias serão adaptadas a esta região.';

  @override
  String get retakeVoiceTest => 'Refazer o teste de voz';

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
    return 'Último teste: $date';
  }

  @override
  String get voiceProfile => 'Perfil de voz';

  @override
  String get voiceTestNeeded =>
      'Faça o teste de voz para as melodias ficarem numa região confortável.';

  @override
  String get shakeToStop =>
      'Está com dificuldade para acordar? Sacuda o telefone durante 4 segundos.';

  @override
  String get holdToStop => 'Prima e segure durante 4 segundos';

  @override
  String get whatsYourName => 'Como te chamas?';

  @override
  String get nameHint => 'O teu nome';

  @override
  String get changeScene => 'Mudar imagem';

  @override
  String get shakeOnboardTitle => 'Outra forma de parar';

  @override
  String get shakeOnboardBody =>
      'Podes sempre parar um alarme sacudindo o telefone durante 4 segundos seguidos. Cantarolar também funciona.';

  @override
  String get shakeAlways => 'Ou sacode o telefone durante 4 segundos';

  @override
  String get easierMelody => 'A tentar uma melodia mais curta.';

  @override
  String get vibrateWithAlarm => 'Vibrar quando o alarme tocar';

  @override
  String get tryAgain => 'Tentar de novo';
}
