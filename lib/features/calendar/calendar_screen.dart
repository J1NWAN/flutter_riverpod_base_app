import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../calendar/app_calendar.dart';
import '../../providers/calendar_provider.dart';
import '../../theme/tokens.dart';
import '../../ui/scaffold.dart';
import '../../ui/navigation/app_destinations.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(calendarEventsProvider);
    final tokens = Theme.of(context).extension<AppTokens>()!;

    return AppScaffold(
      title: 'Calendar',
      destinations: appDestinations,
      currentIndex: 1,
      onDestinationSelected: (index) {
        if (index == 1) {
          return;
        }
        context.go(appDestinations[index].route);
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
