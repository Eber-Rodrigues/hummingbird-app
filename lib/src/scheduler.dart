import 'models.dart';

abstract class AlarmScheduler {
  Future<void> init(void Function(int id) onRing);

  void setVibrate(bool enabled);

  Future<void> upsert(AlarmItem alarm);

  Future<void> scheduleAt(AlarmItem alarm, DateTime when);

  Future<void> cancel(int id);

  Future<void> stop(int id);

  void dispose();
}
