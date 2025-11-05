import 'dart:math';

final RegExp _commaRegExp = RegExp(r'\B(?=(\d{3})+(?!\d))');

class _NormalizedNumber {
  const _NormalizedNumber({required this.isNegative, required this.integerPart, required this.decimalPart});

  final bool isNegative;
  final String integerPart;
  final String decimalPart;
}

_NormalizedNumber _normalizeNumber(num value, int decimalDigits) {
  final isNegative = value.isNegative;
  final absValue = value.abs();
  final fixed = absValue.toStringAsFixed(decimalDigits);
  final parts = fixed.split('.');
  final integerPart = parts.first;
  final decimalPart = parts.length > 1 ? parts[1] : '';
  return _NormalizedNumber(isNegative: isNegative, integerPart: integerPart, decimalPart: decimalPart);
}

String _pad2(int value) => value.toString().padLeft(2, '0');

/// 숫자 포맷 관련 확장.
/// ```
/// 12345.comma() // "12,345"
/// (-9876.543).toCurrency(symbol: r"$", decimalDigits: 2) // "-$9,876.54"
/// 0.157.toPercent(decimalDigits: 1) // "15.7%"
/// ```
extension NumFormatX on num {
  /// 천 단위 콤마를 추가한다.
  String comma({int decimalDigits = 0}) {
    final normalized = _normalizeNumber(this, decimalDigits);
    final buffer = StringBuffer();

    if (normalized.isNegative) {
      buffer.write('-');
    }

    buffer.write(normalized.integerPart.replaceAll(_commaRegExp, ','));

    if (decimalDigits > 0) {
      buffer
        ..write('.')
        ..write(normalized.decimalPart.padRight(decimalDigits, '0'));
    }

    return buffer.toString();
  }

  /// 통화 포맷을 생성한다.
  String toCurrency({String symbol = '₩', bool symbolOnLeft = true, bool spaceBetween = false, int decimalDigits = 0}) {
    final formatted = comma(decimalDigits: decimalDigits);
    final buffer = StringBuffer();
    final separator = spaceBetween ? ' ' : '';

    if (symbolOnLeft) {
      buffer.write(symbol);
      if (separator.isNotEmpty) {
        buffer.write(separator);
      }
      buffer.write(formatted);
    } else {
      buffer.write(formatted);
      if (separator.isNotEmpty) {
        buffer.write(separator);
      }
      buffer.write(symbol);
    }

    return buffer.toString();
  }

  /// 퍼센트 문자열로 변환한다.
  String toPercent({int decimalDigits = 0}) {
    final percentValue = this * 100;
    final normalized = _normalizeNumber(percentValue, decimalDigits);
    final buffer = StringBuffer();

    if (normalized.isNegative) {
      buffer.write('-');
    }

    buffer.write(normalized.integerPart.replaceAll(_commaRegExp, ','));

    if (decimalDigits > 0) {
      buffer
        ..write('.')
        ..write(normalized.decimalPart.padRight(decimalDigits, '0'));
    }

    buffer.write('%');
    return buffer.toString();
  }
}

/// 날짜/시간 포맷 관련 확장.
/// ```
/// DateTime(2024, 5, 1).ymd // "2024-05-01"
/// DateTime(2024, 5, 1, 12, 30).ymdHms // "2024-05-01 12:30:00"
/// DateTime.now().subtract(Duration(minutes: 3)).relativeFrom(DateTime.now()) // "3분 전"
/// ```
extension DateFormatX on DateTime {
  /// yyyy-MM-dd
  String get ymd => '${year.toString().padLeft(4, '0')}-${_pad2(month)}-${_pad2(day)}';

  /// yyyy.MM.dd
  String get ymdDot => '${year.toString().padLeft(4, '0')}.${_pad2(month)}.${_pad2(day)}';

  /// yyyy-MM-dd HH:mm:ss
  String get ymdHms => '$ymd ${_pad2(hour)}:${_pad2(minute)}:${_pad2(second)}';

  /// 기준 시각 [now]와 비교한 상대 시간을 한국어로 반환한다.
  String relativeFrom(DateTime now) {
    final diff = now.difference(this);
    final seconds = diff.inSeconds;

    if (seconds < 0) {
      return '곧';
    }
    if (seconds < 5) {
      return '방금 전';
    }
    if (seconds < 60) {
      return '$seconds초 전';
    }

    final minutes = diff.inMinutes;
    if (minutes < 60) {
      return '$minutes분 전';
    }

    final hours = diff.inHours;
    if (hours < 24) {
      return '$hours시간 전';
    }

    final days = diff.inDays;
    if (days < 30) {
      return '$days일 전';
    }

    final months = max(1, (days / 30).floor());
    if (months < 12) {
      return '$months개월 전';
    }

    final years = max(1, (days / 365).floor());
    return '$years년 전';
  }
}
