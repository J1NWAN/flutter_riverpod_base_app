import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base_app/core/app_config.dart';
import 'package:flutter_riverpod_base_app/core/app_config_provider.dart';
import 'package:flutter_riverpod_base_app/core/token/app_tokens.dart';
import 'package:flutter_riverpod_base_app/ui/button.dart';
import 'package:flutter_riverpod_base_app/ui/card.dart';
import 'package:flutter_riverpod_base_app/ui/navigation/app_destinations.dart';
import 'package:flutter_riverpod_base_app/ui/scaffold.dart';
import 'package:flutter_riverpod_base_app/ui/search_bar.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final configController = ref.read(appConfigProvider.notifier);
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final theme = Theme.of(context);

    return AppScaffold(
      centerTitle: true,
      title: '메인 화면',
      leading: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
      showDefaultSearchAction: true,
      showDefaultSettingsAction: true,

      destinations: appDestinations,
      currentIndex: 0,
      onDestinationSelected: (index) {
        if (index == 0) {
          return;
        }
        context.go(appDestinations[index].route);
      },
      child: ListView(
        children: [
          Gap(tokens.gapLarge),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '현재 환경구성: ${config.flavor.name.toUpperCase()}',
                  style: theme.textTheme.titleMedium,
                ),
                Gap(tokens.gapSmall),
                Text(
                  'BASE URL: ${config.baseUrl}',
                  style: theme.textTheme.bodyMedium,
                ),
                Gap(tokens.gapSmall),
                Text(
                  '분석 기능: ${config.enableAnalytics ? '활성화' : '비활성화'}',
                  style: theme.textTheme.bodySmall,
                ),
                Gap(tokens.gapSmall),
                Text(
                  '베타 기능: ${config.enableBetaFeature ? '활성화' : '비활성화'}',
                  style: theme.textTheme.bodySmall,
                ),
                Gap(tokens.gapLarge),
                Text('런타임 환경 전환 (개발용)', style: theme.textTheme.labelMedium),
                Gap(tokens.gapSmall),
                Wrap(
                  spacing: tokens.gapSmall,
                  runSpacing: tokens.gapSmall,
                  children: [
                    AppButton.secondary(
                      label: 'Dev',
                      onPressed: () => configController.setFlavor(Flavor.dev),
                    ),
                    AppButton.secondary(
                      label: 'Stage',
                      onPressed: () => configController.setFlavor(Flavor.stage),
                    ),
                    AppButton.secondary(
                      label: 'Prod',
                      onPressed: () => configController.setFlavor(Flavor.prod),
                    ),
                    AppButton.text(
                      label:
                          config.enableAnalytics
                              ? 'Analytics 비활성화'
                              : 'Analytics 활성화',
                      onPressed:
                          () => configController.setAnalytics(
                            !config.enableAnalytics,
                          ),
                    ),
                    AppButton.text(
                      label: config.enableBetaFeature ? '베타 기능 끄기' : '베타 기능 켜기',
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
          Gap(tokens.gapLarge),
        ],
      ),
    );
  }
}
