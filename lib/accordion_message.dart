import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class AcccordionMessage extends StatefulWidget {
  final String query;
  final String message;
  const AcccordionMessage({
    super.key,
    required this.query,
    required this.message,
  });
  @override
  State<AcccordionMessage> createState() => _AccordionMessageState();
}

class _AccordionMessageState extends State<AcccordionMessage>
    with TickerProviderStateMixin {
  late String message = "";
  late bool isFetching = false;
  void fetchResponse() {
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        message = widget.message;
        isFetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTileCard(
      title: Text(widget.query),
      borderRadius: const BorderRadius.all(Radius.zero),
      shadowColor: Colors.transparent,
      onExpansionChanged: (isExpanded) {
        if (isExpanded) {
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
