/// API 호출 결과를 표현하는 타입들.
enum ApiErrorType { network, timeout, unauthorized, server, unknown }

class ApiError {
  final ApiErrorType type;
  final String message;
  final int? statusCode;
  final dynamic details;

  const ApiError({
    required this.type,
    required this.message,
    this.statusCode,
    this.details,
  });

  factory ApiError.network(String message, {dynamic details}) => ApiError(
        type: ApiErrorType.network,
        message: message,
        details: details,
      );

  factory ApiError.timeout(String message) => ApiError(
        type: ApiErrorType.timeout,
        message: message,
      );

  factory ApiError.unauthorized(String message, {int? statusCode}) => ApiError(
        type: ApiErrorType.unauthorized,
        message: message,
        statusCode: statusCode,
      );

  factory ApiError.server(
    String message, {
    int? statusCode,
    dynamic details,
  }) =>
      ApiError(
        type: ApiErrorType.server,
        message: message,
        statusCode: statusCode,
        details: details,
      );
}

/// 성공 또는 실패를 나타내는 Result 타입.
class ApiResult<T> {
  final T? data;
  final ApiError? error;

  const ApiResult._({
    this.data,
    this.error,
  });

  bool get isSuccess => error == null;

  static ApiResult<T> success<T>(T data) =>
      ApiResult<T>._(data: data, error: null);

  static ApiResult<T> failure<T>(ApiError error) =>
      ApiResult<T>._(data: null, error: error);
}
