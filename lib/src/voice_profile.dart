import 'dart:math' as math;

import 'humming.dart';

const safetyMarginSemitones = 2;

class VoiceRangeRef {
  const VoiceRangeRef(this.low, this.high);

  final int low;
  final int high;

  double get center => (low + high) / 2;
}

const voiceReferenceRanges = <String, VoiceRangeRef>{
  'soprano': VoiceRangeRef(60, 81),
  'alto': VoiceRangeRef(53, 76),
  'tenor': VoiceRangeRef(47, 69),
  'bass': VoiceRangeRef(41, 64),
};

class VoiceProfile {
  const VoiceProfile({
    required this.gender,
    required this.category,
    required this.minMidi,
    required this.maxMidi,
    required this.minHz,
    required this.maxHz,
    required this.centerMidi,
    required this.completed,
    this.testedAt,
  });

  final String gender;
  final String category;
  final int minMidi;
  final int maxMidi;
  final double minHz;
  final double maxHz;
  final int centerMidi;
  final bool completed;
  final DateTime? testedAt;

  int get safeMin {
    final low = minMidi + safetyMarginSemitones;
    final high = safeMax;
    return low > high ? centerMidi : low;
  }

  int get safeMax {
    final high = maxMidi - safetyMarginSemitones;
    return high < minMidi ? maxMidi : high;
  }

  VoiceProfile copyWith({String? gender}) {
    return VoiceProfile(
      gender: gender ?? this.gender,
      category: category,
      minMidi: minMidi,
      maxMidi: maxMidi,
      minHz: minHz,
      maxHz: maxHz,
      centerMidi: centerMidi,
      completed: completed,
      testedAt: testedAt,
    );
  }

  Map<String, Object?> toJson() => {
        'gender': gender,
        'category': category,
        'minMidi': minMidi,
        'maxMidi': maxMidi,
        'minHz': minHz,
        'maxHz': maxHz,
        'centerMidi': centerMidi,
        'completed': completed,
        'testedAt': testedAt?.toIso8601String(),
      };

  factory VoiceProfile.fromJson(Map<String, Object?> json) {
    return VoiceProfile(
      gender: json['gender'] as String? ?? 'female',
      category: json['category'] as String? ?? 'alto',
      minMidi: json['minMidi'] as int? ?? 55,
      maxMidi: json['maxMidi'] as int? ?? 67,
      minHz: (json['minHz'] as num?)?.toDouble() ?? midiToHz(55),
      maxHz: (json['maxHz'] as num?)?.toDouble() ?? midiToHz(67),
      centerMidi: json['centerMidi'] as int? ?? 61,
      completed: json['completed'] as bool? ?? false,
      testedAt: DateTime.tryParse(json['testedAt'] as String? ?? ''),
    );
  }

  factory VoiceProfile.fromCategory({required String gender, required String category}) {
    final ref = voiceReferenceRanges[category] ?? voiceReferenceRanges['alto']!;
    return VoiceProfile(
      gender: gender,
      category: category,
      minMidi: ref.low,
      maxMidi: ref.high,
      minHz: midiToHz(ref.low),
      maxHz: midiToHz(ref.high),
      centerMidi: ref.center.round(),
      completed: true,
    );
  }

  factory VoiceProfile.conservative(String gender) {
    return VoiceProfile(
      gender: gender,
      category: 'alto',
      minMidi: 55,
      maxMidi: 67,
      minHz: midiToHz(55),
      maxHz: midiToHz(67),
      centerMidi: 61,
      completed: false,
    );
  }
}

double midiToHz(int midi) => 440 * math.pow(2, (midi - 69) / 12).toDouble();

List<int> testPitchesFor(String gender) {
  if (gender == 'male') return const [45, 48, 52, 55, 60, 64];
  return const [53, 57, 60, 64, 67, 72];
}

bool pitchMatches(double heardHz, int targetMidi, {double tolerance = 1.5}) {
  return (hzToMidi(heardHz) - targetMidi).abs() <= tolerance;
}

String categoryForRange(int minMidi, int maxMidi) {
  final center = (minMidi + maxMidi) / 2;
  var best = 'alto';
  var bestScore = -double.infinity;
  for (final entry in voiceReferenceRanges.entries) {
    final low = entry.value.low.toDouble();
    final high = entry.value.high.toDouble();
    final overlap = math.max(0, math.min(maxMidi.toDouble(), high) - math.max(minMidi.toDouble(), low));
    final score = overlap * 2 - (center - entry.value.center).abs();
    if (score > bestScore) {
      bestScore = score;
      best = entry.key;
    }
  }
  return best;
}

VoiceProfile profileFromAttempts({
  required String gender,
  required Map<int, double?> attempts,
}) {
  final matched = <int>[];
  final heard = <double>[];
  for (final entry in attempts.entries) {
    final hz = entry.value;
    if (hz == null) continue;
    heard.add(hz);
    if (pitchMatches(hz, entry.key)) matched.add(entry.key);
  }
  late int minMidi;
  late int maxMidi;
  if (matched.length >= 2) {
    minMidi = matched.reduce(math.min);
    maxMidi = matched.reduce(math.max);
  } else if (matched.length == 1) {
    minMidi = matched.first - 2;
    maxMidi = matched.first + 2;
  } else if (heard.length >= 2) {
    final midis = heard.map((hz) => hzToMidi(hz)).toList()..sort();
    final median = midis[midis.length ~/ 2];
    final tight = midis.every((midi) => (midi - median).abs() <= 3);
    if (tight) {
      minMidi = median.round() - 3;
      maxMidi = median.round() + 3;
    } else {
      return VoiceProfile.conservative(gender);
    }
  } else {
    return VoiceProfile.conservative(gender);
  }
  if (maxMidi < minMidi) maxMidi = minMidi;
  final center = ((minMidi + maxMidi) / 2).round();
  final category = categoryForRange(minMidi, maxMidi);
  return VoiceProfile(
    gender: gender,
    category: category,
    minMidi: minMidi,
    maxMidi: maxMidi,
    minHz: midiToHz(minMidi),
    maxHz: midiToHz(maxMidi),
    centerMidi: center,
    completed: matched.isNotEmpty || heard.length >= 2,
    testedAt: DateTime.now(),
  );
}

List<int> fitMelody({
  required List<double> contour,
  required int noteCount,
  required int safeMin,
  required int safeMax,
}) {
  final minNote = math.min(safeMin, safeMax);
  final maxNote = math.max(safeMin, safeMax);
  var count = noteCount.clamp(1, contour.length);
  while (count >= 3) {
    final placed = _transposeInto(contour.take(count).toList(), minNote, maxNote);
    if (placed != null) return placed;
    count--;
  }
  final center = ((minNote + maxNote) / 2).round().clamp(minNote, maxNote);
  final up = math.min(maxNote, center + 1);
  final down = math.max(minNote, center - 1);
  return [center, up, down];
}

List<int>? _transposeInto(List<double> shape, int safeMin, int safeMax) {
  if (shape.isEmpty) return null;
  final low = shape.reduce(math.min);
  final high = shape.reduce(math.max);
  if (high - low > safeMax - safeMin) return null;
  final shift = (((safeMin + safeMax) / 2) - ((low + high) / 2)).round();
  var notes = [for (final note in shape) (note + shift).round()];
  final tooLow = safeMin - notes.reduce(math.min);
  if (tooLow > 0) notes = [for (final note in notes) note + tooLow];
  final tooHigh = notes.reduce(math.max) - safeMax;
  if (tooHigh > 0) notes = [for (final note in notes) note - tooHigh];
  if (notes.any((note) => note < safeMin || note > safeMax)) return null;
  return notes;
}
