import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

import 'runtime.dart';
import 'voice_profile.dart';

class MelodyPlayer {
  AudioPlayer? _player;

  Future<void> play() async {
    await playNotes(const [60, 62, 64, 65, 67]);
  }

  Future<void> playNotes(List<int> midiNotes, {bool alarm = false}) async {
    if (isWidgetTest || midiNotes.isEmpty) return;
    final player = _player ??= AudioPlayer();
    await player.setVolume(1);
    if (alarm) await _useAlarmStream(player);
    await player.stop();
    await player.play(BytesSource(melodyWav(midiNotes, gain: alarm ? 0.94 : 0.7)));
  }

  Future<void> playMidi(int midi) async {
    await playNotes([midi]);
  }

  Future<void> _useAlarmStream(AudioPlayer player) async {
    await player.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.alarm,
          audioFocus: AndroidAudioFocus.gain,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: const {AVAudioSessionOptions.defaultToSpeaker},
        ),
      ),
    );
  }

  Future<void> stop() async {
    if (isWidgetTest) return;
    await _player?.stop();
  }

  Future<void> dispose() async {
    if (isWidgetTest) return;
    await _player?.dispose();
    _player = null;
  }
}

Uint8List melodyWav(List<int> midiNotes, {int sampleRate = 22050, int noteMs = 400, double gain = 0.94}) {
  final samples = <int>[];
  final attackSamples = (sampleRate * 0.02).round();
  final releaseSamples = (sampleRate * 0.04).round();
  for (final midi in midiNotes) {
    final hz = midiToHz(midi);
    final count = (sampleRate * noteMs / 1000).round();
    for (var i = 0; i < count; i++) {
      final attack = i < attackSamples ? i / attackSamples : 1.0;
      final release = i > count - releaseSamples ? (count - i) / releaseSamples : 1.0;
      final envelope = math.min(attack, release);
      final sample = math.sin(2 * math.pi * hz * i / sampleRate) * envelope * gain;
      samples.add((sample * 32767).round().clamp(-32767, 32767));
    }
  }
  final data = ByteData(44 + samples.length * 2);
  void writeString(int offset, String value) {
    for (var i = 0; i < value.length; i++) {
      data.setUint8(offset + i, value.codeUnitAt(i));
    }
  }

  writeString(0, 'RIFF');
  data.setUint32(4, 36 + samples.length * 2, Endian.little);
  writeString(8, 'WAVE');
  writeString(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 1, Endian.little);
  data.setUint32(24, sampleRate, Endian.little);
  data.setUint32(28, sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  writeString(36, 'data');
  data.setUint32(40, samples.length * 2, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    data.setInt16(44 + i * 2, samples[i], Endian.little);
  }
  return data.buffer.asUint8List();
}
