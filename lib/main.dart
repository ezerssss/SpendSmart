import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/firebase_options.dart';
import 'package:spendsmart/home_page.dart';
import 'package:spendsmart/login_page.dart';
import 'package:spendsmart/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    final profile =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

    AppState().currentUser.value = profile.data() ?? {};
  }

  runApp(const SpendSmart());
}

class SpendSmart extends StatelessWidget {
  const SpendSmart({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppState().currentUser,
      builder: (context, user, _) {
        return MaterialApp(
          title: 'Spend Smart',
          theme: AppThemes.theme,
          debugShowCheckedModeBanner: false,
          home: user.isNotEmpty ? const HomePage() : const LoginPage(),
        );
      },
    );
  }
}
