import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String title;

  const NotificationDetailScreen({required this.title, super.key});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  bool allowFacebook = true;
  bool push = true;
  bool email = true;
  bool sms = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA), // Light blue background
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back.png',
            color: Colors.white,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF104C91), // Blue AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "These are notifications to remind you of updates you may have missed. Here's an example.",
              style: TextStyle(
                color: Colors.black54, // Blackish text
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white, // Whitish container
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "You have 3 new notifications, 1 Timeline post and 1 group update.",
                      style: TextStyle(
                        color: Colors.black87, // Blackish text
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              value: allowFacebook,
              onChanged: (val) => setState(() => allowFacebook = val),
              title: const Text(
                "Allow notifications",
                style: TextStyle(
                  color: Colors.black87, // Blackish text
                  fontSize: 16,
                ),
              ),
              activeColor: Colors.lightBlueAccent,
            ),
            const Divider(height: 32, color: Colors.grey),
            const Text(
              "Where you receive these notifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Blackish text
                fontSize: 16,
              ),
            ),
            SwitchListTile(
              value: push,
              onChanged: (val) => setState(() => push = val),
              title: const Text(
                "Push",
                style: TextStyle(
                  color: Colors.black87, // Blackish text
                  fontSize: 16,
                ),
              ),
              activeColor: Colors.lightBlueAccent,
            ),
            SwitchListTile(
              value: email,
              onChanged: (val) => setState(() => email = val),
              title: const Text(
                "Email",
                style: TextStyle(
                  color: Colors.black87, // Blackish text
                  fontSize: 16,
                ),
              ),
              activeColor: Colors.lightBlueAccent,
            ),
            SwitchListTile(
              value: sms,
              onChanged: (val) => setState(() => sms = val),
              title: const Text(
                "SMS",
                style: TextStyle(
                  color: Colors.black87, // Blackish text
                  fontSize: 16,
                ),
              ),
              activeColor: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
