import 'package:flutter/material.dart';

class HomeSection extends StatelessWidget {
  final String title;
  final Widget child;

  const HomeSection({required this.title, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        child,
      ],
    );
  }
}