import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/app_http_client.dart';
import 'demo_repository.dart';

/// 데모 API를 호출하는 Repository Provider.
final demoRepositoryProvider = Provider<DemoRepository>((ref) {
  final client = ref.watch(appHttpClientProvider);
  return DemoRepository(client);
});
