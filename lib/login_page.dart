import 'dart:developer';

import 'package:flutter/material.dart';
import 'services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ValueNotifier userCredential = ValueNotifier('');
  final authService = AuthService();

  Future<void> signIn() async {
    userCredential.value = await authService.signInWithGoogle();
    if (userCredential.value != null) {
      log(userCredential.value.user!.email);
    }
  }

  Future<void> signOut() async {
    bool result = await authService.signOutFromGoogle();
    if (result) {
      userCredential.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: userCredential,
        builder: (context, value, child) {
          return (userCredential.value == '' || userCredential.value == null)
              ? Center(
                child: ElevatedButton.icon(
                  icon: SizedBox(
                    width: 20,
                    child: Image.asset('assets/google_icon.png'),
                  ),
                  onPressed: signIn,
                  label: Text("Log in with Google"),
                ),
              )
              : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1.5, color: Colors.black54),
                      ),
                      child: Image.network(
                        userCredential.value.user!.photoURL.toString(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(userCredential.value.user!.displayName.toString()),
                    const SizedBox(height: 20),
                    Text(userCredential.value.user!.email.toString()),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: signOut,
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
        },
      ),
    );
  }
}
