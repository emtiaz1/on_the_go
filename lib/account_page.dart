import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _trafficAlert = true;
  bool _movementLogs = false;
  bool _securityNotifications = true;

  @override
  Widget build(BuildContext context) {
    Color primaryRed = const Color(0xFF104C91);
    Color background = const Color(0xFFF3F7FA);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text(
          'Account Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryRed,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back.png',
            color: Colors.white,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
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
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const TwoStepVerificationPage()),
              );
            },
          ),
          _settingsTile(
            icon: Icons.password,
            title: "Change Password",
            subtitle: "Update your account password",
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          _toggleTile(
            icon: Icons.shield_outlined,
            title: "Security Notifications",
            subtitle: "Be alerted of suspicious activity",
            value: _securityNotifications,
            statusColor: Colors.green,
            onChanged: (v) => setState(() => _securityNotifications = v),
          ),
          const SizedBox(height: 24),
          _sectionTitle("Preferences"),
          _toggleTile(
            icon: Icons.traffic,
            title: "Traffic Alerts",
            subtitle: "Enable location-based alerts",
            value: _trafficAlert,
            statusColor: Colors.green,
            onChanged: (v) => setState(() => _trafficAlert = v),
          ),
          _toggleTile(
            icon: Icons.directions_walk,
            title: "Movement Logs",
            subtitle: "Receive summary logs of your movement",
            value: _movementLogs,
            statusColor: Colors.amber,
            onChanged: (v) => setState(() => _movementLogs = v),
          ),
          const SizedBox(height: 24),
          _sectionTitle("Account Access"),
          _settingsTile(
            icon: Icons.devices,
            title: "Linked Devices",
            subtitle: "Manage devices and sessions",
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.login,
            title: "Login Activity",
            subtitle: "View recent sign-ins",
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          _settingsTile(
            icon: Icons.privacy_tip,
            title: "Privacy Summary",
            subtitle: "See what info you've shared",
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _sectionTitle("Account Actions"),
          _settingsTile(
            icon: Icons.remove_circle_outline,
            title: "Deactivate Account",
            subtitle: "Temporarily disable your account",
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showDeactivationSheet(context),
          ),
          _settingsTile(
            icon: Icons.delete_forever,
            title: "Delete Account",
            subtitle: "Permanently delete your account",
            titleColor: Colors.red,
            subtitleColor: Colors.red.shade300,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showDeleteDialog(context),
            iconColor: Colors.red, // Add this parameter to specify icon color
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    void Function()? onTap,
    Color? titleColor,
    Color? subtitleColor,
    Color? iconColor, // Add this parameter
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
            Icon(icon,
                color: iconColor ?? Color(0xFF104C91),
                size: 26), // Use iconColor if provided
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
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required void Function(bool) onChanged,
    required Color statusColor,
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
          Icon(icon, color: Color(0xFF104C91), size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(
                0xFF104C91), // Set the active color to match the primary color
          ),
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

  void _showDeactivationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            const Text(
              "Deactivate Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Your account will be temporarily disabled. You can reactivate it anytime by logging in again.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Replacing SnackBar with AlertDialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Success"),
                      content: const Text("Account Deactivated"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Center(
                  child: Text("Deactivate Now",
                      style: TextStyle(color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
            "Are you sure you want to permanently delete your account? This action cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Replacing SnackBar with AlertDialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Success"),
                    content: const Text("Account Deleted"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

class TwoStepVerificationPage extends StatelessWidget {
  const TwoStepVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _questionController = TextEditingController();
    final _answerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Two-Step Verification"),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Secure your account by adding a recovery question.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: "Security Question",
                hintText: "e.g., What's your first pet's name?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                labelText: "Answer",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(context);
                // Replacing SnackBar with AlertDialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Success"),
                      content: const Text("Two-Step Verification Enabled"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Center(child: Text("Enable Verification")),
            ),
          ],
        ),
      ),
    );
  }
}
