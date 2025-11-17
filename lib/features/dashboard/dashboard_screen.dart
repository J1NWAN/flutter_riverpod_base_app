import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../chart/bar_chart.dart';
import '../../chart/line_chart.dart';
import '../../core/app_config_provider.dart';
import '../../providers/chart_provider.dart';
import '../../core/token/app_tokens.dart';
import '../../ui/card.dart';
import '../../ui/scaffold.dart';
import '../../ui/navigation/app_destinations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartData = ref.watch(chartDataProvider);
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final config = ref.watch(appConfigProvider);

    return AppScaffold(
      title: 'Dashboard',
      destinations: appDestinations,
      currentIndex: 1,
      onDestinationSelected: (index) {
        if (index == 1) {
          return;
        }
        context.go(appDestinations[index].route);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Environment',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Gap(tokens.gapSmall),
                  Text(
                    'Flavor: ${config.flavor.name.toUpperCase()}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Gap(tokens.gapSmall / 2),
                  Text(
                    'Base URL: ${config.baseUrl}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Gap(tokens.gapSmall / 2),
                  Text(
                    'Analytics: ${config.enableAnalytics ? 'Enabled' : 'Disabled'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Gap(tokens.gapLarge),
            Wrap(
              spacing: tokens.gapMedium,
              runSpacing: tokens.gapMedium,
              children:
                  [
                        _StatCard(
                          title: 'Active Users',
                          value: '1,240',
                          trendLabel: '+12% vs last week',
                        ),
                        _StatCard(
                          title: 'Conversion Rate',
                          value: '3.4%',
                          trendLabel: '+0.8% vs last month',
                        ),
                        _StatCard(
                          title: 'Support Tickets',
                          value: '32',
                          trendLabel: '-5 open tickets',
                        ),
                      ]
                      .animate(interval: tokens.fastAnimation)
                      .fadeIn(duration: tokens.fastAnimation)
                      .slideY(
                        begin: 0.15,
                        duration: tokens.normalAnimation,
                        curve: Curves.easeOut,
                      )
                      .toList(),
            ),
            Gap(tokens.gapXLarge),
            AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Performance Overview',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Gap(tokens.gapMedium),
                      SizedBox(
                        height: tokens.gapXLarge * 5,
                        child: AppLineChart(data: chartData),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: tokens.fastAnimation)
                .slideY(
                  begin: 0.1,
                  duration: tokens.normalAnimation,
                  curve: Curves.easeOut,
                ),
            Gap(tokens.gapXLarge),
            AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Revenue Breakdown',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Gap(tokens.gapMedium),
                      SizedBox(
                        height: tokens.gapXLarge * 5,
                        child: AppBarChart(data: chartData),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: tokens.fastAnimation)
                .slideY(
                  begin: 0.1,
                  duration: tokens.normalAnimation,
                  curve: Curves.easeOut,
                ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.trendLabel,
  });

  final String title;
  final String value;
  final String trendLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final theme = Theme.of(context);
    final width = tokens.navigationRailWidth;

    return SizedBox(
      width: width,
      child: AppCard(
        padding: EdgeInsets.all(tokens.gapLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            Gap(tokens.gapSmall),
            Text(value, style: theme.textTheme.headlineMedium),
            Gap(tokens.gapSmall),
            Text(
              trendLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
