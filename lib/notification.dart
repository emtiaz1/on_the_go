import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String, dynamic>> notifications = [
    {
      'name': "Dhaka Traffic Authority",
      'message': "Heavy traffic reported near Gulshan 1 due to road repairs.",
      'time': "15m",
      'post': "Traffic Alert",
      'reaction': null,
      'seen': false,
    },
    {
      'name': "Bangladesh Road Safety",
      'message': "Accident reported on Airport Road. Expect delays.",
      'time': "30m",
      'post': "Road Condition Update",
      'reaction': Icons.warning,
      'seen': false,
    },
    {
      'name': "Dhaka Commuters",
      'message':
          "Severe waterlogging in Mirpur 10 area causing traffic congestion.",
      'time': "1h",
      'post': "Weather Alert",
      'reaction': Icons.cloud,
      'seen': false,
    },
    {
      'name': "Dhaka Traffic Updates",
      'message':
          "Traffic jam reported on Mohakhali Flyover due to vehicle breakdown.",
      'time': "3h",
      'post': "Traffic Jam Alert",
      'reaction': null,
      'seen': false,
    },
    {
      'name': "Road Safety Bangladesh",
      'message':
          "Road closure near Dhanmondi 27 for ongoing construction work.",
      'time': "5h",
      'post': "Road Closure Notice",
      'reaction': null,
      'seen': false,
    },
    {
      'name': "Weather Update BD",
      'message':
          "Heavy rainfall expected in Dhaka. Drive carefully and avoid low-lying areas.",
      'time': "8h",
      'post': "Weather Alert",
      'reaction': Icons.grain,
      'seen': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          _buildBottomHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(notification, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            "Notifications",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(18),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    final bool isSeen = notification['seen'];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: isSeen ? Colors.grey[300] : Colors.white, // Adjusted color here
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[400],
          child: const Icon(Icons.traffic, color: Colors.white),
        ),
        title: Text(notification['name'],
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(notification['message']),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showBottomMenu(index),
        ),
        onTap: () {
          setState(() {
            notifications[index]['seen'] = true;  // Mark as seen when tapped
          });
        },
      ),
    );
  }

  void _showBottomMenu(int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.expand_more),
                title: const Text("Show more"),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Showing more...");
                },
              ),
              ListTile(
                leading: const Icon(Icons.expand_less),
                title: const Text("Show less"),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Showing less...");
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete notification"),
                onTap: () {
                  setState(() {
                    notifications.removeAt(index);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_off),
                title: const Text("Turn off notifications"),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Notifications turned off");
                },
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text("Report issue to notification team"),
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Issue reported");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
