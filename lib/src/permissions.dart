import 'package:permission_handler/permission_handler.dart';

import 'runtime.dart';

Future<void> requestMicrophonePermission() async {
  if (isWidgetTest) return;
  try {
    await Permission.microphone.request();
  } catch (_) {}
}

Future<void> requestAlarmPermissions() async {
  if (isWidgetTest) return;
  try {
    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();
    await Permission.ignoreBatteryOptimizations.request();
  } catch (_) {}
}
