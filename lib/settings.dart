import 'package:flutter/material.dart';
import 'NotificationSettings.dart';
import 'data_and_storage.dart';
import 'privacy_page.dart';
import 'account_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, dynamic>> _allSettingsItems = [
    {
      'icon': Icons.vpn_key,
      'title': 'Account',
      'subtitle': 'Security notifications, change number',
      'color': Colors.red,
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountPage(),
          ),
        );
      },
    },
    {
      'icon': Icons.lock,
      'title': 'Privacy',
      'subtitle': 'Audience, Visibility, read receipts',
      'color': Colors.green,
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrivacyPage(),
          ),
        );
      },
    },
    {
      'icon': Icons.account_circle,
      'title': 'Avatar',
      'subtitle': 'Create, edit, profile photo',
      'color': Colors.blue,
    },
    {
      'icon': Icons.list_alt,
      'title': 'Lists',
      'subtitle': 'Manage people and groups',
      'color': Colors.orange,
    },
    {
      'icon': Icons.chat,
      'title': 'Chats',
      'subtitle': 'Theme, wallpapers, chat history',
      'color': Colors.purple,
    },
    {
      'icon': Icons.notifications,
      'title': 'Notifications',
      'subtitle': 'Message, group & call tones',
      'color': Colors.teal,
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationSettingsPage(),
          ),
        );
      },
    },
    {
      'icon': Icons.storage,
      'title': 'Storage and data',
      'subtitle': 'Network usage, auto-download',
      'color': Colors.brown,
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StoragePage(),
          ),
        );
      },
    },
    {
      'icon': Icons.language,
      'title': 'App language',
      'subtitle': "English (device's language)",
      'color': Colors.cyan,
    },
    {
      'icon': Icons.help,
      'title': 'Help',
      'subtitle': 'Help center, contact us, privacy policy',
      'color': Colors.indigo,
    },
  ];

  List<Map<String, dynamic>> _filteredSettingsItems = [];

  @override
  void initState() {
    super.initState();
    _filteredSettingsItems = _allSettingsItems;

    _searchController.addListener(() {
      _filterSettingsItems(_searchController.text);
    });
  }

  void _filterSettingsItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSettingsItems = _allSettingsItems;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  border: InputBorder.none,
                ),
                cursorColor: Colors.white,
              )
            : const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
        backgroundColor: Colors.lightBlue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchController.clear();
              });
            },
          ),
        ],
        elevation: 0,
      ),
      backgroundColor: Colors.lightBlue.shade50,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _filteredSettingsItems.length,
        itemBuilder: (context, index) {
          final item = _filteredSettingsItems[index];
          return _buildSettingsItem(
            context,
            icon: item['icon'],
            title: item['title'],
            subtitle: item['subtitle'],
            color: item['color'],
            onTap: item['onTap'] != null
                ? () => item['onTap'](context)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: _SettingsItem(
          icon: icon,
          title: title,
          subtitle: subtitle,
          color: color,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
