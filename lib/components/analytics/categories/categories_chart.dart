import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/components/analytics/categories/legend_row.dart';
import 'package:spendsmart/components/analytics/period_enum.dart';
import 'package:spendsmart/errors/auth.dart';
import 'package:spendsmart/services/auth.dart';
import 'package:spendsmart/services/firestore.dart';
import 'package:spendsmart/styles.dart';

class CategoriesChart extends StatefulWidget {
  const CategoriesChart({super.key});

  @override
  State<CategoriesChart> createState() => _CategoriesChartState();
}

class _CategoriesChartState extends State<CategoriesChart> {
  PeriodEnum selectedPeriod = PeriodEnum.week;
  bool isVerticalLayout = false;
  int touchedIndex = -1;

  Map<String, double> data = {};

  final List<Color> colorPalette = [
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

  @override
  void initState() {
    super.initState();

    loadReceipts();
  }

  void onPeriodChanged(PeriodEnum period) {
    setState(() {
      selectedPeriod = period;
    });
    loadReceipts();
  }

  double get periodTotal => data.values.fold(0.0, (sum, price) => sum + price);

  Future<void> loadReceipts() async {
    final user = AppState().currentUser.value;

    if (user.isEmpty) {
      throw NoUser();
    }

    final receipts = await FirestoreService.getReceipts(user['uid'] as String);
    final dateToday = DateTime.now();
    late DateTime startDate;

    switch (selectedPeriod) {
      case PeriodEnum.month:
        startDate = DateTime(dateToday.year, dateToday.month, 1);
        break;
      case PeriodEnum.year:
        startDate = DateTime(dateToday.year, 1, 1);
        break;
      default:
        final weekDay = dateToday.weekday;
        startDate = dateToday.subtract(Duration(days: weekDay - 1));
        break;
    }

    final Map<String, double> sums = {};
    for (final receipt in receipts) {
      final dt = DateTime.parse(receipt.date);
      if (dt.isBefore(startDate)) continue;
      sums[receipt.category] =
          (sums[receipt.category] ?? 0) + receipt.totalPrice;
    }

    setState(() {
      data = sums;
      touchedIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();
    final horizontalCount = min(entries.length, 4);

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.heavyImpact();
        setState(() => isVerticalLayout = !isVerticalLayout);
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.onBlack,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Spendings',
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
                  onSelected: onPeriodChanged,
                  itemBuilder:
                      (_) =>
                          PeriodEnum.values
                              .map(
                                (p) => PopupMenuItem(
                                  value: p,
                                  child: Text(p.periodLabel),
                                ),
                              )
                              .toList(),
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
              padding: const EdgeInsets.only(left: 8.0, top: 1.5),
              child: Text(
                'PHP ${periodTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (!isVerticalLayout) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 40),
                    child: SizedBox(
                      width: 180,
                      height: 180 / 1.3,
                      child: buildPieChart(entries),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 40),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: List.generate(horizontalCount, (i) {
                          return LegendRow(
                            color: getColorForIndex(i),
                            text: entries[i].key,
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 180, child: buildPieChart(entries)),
                  const SizedBox(height: 16),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12.0,
                      runSpacing: 8.0,
                      children: List.generate(entries.length, (i) {
                        return LegendRow(
                          color: getColorForIndex(i),
                          text: entries[i].key,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],

            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.border,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isVerticalLayout
                        ? 'Long press to reduce'
                        : 'Long press to see other categories',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.onWhite),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPieChart(List<MapEntry<String, double>> entries) {
    return PieChart(
      PieChartData(
        borderData: FlBorderData(show: false),
        sectionsSpace: 3,
        centerSpaceRadius: 30,
        pieTouchData: PieTouchData(
          touchCallback: (event, resp) {
            setState(() {
              if (resp == null ||
                  resp.touchedSection == null ||
                  !event.isInterestedForInteractions) {
                touchedIndex = -1;
              } else {
                touchedIndex = resp.touchedSection!.touchedSectionIndex;
              }
            });
          },
        ),
        sections: getSections(entries),
      ),
    );
  }

  List<PieChartSectionData> getSections(
    List<MapEntry<String, double>> entries,
  ) {
    return List.generate(entries.length, (i) {
      final raw = entries[i].value;
      final percent = periodTotal > 0 ? (raw / periodTotal) * 100 : 0.0;
      final isTouched = i == touchedIndex;
      return PieChartSectionData(
        color: getColorForIndex(i),
        value: raw,
        title: '${percent.toStringAsFixed(0)}%',
        radius: isTouched ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: isTouched ? 18 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Color getColorForIndex(int index) {
    return colorPalette[index % colorPalette.length];
  }
}
