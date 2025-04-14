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
      backgroundColor: Color(0xFF0D1117), // Dark bluish background
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF1F6FEB), // Bright bluish AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "What notifications you receive",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Facebook may still send you important notifications about your account and content outside of your preferred notification settings.",
              style: TextStyle(color: Colors.grey[400]),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
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
                        color: Color(0xFF1E293B), // Dark bluish card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: Icon(item['icon'], color: Colors.lightBlue),
                          title: Text(
                            item['title'],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Push, Email, SMS',
                            style: TextStyle(color: Colors.blue[200]),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.blueAccent),
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