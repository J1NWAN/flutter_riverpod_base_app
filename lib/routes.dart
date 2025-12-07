class AppRoutes {
  const AppRoutes._();

  static const main = '/';
  static const dashboard = '/dashboard';
  static const calendar = '/calendar';
  static const component = '/component';
  static const search = '/search';

  // 인증 관련 라우트
  static const login = '/auth/login';
  static const signup = '/auth/signup';

  // 설정 관련 라우트
  static const setting = '/setting';
  static const theme = '/setting/theme';
}
