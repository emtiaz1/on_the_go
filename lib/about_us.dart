import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF104C91), // Blue background for AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Description Section
            const Text(
              'About Our App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104C91), // Blue color for heading
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'On The Go is a mobile application designed to help users explore, '
                  'connect, and share their experiences seamlessly. Whether you are '
                  'traveling, discovering new places, or sharing your journey, our app '
                  'provides the tools you need to stay connected and informed.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Team Section
            const Text(
              'Meet Our Team',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104C91), // Blue color for heading
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: const [
                TeamMember(
                  name: 'Montakir Emtiaz Ahmed Rafid',
                  id: '221-15-5151',
                ),
                TeamMember(
                  name: 'Md Atique Enam',
                  id: '221-15-5292',
                ),
                TeamMember(
                  name: 'Iftekharul Islam',
                  id: '221-15-5308',
                ),
                TeamMember(
                  name: 'Foujia Afrose Tanha',
                  id: '221-15-5609',
                ),
                TeamMember(
                  name: 'Md Asif Shahriar Arpon',
                  id: '221-15-5655',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Contact Section
            const Text(
              'Contact Us',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104C91), // Blue color for heading
              ),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'If you have any questions, feedback, or suggestions, feel free to '
                  'reach out to us at support@onthego.com. We would love to hear from you!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMember extends StatelessWidget {
  final String name;
  final String id;

  const TeamMember({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.person,
              color: Color(0xFF104C91), // Blue icon for team members
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '$name\nID: $id',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5, // Line height for better readability
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
