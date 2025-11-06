import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base_app/core/formatters.dart';
import 'package:flutter_riverpod_base_app/ui/app_dialog.dart';
import 'package:flutter_riverpod_base_app/ui/app_toast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../providers/theme_provider.dart';
import '../../routes.dart';
import '../../theme/tokens.dart';
import '../../ui/button.dart';
import '../../ui/app_dialog.dart';
import '../../ui/app_toast.dart';
import '../../ui/card.dart';
import '../../ui/scaffold.dart';
import '../../ui/text_field.dart';

const _destinations = [
  AppDestination(
    label: 'Dashboard',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    route: AppRoutes.dashboard,
  ),
  AppDestination(
    label: 'Calendar',
    icon: Icons.event_note_outlined,
    selectedIcon: Icons.event_note,
    route: AppRoutes.calendar,
  ),
  AppDestination(
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    route: AppRoutes.settings,
  ),
];

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
      ref.read(themeControllerProvider.notifier).setThemeMode(ThemeMode.system);
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
    final themeMode = ref.watch(themeControllerProvider);
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'Settings',
      destinations: _destinations,
      currentIndex: 2,
      onDestinationSelected: (index) {
        if (index == 2) {
          return;
        }
        context.go(_destinations[index].route);
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
                    ref
                        .read(themeControllerProvider.notifier)
                        .setThemeMode(mode);
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
                                type: AppToastType.success,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
