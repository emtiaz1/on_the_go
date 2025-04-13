import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  _NotificationSettingsPageState createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // State variables for toggle switches
  Map<String, Map<String, bool>> notificationSettings = {
    'Comments': {'Push': true, 'Email': true, 'SMS': false},
    'Tags': {'Push': true, 'Email': true, 'SMS': false},
    'Reminders': {'Push': true, 'Email': true, 'SMS': false},
    'More Activity About You': {'Push': true, 'Email': true, 'SMS': false},
    'Updates from Friends': {'Push': true, 'Email': true, 'SMS': false},
    'Friend Requests': {'Push': true, 'Email': true, 'SMS': false},
    'People You May Know': {'Push': true, 'Email': true, 'SMS': false},
    'Birthdays': {'Push': true, 'Email': true, 'SMS': false},
    'Groups': {'Push': true, 'Email': true, 'SMS': false},
    'Video': {'Push': true, 'Email': true, 'SMS': false},
    'Events': {'Push': true, 'Email': true, 'SMS': false},
  };

  // Icons for each notification category
  final Map<String, IconData> categoryIcons = {
    'Comments': Icons.comment_outlined,
    'Tags': Icons.local_offer_outlined,
    'Reminders': Icons.notifications_none,
    'More Activity About You': Icons.person_outline,
    'Updates from Friends': Icons.group_outlined,
    'Friend Requests': Icons.person_add_outlined,
    'People You May Know': Icons.people_alt_outlined,
    'Birthdays': Icons.cake_outlined,
    'Groups': Icons.groups_outlined,
    'Video': Icons.play_circle_outline,
    'Events': Icons.event_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFF18191A),
      body: notificationSettings.isEmpty
          ? const Center(
              child: Text(
                'No notification settings available.',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text(
                  'WHAT NOTIFICATIONS YOU RECEIVE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Facebook may still send you important notifications about your account and content outside of your preferred notification settings.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ...notificationSettings.keys.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            categoryIcons[category],
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16.0,
                        runSpacing: 8.0,
                        children: ['Push', 'Email', 'SMS'].map((type) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                type,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Switch(
                                value: notificationSettings[category]![type]!,
                                onChanged: (value) {
                                  setState(() {
                                    notificationSettings[category]![type] = value;
                                  });
                                },
                                activeColor: Colors.blue,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ],
            ),
    );
  }
}

// Example usage of the suggested code change
void navigateToNotificationSettings(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
  );
}
