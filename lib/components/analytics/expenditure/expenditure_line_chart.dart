import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/components/analytics/period_enum.dart';
import 'package:spendsmart/errors/auth.dart';
import 'package:spendsmart/services/firestore.dart';
import 'package:spendsmart/styles.dart';
import 'dart:math';

class ExpenditureLineChart extends StatefulWidget {
  const ExpenditureLineChart({super.key});

  @override
  State<ExpenditureLineChart> createState() => _ExpenditureLineState();
}

class _ExpenditureLineState extends State<ExpenditureLineChart> {
  List<Color> colorPalette = [AppColors.primary, AppColors.secondary];
  List<FlSpot> weeklySpots = [];
  List<FlSpot> monthlySpots = [];
  List<FlSpot> yearlySpots = [];

  Map<PeriodEnum, double> periodTotals = {
    PeriodEnum.week: 0,
    PeriodEnum.month: 0,
    PeriodEnum.year: 0,
  };

  PeriodEnum selectedPeriod = PeriodEnum.week;

  double monthlyBudget = 0;

  @override
  void initState() {
    super.initState();
    loadReceipts();
  }

  Future<void> loadReceipts() async {
    final user = AppState().currentUser.value;
    if (user.isEmpty) throw NoUser();
    monthlyBudget = (user['monthlyBudget'] as num).toDouble();
    final userId = user['uid'] as String;
    final receipts = await FirestoreService.getReceipts(userId);
    final dateToday = DateTime.now();

    final weeklySum = List.filled(7, 0.0);
    final weekStart = dateToday.subtract(Duration(days: dateToday.weekday - 1));
    for (var receipt in receipts) {
      final dt = DateTime.parse(receipt.date);
      if (dt.isBefore(weekStart)) continue;
      final i = dt.weekday - 1;
      weeklySum[i] += receipt.totalPrice;
    }
    weeklySpots = [
      for (var i = 0; i < weeklySum.length; i++)
        FlSpot(i.toDouble(), weeklySum[i]),
    ];
    periodTotals[PeriodEnum.week] = weeklySum.fold(0, (a, b) => a + b);
    final daysInMonth = DateUtils.getDaysInMonth(
      dateToday.year,
      dateToday.month,
    );
    final monthlySum = List.filled(daysInMonth, 0.0);
    final monthStart = DateTime(dateToday.year, dateToday.month, 1);
    for (var receipt in receipts) {
      final dt = DateTime.parse(receipt.date);
      if (dt.isBefore(monthStart)) continue;
      monthlySum[dt.day - 1] += receipt.totalPrice;
    }
    monthlySpots = [
      for (var i = 0; i < monthlySum.length; i++)
        FlSpot(i.toDouble(), monthlySum[i]),
    ];
    periodTotals[PeriodEnum.month] = monthlySum.fold(0, (a, b) => a + b);
    final yearlySum = List.filled(12, 0.0);
    final yearStart = DateTime(dateToday.year, 1, 1);
    for (var receipt in receipts) {
      final dt = DateTime.parse(receipt.date);
      if (dt.isBefore(yearStart)) continue;
      yearlySum[dt.month - 1] += receipt.totalPrice;
    }
    yearlySpots = [
      for (var i = 0; i < yearlySum.length; i++)
        FlSpot(i.toDouble(), yearlySum[i]),
    ];
    periodTotals[PeriodEnum.year] = yearlySum.fold(0, (a, b) => a + b);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final periodTotal = '₱ ${periodTotals[selectedPeriod]!.toStringAsFixed(2)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Spending Trends',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
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
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4),
          child: Text(
            selectedPeriod.periodLabel,
            style: const TextStyle(color: AppColors.onWhite, fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 1.5, bottom: 10),
          child: Text(
            periodTotal,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 30,
              left: 1,
              top: 22,
              bottom: 8,
            ),
            child: LineChart(getChartData()),
          ),
        ),
      ],
    );
  }

  LineChartData getChartData() {
    final budgetLine = HorizontalLine(
      y: monthlyBudget,
      color: colorPalette[0],
      strokeWidth: 2,
      dashArray: [6, 3],
    );
    switch (selectedPeriod) {
      case PeriodEnum.month:
        return baseLineData(
          monthlySpots,
          monthlySpots.length - 1,
          disableTouch: true,
          horizontalLines: [budgetLine],
        );
      case PeriodEnum.year:
        return baseLineData(
          yearlySpots,
          11,
          xTicks: 2,
          horizontalLines: [budgetLine],
        );
      default:
        return baseLineData(weeklySpots, 6, horizontalLines: [budgetLine]);
    }
  }

  LineChartData baseLineData(
    List<FlSpot> spots,
    double maxX, {
    bool disableTouch = false,
    int xTicks = 3,
    int yTicks = 4,
    List<HorizontalLine> horizontalLines = const [],
  }) {
    final rawSpotMax =
        spots.isEmpty ? 0.0 : spots.map((s) => s.y).reduce((a, b) => max(a, b));

    final rawLineMax =
        horizontalLines.isEmpty
            ? 0.0
            : horizontalLines.map((h) => h.y).reduce((a, b) => max(a, b));

    final rawMaxY = max(rawSpotMax, rawLineMax);

    final maxY = rawMaxY * 1.1;

    final yInterval = (maxY > 0 && yTicks > 0) ? maxY / yTicks : 1.0;
    final xInterval = (maxX > 0 && xTicks > 1) ? maxX / (xTicks - 1) : 1.0;
    Widget buildXLabel(double value, TitleMeta meta) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      String text = '';

      switch (selectedPeriod) {
        case PeriodEnum.week:
          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          if (value.toInt() < days.length) {
            text = days[value.toInt()];
          }
          break;

        case PeriodEnum.month:
          if ((value / xInterval).roundToDouble() == value / xInterval) {
            final day = value.toInt() + 1;
            final now = DateTime.now();
            final monthName = months[now.month - 1];
            text = '$monthName $day';
          }
          break;

        case PeriodEnum.year:
          if (value.toInt() < months.length) {
            text = months[value.toInt()];
          }
          break;
      }

      return SideTitleWidget(
        meta: meta,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    Widget buildYLabel(double value, TitleMeta meta) {
      const style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.white,
      );
      if ((value / yInterval).roundToDouble() == value / yInterval) {
        if (value >= 1000) {
          final kVal = value / 1000;
          final digits = (kVal % 1 == 0) ? 0 : 1;
          final label = kVal.toStringAsFixed(digits);
          return SideTitleWidget(
            meta: meta,
            child: Text('${label}K', style: style),
          );
        } else {
          return SideTitleWidget(
            meta: meta,
            child: Text(value.toInt().toString(), style: style),
          );
        }
      }
      return SideTitleWidget(meta: meta, child: Text('', style: style));
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        drawHorizontalLine: true,
        verticalInterval: xInterval,
        horizontalInterval: yInterval,
        getDrawingHorizontalLine:
            (v) => FlLine(color: const Color(0xff37434d), strokeWidth: 1),
        getDrawingVerticalLine:
            (v) => FlLine(color: const Color(0xff37434d), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: xInterval,
            reservedSize: 30,
            getTitlesWidget: (v, meta) => buildXLabel(v, meta),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: yInterval,
            reservedSize: 42,
            getTitlesWidget: (v, meta) => buildYLabel(v, meta),
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
      maxX: maxX,
      minY: 0,
      maxY: maxY,
      lineTouchData:
          disableTouch
              ? const LineTouchData(enabled: false)
              : const LineTouchData(),
      extraLinesData: ExtraLinesData(horizontalLines: horizontalLines),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
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
