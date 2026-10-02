import 'dart:async';

import 'models.dart';
import 'scheduler.dart';

class WebAlarmScheduler implements AlarmScheduler {
  final Map<int, Timer> _timers = {};
  void Function(int id)? _onRing;
  bool vibrate = true;

  @override
  void setVibrate(bool enabled) {
    vibrate = enabled;
  }

  @override
  Future<void> init(void Function(int id) onRing) async {
    _onRing = onRing;
  }

  @override
  Future<void> upsert(AlarmItem alarm) async {
    _timers.remove(alarm.id)?.cancel();
    if (!alarm.enabled) return;
    _arm(alarm.id, alarm.nextFire());
  }

  @override
  Future<void> scheduleAt(AlarmItem alarm, DateTime when) async {
    _arm(alarm.id, when);
  }

  void _arm(int id, DateTime when) {
    _timers.remove(id)?.cancel();
    final delay = when.difference(DateTime.now());
    _timers[id] = Timer(delay.isNegative ? Duration.zero : delay, () {
      _timers.remove(id);
      _onRing?.call(id);
    });
  }

  @override
  Future<void> cancel(int id) async {
    _timers.remove(id)?.cancel();
  }

  @override
  Future<void> stop(int id) async {
    _timers.remove(id)?.cancel();
  }

  @override
  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}
