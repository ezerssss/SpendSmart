import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendsmart/components/processing_receipt/loader_screen.dart';
import 'dart:async';

import 'package:spendsmart/components/processing_receipt/result_screen.dart';
import 'package:spendsmart/errors/auth.dart';
import 'package:spendsmart/errors/network.dart';
import 'package:spendsmart/services/storage.dart';

enum ProcessingStates { uploading, analyzing, success, error }

class ProcessingReceiptPage extends StatefulWidget {
  const ProcessingReceiptPage({super.key, required this.uri});

  final String uri;

  @override
  State<ProcessingReceiptPage> createState() => _ProcessingReceiptPageState();
}

class _ProcessingReceiptPageState extends State<ProcessingReceiptPage> {
  ProcessingStates currentState = ProcessingStates.uploading;
  String errorMsg =
      "We couldn’t process your receipt this time. Please try again or choose a clearer image.";
  String imageUrl = "";

  Future<void> uploadReceipt() async {
    try {
      final url = await StorageService.uploadImage(widget.uri);
      setState(() {
        imageUrl = url;
        currentState = ProcessingStates.analyzing;
      });
    } on NoUser {
      setState(() {
        errorMsg =
            "You need to be logged in to continue. Please sign in and try again.";
        currentState = ProcessingStates.error;
      });
    } on NoNetwork {
      setState(() {
        errorMsg =
            "No internet connection detected. Please check your connection and try again.";
        currentState = ProcessingStates.error;
      });
    } on Exception catch (e) {
      print(e);
      setState(() {
        errorMsg = "Something went wrong on our end. Please try again shortly.";
        currentState = ProcessingStates.error;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    uploadReceipt();
  }

  @override
  void didUpdateWidget(covariant ProcessingReceiptPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    switch (currentState) {
      case ProcessingStates.uploading:
        uploadReceipt();
        break;
      case ProcessingStates.analyzing:
        print("Analyzing");
      case ProcessingStates.success:
        print("Success");
      case ProcessingStates.error:
        print("Error");
    }
  }

  Widget getScreen() {
    switch (currentState) {
      case ProcessingStates.uploading:
        return LoaderScreen(
          icon: LoadingAnimationWidget.hexagonDots(
            color: Theme.of(context).colorScheme.secondary,
            size: 100,
          ),
          title: "Uploading Your Receipt",
          description:
              "We’re securely sending your receipt to our servers. Hang tight — this won’t take long.",
        );
      case ProcessingStates.analyzing:
        return LoaderScreen(
          icon: LoadingAnimationWidget.flickr(
            leftDotColor: Theme.of(context).colorScheme.secondary,
            rightDotColor: Theme.of(context).colorScheme.primary,
            size: 100,
          ),
          title: "Analyzing Your Receipt",
          description:
              "Our AI is reading your receipt line by line to extract items, prices, and more.",
        );
      case ProcessingStates.success:
        return ResultScreen(
          isSuccess: true,
          title: "Your Receipt is Ready!",
          description:
              "We’ve extracted your receipt info. Make any necessary edits to ensure accuracy before saving.",
        );
      case ProcessingStates.error:
        return ResultScreen(
          isSuccess: false,
          title: "Oops, Something Went Wrong",
          description: errorMsg,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getScreen());
  }
}
