import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: const [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 10),
          Icon(Icons.more_vert, color: Colors.black),
        ],
      ),
      body: ListView(
        children: [
          _buildNewNotificationsSection(),
          _buildTodayNotificationsSection(),
        ],
      ),
    );
  }

  Widget _buildNewNotificationsSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('New',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildNotificationCard(
            name: "Dhaka Traffic Authority",
            message:
                "Heavy traffic reported near Gulshan 1 due to road repairs.",
            time: "15m",
            post: "Traffic Alert",
          ),
          _buildNotificationCard(
            name: "Bangladesh Road Safety",
            message: "Accident reported on Airport Road. Expect delays.",
            time: "30m",
            post: "Road Condition Update",
            reaction: Icons.warning,
          ),
          _buildNotificationCard(
            name: "Dhaka Commuters",
            message:
                "Severe waterlogging in Mirpur 10 area causing traffic congestion.",
            time: "1h",
            post: "Weather Alert",
            reaction: Icons.cloud,
          ),
        ],
      ),
    );
  }

  Widget _buildTodayNotificationsSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Today',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildNotificationCard(
            name: "Dhaka Traffic Updates",
            message:
                "Traffic jam reported on Mohakhali Flyover due to vehicle breakdown.",
            time: "3h",
            post: "Traffic Jam Alert",
          ),
          _buildNotificationCard(
            name: "Road Safety Bangladesh",
            message:
                "Road closure near Dhanmondi 27 for ongoing construction work.",
            time: "5h",
            post: "Road Closure Notice",
          ),
          _buildNotificationCard(
            name: "Weather Update BD",
            message:
                "Heavy rainfall expected in Dhaka. Drive carefully and avoid low-lying areas.",
            time: "8h",
            post: "Weather Alert",
            reaction: Icons.grain,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String name,
    required String message,
    required String time,
    required String post,
    IconData? reaction,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.grey[200], // Light theme card background
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[400],
          child: const Icon(Icons.traffic, color: Colors.white),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        trailing: reaction != null
            ? Icon(
                reaction,
                color: Colors.red,
              )
            : null,
        isThreeLine: true,
        onTap: () {
          // Handle notification tap
        },
      ),
    );
  }
}
