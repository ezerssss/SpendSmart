import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendsmart/components/analytics/expenditure/axis_builder.dart';
import 'package:spendsmart/components/analytics/period_enum.dart';
import 'package:spendsmart/styles.dart';

class ExpenditureLineChart extends StatefulWidget {
  const ExpenditureLineChart({super.key});

  @override
  State<ExpenditureLineChart> createState() => _ExpenditureLineState();
}

class _ExpenditureLineState extends State<ExpenditureLineChart> {
  List<Color> colorPalette = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.success,
    AppColors.danger,
    AppColors.onWhite,
    AppColors.onBlack,
    AppColors.white,
    AppColors.border,
    AppColors.primary,
    AppColors.secondary,
    AppColors.accent,
    AppColors.success,
    AppColors.danger,
    AppColors.onWhite,
  ];

  PeriodEnum selectedPeriod = PeriodEnum.week;

  final Map<PeriodEnum, String> dummyAmounts = <PeriodEnum, String>{
    PeriodEnum.week: 'PHP 250',
    PeriodEnum.month: 'PHP 1,000',
    PeriodEnum.year: 'PHP 12,000',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 1.5),
              child: Text(
                dummyAmounts[selectedPeriod] ?? '',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            PopupMenuButton<PeriodEnum>(
              icon: const Icon(Icons.more_vert, color: AppColors.white),
              color: AppColors.black,
              onSelected: (period) {
                setState(() {
                  selectedPeriod = period;
                });
              },
              itemBuilder:
                  (_) =>
                      PeriodEnum.values.map((p) {
                        return PopupMenuItem(
                          value: p,
                          child: Text(p.periodLabel),
                        );
                      }).toList(),
            ),
          ],
        ),
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(getChartData()),
          ),
        ),
      ],
    );
  }

  LineChartData getChartData() {
    switch (selectedPeriod) {
      case PeriodEnum.month:
        return monthlyData();
      case PeriodEnum.year:
        return yearlyData();
      default:
        return weeklyData();
    }
  }

  LineChartData weeklyData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: AxisTitleBuilder.buildX,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: AxisTitleBuilder.buildY,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          gradient: LinearGradient(
            colors: [
              ColorTween(
                begin: colorPalette[0],
                end: colorPalette[1],
              ).lerp(0.2)!,
              ColorTween(
                begin: colorPalette[0],
                end: colorPalette[1],
              ).lerp(0.2)!,
            ],
          ),
          isCurved: true,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(
                  begin: colorPalette[0],
                  end: colorPalette[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
                ColorTween(
                  begin: colorPalette[0],
                  end: colorPalette[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData monthlyData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: AxisTitleBuilder.buildX,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: AxisTitleBuilder.buildY,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(
                begin: colorPalette[0],
                end: colorPalette[1],
              ).lerp(0.2)!,
              ColorTween(
                begin: colorPalette[0],
                end: colorPalette[1],
              ).lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(
                  begin: colorPalette[0],
                  end: colorPalette[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
                ColorTween(
                  begin: colorPalette[0],
                  end: colorPalette[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  LineChartData yearlyData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Color(0xff37434d), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: AxisTitleBuilder.buildX,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: AxisTitleBuilder.buildY,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          gradient: LinearGradient(
            colors: [
              ColorTween(
                begin: colorPalette[0],
                end: colorPalette[1],
              ).lerp(0.2)!,
              ColorTween(
                begin: colorPalette[0],
                end: colorPalette[1],
              ).lerp(0.2)!,
            ],
          ),
          isCurved: true,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(
                  begin: colorPalette[0],
                  end: colorPalette[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
                ColorTween(
                  begin: colorPalette[0],
                  end: colorPalette[1],
                ).lerp(0.2)!.withValues(alpha: 0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
