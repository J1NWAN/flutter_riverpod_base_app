import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'chart_data.dart';

class AppBarChart extends StatelessWidget {
  const AppBarChart({required this.data, super.key});

  final ChartData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final textTheme = theme.textTheme;

    final groups = <BarChartGroupData>[];
    for (var index = 0; index < data.xAxisLabels.length; index++) {
      final rods = <BarChartRodData>[];
      for (final series in data.barSeries) {
        final radius = series.radius?.resolve(TextDirection.ltr) ?? BorderRadius.circular(tokens.gapSmall);
        rods.add(
          BarChartRodData(
            toY: series.values[index],
            color: series.color,
            width: tokens.gapSmall * 1.5,
            borderRadius: radius,
            gradient: LinearGradient(
              colors: [series.color.withOpacity(0.9), series.color.withOpacity(0.5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );
      }

      groups.add(BarChartGroupData(x: index, barRods: rods, barsSpace: tokens.gapSmall));
    }

    return BarChart(
      BarChartData(
        barGroups: groups,
        gridData: FlGridData(
          show: true,
          horizontalInterval: tokens.gapMedium,
          getDrawingHorizontalLine: (value) => FlLine(color: theme.colorScheme.outlineVariant.withOpacity(0.25), strokeWidth: 1),
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4), width: 1.5),
            left: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4), width: 1.5),
            top: BorderSide.none,
            right: BorderSide.none,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: tokens.gapXLarge,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= data.xAxisLabels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: EdgeInsets.only(top: tokens.gapSmall),
                  child: Text(data.xAxisLabels[index], style: textTheme.labelMedium),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: tokens.gapXLarge,
              getTitlesWidget:
                  (value, meta) => Padding(
                    padding: EdgeInsets.only(right: tokens.gapSmall),
                    child: Text(value.toStringAsFixed(0), style: textTheme.labelMedium),
                  ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: EdgeInsets.all(tokens.gapSmall),
            getTooltipColor: (group) =>
                theme.colorScheme.surface.withOpacity(0.95),
            tooltipBorder: BorderSide(
              color: theme.colorScheme.outlineVariant.withOpacity(0.3),
            ),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final series = data.barSeries[rodIndex];
              final label = data.xAxisLabels[group.x.toInt()];
              return BarTooltipItem('${series.id}\n$label: ${rod.toY.toStringAsFixed(1)}', textTheme.bodyMedium!);
            },
          ),
        ),
      ),
    );
  }
}
