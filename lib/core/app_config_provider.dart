import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';

/// Riverpod 기반 앱 전역 설정 Provider.
/// - 언제 사용: 앱 전체에서 `ref.watch(appConfigProvider)`로 환경 정보를 공유할 때.
/// - 사용법(usage):
///   ```dart
///   final cfg = ref.watch(appConfigProvider);
///   ref.read(appConfigProvider.notifier).setFlavor(Flavor.stage); // 개발용 런타임 전환
///   ref.read(appConfigProvider.notifier).setBaseUrl('http://localhost:3000');
///   ```
/// - 예시: HTTP 클라이언트 baseUrl, MaterialApp title, 테마 토큰 분기 등에 활용.
/// - 주의: 운영 배포에서는 `AppConfig.fromEnv()` 값을 사용하고, 런타임 전환은 개발/데모에서만 활용 권장.
class AppConfigController extends StateNotifier<AppConfig> {
  AppConfigController(super.initial);

  void setFlavor(Flavor flavor) {
    state = _presetByFlavor(flavor);
  }

  void update(AppConfig config) {
    state = config;
  }

  void setBaseUrl(String url) {
    state = state.copyWith(baseUrl: url);
  }

  void setAnalytics(bool enabled) {
    state = state.copyWith(enableAnalytics: enabled);
  }

  void setBeta(bool enabled) {
    state = state.copyWith(enableBetaFeature: enabled);
  }

  AppConfig _presetByFlavor(Flavor flavor) {
    switch (flavor) {
      case Flavor.dev:
        return AppConfig.dev();
      case Flavor.stage:
        return AppConfig.stage();
      case Flavor.prod:
        return AppConfig.prod();
    }
  }
}

final appConfigProvider = StateNotifierProvider<AppConfigController, AppConfig>(
  (ref) => AppConfigController(AppConfig.fromEnv()),
);
