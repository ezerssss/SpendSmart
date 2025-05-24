import 'package:flutter/material.dart';
import 'package:spendsmart/home_page.dart';
import 'package:spendsmart/on_boarding_page.dart';
import 'package:spendsmart/styles.dart';
import 'my_receipts_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SpendSmart());
}

class SpendSmart extends StatelessWidget {
  const SpendSmart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spend Smart',
      theme: AppThemes.theme,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
