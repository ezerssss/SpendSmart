import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:spendsmart/processing_reciept_page.dart';
import 'package:spendsmart/utils/scanner.dart';
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
  Future<void> handleScan() async {
    dynamic scannerResult;

    try {
      scannerResult =
          await FlutterDocScanner().getScanDocumentsUri(page: 1) ??
          'Unknown platform documents';
    } on PlatformException {
      scannerResult = 'Failed to get scanned documents.';
    }

    if (scannerResult is Map) {
      String uri = ScannerUtils.extractFileUri(scannerResult["Uri"].toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessingReceiptPage(uri: uri),
        ),
      );
    }
  }

  Future<void> signOut() async {
    bool result = await AuthService.signOutFromGoogle();
    if (result) {
      AppState().currentUser.value = {};
    }

    if (!mounted) return;

    Navigator.pushReplacement(context, createRoute(LoginPage()));
  }

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
                ElevatedButton(onPressed: signOut, child: Text("Sign out")),
                ElevatedButton.icon(
                  onPressed: handleScan,
                  icon: Icon(Icons.receipt),
                  label: Text("Scan Receipt"),
                ),
              ],
            ),
            MyReceiptsPage(),
          ],
        ),
      ),
    );
  }
}
