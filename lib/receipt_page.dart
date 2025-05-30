import 'package:flutter/material.dart';
import 'package:spendsmart/models/receipt.dart';
import 'package:spendsmart/styles.dart';
import 'package:spendsmart/components/receipt_form.dart'; // adjust import
import 'package:spendsmart/utils/transitions.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Item> sampleItems = List.generate(
      3,
      (index) => Item(
        name: "Item $index",
        quantity: 1 + index,
        price: 50 * (index + 1),
      ),
    );

    final Receipt sampleReceipt = Receipt(
      businessName: "Merchant Store",
      category: "Restaurant",
      items: sampleItems,
      date: DateTime.now().toIso8601String(),
      imageUrl: "",
      totalPrice: 0,
    );

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
              child: ReceiptForm(isEditable: true, receipt: sampleReceipt),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
