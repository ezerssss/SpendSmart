import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoriesChart extends StatefulWidget {
  const CategoriesChart({super.key});

  @override
  State<CategoriesChart> createState() => CategoriesChartState();
}

class CategoriesChartState extends State<CategoriesChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: PieChart(
        PieChartData(
          borderData: FlBorderData(show: false),
          sectionsSpace: 3,
          centerSpaceRadius: 30,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sections: getCategorySections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> getCategorySections() {
    final data = <String, double>{
      'Grocery': 10,
      'Restaurant': 10,
      'Fast Food': 7,
      'Cafe': 6,
      'Retail': 8,
      'Pharmacy': 7,
      'Gas Station': 6,
      'Electronics': 5,
      'Clothing': 6,
      'Home Improvement': 8,
      'Office Supplies': 5,
      'Bookstore': 3,
      'Bakery': 3,
      'Liquor Store': 3,
      'Convenience Store': 3,
    };

    int i = 0;
    return data.entries.map((entry) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 60 : 50;
      final double fontSize = isTouched ? 18 : 12;

      final section = PieChartSectionData(
        color: _colorForIndex(i),
        value: entry.value,
        title: '${entry.value.toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
      i++;
      return section;
    }).toList();
  }

  Color _colorForIndex(int index) {
    const palette = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.indigo,
      Colors.lime,
      Colors.brown,
      Colors.deepPurple,
      Colors.lightBlue,
    ];
    return palette[index % palette.length];
  }
}
