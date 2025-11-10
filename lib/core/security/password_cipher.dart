import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// SHA-256 기반 비밀번호 해시 유틸.
/// - 언제 사용: 비밀번호를 서버로 전송하기 전에 해시하거나, 로컬에서 두 문자열이 동일한지 검증할 때.
/// - 사용법:
///   ```dart
///   final salt = PasswordCipher.generateSalt();
///   final hashed = PasswordCipher.hash('plain-password', salt: salt);
///   final isValid = PasswordCipher.verify('plain-password', hashed);
///   ```
class PasswordCipher {
  const PasswordCipher._();

  /// SHA-256 해시를 생성한다. 반환값은 `salt:hash` 형식.
  static String hash(
    String input, {
    String? salt,
  }) {
    final resolvedSalt = salt ?? generateSalt();
    final bytes = utf8.encode('$resolvedSalt$input');
    final digest = sha256.convert(bytes).toString();
    return '$resolvedSalt:$digest';
  }

  /// 해시 문자열과 평문 입력을 비교한다.
  static bool verify(String input, String hashed) {
    final parts = hashed.split(':');
    if (parts.length != 2) {
      return false;
    }
    final salt = parts[0];
    final expected = hash(input, salt: salt);
    return _constantTimeEquals(expected, hashed);
  }

  /// 암호화에 사용할 랜덤 salt를 생성한다.
  static String generateSalt({int length = 16}) {
    final random = Random.secure();
    final values = List<int>.generate(length, (_) => random.nextInt(256));
    return base64UrlEncode(values);
  }

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
