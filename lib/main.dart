import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spendsmart/firebase_options.dart';
import 'package:spendsmart/login_page.dart';
import 'package:spendsmart/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
