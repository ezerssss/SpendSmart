import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uri = "";

  Future<void> handleScan() async {
    dynamic scannedReceipt;

    try {
      scannedReceipt =
          await FlutterDocScanner().getScanDocumentsUri(page: 1) ??
          'Unknown platform documents';
    } on PlatformException {
      scannedReceipt = 'Failed to get scanned documents.';
    }

    if (scannedReceipt is Map) {
      setState(() {
        uri = scannedReceipt['Uri']
            .toString()
            .split("file://")[1]
            .replaceAll("}]", "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SpendSmart")),
      body: ListView(
        children: [
          ElevatedButton.icon(
            onPressed: handleScan,
            icon: Icon(Icons.receipt),
            label: Text("Scan Receipt"),
          ),
          uri.length > 0 ? Expanded(child: Image.file(File(uri))) : Container(),
        ],
      ),
    );
  }
}
