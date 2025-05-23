import 'package:flutter/material.dart';
import 'package:spendsmart/login_page.dart';
import 'package:spendsmart/styles.dart';
import 'services/firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
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
      home: const LoginPage(),
    );
  }
}
