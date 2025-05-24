import 'package:flutter/material.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/home_page.dart';
import 'package:spendsmart/on_boarding_page.dart';
import 'services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();

  Future<void> signIn() async {
    AppState().currentUser.value = await authService.signInWithGoogle();

    if (!mounted) return;

    if (AppState().currentUser.value["isOnboarded"]) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomePage(),
        ),
      );
    } else {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const OnBoardingPage(),
        ),
      );
    }
  }

  Future<void> signOut() async {
    bool result = await authService.signOutFromGoogle();
    if (result) {
      AppState().currentUser.value = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: AppState().currentUser,
        builder: (context, user, _) {
          return Center(
            child: ElevatedButton.icon(
              icon: SizedBox(
                width: 20,
                child: Image.asset('assets/google_icon.png'),
              ),
              onPressed: signIn,
              label: Text("Log in with Google"),
            ),
          );
        },
      ),
    );
  }
}
