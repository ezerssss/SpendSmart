import 'package:flutter/material.dart';
import 'package:spendsmart/models/receipt.dart';
import 'package:spendsmart/components/receipt_form.dart';
import 'package:spendsmart/utils/transitions.dart';

class ReceiptPage extends StatelessWidget {
  final Receipt receipt;
  final bool isEditable;

  const ReceiptPage({super.key, required this.receipt, this.isEditable = true});

  void handleReceiptSubmit(Receipt receipt) {
    print('Received receipt from form: $receipt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Receipt Details"),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ReceiptRevealAnimation(
              child: ReceiptForm(
                isEditable: isEditable,
                receipt: receipt,
                onSubmit: handleReceiptSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
