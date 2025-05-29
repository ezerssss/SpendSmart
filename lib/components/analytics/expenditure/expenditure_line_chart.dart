import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendsmart/styles.dart';

class ExpenditureLineChart extends StatefulWidget {

  const ExpenditureLineChart({super.key});

  @override
  State<ExpenditureLineChart> createState() => _ExpenditureLineState();

}

class _ExpenditureLineState extends State<ExpenditureLineChart>{

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


  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AspectRatio(aspectRatio: 1.3, );
  }
}
