import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../calendar/app_calendar.dart';
import '../../providers/calendar_provider.dart';
import '../../routes.dart';
import '../../theme/tokens.dart';
import '../../ui/scaffold.dart';

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

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(calendarEventsProvider);
    final tokens = Theme.of(context).extension<AppTokens>()!;

    return AppScaffold(
      title: 'Calendar',
      destinations: _destinations,
      currentIndex: 1,
      onDestinationSelected: (index) {
        if (index == 1) {
          return;
        }
        context.go(_destinations[index].route);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: tokens.gapXLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [AppCalendar(events: events), Gap(tokens.gapXLarge)],
          ),
        ),
      ),
    );
  }
}
