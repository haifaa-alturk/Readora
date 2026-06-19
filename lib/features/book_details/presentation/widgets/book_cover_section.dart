import 'package:flutter/material.dart';

class BookCoverSection extends StatelessWidget {
  const BookCoverSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFFE6B800),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.pets,
            color: Colors.white,
            size: 28,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          "Mr.Ducky recommends this book!",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),

        const SizedBox(height: 20),

        Container(
          height: 260,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade300,
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 5),
                color: Colors.black12,
              ),
            ],
          ),
          child: const Icon(
            Icons.book,
            size: 90,
          ),
        ),
      ],
    );
  }
}