import 'package:flutter/material.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final Widget icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: icon),
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
