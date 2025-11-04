import 'package:flutter/material.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.start,
    required this.end,
    required this.title,
    required this.color,
  });

  final DateTime start;
  final DateTime end;
  final String title;
  final Color color;
}
