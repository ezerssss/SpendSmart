import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';

class MyReceiptsPage extends StatefulWidget {
  const MyReceiptsPage({super.key});

  @override
  State<MyReceiptsPage> createState() => _MyReceiptsPageState();
}

class MockData {
  static String receiptName = "Merchant Store";
  static DateTime date = DateTime.now();
  static double totalSpent = 1000;
}

class _MyReceiptsPageState extends State<MyReceiptsPage> {
  Card getCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
      ),
      margin: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(MockData.receiptName),
                Text(DateFormat('MMMM d, y, h:mm a').format(MockData.date)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text(
                  "₱${MockData.totalSpent}",
                  style: TextStyle(fontFamily: 'Roboto'),
                ),
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

  var mockReceipts = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      mockReceipts = [...mockReceipts, '$i'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return mockReceipts.isEmpty
        ? noReceipts()
        : ListView.builder(
          itemCount: mockReceipts.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: InkWell(
                child: getCard(),
                onTap:
                    () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return FullReceiptImage();
                          },
                        ),
                      ),
                    },
              ),
            );
          },
        );
  }
}

class FullReceiptImage extends StatefulWidget {
  const FullReceiptImage({super.key});

  @override
  State<FullReceiptImage> createState() => _FullReceiptImageState();
}

class _FullReceiptImageState extends State<FullReceiptImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: NetworkImage("https://picsum.photos/200/300"),
      ),
    );
  }
}
