import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة تجريبية للإشعارات
    final List<Map<String, String>> notifications = [
      {
        'title': 'تمت إضافة كتاب جديد',
        'body': 'تمت إضافة كتاب جديد لمؤلفك المفضل أدهم الشرقاوي.',
        'time': 'منذ 10 دقائق',
      },
      {
        'title': 'تذكير بموعد الإعارة',
        'body': 'ينتهي موعد استعارة كتاب "ساق البامبو" غداً.',
        'time': 'منذ ساعتين',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 159, 120, 194),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'لا توجد إشعارات حالياً',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFC9B6F5),
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    title: Text(
                      item['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['body']!),
                    trailing: Text(
                      item['time']!,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}