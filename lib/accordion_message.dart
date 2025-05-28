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

class _AccordionMessageState extends State<AcccordionMessage> {
  late String? message = "";
  late int counter = 0;

  void fetchResponse() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        message = widget.message;
        counter++;
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
          fetchResponse();
        } else {
          setState(() {
            message = null;
          });
        }
      },
      children: <Widget>[
        const Divider(thickness: 1.0, height: 1.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              (message ?? "") + "\n\n" + "Fetched times: " + counter.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
