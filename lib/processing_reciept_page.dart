import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:async';

enum ProcessingStates { uploading, analyzing, success, error }

class ProcessingReceiptPage extends StatefulWidget {
  const ProcessingReceiptPage({super.key, required this.uri});

  final String uri;

  @override
  State<ProcessingReceiptPage> createState() => _ProcessingReceiptPageState();
}

class _ProcessingReceiptPageState extends State<ProcessingReceiptPage> {
  ProcessingStates currentState = ProcessingStates.uploading;

  @override
  void initState() {
    super.initState();

    Timer(
      Duration(seconds: 3),
      () => setState(() {
        currentState = ProcessingStates.analyzing;
      }),
    );
  }

  Widget getScreen() {
    switch (currentState) {
      case ProcessingStates.uploading:
        return LoaderScreens(
          loader: LoadingAnimationWidget.hexagonDots(
            color: Theme.of(context).colorScheme.secondary,
            size: 100,
          ),
          title: "Uploading Your Receipt",
          description:
              "We’re securely sending your receipt to our servers. Hang tight — this won’t take long.",
        );
      case ProcessingStates.analyzing:
        return LoaderScreens(
          loader: LoadingAnimationWidget.flickr(
            leftDotColor: Theme.of(context).colorScheme.secondary,
            rightDotColor: Theme.of(context).colorScheme.primary,
            size: 100,
          ),
          title: "Analyzing Your Receipt",
          description:
              "Our AI is reading your receipt line by line to extract items, prices, and more.",
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getScreen());
  }
}

class LoaderScreens extends StatelessWidget {
  const LoaderScreens({
    super.key,
    required this.loader,
    required this.title,
    required this.description,
  });

  final Widget loader;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: loader),
        SizedBox(height: 40),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 350,
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
