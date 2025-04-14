import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    Color primaryRed = const Color(0xFFD32F2F);
    Color background = const Color(0xFFFFF5F5);
    Color tileColor = Colors.white;
    Color subtitleColor = Colors.grey.shade600;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryRed,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Security"),
          _settingsTile(
            icon: Icons.verified_user,
            title: "Two-Step Verification",
            subtitle: "Add extra security to your account",
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: subtitleColor),
          ),
          _settingsTile(
            icon: Icons.password,
            title: "Change Password",
            subtitle: "Update your account password",
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: subtitleColor),
          ),
          _settingsTile(
            icon: Icons.shield_outlined,
            title: "Security Notifications",
            subtitle: "Be alerted of suspicious activity",
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          const SizedBox(height: 24),
          _sectionTitle("Preferences"),
          _settingsTile(
            icon: Icons.traffic,
            title: "Traffic Alerts",
            subtitle: "Enable location-based alerts",
            trailing: Switch(value: true, onChanged: (v) {}),
          ),
          _settingsTile(
            icon: Icons.directions_walk,
            title: "Movement Logs",
            subtitle: "Receive summary logs of your movement",
            trailing: Switch(value: false, onChanged: (v) {}),
          ),
          const SizedBox(height: 24),
          _sectionTitle("Account Actions"),
          _settingsTile(
            icon: Icons.remove_circle_outline,
            title: "Deactivate Account",
            subtitle: "Temporarily disable your account",
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: subtitleColor),
          ),
          _settingsTile(
            icon: Icons.delete_forever,
            title: "Delete Account",
            subtitle: "Permanently delete your account",
            titleColor: Colors.red,
            subtitleColor: Colors.red.shade300,
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red.shade300),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? titleColor,
    Color? subtitleColor,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red.shade700, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? Colors.black,
                    )),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: subtitleColor ?? Colors.grey.shade600,
                    )),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    );
  }
}
