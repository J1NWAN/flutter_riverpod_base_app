import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'chart_data.dart';

class AppLineChart extends StatelessWidget {
  const AppLineChart({required this.data, super.key});

  final ChartData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = theme.extension<AppTokens>()!;
    final textTheme = theme.textTheme;

    final spots =
        data.lineSeries
            .map(
              (series) => LineChartBarData(
                spots: [for (var index = 0; index < series.values.length; index++) FlSpot(index.toDouble(), series.values[index])],
                isCurved: series.curved,
                color: series.color,
                barWidth: series.strokeWidth,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [series.color.withOpacity(0.2), series.color.withOpacity(0.05)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            )
            .toList();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: data.xAxisLabels.length - 1,
        lineBarsData: spots,
        gridData: FlGridData(
          show: true,
          horizontalInterval: tokens.gapMedium,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(color: theme.colorScheme.outlineVariant.withOpacity(0.3), strokeWidth: 1),
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
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4), width: 1.5),
            left: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4), width: 1.5),
            top: BorderSide.none,
            right: BorderSide.none,
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: tokens.radiusSmall.topLeft.x,
            tooltipPadding: EdgeInsets.all(tokens.gapSmall),
            getTooltipColor: (spot) =>
                theme.colorScheme.surface.withOpacity(0.9),
            tooltipBorder: BorderSide(
              color: theme.colorScheme.outlineVariant.withOpacity(0.3),
            ),
            getTooltipItems: (spots) => spots
                .map(
                  (spot) => LineTooltipItem(
                    '${data.xAxisLabels[spot.x.toInt()]}: ${spot.y.toStringAsFixed(1)}',
                    textTheme.bodyMedium!,
                    textAlign: TextAlign.left,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
