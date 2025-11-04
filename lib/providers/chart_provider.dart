import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../chart/chart_data.dart';

part 'chart_provider.g.dart';

@riverpod
ChartData chartData(ChartDataRef ref) {
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  return const ChartData(
    xAxisLabels: labels,
    lineSeries: [
      LineSeries(
        id: 'Sessions',
        color: Color(0xFF4A6572),
        values: [120, 150, 170, 160, 180, 210, 190],
      ),
      LineSeries(
        id: 'Signups',
        color: Color(0xFF1B998B),
        values: [20, 24, 22, 30, 32, 28, 35],
        strokeWidth: 4,
      ),
    ],
    barSeries: [
      BarSeries(
        id: 'Revenue',
        color: Color(0xFFEDAE49),
        values: [12, 14, 13, 16, 18, 22, 20],
      ),
      BarSeries(
        id: 'Expenses',
        color: Color(0xFFD64550),
        values: [8, 9, 8, 9, 10, 12, 11],
      ),
    ],
  );
}
