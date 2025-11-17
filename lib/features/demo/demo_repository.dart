import '../../core/network/api_result.dart';
import '../../core/network/app_http_client.dart';

class DemoRepository {
  DemoRepository(this._client);
  final AppHttpClient _client;

  Future<ApiResult<List<Map<String, dynamic>>>> userAll() {
    return _client.get<List<Map<String, dynamic>>>(
      '/user/all',
      parser: (json) => (json as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }
}
