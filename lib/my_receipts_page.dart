import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendsmart/receipt_page.dart';
import 'package:spendsmart/utils/transitions.dart';
import 'full_image.dart';
import 'package:spendsmart/services/firestore.dart';
import 'package:spendsmart/services/auth.dart';
import 'models/receipt.dart';

class MyReceiptsPage extends StatefulWidget {
  const MyReceiptsPage({super.key});

  @override
  State<MyReceiptsPage> createState() => _MyReceiptsPageState();
}

class _MyReceiptsPageState extends State<MyReceiptsPage> {
  Card getCard(Receipt receipt) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receipt.businessName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    receipt.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat(
                      'MMMM d, y, h:mm a',
                    ).format(DateTime.parse(receipt.date).toLocal()),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₱${receipt.totalPrice}",
                  style: const TextStyle(fontFamily: 'Roboto', fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "press to see receipt",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiaryFixedDim,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget noReceipts() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: Theme.of(context).colorScheme.secondary,
            size: 50,
          ),
          Text(
            "You currently have no receipts.",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget getLoading() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          LoadingAnimationWidget.hexagonDots(color: Colors.white, size: 20),
          Text(
            "Fetching your receipts from the database",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  late String? userId;
  late Stream<QuerySnapshot> receiptStream;
  @override
  void initState() {
    super.initState();
    userId = AuthService.auth.currentUser?.uid;
    final receiptsRef = FirestoreService.db
        .collection("users")
        .doc(userId)
        .collection("receipts")
        .orderBy("date", descending: true);
    receiptStream = receiptsRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: receiptStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return getLoading();
        }

        if (snapshot.data!.docs.isEmpty) {
          return noReceipts();
        }

        return Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 20, top: 30, bottom: 10),
              child: Text(
                "My Receipts",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children:
                    snapshot.data!.docs
                        .map((DocumentSnapshot document) {
                          Receipt receipt = Receipt.fromMap(
                            document.data()! as Map<String, dynamic>,
                            id: document.id,
                          );
                          return InkWell(
                            child: getCard(receipt),
                            onTap:
                                () => {
                                  Navigator.push(
                                    context,
                                    createRoute(
                                      ReceiptPage(
                                        receipt: receipt,
                                        isEditable: false,
                                      ),
                                    ),
                                  ),
                                },
                          );
                        })
                        .toList()
                        .cast(),
              ),
            ),
          ],
        );
      },
    );
  }
}
