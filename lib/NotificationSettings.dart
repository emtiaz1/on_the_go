import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatelessWidget {
  final String title;

  const NotificationDetailScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF1F6FEB),
      ),
      body: Center(
        child: Text(
          'Details for $title',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF0D1117),
    );
  }
}

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
    // Show only the first half of the items
    final halfItems = items.sublist(0, (items.length / 2).ceil());

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF1F6FEB),
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
                color: Colors.lightBlueAccent,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Facebook may still send you important notifications about your account and content outside of your preferred notification settings.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: halfItems.length,
                itemBuilder: (context, index) {
                  final item = halfItems[index];
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
                      color: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: Icon(item['icon'], color: Colors.lightBlue),
                        title: Text(
                          item['title'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'Push, Email, SMS',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.blueAccent,
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