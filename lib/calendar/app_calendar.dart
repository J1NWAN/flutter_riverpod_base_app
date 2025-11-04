import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';

import '../theme/tokens.dart';
import 'calendar_event.dart';

class AppCalendar extends StatefulWidget {
  const AppCalendar({
    required this.events,
    super.key,
  });

  final Map<DateTime, List<CalendarEvent>> events;

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late final Map<DateTime, List<CalendarEvent>> _eventMap;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateUtils.dateOnly(_focusedDay);
    _eventMap = LinkedHashMap<DateTime, List<CalendarEvent>>(
      equals: isSameDay,
      hashCode: (date) =>
          DateTime(date.year, date.month, date.day).millisecondsSinceEpoch,
    );

    widget.events.forEach((key, value) {
      final normalized = DateUtils.dateOnly(key);
      final existing = _eventMap[normalized] ?? <CalendarEvent>[];
      _eventMap[normalized] = [...existing, ...value];
    });
  }

  List<CalendarEvent> _eventsForDay(DateTime day) {
    return _eventMap[DateUtils.dateOnly(day)] ?? const [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final textTheme = theme.textTheme;

    final selectedEvents =
        _selectedDay != null ? _eventsForDay(_selectedDay!) : const <CalendarEvent>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TableCalendar<CalendarEvent>(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarFormat: CalendarFormat.month,
          eventLoader: _eventsForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = DateUtils.dateOnly(selectedDay);
              _focusedDay = focusedDay;
            });
          },
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: textTheme.titleMedium!,
            leftChevronIcon: Icon(
              Icons.chevron_left,
              size: tokens.gapLarge,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              size: tokens.gapLarge,
            ),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.15),
              borderRadius: tokens.radiusMedium,
            ),
            selectedDecoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: tokens.radiusMedium,
            ),
            selectedTextStyle: textTheme.bodyMedium!.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
            todayTextStyle: textTheme.bodyMedium!,
            markersMaxCount: 3,
            markersAlignment: Alignment.bottomCenter,
            markerDecoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: tokens.radiusSmall,
            ),
          ),
          calendarBuilders: CalendarBuilders<CalendarEvent>(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.only(bottom: tokens.gapSmall / 2),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: tokens.gapSmall / 2,
                  children: events
                      .take(3)
                      .map(
                        (event) => Container(
                          width: tokens.gapSmall,
                          height: tokens.gapSmall,
                          decoration: BoxDecoration(
                            color: event.color,
                            borderRadius: tokens.radiusSmall,
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ),
        Gap(tokens.gapLarge),
        Text(
          'Events',
          style: textTheme.titleMedium,
        ),
        Gap(tokens.gapMedium),
        if (selectedEvents.isEmpty)
          Container(
            padding: EdgeInsets.all(tokens.gapLarge),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
              borderRadius: tokens.radiusMedium,
            ),
            child: Text(
              'No events scheduled.',
              style: textTheme.bodyMedium,
            ),
          )
        else
          ...selectedEvents.map(
            (event) => Container(
              margin: EdgeInsets.only(bottom: tokens.gapSmall),
              padding: EdgeInsets.all(tokens.gapMedium),
              decoration: BoxDecoration(
                color: event.color.withOpacity(0.15),
                borderRadius: tokens.radiusMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: textTheme.titleSmall,
                  ),
                  Gap(tokens.gapSmall / 2),
                  Text(
                    '${TimeOfDay.fromDateTime(event.start).format(context)} - ${TimeOfDay.fromDateTime(event.end).format(context)}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
