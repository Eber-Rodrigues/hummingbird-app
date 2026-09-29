import 'models.dart';

abstract class AlarmScheduler {
  Future<void> init(void Function(int id) onRing);

  Future<void> upsert(AlarmItem alarm);

  Future<void> cancel(int id);

  Future<void> stop(int id);

  void dispose();
}
