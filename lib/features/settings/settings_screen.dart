import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_config.dart';
import '../../core/app_config_provider.dart';
import '../../core/formatters.dart';
import '../../providers/theme_provider.dart';
import '../../routes.dart';
import '../../core/token/app_tokens.dart';
import '../../ui/button.dart';
import '../../ui/app_dialog.dart';
import '../../ui/app_toast.dart';
import '../../ui/card.dart';
import '../../ui/scaffold.dart';
import '../../ui/text_field.dart';
import '../../ui/navigation/app_destinations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _handleResetTheme(BuildContext context, WidgetRef ref) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: '테마 초기화',
      message: '테마를 기본값으로 되돌릴까요?',
      confirmText: '초기화',
      cancelText: '취소',
      barrierDismissible: true,
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      ref.read(themeControllerProvider.notifier).setMode(ThemeMode.system);
      await AppToast.show(
        context,
        message: '시스템 테마로 되돌렸어요.',
        type: AppToastType.info,
        position: AppToastPosition.bottom,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final configController = ref.read(appConfigProvider.notifier);
    final themeState = ref.watch(themeControllerProvider);
    final themeMode = themeState.mode;
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'Settings',
      destinations: appDestinations,
      currentIndex: 4,
      onDestinationSelected: (index) {
        if (index == 4) {
          return;
        }
        context.go(appDestinations[index].route);
      },
      child: ListView(
        padding: EdgeInsets.only(bottom: tokens.gapXLarge),
        children: [
          Padding(
            padding: EdgeInsets.all(tokens.gapLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Appearance', style: theme.textTheme.titleLarge),
                Gap(tokens.gapMedium),
                SegmentedButton<ThemeMode>(
                  style: ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(
                        horizontal: tokens.gapLarge,
                        vertical: tokens.gapSmall,
                      ),
                    ),
                  ),
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('System'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Light'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (selection) {
                    final mode = selection.first;
                    ref.read(themeControllerProvider.notifier).setMode(mode);
                  },
                ),
                Gap(tokens.gapXLarge),
                Text('Components preview', style: theme.textTheme.titleLarge),
                Gap(tokens.gapMedium),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Typography', style: theme.textTheme.titleMedium),
                      Gap(tokens.gapSmall),
                      Text(
                        'Headline Medium',
                        style: theme.textTheme.headlineMedium,
                      ),
                      Gap(tokens.gapSmall),
                      Text(
                        'Body Medium sample text for preview purposes.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Gap(tokens.gapLarge),
                      Text('Buttons', style: theme.textTheme.titleMedium),
                      Gap(tokens.gapSmall),
                      Wrap(
                        spacing: tokens.gapSmall,
                        runSpacing: tokens.gapSmall,
                        children: [
                          AppButton.primary(
                            label: 'Primary',
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            onPressed: () {
                              _handleResetTheme(context, ref);
                            },
                          ),
                          AppButton.secondary(
                            label: 'Secondary',
                            backgroundColor: theme.colorScheme.secondary,
                            foregroundColor: theme.colorScheme.onSecondary,
                          ),
                          AppButton.text(
                            label: 'Text',
                            foregroundColor: Colors.blue,
                          ),
                          AppButton.danger(
                            label: 'Danger',
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                            onPressed: () {
                              AppToast.show(
                                context,
                                message: '오류가 발생했습니다.',
                                type: AppToastType.error,
                                position: AppToastPosition.top,
                                background: theme.colorScheme.error,
                                foreground: theme.colorScheme.onError,
                              );
                            },
                          ),
                        ],
                      ),
                      Gap(tokens.gapLarge),
                      Text('Input', style: theme.textTheme.titleMedium),
                      Gap(tokens.gapSmall),
                      const AppTextField(label: 'Label', hint: 'Placeholder'),
                      Gap(tokens.gapSmall),
                      Text(1234567.8.comma()),
                      Gap(tokens.gapSmall),
                      Text(DateTime(2024, 2, 3).ymd),
                      Gap(tokens.gapSmall),
                      Text(DateTime(2024, 2, 3, 9, 15).ymdHms),
                      Gap(tokens.gapSmall),
                      Text(DateTime(2024, 2, 3).ymdDot),
                      Gap(tokens.gapSmall),
                      Text(DateTime(2025, 2, 3).relativeFrom(DateTime.now())),
                    ],
                  ),
                ),
                Gap(tokens.gapXLarge),
                Text('Environment', style: theme.textTheme.titleLarge),
                Gap(tokens.gapMedium),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current flavor: ${config.flavor.name.toUpperCase()}',
                        style: theme.textTheme.titleMedium,
                      ),
                      Gap(tokens.gapSmall),
                      Text(
                        'Base URL: ${config.baseUrl}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      Gap(tokens.gapSmall),
                      Text(
                        'Analytics: ${config.enableAnalytics ? 'Enabled' : 'Disabled'}',
                        style: theme.textTheme.bodySmall,
                      ),
                      Gap(tokens.gapSmall),
                      Text(
                        'Beta feature: ${config.enableBetaFeature ? 'Enabled' : 'Disabled'}',
                        style: theme.textTheme.bodySmall,
                      ),
                      Gap(tokens.gapLarge),
                      Text(
                        'Runtime override (development only)',
                        style: theme.textTheme.labelMedium,
                      ),
                      Gap(tokens.gapSmall),
                      Wrap(
                        spacing: tokens.gapSmall,
                        runSpacing: tokens.gapSmall,
                        children: [
                          AppButton.secondary(
                            label: 'Dev',
                            onPressed:
                                () => configController.setFlavor(Flavor.dev),
                          ),
                          AppButton.secondary(
                            label: 'Stage',
                            onPressed:
                                () => configController.setFlavor(Flavor.stage),
                          ),
                          AppButton.secondary(
                            label: 'Prod',
                            onPressed:
                                () => configController.setFlavor(Flavor.prod),
                          ),
                          AppButton.text(
                            label:
                                config.enableAnalytics
                                    ? 'Disable Analytics'
                                    : 'Enable Analytics',
                            onPressed:
                                () => configController.setAnalytics(
                                  !config.enableAnalytics,
                                ),
                          ),
                          AppButton.text(
                            label:
                                config.enableBetaFeature
                                    ? 'Disable Beta'
                                    : 'Enable Beta',
                            onPressed:
                                () => configController.setBeta(
                                  !config.enableBetaFeature,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gap(tokens.gapXLarge),
                Text('계정', style: theme.textTheme.titleLarge),
                Gap(tokens.gapMedium),
                Wrap(
                  spacing: tokens.gapSmall,
                  runSpacing: tokens.gapSmall,
                  children: [
                    AppButton.primary(
                      label: '로그인 화면 보기',
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      onPressed: () => context.go(AppRoutes.login),
                    ),
                    AppButton.secondary(
                      label: '회원가입 화면 보기',
                      onPressed: () => context.go(AppRoutes.signup),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
