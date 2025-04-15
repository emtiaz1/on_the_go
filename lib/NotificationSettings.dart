import 'package:flutter/material.dart';
import 'notification_detail.dart';

class NotificationSettingsPage extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'icon': Icons.comment, 'title': 'Comments'},
    {'icon': Icons.label, 'title': 'Tags'},
    {'icon': Icons.notifications_active, 'title': 'Reminders'},
    {'icon': Icons.dashboard_customize, 'title': 'More Activity About You'},
    {'icon': Icons.people, 'title': 'Updates from friends'},
    {'icon': Icons.person_add_alt_1, 'title': 'Friend Requests'},
    {'icon': Icons.person_outline, 'title': 'People you may know'},
    {'icon': Icons.cake, 'title': 'Birthdays'},
    {'icon': Icons.group, 'title': 'Groups'},
    {'icon': Icons.video_collection, 'title': 'Video'},
    {'icon': Icons.event, 'title': 'Events'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50, // Light blue background
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF104C91), // Bluish AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What notifications you receive",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Blackish text
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Facebook may still send you important notifications about your account and content outside of your preferred notification settings.",
              style: TextStyle(color: Colors.black54), // Blackish text
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationDetailScreen(
                            title: item['title'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white, // Whitish card background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Icon(item['icon'], color: const Color(0xFF104C91)), // Bluish icon
                        title: Text(
                          item['title'],
                          style: const TextStyle(
                            color: Colors.black87, // Blackish text
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Push, Email, SMS',
                          style: TextStyle(color: Colors.black54), // Blackish text
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black54, // Blackish icon
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}