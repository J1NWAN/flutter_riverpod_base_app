/// 앱 전역 Env/Flavor 설정 모델.
/// - 언제 사용: 런타임 전역에서 환경 정보를 공유하고 싶을 때 (예: 서버 주소, 기능 플래그).
/// - 사용법:
///   ```dart
///   const cfg = AppConfig.fromEnv();
///   print(cfg.baseUrl);
///   ```
/// - 빌드 예시(--dart-define):
///   ```bash
///   flutter run \
///     --dart-define=FLAVOR=prod \
///     --dart-define=APP_NAME=MyApp \
///     --dart-define=BASE_URL=https://api.example.com \
///     --dart-define=ENABLE_ANALYTICS=true \
///     --dart-define=ENABLE_BETA_FEATURE=false
///   ```
/// - 주의: [AppConfig.fromEnv]는 컴파일 타임 상수 기반이므로 런타임 중 자동 변경되지 않습니다.
enum Flavor { dev, stage, prod }

class AppConfig {
  final Flavor flavor;
  final String appName;
  final String baseUrl;
  final bool enableAnalytics;
  final bool enableBetaFeature;

  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.enableAnalytics,
    required this.enableBetaFeature,
  });

  factory AppConfig.dev() => const AppConfig(
    flavor: Flavor.dev,
    appName: 'Flutter Base (Dev)',
    baseUrl: 'https://cece2bee-5679-4c18-819c-4d8fdbbd3189.mock.pstmn.io',
    enableAnalytics: false,
    enableBetaFeature: true,
  );

  factory AppConfig.stage() => const AppConfig(
    flavor: Flavor.stage,
    appName: 'Flutter Base (Stage)',
    baseUrl: 'https://stage.api.example.com',
    enableAnalytics: true,
    enableBetaFeature: true,
  );

  factory AppConfig.prod() => const AppConfig(
    flavor: Flavor.prod,
    appName: 'Flutter Base',
    baseUrl: 'https://api.example.com',
    enableAnalytics: true,
    enableBetaFeature: false,
  );

  AppConfig.fromEnv()
    : flavor = _readFlavorFromEnv(),
      appName = const String.fromEnvironment(
        'APP_NAME',
        defaultValue: 'Flutter Base App',
      ),
      baseUrl = const String.fromEnvironment(
        'BASE_URL',
        defaultValue:
            'https://cece2bee-5679-4c18-819c-4d8fdbbd3189.mock.pstmn.io',
      ),
      enableAnalytics = const bool.fromEnvironment(
        'ENABLE_ANALYTICS',
        defaultValue: false,
      ),
      enableBetaFeature = const bool.fromEnvironment(
        'ENABLE_BETA_FEATURE',
        defaultValue: true,
      );

  AppConfig copyWith({
    Flavor? flavor,
    String? appName,
    String? baseUrl,
    bool? enableAnalytics,
    bool? enableBetaFeature,
  }) {
    return AppConfig(
      flavor: flavor ?? this.flavor,
      appName: appName ?? this.appName,
      baseUrl: baseUrl ?? this.baseUrl,
      enableAnalytics: enableAnalytics ?? this.enableAnalytics,
      enableBetaFeature: enableBetaFeature ?? this.enableBetaFeature,
    );
  }

  static Flavor _readFlavorFromEnv() {
    final value =
        const String.fromEnvironment(
          'FLAVOR',
          defaultValue: 'dev',
        ).toLowerCase();
    switch (value) {
      case 'prod':
        return Flavor.prod;
      case 'stage':
        return Flavor.stage;
      case 'dev':
      default:
        return Flavor.dev;
    }
  }

  @override
  int get hashCode =>
      Object.hash(flavor, appName, baseUrl, enableAnalytics, enableBetaFeature);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppConfig &&
        other.flavor == flavor &&
        other.appName == appName &&
        other.baseUrl == baseUrl &&
        other.enableAnalytics == enableAnalytics &&
        other.enableBetaFeature == enableBetaFeature;
  }

  @override
  String toString() {
    return 'AppConfig(flavor: $flavor, appName: $appName, baseUrl: $baseUrl, '
        'enableAnalytics: $enableAnalytics, enableBetaFeature: $enableBetaFeature)';
  }
}
