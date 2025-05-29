import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';

class AxisTitleBuilder {
  static SideTitleWidget buildX(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    final label = {2: 'MAR', 5: 'JUN', 8: 'SEP'}[value.toInt()] ?? '';
    return SideTitleWidget(meta: meta, child: Text(label, style: style));
  }

  static SideTitleWidget buildY(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
    final label = {1: '10K', 3: '30K', 5: '50K'}[value.toInt()] ?? '';
    return SideTitleWidget(meta: meta, child: Text(label, style: style));
  }
}
