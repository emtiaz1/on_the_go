import 'package:flutter/material.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String title;

  NotificationDetailScreen({required this.title});

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
      backgroundColor: Color(0xFF0D1117), // Dark bluish background
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFF1F6FEB), // Blue AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "These are notifications to remind you of updates you may have missed. Here's an example.",
              style: TextStyle(color: Colors.grey[400]),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFF1E293B), // Dark bluish container
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/user.png'), // Replace with your asset
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "You have 3 new notifications, 1 Timeline post and 1 group update.",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 24),
            SwitchListTile(
              value: allowFacebook,
              onChanged: (val) => setState(() => allowFacebook = val),
              title: Text(
                "Allow notifications on Facebook",
                style: TextStyle(color: Colors.white),
              ),
              activeColor: Colors.lightBlueAccent,
            ),
            Divider(height: 32, color: Colors.blueGrey),
            Text(
              "Where you receive these notifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
            SwitchListTile(
              value: push,
              onChanged: (val) => setState(() => push = val),
              title: Text("Push", style: TextStyle(color: Colors.white)),
              activeColor: Colors.lightBlueAccent,
            ),
            SwitchListTile(
              value: email,
              onChanged: (val) => setState(() => email = val),
              title: Text("Email", style: TextStyle(color: Colors.white)),
              activeColor: Colors.lightBlueAccent,
            ),
            SwitchListTile(
              value: sms,
              onChanged: (val) => setState(() => sms = val),
              title: Text("SMS", style: TextStyle(color: Colors.white)),
              activeColor: Colors.lightBlueAccent,
            ),
          ],
        ),
      ),
    );
  }
}