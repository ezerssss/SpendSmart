import 'dart:async';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class AcccordionMessage extends StatefulWidget {
  final String query;
  const AcccordionMessage({super.key, required this.query});
  @override
  State<AcccordionMessage> createState() => _AccordionMessageState();
}

class _AccordionMessageState extends State<AcccordionMessage>
    with TickerProviderStateMixin {
  late String message = "";
  late bool isFetching = false;
  late bool hasFetched = false;
  late Timer timer = Timer(Duration(seconds: 0), () {});
  void fetchResponse() {
    timer = Timer(Duration(seconds: 4), () {
      setState(() {
        message = "test message";
        isFetching = false;
        hasFetched = true;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      title: Text(widget.query),
      borderRadius: const BorderRadius.all(Radius.zero),
      shadowColor: Colors.transparent,
      onExpansionChanged: (isExpanded) {
        if (isExpanded && !hasFetched) {
          setState(() {
            isFetching = true;
          });
          fetchResponse();
        }
      },
      children: <Widget>[
        const Divider(thickness: 1.0, height: 1.0),
        isFetching
            ? Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Please wait while the AI is analyzing your data  ",
                      style: TextStyle(fontSize: 16),
                    ),
                    LoadingAnimationWidget.hexagonDots(
                      color: Colors.white,
                      size: 12,
                    ),
                  ],
                ),
              ),
            )
            : Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(message, style: TextStyle(fontSize: 16)),
              ),
            ),
      ],
    );
  }
}
