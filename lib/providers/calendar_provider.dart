import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../calendar/calendar_event.dart';

part 'calendar_provider.g.dart';

@riverpod
Map<DateTime, List<CalendarEvent>> calendarEvents(CalendarEventsRef ref) {
  final now = DateTime.now();
  final today = DateUtils.dateOnly(now);
  final tomorrow = DateUtils.dateOnly(now.add(const Duration(days: 1)));
  final nextWeek = DateUtils.dateOnly(now.add(const Duration(days: 7)));

  return {
    today: [
      CalendarEvent(
        start: DateTime(now.year, now.month, now.day, 9, 0),
        end: DateTime(now.year, now.month, now.day, 10, 0),
        title: 'Team Standup',
        color: const Color(0xFF1B998B),
      ),
      CalendarEvent(
        start: DateTime(now.year, now.month, now.day, 14, 0),
        end: DateTime(now.year, now.month, now.day, 15, 0),
        title: 'Product Review',
        color: const Color(0xFF4A6572),
      ),
    ],
    tomorrow: [
      CalendarEvent(
        start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 11, 0),
        end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 12, 0),
        title: 'Client Demo',
        color: const Color(0xFFEDAE49),
      ),
    ],
    nextWeek: [
      CalendarEvent(
        start: DateTime(nextWeek.year, nextWeek.month, nextWeek.day, 13, 0),
        end: DateTime(nextWeek.year, nextWeek.month, nextWeek.day, 16, 0),
        title: 'Roadmap Workshop',
        color: const Color(0xFFD64550),
      ),
    ],
  };
}
