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
          color: Color.fromARGB(128, 151, 146, 66),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.notifications_none, color: Colors.white, size: 30),
                Row(
                  children: [
                    Text("نقاطك: $points", style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(width: 10),
                    const CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.person)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "ابحث عن عنوان، مؤلف...",
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
