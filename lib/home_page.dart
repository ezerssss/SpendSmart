import 'package:flutter/material.dart';
import 'package:spendsmart/my_receipts_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                child: const Text("Home"),
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
        body: TabBarView(children: [Text("SpendSmart"), MyReceiptsPage()]),
      ),
    );
  }
}
