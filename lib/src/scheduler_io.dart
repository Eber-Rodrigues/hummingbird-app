import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import 'models.dart';
import 'scheduler.dart';

class NativeAlarmScheduler implements AlarmScheduler {
  StreamSubscription<dynamic>? _ringing;
  void Function(int id)? _onRing;

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
    await Alarm.set(
      alarmSettings: AlarmSettings(
        id: alarm.id,
        dateTime: alarm.nextFire(),
        assetAudioPath: 'assets/audio/alarm.wav',
        loopAudio: true,
        vibrate: true,
        warningNotificationOnKill: false,
        androidFullScreenIntent: true,
        androidStopAlarmOnTermination: false,
        volumeSettings: VolumeSettings.fade(
          volume: 0.8,
          fadeDuration: const Duration(seconds: 4),
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
