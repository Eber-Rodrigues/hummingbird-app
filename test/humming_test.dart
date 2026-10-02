import 'package:flutter_test/flutter_test.dart';
import 'package:hummingbird/src/humming.dart';
import 'package:hummingbird/src/voice_profile.dart';

void main() {
  const module = MelodyHummingModule();

  List<double> trace(List<double> notes) {
    final samples = <double>[];
    for (var i = 0; i < notes.length - 1; i++) {
      for (var step = 0; step < 8; step++) {
        final t = step / 8;
        samples.add(60 + notes[i] + (notes[i + 1] - notes[i]) * t);
      }
    }
    samples.add(60 + notes.last);
    return samples;
  }

  test('an exact melody matches even on strict', () {
    final match = module.evaluate(
      melodyId: 'morning_light',
      difficulty: 'Hard',
      tolerance: 'Strict',
      semitones: trace(contourFor('morning_light')),
    );
    expect(match.outcome, HummingOutcome.matched);
  });

  test('a flat hum misses a rising melody', () {
    final match = module.evaluate(
      melodyId: 'morning_light',
      difficulty: 'Medium',
      tolerance: 'Relaxed',
      semitones: List<double>.filled(12, 60),
    );
    expect(match.outcome, HummingOutcome.missed);
  });

  test('a short trace is rejected', () {
    final match = module.evaluate(
      melodyId: 'sunrise',
      difficulty: 'Easy',
      tolerance: 'Relaxed',
      semitones: const [60, 62, 64],
    );
    expect(match.outcome, HummingOutcome.tooShort);
  });

  test('easy accepts the opening of the melody and hard asks for the full span', () {
    final opening = trace(contourFor('sunrise').take(3).toList());
    final easy = module.evaluate(
      melodyId: 'sunrise',
      difficulty: 'Easy',
      tolerance: 'Normal',
      semitones: opening,
    );
    final hard = module.evaluate(
      melodyId: 'sunrise',
      difficulty: 'Hard',
      tolerance: 'Relaxed',
      semitones: opening,
    );
    expect(easy.outcome, HummingOutcome.matched);
    expect(hard.outcome, HummingOutcome.missed);
  });

  test('a wide hum recommends a harder difficulty', () {
    final narrow = module.measure(const [60, 61, 62, 61]);
    final wide = module.measure(const [58, 62, 70, 74]);
    expect(narrow.difficulty, 'Easy');
    expect(wide.difficulty, 'Hard');
    expect(wide.lowName, 'A#3');
    expect(wide.highName, 'D5');
  });

  test('measured range classifies a voice and transposes the melody', () {
    expect(categoryForRange(72, 80), 'soprano');
    expect(categoryForRange(41, 52), 'bass');
    final maleMid = profileFromAttempts(
      gender: 'male',
      attempts: {60: midiToHz(60), 64: midiToHz(64)},
    );
    expect(maleMid.gender, 'male');
    expect(maleMid.category, isNot('bass'));
    final bass = VoiceProfile.fromCategory(gender: 'male', category: 'bass');
    final soprano = VoiceProfile.fromCategory(gender: 'female', category: 'soprano');
    final contour = contourFor('morning_light');
    final lowMelody = fitMelody(
      contour: contour,
      noteCount: 5,
      safeMin: bass.safeMin,
      safeMax: bass.safeMax,
    );
    final highMelody = fitMelody(
      contour: contour,
      noteCount: 5,
      safeMin: soprano.safeMin,
      safeMax: soprano.safeMax,
    );
    expect(lowMelody.first, lessThan(highMelody.first));
    for (final note in lowMelody) {
      expect(note, inInclusiveRange(bass.safeMin, bass.safeMax));
    }
    for (final note in highMelody) {
      expect(note, inInclusiveRange(soprano.safeMin, soprano.safeMax));
    }
    final narrow = fitMelody(contour: contourFor('sunrise'), noteCount: 5, safeMin: 62, safeMax: 62);
    expect(narrow.length, lessThanOrEqualTo(3));
    expect(narrow.every((note) => note == 62), isTrue);
  });
}
