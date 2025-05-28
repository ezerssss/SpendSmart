import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:spendsmart/processing_reciept_page.dart';
import 'dart:async';

import 'package:spendsmart/styles.dart';
import 'package:spendsmart/utils/scanner.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.description,
  });

  final bool isSuccess;
  final String title;
  final String description;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confetti;

  @override
  void initState() {
    super.initState();

    _confetti = ConfettiController(duration: const Duration(seconds: 2));

    if (widget.isSuccess) {
      _confetti.play();

      Timer(Duration(seconds: 2), () {});
    }
  }

  @override
  void dispose() {
    super.dispose();

    _confetti.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 50,
            shouldLoop: false,
            minBlastForce: 10,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 50,
            shouldLoop: false,
            minBlastForce: 10,
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ShakeWidget(
                duration: Duration(seconds: 2),
                autoPlay: !widget.isSuccess,
                shakeConstant: ShakeLittleConstant1(),
                child: Icon(
                  widget.isSuccess ? Icons.check_circle_rounded : Icons.error,
                  size: 100,
                  color:
                      widget.isSuccess
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.error,
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              widget.title,
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
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),

        !widget.isSuccess ? RetakePhotoButtons() : Container(),
      ],
    );
  }
}

class RetakePhotoButtons extends StatelessWidget {
  const RetakePhotoButtons({super.key});

  void handleRetakePhoto(BuildContext context) async {
    String uri = await ScannerUtils.scanReceipt();

    if (uri.isNotEmpty && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProcessingReceiptPage(uri: uri),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                handleRetakePhoto(context);
              },
              child: Text(
                "Retake Photo",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: 110),
        ],
      ),
    );
  }
}
