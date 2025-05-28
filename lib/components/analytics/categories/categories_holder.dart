// Updated CategoriesHolder with AppColors applied to chart and legend colors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendsmart/components/analytics/categories/legend_row.dart';
import 'package:spendsmart/styles.dart';
import 'categories_chart.dart';

class CategoriesHolder extends StatefulWidget {
  final CategoriesChart chart;

  const CategoriesHolder({super.key, required this.chart});

  @override
  State<CategoriesHolder> createState() => _CategoriesHolderState();
}

class _CategoriesHolderState extends State<CategoriesHolder> {
  String selectedPeriod = 'THIS MONTH';
  bool isVerticalLayout = false;

  final Map<String, String> dummyAmounts = {
    'THIS MONTH': 'PHP 1,000',
    'THIS WEEK': 'PHP 250',
    'THIS YEAR': 'PHP 12,000',
  };

  List<String> categoryLabels = [
    'Grocery',
    'Restaurant',
    'Fast Food',
    'Cafe',
    'Retail',
    'Pharmacy',
    'Gas Station',
    'Electronics',
    'Clothing',
    'Home Improvement',
    'Office Supplies',
    'Bookstore',
    'Bakery',
    'Liquor Store',
    'Convenience Store',
  ];

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.heavyImpact();
        setState(() => isVerticalLayout = !isVerticalLayout);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Categories',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: AppColors.white),
                      color: AppColors.black,
                      onSelected: (value) {
                        setState(() {
                          selectedPeriod = value.toUpperCase();
                        });
                      },
                      itemBuilder:
                          (item) => [
                            const PopupMenuItem(
                              value: 'This Month',
                              child: Text("This Month"),
                            ),
                            const PopupMenuItem(
                              value: 'This Week',
                              child: Text('This Week'),
                            ),
                            const PopupMenuItem(
                              value: 'This Year',
                              child: Text('This Year'),
                            ),
                          ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    selectedPeriod,
                    style: const TextStyle(
                      color: AppColors.onWhite,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 1.5),
                  child: Text(
                    dummyAmounts[selectedPeriod] ?? '',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (!isVerticalLayout)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 40),
                        child: SizedBox(
                          width: 180,
                          height: 180 / 1.3,
                          child: widget.chart,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 40),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: const [
                              LegendRow(
                                color: AppColors.primary,
                                text: 'Grocery',
                              ),
                              LegendRow(
                                color: AppColors.secondary,
                                text: 'Restaurant',
                              ),
                              LegendRow(
                                color: AppColors.accent,
                                text: 'Fast Food',
                              ),
                              LegendRow(
                                color: AppColors.success,
                                text: 'Others',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 180, child: widget.chart),
                      const SizedBox(height: 16),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12.0,
                          runSpacing: 8.0,
                          children: List.generate(
                            categoryLabels.length,
                            (i) => LegendRow(
                              color: colorPalette[i % colorPalette.length],
                              text: categoryLabels[i],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                        style: TextStyle(
                          color: AppColors.onWhite.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
