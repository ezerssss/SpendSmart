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
    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign-in failed. Please try again.")),
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
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 300),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "SpendSmart",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        "Snap receipts. Track spending. Spend smarter.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 200),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: SizedBox(
                        width: 20,
                        child: Image.asset('assets/google_icon.png'),
                      ),
                      onPressed: signIn,
                      label: Text(
                        "Sign in with Google",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
