import 'package:flutter/material.dart';
import 'package:spendsmart/components/analytics/expenditure/expenditure_line_chart.dart';

class ExpenditureHolder extends StatelessWidget {
  final ExpenditureLineChart chart;

  const ExpenditureHolder({super.key, required this.chart});

  @override
  Widget build(BuildContext context) {
    return (Padding(padding: EdgeInsets.all(20), child: chart));
  }
}
