import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color background = const Color(0xFFF1FFF5);
    Color tileColor = Colors.white;
    Color primaryGreen = const Color(0xFF34A853);
    Color subtitleColor = Colors.grey.shade600;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Privacy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader("Account Privacy"),
          _customTile(
            title: "Private Account",
            subtitle:
                "Only approved followers can see your traffic alerts and movements.",
            icon: Icons.lock_outline,
            trailing: Switch(
              value: true,
              onChanged: (val) {},
              activeColor: primaryGreen,
            ),
          ),
          _customTile(
            title: "Last Seen & Online",
            subtitle: "Control who can see when you're online.",
            icon: Icons.visibility_outlined,
          ),

          const SizedBox(height: 20),
          _sectionHeader("Location Sharing"),
          _customTile(
            title: "Live Location",
            subtitle: "Manage who can see your live location.",
            icon: Icons.location_on_outlined,
          ),
          _customTile(
            title: "Traffic Report Zones",
            subtitle: "Configure zones for movement notifications.",
            icon: Icons.map_outlined,
          ),

          const SizedBox(height: 20),
          _sectionHeader("Interactions"),
          _customTile(
            title: "Blocked Users",
            subtitle: "View or unblock users you’ve blocked.",
            icon: Icons.block_outlined,
          ),
          _customTile(
            title: "Who Can Message Me",
            subtitle: "Choose who is allowed to send you messages.",
            icon: Icons.message_outlined,
          ),

          const SizedBox(height: 20),
          _sectionHeader("Permissions"),
          _customTile(
            title: "Data Access",
            subtitle: "Control access to your contacts and photos.",
            icon: Icons.privacy_tip_outlined,
          ),
          _customTile(
            title: "Crash Reports",
            subtitle:
                "Help us improve the app by sending anonymous crash logs.",
            icon: Icons.bug_report_outlined,
            trailing: Switch(
              value: false,
              onChanged: (val) {},
              activeColor: primaryGreen,
            ),
          ),

          const SizedBox(height: 30),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "View Full Privacy Policy",
                style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customTile({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }
}
