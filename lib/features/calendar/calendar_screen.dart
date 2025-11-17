import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../calendar/app_calendar.dart';
import '../../core/app_config_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../core/token/app_tokens.dart';
import '../../ui/scaffold.dart';
import '../../ui/navigation/app_destinations.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(calendarEventsProvider);
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final config = ref.watch(appConfigProvider);

    return AppScaffold(
      title: 'Calendar',
      destinations: appDestinations,
      currentIndex: 2,
      onDestinationSelected: (index) {
        if (index == 2) {
          return;
        }
        context.go(appDestinations[index].route);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: tokens.gapXLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Current API: ${config.baseUrl}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Gap(tokens.gapMedium),
              AppCalendar(events: events),
              Gap(tokens.gapXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
