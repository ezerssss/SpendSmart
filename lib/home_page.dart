import 'package:flutter/material.dart';
import 'package:spendsmart/accordion_message.dart';
import 'package:spendsmart/my_receipts_page.dart';
import 'package:spendsmart/app_state.dart';
import 'package:spendsmart/login_page.dart';
import 'package:spendsmart/services/auth.dart';
import 'package:spendsmart/utils/transitions.dart';

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

  final message =
      "You tend to spend more with Yakult. It seems that you are addicted to it. It can be observed that the Yakult in Green Ribbon is much cheaper than the one in Mercury Drug Store. Perhaps you can try changing where you buy the Yakult.";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("SpendSmart"),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabAlignment: TabAlignment.fill,
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Colors.white,
            tabs: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 30,
                ),
                child: Text("SpendSmart"),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 30,
                ),
                child: const Text("My Receipts"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Text("SpendSmart"),
                ElevatedButton(onPressed: signOut, child: Text("Sign out")),
                AcccordionMessage(
                  query: "How do I save my money with groceries?",
                  message: message + message + message + message + message,
                ),
                AcccordionMessage(
                  query: "Where do I spend my money the most?",
                  message: message,
                ),
                AcccordionMessage(query: "Any other tips?", message: message),
              ],
            ),
            MyReceiptsPage(),
          ],
        ),
      ),
    );
  }
}
