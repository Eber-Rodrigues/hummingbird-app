class Melody {
  const Melody(this.id, this.name, this.detail, this.voices);

  final String id;
  final String name;
  final String detail;
  final Set<String> voices;
}

const melodies = <Melody>[
  Melody('morning_light', 'Morning Light', 'Soft and bright', {'soprano', 'alto'}),
  Melody('ocean_breeze', 'Ocean Breeze', 'Easy and rolling', {'alto', 'tenor'}),
  Melody('sunrise', 'Sunrise', 'Bright and steady', {'tenor', 'bass'}),
];

List<Melody> melodiesForVoice(String? voice) {
  if (voice == null) return melodies;
  final matched = melodies.where((melody) => melody.voices.contains(voice)).toList();
  return matched.isEmpty ? melodies : matched;
}

const difficulties = ['Easy', 'Medium', 'Hard'];
const tolerances = ['Relaxed', 'Normal', 'Strict'];

const dayLetters = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

Melody melodyById(String id) {
  return melodies.firstWhere((melody) => melody.id == id, orElse: () => melodies.first);
}

class AlarmItem {
  const AlarmItem({
    required this.id,
    required this.hour,
    required this.minute,
    required this.weekdays,
    required this.melodyId,
    required this.difficulty,
    required this.tolerance,
    required this.enabled,
    required this.label,
    this.snoozeMinutes = 5,
  });

  final int id;
  final int hour;
  final int minute;
  final Set<int> weekdays;
  final String melodyId;
  final String difficulty;
  final String tolerance;
  final bool enabled;
  final String label;
  final int snoozeMinutes;

  AlarmItem copyWith({
    int? hour,
    int? minute,
    Set<int>? weekdays,
    String? melodyId,
    String? difficulty,
    String? tolerance,
    bool? enabled,
    String? label,
    int? snoozeMinutes,
  }) {
    return AlarmItem(
      id: id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      weekdays: weekdays ?? this.weekdays,
      melodyId: melodyId ?? this.melodyId,
      difficulty: difficulty ?? this.difficulty,
      tolerance: tolerance ?? this.tolerance,
      enabled: enabled ?? this.enabled,
      label: label ?? this.label,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
    );
  }

  String get timeLabel => formatClock(hour, minute);

  String get daySummary {
    if (weekdays.isEmpty) return 'Once';
    if (weekdays.length == 7) return 'Every day';
    if (weekdays.containsAll({1, 2, 3, 4, 5}) && weekdays.length == 5) {
      return 'Weekdays';
    }
    if (weekdays.containsAll({6, 7}) && weekdays.length == 2) return 'Weekends';
    return dayLetters
        .asMap()
        .entries
        .where((entry) => weekdays.contains(entry.key + 1))
        .map((entry) => entry.value)
        .join(' ');
  }

  DateTime nextFire([DateTime? from]) {
    final now = from ?? DateTime.now();
    if (weekdays.isEmpty) {
      var when = DateTime(now.year, now.month, now.day, hour, minute);
      if (!when.isAfter(now)) when = when.add(const Duration(days: 1));
      return when;
    }
    for (var offset = 0; offset < 8; offset++) {
      final day = now.add(Duration(days: offset));
      if (!weekdays.contains(day.weekday)) continue;
      final when = DateTime(day.year, day.month, day.day, hour, minute);
      if (when.isAfter(now)) return when;
    }
    return DateTime(now.year, now.month, now.day, hour, minute).add(const Duration(days: 7));
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'hour': hour,
        'minute': minute,
        'weekdays': weekdays.toList(),
        'melodyId': melodyId,
        'difficulty': difficulty,
        'tolerance': tolerance,
        'enabled': enabled,
        'label': label,
        'snoozeMinutes': snoozeMinutes,
      };

  factory AlarmItem.fromJson(Map<String, Object?> json) {
    final days = (json['weekdays'] as List<Object?>?) ?? const [];
    return AlarmItem(
      id: json['id'] as int,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      weekdays: days.cast<int>().toSet(),
      melodyId: json['melodyId'] as String,
      difficulty: json['difficulty'] as String,
      tolerance: json['tolerance'] as String,
      enabled: json['enabled'] as bool,
      label: json['label'] as String,
      snoozeMinutes: _snoozeMinutes(json['snoozeMinutes']),
    );
  }
}

int _snoozeMinutes(Object? value) {
  return value == 2 || value == 10 ? value as int : 5;
}

String formatClock(int hour, int minute) {
  final period = hour >= 12 ? 'PM' : 'AM';
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;
  return '$hour12:${minute.toString().padLeft(2, '0')} $period';
}

List<AlarmItem> seedAlarms() {
  return const [
    AlarmItem(
      id: 1,
      hour: 6,
      minute: 30,
      weekdays: {1, 2, 3, 4, 5},
      melodyId: 'morning_light',
      difficulty: 'Medium',
      tolerance: 'Normal',
      enabled: true,
      label: 'Morning Light',
    ),
    AlarmItem(
      id: 2,
      hour: 8,
      minute: 15,
      weekdays: {6, 7},
      melodyId: 'ocean_breeze',
      difficulty: 'Easy',
      tolerance: 'Relaxed',
      enabled: true,
      label: 'Ocean Breeze',
    ),
    AlarmItem(
      id: 3,
      hour: 7,
      minute: 0,
      weekdays: {1, 2, 3, 4, 5, 6, 7},
      melodyId: 'sunrise',
      difficulty: 'Hard',
      tolerance: 'Strict',
      enabled: true,
      label: 'Sunrise',
    ),
  ];
}

