import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullReceiptImage extends StatefulWidget {
  final String imageUrl;
  const FullReceiptImage({super.key, required this.imageUrl});
  @override
  State<FullReceiptImage> createState() => _FullReceiptImageState();
}

class _FullReceiptImageState extends State<FullReceiptImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(imageProvider: NetworkImage(widget.imageUrl)),
    );
  }
}
