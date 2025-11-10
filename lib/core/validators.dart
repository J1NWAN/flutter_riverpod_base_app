/// 공통 Validator 유틸.
/// - 언제 사용: 여러 TextField에서 동일한 검증 로직을 재사용하고 싶을 때.
/// - 사용법:
///   ```dart
///   validator: (v) => Validators.required(v) ?? Validators.email(v);
///   ```
class Validators {
  /// 필수 입력을 확인한다.
  static String? required(String? v, {String message = '필수 입력 항목입니다.'}) {
    if (v == null || v.trim().isEmpty) {
      return message;
    }
    return null;
  }

  /// 이메일 형식을 검증한다.
  static String? email(String? v,
      {String message = '이메일 형식이 올바르지 않습니다.'}) {
    if (v == null || v.isEmpty) {
      return null;
    }
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(v.trim())) {
      return message;
    }
    return null;
  }

  /// 최소 길이 이상인지 확인한다.
  static String? minLength(String? v, int len, {String? message}) {
    if (v == null || v.length < len) {
      return message ?? '최소 $len자 이상 입력해야 합니다.';
    }
    return null;
  }

  /// 최대 길이 이하인지 확인한다.
  static String? maxLength(String? v, int len, {String? message}) {
    if (v != null && v.length > len) {
      return message ?? '최대 $len자 이하로 입력해야 합니다.';
    }
    return null;
  }

  /// 다른 값과 일치하는지 확인한다.
  static String? equals(String? v, String other,
      {String message = '값이 일치하지 않습니다.'}) {
    if (v != other) {
      return message;
    }
    return null;
  }
}
