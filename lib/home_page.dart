import 'package:flutter/material.dart';
import 'package:spendsmart/my_receipts_page.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/login_page.dart';
import 'package:spendsmart/services/auth.dart';
import 'package:spendsmart/styles.dart';
import 'package:spendsmart/utils/transitions.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    Text("SpendSmart"),
                    ElevatedButton(onPressed: signOut, child: Text("Sign out")),
                  ],
                )
                : MyReceiptsPage(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: AppColors.secondary,
        child: Icon(Icons.add_rounded, color: AppColors.black),
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
