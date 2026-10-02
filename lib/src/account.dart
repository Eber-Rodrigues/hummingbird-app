import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

enum AccountError { invalidEmail, shortPassword, mismatch, exists, wrongLogin }

class LocalAccount {
  const LocalAccount({
    required this.email,
    required this.salt,
    required this.hash,
    this.gender,
    this.voice,
    this.permissionsAck = false,
    this.name = '',
  });

  final String email;
  final String salt;
  final String hash;
  final String? gender;
  final String? voice;
  final bool permissionsAck;
  final String name;

  LocalAccount copyWith({
    String? gender,
    String? voice,
    bool? permissionsAck,
    String? name,
    bool clearGender = false,
    bool clearVoice = false,
  }) {
    return LocalAccount(
      email: email,
      salt: salt,
      hash: hash,
      gender: clearGender ? null : (gender ?? this.gender),
      voice: clearVoice ? null : (voice ?? this.voice),
      permissionsAck: permissionsAck ?? this.permissionsAck,
      name: name ?? this.name,
    );
  }

  Map<String, Object?> toJson() => {
        'email': email,
        'salt': salt,
        'hash': hash,
        'gender': gender,
        'voice': voice,
        'permissionsAck': permissionsAck,
        'name': name,
      };

  factory LocalAccount.fromJson(Map<String, Object?> json) {
    return LocalAccount(
      email: json['email'] as String? ?? '',
      salt: json['salt'] as String? ?? '',
      hash: json['hash'] as String? ?? '',
      gender: json['gender'] as String?,
      voice: json['voice'] as String?,
      permissionsAck: json['permissionsAck'] as bool? ?? false,
      name: json['name'] as String? ?? '',
    );
  }
}

bool looksLikeEmail(String value) {
  final email = value.trim();
  final at = email.indexOf('@');
  if (at <= 0) return false;
  final dot = email.lastIndexOf('.');
  return dot > at + 1 && dot < email.length - 1 && !email.contains(' ');
}

String hashPassword(String password, String salt) {
  return sha256.convert(utf8.encode('$salt:$password')).toString();
}

String newSalt() {
  final random = Random.secure();
  final bytes = List<int>.generate(16, (_) => random.nextInt(256));
  return base64UrlEncode(bytes);
}
