import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import 'models.dart';
import 'scheduler.dart';

class NativeAlarmScheduler implements AlarmScheduler {
  StreamSubscription<dynamic>? _ringing;
  void Function(int id)? _onRing;
  bool vibrate = true;

  @override
  void setVibrate(bool enabled) {
    vibrate = enabled;
  }

  bool get _underTest => Platform.environment.containsKey('FLUTTER_TEST');

  @override
  Future<void> init(void Function(int id) onRing) async {
    _onRing = onRing;
    if (_underTest) return;
    await Alarm.init();
    _ringing = Alarm.ringing.listen((ringing) {
      for (final alarm in ringing.alarms) {
        _onRing?.call(alarm.id);
      }
    });
  }

  @override
  Future<void> upsert(AlarmItem alarm) async {
    if (_underTest) return;
    if (!alarm.enabled) {
      await Alarm.stop(alarm.id);
      return;
    }
    await _set(alarm, alarm.nextFire());
  }

  @override
  Future<void> scheduleAt(AlarmItem alarm, DateTime when) async {
    if (_underTest) return;
    await _set(alarm, when);
  }

  Future<void> _set(AlarmItem alarm, DateTime when) {
    return Alarm.set(
      alarmSettings: AlarmSettings(
        id: alarm.id,
        dateTime: when,
        assetAudioPath: 'assets/audio/alarm.wav',
        loopAudio: true,
        vibrate: vibrate,
        warningNotificationOnKill: false,
        androidFullScreenIntent: true,
        androidStopAlarmOnTermination: false,
        volumeSettings: VolumeSettings.fade(
          volume: 1,
          fadeDuration: const Duration(seconds: 3),
          volumeEnforced: true,
        ),
        notificationSettings: NotificationSettings(
          title: alarm.label,
          body: 'Wake up with your melody',
          stopButton: 'Stop',
          icon: 'notification_icon',
          iconColor: const Color(0xFF219EBC),
        ),
      ),
    );
  }

  @override
  Future<void> cancel(int id) async {
    if (_underTest) return;
    await Alarm.stop(id);
  }

  @override
  Future<void> stop(int id) async {
    if (_underTest) return;
    await Alarm.stop(id);
  }

  @override
  void dispose() {
    _ringing?.cancel();
  }
}
