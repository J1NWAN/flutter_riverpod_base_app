import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../app_config_provider.dart';
import 'api_result.dart';

/// `Provider<AppHttpClient>`로 주입하는 공통 HTTP 클라이언트.
final appHttpClientProvider = Provider<AppHttpClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final client = AppHttpClient(baseUrl: config.baseUrl);
  ref.onDispose(client.dispose);
  return client;
});

/// Base URL과 http.Client를 감싼 간단한 래퍼.
/// - 각 API 호출은 `ApiResult<T>`를 반환하며, 성공/실패를 한 패턴으로 처리할 수 있다.
class AppHttpClient {
  AppHttpClient({
    required String baseUrl,
    http.Client? client,
  })  : _baseUri = Uri.parse(baseUrl),
        _client = client ?? http.Client();

  final Uri _baseUri;
  final http.Client _client;

  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic data)? parser,
  }) {
    return _send<T>(
      method: 'GET',
      path: path,
      queryParameters: queryParameters,
      headers: headers,
      parser: parser,
    );
  }

  Future<ApiResult<T>> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    T Function(dynamic data)? parser,
  }) {
    return _send<T>(
      method: 'POST',
      path: path,
      queryParameters: queryParameters,
      headers: headers,
      body: body,
      parser: parser,
    );
  }

  Future<ApiResult<T>> put<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    T Function(dynamic data)? parser,
  }) {
    return _send<T>(
      method: 'PUT',
      path: path,
      queryParameters: queryParameters,
      headers: headers,
      body: body,
      parser: parser,
    );
  }

  Future<ApiResult<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    T Function(dynamic data)? parser,
  }) {
    return _send<T>(
      method: 'DELETE',
      path: path,
      queryParameters: queryParameters,
      headers: headers,
      body: body,
      parser: parser,
    );
  }

  Future<ApiResult<T>> _send<T>({
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Object? body,
    T Function(dynamic data)? parser,
  }) async {
    final uri = _resolve(path, queryParameters);
    final resolvedHeaders = <String, String>{
      if (headers != null) ...headers,
    };

    Object? resolvedBody = body;
    if (body is Map || body is List) {
      resolvedBody = jsonEncode(body);
      resolvedHeaders.putIfAbsent('Content-Type', () => 'application/json');
    }

    try {
      http.Response response;
      switch (method) {
        case 'POST':
          response = await _client.post(
            uri,
            headers: resolvedHeaders,
            body: resolvedBody,
          );
          break;
        case 'PUT':
          response = await _client.put(
            uri,
            headers: resolvedHeaders,
            body: resolvedBody,
          );
          break;
        case 'DELETE':
          response = await _client.delete(
            uri,
            headers: resolvedHeaders,
            body: resolvedBody,
          );
          break;
        case 'GET':
        default:
          response = await _client.get(
            uri,
            headers: resolvedHeaders,
          );
          break;
      }
      return _handleResponse(response, parser);
    } on SocketException catch (e) {
      return ApiResult.failure(
        ApiError.network('네트워크 연결을 확인해 주세요.', details: e.message),
      );
    } on HttpException catch (e) {
      return ApiResult.failure(
        ApiError.server('요청 처리 중 오류가 발생했습니다.', details: e.message),
      );
    } on TimeoutException catch (e) {
      return ApiResult.failure(
        ApiError.timeout('요청 시간이 초과되었습니다. (${e.message ?? ''})'),
      );
    } catch (e, st) {
      debugPrint('HTTP 요청 중 예기치 못한 오류: $e\n$st');
      return ApiResult.failure(
        ApiError(
          type: ApiErrorType.unknown,
          message: '알 수 없는 오류가 발생했습니다.',
          details: e.toString(),
        ),
      );
    }
  }

  ApiResult<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic data)? parser,
  ) {
    final status = response.statusCode;
    final bodyText = response.body;
    final isJson = response.headers['content-type']?.contains('application/json') ?? false;
    final dynamic decodedBody = bodyText.isEmpty
        ? null
        : (isJson ? jsonDecode(bodyText) : bodyText);

    if (status >= 200 && status < 300) {
      try {
        if (parser != null) {
          final parsed = parser(decodedBody);
          return ApiResult.success(parsed);
        }
        return ApiResult.success(decodedBody as T);
      } catch (e) {
        return ApiResult.failure(
          ApiError(
            type: ApiErrorType.unknown,
            message: '응답을 파싱하는 중 오류가 발생했습니다.',
            details: e.toString(),
          ),
        );
      }
    }

    final type = switch (status) {
      401 || 403 => ApiErrorType.unauthorized,
      >= 500 => ApiErrorType.server,
      _ => ApiErrorType.server,
    };
    final message = decodedBody is Map && decodedBody['message'] != null
        ? decodedBody['message'].toString()
        : '요청이 실패했습니다. (HTTP $status)';
    return ApiResult.failure(
      ApiError(
        type: type,
        message: message,
        statusCode: status,
        details: decodedBody,
      ),
    );
  }

  Uri _resolve(String path, Map<String, dynamic>? queryParameters) {
    final uri = _baseUri.resolve(path);
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    final mergedQuery = <String, String>{
      ...uri.queryParameters,
      for (final entry in queryParameters.entries)
        entry.key: entry.value.toString(),
    };
    return uri.replace(queryParameters: mergedQuery);
  }

  void dispose() {
    _client.close();
  }
}
