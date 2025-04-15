import 'package:flutter/material.dart';
import 'NotificationSettings.dart';
import 'data_and_storage.dart';
import 'privacy_page.dart';
import 'account_page.dart';
import 'media.dart';
import 'help.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Map<String, dynamic>> _allSettingsItems = [];
  List<Map<String, dynamic>> _filteredSettingsItems = [];

  @override
  void initState() {
    super.initState();

    _allSettingsItems.addAll([
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
        'icon': Icons.perm_media,
        'title': 'Media',
        'subtitle': 'Manage your media files',
        'color': Colors.orange,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MediaPage(),
            ),
          );
        },
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
        'onTap': (BuildContext context) {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            builder: (context) => const LanguageBottomSheet(),
          );
        },
      },
      {
        'icon': Icons.help,
        'title': 'Help',
        'subtitle': 'Help center, contact us, privacy policy',
        'color': Colors.indigo,
        'onTap': (BuildContext context) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HelpPage(),
            ),
          );
        },
      },
    ]);

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
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
                cursorColor: Colors.white,
              )
            : const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
        backgroundColor: const Color(0xFF104C91),
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back.png',
            color: Colors.white,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
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
      backgroundColor: const Color(0xFFF3F7FA),
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
            onTap: item['onTap'] != null ? () => item['onTap'](context) : null,
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

class LanguageBottomSheet extends StatefulWidget {
  const LanguageBottomSheet({super.key});

  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  String _selectedLanguage = 'English';

  final List<String> _languages = [
    'English',
    'Bangla',
    'Hindi',
    'Spanish',
    'French',
    'Chinese',
    'Arabic',
    'Japanese',
    'German',
    'Russian',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select App Language',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF104C91),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: _languages.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final language = _languages[index];
                return ListTile(
                  leading: Icon(
                    _selectedLanguage == language
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: _selectedLanguage == language
                        ? const Color(0xFF104C91)
                        : Colors.grey,
                  ),
                  title: Text(
                    language,
                    style: const TextStyle(fontSize: 16),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language;
                    });
                    Navigator.pop(context);
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
