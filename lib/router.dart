import 'package:flutter/material.dart';
import 'package:flutter_riverpod_base_app/features/component/component_screen.dart';
import 'package:flutter_riverpod_base_app/features/settings/open_soucre_license/open_source_license_screen.dart';
import 'package:flutter_riverpod_base_app/features/settings/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/calendar/calendar_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/notification/notification_screen.dart';
import 'features/search/search_screen.dart';
import 'features/main/main_screen.dart';
import 'features/settings/setting_screen.dart';
import 'features/theme/theme_screen.dart';
import 'routes.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.main,
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.calendar,
        name: 'calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: AppRoutes.component,
        name: 'component',
        builder: (context, state) => const ComponentScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.setting,
        name: 'setting',
        builder: (context, state) => const SettingScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.theme,
        name: 'theme',
        builder: (context, state) => const ThemeScreen(),
      ),
      GoRoute(
        path: AppRoutes.notification,
        name: 'notification',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.openSourceLicense,
        name: 'open-source-license',
        builder: (context, state) => const OpenSourceLicenseScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
    ],
  );
}
