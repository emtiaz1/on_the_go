import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF104C91),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 20),
            _buildHelpCard(
              context,
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Find answers to frequently asked questions.',
              onTap: () {
                // Navigate to Help Center Page
              },
            ),
            _buildHelpCard(
              context,
              icon: Icons.contact_support,
              title: 'Contact Us',
              subtitle: 'Reach out to our support team for assistance.',
              onTap: () {
                // Navigate to Contact Page
              },
            ),
            _buildHelpCard(
              context,
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              subtitle: 'Understand how we handle your data and privacy.',
              onTap: () {
                // Navigate to Privacy Policy Page
              },
            ),
            _buildHelpCard(
              context,
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Share your suggestions or report a bug.',
              onTap: () {
                // Navigate to Feedback Page
              },
            ),
            _buildHelpCard(
              context,
              icon: Icons.info_outline,
              title: 'App Info',
              subtitle: 'View app version, developer info, and more.',
              onTap: () {
                // Navigate to App Info Page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Need Help?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'We are here to assist you. Browse the options below to get support.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildHelpCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF104C91),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black38, size: 16),
          ],
        ),
      ),
    );
  }
}
