import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';
import 'humming.dart';
import 'models.dart';
import 'voice_profile.dart';
import 'scheduler.dart';
import 'scheduler_picker.dart';

class AlarmController extends ChangeNotifier {
  AlarmController({
    AlarmScheduler? scheduler,
    MelodyHummingModule? humming,
    this.decisionAfter = const Duration(minutes: 2),
  })  : scheduler = scheduler ?? createAlarmScheduler(),
        humming = humming ?? const MelodyHummingModule();

  final AlarmScheduler scheduler;
  final MelodyHummingModule humming;
  final Duration decisionAfter;

  static const _alarmsKey = 'alarms.v1';
  static const _accountsKey = 'accounts.v1';
  static const _sessionKey = 'session.v1';
  static const _nameKey = 'displayName.v1';
  static const _nameChosenKey = 'nameChosen.v1';
  static const _sceneKey = 'homeScene.v1';
  static const _themeKey = 'theme.v1';
  static const _localeKey = 'locale.v1';
  static const _genderKey = 'gender.v1';
  static const _voiceKey = 'voice.v1';
  static const _permissionsKey = 'permissionsAck.v1';
  static const _hourKey = 'hourFormat.v1';
  static const _vibrateKey = 'vibrate.v1';
  static const _profileKey = 'voiceProfile.v1';

  List<AlarmItem> alarms = [];
  List<LocalAccount> _accounts = [];
  bool ready = false;
  String displayName = 'Hummingbird';
  bool nameChosen = false;
  int homeScene = 0;
  bool darkMode = false;
  String languageCode = 'en';
  bool use24Hour = true;
  bool vibrateOnAlarm = true;
  String? sessionEmail;
  String? gender;
  String? voice;
  VoiceProfile? voiceProfile;
  bool permissionsAck = false;
  int? ringingId;
  bool previewRing = false;

  bool get isReadyForHome => gender != null && voice != null && permissionsAck;

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
    darkMode = prefs.getString(_themeKey) == 'dark';
    languageCode = switch (prefs.getString(_localeKey)) {
      'pt' => 'pt',
      'es' => 'es',
      _ => 'en',
    };
    use24Hour = prefs.getString(_hourKey) != '12';
    vibrateOnAlarm = prefs.getBool(_vibrateKey) ?? true;
    displayName = prefs.getString(_nameKey) ?? 'Hummingbird';
    nameChosen = prefs.getBool(_nameChosenKey) ?? false;
    homeScene = (prefs.getInt(_sceneKey) ?? 0).clamp(0, 2);
    final rawAccounts = prefs.getString(_accountsKey);
    if (rawAccounts != null) {
      final decoded = jsonDecode(rawAccounts) as List<Object?>;
      _accounts = decoded
          .map((item) => LocalAccount.fromJson(Map<String, Object?>.from(item as Map)))
          .where((account) => account.email.isNotEmpty)
          .toList();
    }
    sessionEmail = prefs.getString(_sessionKey);
    gender = prefs.getString(_genderKey);
    voice = prefs.getString(_voiceKey);
    permissionsAck = prefs.getBool(_permissionsKey) ?? false;
    final account = _current;
    if (account != null) {
      gender ??= account.gender;
      voice ??= account.voice;
      if (!prefs.containsKey(_permissionsKey)) permissionsAck = account.permissionsAck;
      if (account.name.trim().isNotEmpty && prefs.getString(_nameKey) == null) {
        displayName = account.name;
      }
    }
    final rawProfile = prefs.getString(_profileKey);
    if (rawProfile != null) {
      voiceProfile = VoiceProfile.fromJson(Map<String, Object?>.from(jsonDecode(rawProfile) as Map));
      gender = voiceProfile!.gender;
      voice = voiceProfile!.category;
    } else if (gender != null && voice != null) {
      voiceProfile = VoiceProfile.fromCategory(gender: gender!, category: voice!);
    }
    final raw = prefs.getString(_alarmsKey);
    if (raw == null) {
      alarms = seedAlarms();
      await prefs.setString(_alarmsKey, jsonEncode(alarms.map((alarm) => alarm.toJson()).toList()));
    } else {
      final decoded = jsonDecode(raw) as List<Object?>;
      alarms = decoded
          .map((item) => AlarmItem.fromJson(Map<String, Object?>.from(item as Map)))
          .toList();
    }
    await scheduler.init(_onNativeRing);
    scheduler.setVibrate(vibrateOnAlarm);
    for (final alarm in alarms) {
      await scheduler.upsert(alarm);
    }
    ready = true;
    notifyListeners();
  }

  void _applySession(String fallbackName) {
    final account = _current;
    if (account == null) {
      sessionEmail = null;
      gender = null;
      voice = null;
      permissionsAck = false;
      displayName = fallbackName;
      return;
    }
    gender = account.gender;
    voice = account.voice;
    permissionsAck = account.permissionsAck;
    displayName = account.name.trim().isEmpty ? fallbackName : account.name;
  }

  LocalAccount? get _current {
    final email = sessionEmail;
    if (email == null) return null;
    for (final account in _accounts) {
      if (account.email == email) return account;
    }
    return null;
  }

  void _onNativeRing(int id) {
    if (ringingId != null) return;
    previewRing = false;
    ringingId = id;
    notifyListeners();
  }

  Future<AccountError?> signUp({
    required String email,
    required String password,
    required String confirm,
  }) async {
    final normalized = email.trim().toLowerCase();
    if (!looksLikeEmail(normalized)) return AccountError.invalidEmail;
    if (password.length < 6) return AccountError.shortPassword;
    if (password != confirm) return AccountError.mismatch;
    if (_accounts.any((account) => account.email == normalized)) return AccountError.exists;
    final salt = newSalt();
    final account = LocalAccount(
      email: normalized,
      salt: salt,
      hash: hashPassword(password, salt),
      name: normalized.split('@').first,
    );
    _accounts = [..._accounts, account];
    sessionEmail = normalized;
    gender = null;
    voice = null;
    permissionsAck = false;
    displayName = account.name;
    notifyListeners();
    await _persistAccounts();
    return null;
  }

  Future<AccountError?> logIn({required String email, required String password}) async {
    final normalized = email.trim().toLowerCase();
    LocalAccount? account;
    for (final item in _accounts) {
      if (item.email == normalized) account = item;
    }
    if (account == null || account.hash != hashPassword(password, account.salt)) {
      return AccountError.wrongLogin;
    }
    sessionEmail = account.email;
    _applySession(account.name);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, account.email);
    return null;
  }

  Future<void> logOut() async {
    sessionEmail = null;
    gender = null;
    voice = null;
    permissionsAck = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<void> setGender(String value) async {
    gender = value == 'male' ? 'male' : 'female';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_genderKey, gender!);
    await _saveCurrent((account) => account.copyWith(gender: gender));
  }

  VoiceProfile melodyProfile() {
    return voiceProfile ?? VoiceProfile.conservative(gender ?? 'female');
  }

  Future<void> saveVoiceProfile(VoiceProfile profile) async {
    voiceProfile = profile;
    gender = profile.gender;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_genderKey, profile.gender);
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
    await setVoice(profile.category);
  }

  Future<void> setVoice(String category) async {
    voice = voiceCategories.contains(category) ? category : 'alto';
    final allowed = melodiesForVoice(voice);
    final allowedIds = allowed.map((melody) => melody.id).toSet();
    final next = <AlarmItem>[];
    var changed = false;
    for (final alarm in alarms) {
      if (allowedIds.contains(alarm.melodyId)) {
        next.add(alarm);
      } else {
        changed = true;
        next.add(alarm.copyWith(melodyId: allowed.first.id, label: allowed.first.name));
      }
    }
    alarms = next;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_voiceKey, voice!);
    await _saveCurrent((account) => account.copyWith(voice: voice));
    if (!changed) return;
    await _persist();
    for (final alarm in alarms) {
      await scheduler.upsert(alarm);
    }
  }

  Future<void> acknowledgePermissions() async {
    permissionsAck = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionsKey, true);
    await _saveCurrent((account) => account.copyWith(permissionsAck: true));
  }

  Future<void> setUse24Hour(bool enabled) async {
    use24Hour = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hourKey, enabled ? '24' : '12');
  }

  Future<void> setVibrateOnAlarm(bool enabled) async {
    vibrateOnAlarm = enabled;
    scheduler.setVibrate(enabled);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrateKey, enabled);
    for (final alarm in alarms) {
      await scheduler.upsert(alarm);
    }
  }

  Future<void> setDarkMode(bool enabled) async {
    darkMode = enabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, enabled ? 'dark' : 'light');
  }

  Future<void> setLanguage(String code) async {
    languageCode = switch (code) {
      'pt' => 'pt',
      'es' => 'es',
      _ => 'en',
    };
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
  }

  Future<void> chooseName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    displayName = trimmed.length > 10 ? trimmed.substring(0, 10) : trimmed;
    nameChosen = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, displayName);
    await prefs.setBool(_nameChosenKey, true);
  }

  Future<void> setHomeScene(int index) async {
    homeScene = index.clamp(0, 2);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sceneKey, homeScene);
  }

  Future<void> setDisplayName(String name) async {
    final trimmed = name.trim();
    displayName = trimmed.isEmpty ? 'Hummingbird' : (trimmed.length > 10 ? trimmed.substring(0, 10) : trimmed);
    nameChosen = trimmed.isNotEmpty;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, displayName);
    await prefs.setBool(_nameChosenKey, nameChosen);
    await _saveCurrent((account) => account.copyWith(name: displayName));
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

  Future<void> releaseNativeLoop() async {
    final id = ringingId;
    if (id == null || previewRing) return;
    await scheduler.stop(id);
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

  Future<void> _saveCurrent(LocalAccount Function(LocalAccount account) update) async {
    final current = _current;
    if (current == null) return;
    _accounts = [
      for (final account in _accounts) account.email == current.email ? update(account) : account,
    ];
    await _persistAccounts();
  }

  Future<void> _persistAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accountsKey, jsonEncode(_accounts.map((account) => account.toJson()).toList()));
    final email = sessionEmail;
    if (email == null) {
      await prefs.remove(_sessionKey);
    } else {
      await prefs.setString(_sessionKey, email);
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_alarmsKey, jsonEncode(alarms.map((alarm) => alarm.toJson()).toList()));
  }

  @override
  void dispose() {
    scheduler.dispose();
    super.dispose();
  }
}
