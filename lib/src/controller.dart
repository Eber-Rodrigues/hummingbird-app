import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';
import 'scheduler.dart';
import 'scheduler_picker.dart';

class AlarmController extends ChangeNotifier {
  AlarmController({AlarmScheduler? scheduler, HummingModule? humming})
      : scheduler = scheduler ?? createAlarmScheduler(),
        humming = humming ?? const UnimplementedHummingModule();

  final AlarmScheduler scheduler;
  final HummingModule humming;

  static const _alarmsKey = 'alarms.v1';
  static const _onboardedKey = 'onboarded.v1';
  static const _nameKey = 'displayName.v1';

  List<AlarmItem> alarms = [];
  bool ready = false;
  bool onboarded = false;
  String displayName = 'Hummingbird';
  int? ringingId;
  bool previewRing = false;

  AlarmItem? get ringingAlarm {
    final id = ringingId;
    if (id == null) return null;
    for (final alarm in alarms) {
      if (alarm.id == id) return alarm;
    }
    return null;
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    onboarded = prefs.getBool(_onboardedKey) ?? false;
    displayName = prefs.getString(_nameKey) ?? 'Hummingbird';
    final raw = prefs.getString(_alarmsKey);
    if (raw == null) {
      alarms = seedAlarms();
      await prefs.setString(_alarmsKey, jsonEncode(alarms.map((a) => a.toJson()).toList()));
    } else {
      final decoded = jsonDecode(raw) as List<Object?>;
      alarms = decoded
          .map((item) => AlarmItem.fromJson(Map<String, Object?>.from(item as Map)))
          .toList();
    }
    await scheduler.init(_onNativeRing);
    for (final alarm in alarms) {
      await scheduler.upsert(alarm);
    }
    ready = true;
    notifyListeners();
  }

  void _onNativeRing(int id) {
    if (ringingId != null) return;
    previewRing = false;
    ringingId = id;
    notifyListeners();
  }

  Future<void> finishOnboarding() async {
    onboarded = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardedKey, true);
  }

  Future<void> setDisplayName(String name) async {
    final trimmed = name.trim();
    displayName = trimmed.isEmpty ? 'Hummingbird' : trimmed;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, displayName);
  }

  Future<void> saveAlarm(AlarmItem alarm) async {
    final index = alarms.indexWhere((item) => item.id == alarm.id);
    if (index == -1) {
      alarms = [...alarms, alarm];
    } else {
      final next = [...alarms];
      next[index] = alarm;
      alarms = next;
    }
    await _persist();
    await scheduler.upsert(alarm);
    notifyListeners();
  }

  Future<void> setEnabled(AlarmItem alarm, bool enabled) async {
    await saveAlarm(alarm.copyWith(enabled: enabled));
  }

  Future<void> deleteAlarm(int id) async {
    alarms = alarms.where((alarm) => alarm.id != id).toList();
    if (ringingId == id) {
      ringingId = null;
      previewRing = false;
    }
    await scheduler.cancel(id);
    await _persist();
    notifyListeners();
  }

  int nextId() {
    var maxId = 0;
    for (final alarm in alarms) {
      if (alarm.id > maxId) maxId = alarm.id;
    }
    return maxId + 1;
  }

  void preview(AlarmItem alarm) {
    previewRing = true;
    ringingId = alarm.id;
    notifyListeners();
  }

  Future<void> stopRinging() async {
    final id = ringingId;
    final wasPreview = previewRing;
    ringingId = null;
    previewRing = false;
    notifyListeners();
    if (id == null || wasPreview) return;

    await scheduler.stop(id);
    AlarmItem? alarm;
    for (final item in alarms) {
      if (item.id == id) alarm = item;
    }
    if (alarm == null) return;
    if (alarm.weekdays.isEmpty) {
      await saveAlarm(alarm.copyWith(enabled: false));
      return;
    }
    await scheduler.upsert(alarm);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_alarmsKey, jsonEncode(alarms.map((a) => a.toJson()).toList()));
  }

  @override
  void dispose() {
    scheduler.dispose();
    super.dispose();
  }
}
