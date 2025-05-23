import 'dart:io';

import 'package:flutter/material.dart';

class ProcessingReceiptPage extends StatefulWidget {
  const ProcessingReceiptPage({super.key, required this.uri});

  final String uri;

  @override
  State<ProcessingReceiptPage> createState() => _ProcessingReceiptPageState();
}

class _ProcessingReceiptPageState extends State<ProcessingReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.file(File(this.widget.uri), height: 500)),
    );
  }
}
