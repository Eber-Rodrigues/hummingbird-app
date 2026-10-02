import 'dart:async';
import 'dart:math' as math;

import 'package:sensors_plus/sensors_plus.dart';

import 'runtime.dart';

class ShakeToStop {
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  Timer? _probe;
  DateTime? _shakingSince;

  void start(void Function() onDone, {void Function()? onUnavailable}) {
    if (isWidgetTest) return;
    stop();
    var sawEvent = false;
    try {
      _subscription = userAccelerometerEventStream().listen((event) {
        sawEvent = true;
        final magnitude = math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
        final now = DateTime.now();
        if (magnitude > 3) {
          _shakingSince ??= now;
          if (now.difference(_shakingSince!) >= const Duration(seconds: 4)) {
            stop();
            onDone();
          }
        } else if (_shakingSince != null && now.difference(_shakingSince!) > const Duration(milliseconds: 350)) {
          _shakingSince = null;
        }
      }, onError: (_) {
        stop();
        onUnavailable?.call();
      });
      _probe = Timer(const Duration(seconds: 1), () {
        if (sawEvent) return;
        stop();
        onUnavailable?.call();
      });
    } catch (_) {
      onUnavailable?.call();
    }
  }

  void stop() {
    _probe?.cancel();
    _probe = null;
    _subscription?.cancel();
    _subscription = null;
    _shakingSince = null;
  }
}
