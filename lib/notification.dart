import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
=======
import 'package:google_fonts/google_fonts.dart';
import 'package:on_the_go_demo/utils/constans/colors.dart';
>>>>>>> a97f52e2f0349f0835df06f1cef83a2b3066a003

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
  void initState() {
    super.initState();
    _fetchPostsFromFirestore();
  }

  // Fetch posts from Firestore and add them as notifications
  Future<void> _fetchPostsFromFirestore() async {
    final firestore = FirebaseFirestore.instance;

    // Listen for new posts in the Firestore collection
    firestore.collection('posts').snapshots().listen((snapshot) {
      for (var doc in snapshot.docChanges) {
        if (doc.type == DocumentChangeType.added) {
          final data = doc.doc.data();
          if (data != null) {
            setState(() {
              notifications.insert(0, {
                'name': "Someone", // Replace userName with "Someone"
                'message': "Someone posted from ${data['location']} about ${data['tags']}",
                'time': "Just now",
                'post': data['content'],
                'reaction': null,
                'seen': false,
              });
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50, // Light blue background
      appBar: AppBar(
<<<<<<< HEAD
        backgroundColor: const Color(0xFF104C91), // Bluish AppBar
        elevation: 2,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
=======
        title: Row(
          children: [
            Text(
              'Notifications',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Color(0xFF104C91),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                height: 28,
                'assets/icons/menus.png',
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
>>>>>>> a97f52e2f0349f0835df06f1cef83a2b3066a003
        ),
      ),
<<<<<<< HEAD
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationCard(notification, index);
              },
            ),
=======
      backgroundColor: Color(0xFFF3F7FA),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(notification, index);
        },
      ),
>>>>>>> a97f52e2f0349f0835df06f1cef83a2b3066a003
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, int index) {
    final bool isSeen = notification['seen'];
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
<<<<<<< HEAD
      color: Colors.white, // Whitish background for notification card
      elevation: 2,
=======
      color: isSeen
          ? Colors.grey[200]
          : Colors.grey[300], // Light if seen, dark if unseen
>>>>>>> a97f52e2f0349f0835df06f1cef83a2b3066a003
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isSeen ? Colors.grey[300] : Colors.grey[400],
          child: const Icon(Icons.notifications, color: Colors.white),
        ),
        title: Text(
          notification['message'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Blackish text for title
          ),
        ),
        subtitle: Text(
          notification['post'],
          style: const TextStyle(color: Colors.black87), // Blackish text
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () => _showBottomMenu(index),
        ),
        onTap: () {
          setState(() {
            notifications[index]['seen'] = true;
          });
        },
      ),
    );
  }

  void _showBottomMenu(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.expand_more, color: Colors.black),
                  title: const Text(
                    "Show more",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnack("Showing more...");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.expand_less, color: Colors.black),
                  title: const Text(
                    "Show less",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnack("Showing less...");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.black),
                  title: const Text(
                    "Delete notification",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    setState(() {
                      notifications.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_off, color: Colors.black),
                  title: const Text(
                    "Turn off notifications",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnack("Notifications turned off");
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.report, color: Colors.black),
                  title: const Text(
                    "Report issue to notification team",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showSnack("Issue reported");
                  },
                ),
              ],
            ),
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
