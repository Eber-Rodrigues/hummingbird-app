import 'dart:async';

import 'models.dart';
import 'scheduler.dart';

class WebAlarmScheduler implements AlarmScheduler {
  final Map<int, Timer> _timers = {};
  void Function(int id)? _onRing;

  @override
  Future<void> init(void Function(int id) onRing) async {
    _onRing = onRing;
  }

  @override
  Future<void> upsert(AlarmItem alarm) async {
    _timers.remove(alarm.id)?.cancel();
    if (!alarm.enabled) return;
    final when = alarm.nextFire();
    final delay = when.difference(DateTime.now());
    _timers[alarm.id] = Timer(delay.isNegative ? Duration.zero : delay, () {
      _timers.remove(alarm.id);
      _onRing?.call(alarm.id);
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
