import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:record/record.dart';

import 'runtime.dart';

class PitchCapture {
  Future<double?> comfortablePitch({
    Duration maxDuration = const Duration(seconds: 4),
    int stopAfter = 0,
  }) async {
    if (isWidgetTest) return 523.25;
    final samples = await _collectHz(maxDuration, stopAfter: stopAfter);
    return _median(samples);
  }

  Future<List<double>> listenContour({Duration maxDuration = const Duration(seconds: 5)}) async {
    if (isWidgetTest) return List<double>.filled(12, 60);
    final samples = await _collectHz(maxDuration);
    return [for (final hz in samples) 69 + 12 * (math.log(hz / 440) / math.ln2)];
  }

  Future<List<double>> _collectHz(Duration maxDuration, {int stopAfter = 0}) async {
    final recorder = AudioRecorder();
    final found = <double>[];
    StreamSubscription<Uint8List>? subscription;
    final done = Completer<void>();
    final timer = Timer(maxDuration, () {
      if (!done.isCompleted) done.complete();
    });
    try {
      if (!await recorder.hasPermission()) {
        if (stopAfter == 0) await done.future;
        return found;
      }
      final stream = await recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );
      final buffer = <double>[];
      subscription = stream.listen((chunk) {
        buffer.addAll(_pcm16(chunk));
        while (buffer.length >= 2048) {
          final window = buffer.sublist(0, 2048);
          buffer.removeRange(0, 1024);
          final hz = _fundamentalHz(window, 16000);
          if (hz != null) found.add(hz);
        }
        if (stopAfter > 0 && found.length >= stopAfter && !done.isCompleted) {
          done.complete();
        }
      });
      await done.future;
    } catch (_) {
      if (stopAfter == 0 && !done.isCompleted) await done.future;
      return found;
    } finally {
      timer.cancel();
      await subscription?.cancel();
      if (await recorder.isRecording()) {
        await recorder.stop();
      }
      await recorder.dispose();
    }
    return found;
  }
}

List<double> _pcm16(Uint8List chunk) {
  final samples = <double>[];
  for (var i = 0; i + 1 < chunk.length; i += 2) {
    final value = chunk[i] | (chunk[i + 1] << 8);
    final signed = value > 32767 ? value - 65536 : value;
    samples.add(signed / 32768);
  }
  return samples;
}

double? _fundamentalHz(List<double> samples, int sampleRate) {
  var energy = 0.0;
  for (final sample in samples) {
    energy += sample * sample;
  }
  if (energy / samples.length < 0.0004) return null;
  const minHz = 75.0;
  const maxHz = 1000.0;
  final minLag = (sampleRate / maxHz).floor();
  final maxLag = math.min((sampleRate / minHz).floor(), samples.length - 1);
  var bestLag = -1;
  var best = double.negativeInfinity;
  for (var lag = minLag; lag <= maxLag; lag++) {
    var sum = 0.0;
    final limit = samples.length - lag;
    for (var i = 0; i < limit; i += 2) {
      sum += samples[i] * samples[i + lag];
    }
    if (sum > best) {
      best = sum;
      bestLag = lag;
    }
  }
  if (bestLag < 0) return null;
  return sampleRate / bestLag;
}

double? _median(List<double> values) {
  if (values.isEmpty) return null;
  final sorted = [...values]..sort();
  return sorted[sorted.length ~/ 2];
}
