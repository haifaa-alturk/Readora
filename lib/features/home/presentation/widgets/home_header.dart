import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final int points;
  const HomeHeader({required this.points, super.key});

  @override
  Widget build(BuildContext context) {
    return 
    // SliverToBoxAdapter(
       Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 99, 152, 172),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.notifications_none, color: Color.fromARGB(255, 231, 230, 227), size: 30),
                Row(
                  children: [
                    // Text("نقاطك: $points", style: const TextStyle(color: Color.fromARGB(255, 243, 7, 180), fontSize: 16)),
                    const SizedBox(width: 10),
                    const CircleAvatar(radius: 20, backgroundColor: Color.fromARGB(255, 168, 94, 188), child: Icon(Icons.person)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 180, 208, 219),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  
                  hintText: "Search...",
                   hintStyle: TextStyle(
      color: Color.fromARGB(255, 58, 60, 62), 
      fontSize: 16,
    ),
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      );
    // );
  }
}
