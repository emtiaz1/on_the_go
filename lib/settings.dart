import 'package:flutter/material.dart';
import 'NotificationSettings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allSettingsItems = [
    {
      'icon': Icons.vpn_key,
      'title': 'Account',
      'subtitle': 'Security notifications, change number',
      'color': Colors.red,
    },
    {
      'icon': Icons.lock,
      'title': 'Privacy',
      'subtitle': 'Block contacts, disappearing messages',
      'color': Colors.green,
    },
    {
      'icon': Icons.chat,
      'title': 'Chats',
      'subtitle': 'Theme, wallpapers, chat history',
      'color': Colors.blue,
    },
    {
      'icon': Icons.notifications,
      'title': 'Notifications',
      'subtitle': 'Message, group & call tones',
      'color': Colors.orange,
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationSettingsPage(),
          ),
        );
      },
    },
    {
      'icon': Icons.help,
      'title': 'Help',
      'subtitle': 'Help center, contact us, privacy policy',
      'color': Colors.purple,
    },
    {
      'icon': Icons.language,
      'title': 'Language',
      'subtitle': 'Change app language',
      'color': Colors.teal,
    },
    {
      'icon': Icons.storage,
      'title': 'Storage',
      'subtitle': 'Manage storage and data usage',
      'color': Colors.brown,
    },
  ];

  late List<Map<String, dynamic>> _filteredSettingsItems;

  @override
  void initState() {
    super.initState();
    _filteredSettingsItems = List.from(_allSettingsItems);
    _searchController.addListener(() {
      _filterSettingsItems(_searchController.text);
    });
  }

  void _filterSettingsItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSettingsItems = List.from(_allSettingsItems);
      } else {
        _filteredSettingsItems = _allSettingsItems.where((item) {
          final title = item['title'].toString().toLowerCase();
          final subtitle = item['subtitle'].toString().toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) || subtitle.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search settings...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSettingsItems.length,
              itemBuilder: (context, index) {
                final item = _filteredSettingsItems[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item['color'],
                    child: Icon(item['icon'], color: Colors.white),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['subtitle']),
                  onTap: () {
                    if (item['onTap'] != null) {
                      item['onTap'](context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item['title']} tapped')),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
