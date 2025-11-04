import 'package:flutter/material.dart';

class ChartData {
  const ChartData({
    required this.xAxisLabels,
    this.lineSeries = const [],
    this.barSeries = const [],
  });

  final List<String> xAxisLabels;
  final List<LineSeries> lineSeries;
  final List<BarSeries> barSeries;

  bool get hasLineSeries => lineSeries.isNotEmpty;
  bool get hasBarSeries => barSeries.isNotEmpty;
}

class LineSeries {
  const LineSeries({
    required this.id,
    required this.color,
    required this.values,
    this.curved = true,
    this.strokeWidth = 3,
  });

  final String id;
  final Color color;
  final List<double> values;
  final bool curved;
  final double strokeWidth;
}

class BarSeries {
  const BarSeries({
    required this.id,
    required this.color,
    required this.values,
    this.radius,
  });

  final String id;
  final Color color;
  final List<double> values;
  final BorderRadius? radius;
}
