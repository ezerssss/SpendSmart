import 'package:flutter/material.dart';
import 'package:spendsmart/components/analytics/categories/categories_holder.dart';
import 'package:spendsmart/processing_reciept_page.dart';
import 'package:spendsmart/services/openai.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            bottomNavIndex == 0
                ? Column(
                  children: [
                    ElevatedButton(onPressed: signOut, child: Text("Sign out")),
                    SizedBox(
                      child: CategoriesHolder(chart: const CategoriesChart()),
                    ),
                  ],
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
