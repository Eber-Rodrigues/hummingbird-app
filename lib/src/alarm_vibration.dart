import 'package:vibration/vibration.dart';

import 'runtime.dart';

class AlarmVibration {
  var _running = false;

  Future<void> start() async {
    if (isWidgetTest || _running) return;
    _running = true;
    try {
      final available = await Vibration.hasVibrator();
      if (available != true) {
        _running = false;
        return;
      }
      await Vibration.vibrate(pattern: const [0, 900, 400, 900, 400], repeat: 0);
    } catch (_) {
      _running = false;
    }
  }

  Future<void> stop() async {
    _running = false;
    if (isWidgetTest) return;
    try {
      await Vibration.cancel();
    } catch (_) {}
  }
}
