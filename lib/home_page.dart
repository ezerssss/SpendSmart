import 'package:flutter/material.dart';
import 'package:spendsmart/components/analytics/expenditure/expenditure_holder.dart';
import 'package:spendsmart/components/analytics/expenditure/expenditure_line_chart.dart';
import 'package:spendsmart/components/home/accordion_message.dart';
import 'package:spendsmart/constants/receipt.dart';
import 'package:spendsmart/processing_reciept_page.dart';
import 'package:spendsmart/receipt_page.dart';
import 'package:spendsmart/services/firestore.dart';
import 'package:spendsmart/utils/scanner.dart';
import 'package:spendsmart/my_receipts_page.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/login_page.dart';
import 'package:spendsmart/services/auth.dart';
import 'package:spendsmart/styles.dart';
import 'package:spendsmart/utils/transitions.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:spendsmart/components/analytics/categories/categories_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> handleScan() async {
    String uri = await ScannerUtils.scanReceipt();

    if (uri.isNotEmpty && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessingReceiptPage(uri: uri),
        ),
      );
    }
  }

  Future<void> signOut() async {
    bool result = await AuthService.signOutFromGoogle();
    if (result) {
      AppState().currentUser.value = {};
    }

    if (!mounted) return;

    Navigator.pushReplacement(context, createRoute(LoginPage()));
  }

  int bottomNavIndex = 0;
  final List<IconData> iconList = [
    Icons.home_rounded,
    Icons.receipt_long_rounded,
  ];

  String budgetString = "0";

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Budget'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'PHP 0.00',
              labelText: 'Monthly Budget',
            ),
            initialValue:
                AppState().currentUser.value['monthlyBudget']?.toString() ??
                '0',
            onChanged: (value) {
              setState(() {
                budgetString = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Set'),
              onPressed: () async {
                await FirestoreService.saveMonthlyBudget(
                  int.parse(budgetString),
                );
                AppState().currentUser.value["monthlyBudget"] = int.parse(
                  budgetString,
                );
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            bottomNavIndex == 0
                ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hello, ${AppState().currentUser.value["displayName"].split(' ')[0] ?? "User"}!",
                              style: const TextStyle(
                                color: AppColors.secondary,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _dialogBuilder(context),
                                  style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                  ),
                                  child: Text(
                                    "Set budget",
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: signOut,
                                  style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(horizontal: 12),
                                    ),
                                  ),
                                  child: Text(
                                    "Log out",
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(child: const CategoriesChart()),
                      SizedBox(
                        child: ExpenditureHolder(
                          chart: const ExpenditureLineChart(),
                        ),
                      ),
                      AcccordionMessage(query: "Where Am I Overspending?"),
                      AcccordionMessage(
                        query: "How Can I Improve My Budgeting?",
                      ),
                      AcccordionMessage(query: "What Are My Spending Trends?"),
                      AcccordionMessage(
                        query: "Money-Saving Suggestions for This Week",
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                )
                : MyReceiptsPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: handleScan,
        shape: const CircleBorder(),
        backgroundColor: AppColors.secondary,
        child: Icon(Icons.camera_alt, color: AppColors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        activeIndex: bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) => setState(() => bottomNavIndex = index),
        tabBuilder: (int index, bool isActive) {
          return Icon(
            iconList[index],
            size: 26,
            color: isActive ? AppColors.secondary : AppColors.black,
          );
        },
      ),
    );
  }
}
