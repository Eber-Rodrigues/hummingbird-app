import 'dart:math' as math;

enum HummingOutcome { matched, tooShort, missed }

class HummingMatch {
  const HummingMatch({required this.outcome, required this.score});

  final HummingOutcome outcome;
  final double score;
}

class VoiceRange {
  const VoiceRange({
    required this.lowMidi,
    required this.highMidi,
    required this.difficulty,
  });

  final int lowMidi;
  final int highMidi;
  final String difficulty;

  String get lowName => midiName(lowMidi);
  String get highName => midiName(highMidi);
}

/// Relative pitch of each melody, in semitones from the first note.
const melodyContours = <String, List<double>>{
  'morning_light': [0, 2, 4, 5, 7],
  'ocean_breeze': [0, 2, 0, -2, 0],
  'sunrise': [0, 4, 7, 11, 12],
};

const double contourFloor = -2;
const double contourCeil = 12;

const melodyPlayLength = Duration(seconds: 2);
const humGapExtra = Duration(seconds: 3);
const humListenLength = Duration(seconds: 5);

const voiceCategories = ['soprano', 'alto', 'tenor', 'bass'];

double hzToMidi(double hz) {
  return 69 + 12 * (math.log(hz / 440) / math.ln2);
}

List<double> contourFor(String melodyId) {
  return melodyContours[melodyId] ?? melodyContours['morning_light']!;
}

int noteCountFor(String difficulty) {
  return switch (difficulty) {
    'Easy' => 3,
    'Hard' => 5,
    _ => 4,
  };
}

double toleranceSemitones(String tolerance) {
  return switch (tolerance) {
    'Relaxed' => 2,
    'Strict' => 0.45,
    _ => 1,
  };
}

class MelodyHummingModule {
  const MelodyHummingModule();

  HummingMatch evaluate({
    required String melodyId,
    required String difficulty,
    required String tolerance,
    required List<double> semitones,
    List<double>? shape,
  }) {
    if (semitones.length < 6) {
      return const HummingMatch(outcome: HummingOutcome.tooShort, score: 0);
    }
    final count = shape?.length ?? noteCountFor(difficulty);
    final target = _relative((shape ?? contourFor(melodyId)).take(count).toList());
    final hummed = _relative(_resample(semitones, count));
    if (difficulty == 'Hard') {
      final targetSpan = _span(target);
      final hummedSpan = _span(hummed);
      if (targetSpan > 0 && hummedSpan < targetSpan * 0.65) {
        return const HummingMatch(outcome: HummingOutcome.missed, score: 0);
      }
    }
    var error = 0.0;
    for (var i = 0; i < count; i++) {
      error += (hummed[i] - target[i]).abs();
    }
    error /= count;
    final limit = toleranceSemitones(tolerance);
    final score = (1 - (error / limit)).clamp(0.0, 1.0);
    if (error <= limit) {
      return HummingMatch(outcome: HummingOutcome.matched, score: score);
    }
    return HummingMatch(outcome: HummingOutcome.missed, score: score);
  }

  VoiceRange measure(List<double> semitones) {
    if (semitones.isEmpty) {
      return const VoiceRange(lowMidi: 60, highMidi: 60, difficulty: 'Easy');
    }
    final low = semitones.reduce(math.min);
    final high = semitones.reduce(math.max);
    final span = high - low;
    final difficulty = span < 4
        ? 'Easy'
        : span < 8
            ? 'Medium'
            : 'Hard';
    return VoiceRange(
      lowMidi: low.round(),
      highMidi: high.round(),
      difficulty: difficulty,
    );
  }
}

List<double> _relative(List<double> notes) {
  if (notes.isEmpty) return notes;
  final origin = notes.first;
  return [for (final note in notes) note - origin];
}

double _span(List<double> notes) {
  if (notes.isEmpty) return 0;
  return notes.reduce(math.max) - notes.reduce(math.min);
}

List<double> _resample(List<double> samples, int count) {
  if (count <= 1) return [samples.first];
  final out = <double>[];
  for (var i = 0; i < count; i++) {
    final position = i / (count - 1) * (samples.length - 1);
    final lower = position.floor();
    final upper = math.min(lower + 1, samples.length - 1);
    final fraction = position - lower;
    out.add(samples[lower] * (1 - fraction) + samples[upper] * fraction);
  }
  return out;
}

String midiName(int midi) {
  const names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  final index = midi % 12;
  final name = names[index < 0 ? index + 12 : index];
  final octave = (midi / 12).floor() - 1;
  return '$name$octave';
}

double intervalToY(double interval, double height) {
  final t = ((interval - contourFloor) / (contourCeil - contourFloor)).clamp(0.0, 1.0);
  return (1 - t) * height;
}

double yToMidi(double y, double height) {
  if (height <= 0) return 60;
  final t = (1 - (y / height)).clamp(0.0, 1.0);
  return 60 + t * (contourCeil - contourFloor);
}
