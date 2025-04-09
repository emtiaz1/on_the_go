import 'package:flutter/material.dart';
import 'user.dart'; // Import the UserPage

final List<Widget> _pages = [
  Center(child: Text('Newsfeed Page', style: TextStyle(fontSize: 20))),
  Center(child: Text('Search Page', style: TextStyle(fontSize: 20))),
  Center(child: Text('Maps Page', style: TextStyle(fontSize: 20))),
  Center(child: Text('Create New Post', style: TextStyle(fontSize: 20))),
  const UserPage(), // Add the UserPage here
];

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String selectedOption = 'Posts'; // Default selected option

  void _showFullCoverPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: InteractiveViewer(
            child: Image.asset(
              'assets/images/cover.png', // Full cover photo
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover Photo with Profile Picture
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () => _showFullCoverPhoto(
                      context), // Show full cover photo on tap
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/cover.png'), // Cover photo
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom:
                      -50, // Position the profile picture overlapping the cover photo
                  left: MediaQuery.of(context).size.width / 2 -
                      60, // Center the profile picture
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                        'assets/images/profile.png'), // Profile photo
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70), // Space below the profile picture
            // User Name
            const Text(
              'Kuddus',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // User Email
            const Text(
              'kuddus@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // About Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Bio
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Bio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'I am a traveller, i love to travel in different places. I love to keep updating traffic condition to help people.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),
            // Job
            const ListTile(
              leading: Icon(Icons.work, color: Colors.blue),
              title: Text('Software Engineer'),
              subtitle: Text('ABC Tech Ltd.'),
            ),
            // University
            const ListTile(
              leading: Icon(Icons.school, color: Colors.blue),
              title: Text('Daffodil International University'),
              subtitle: Text('Computer Science'),
            ),
            // College
            const ListTile(
              leading: Icon(Icons.account_balance, color: Colors.blue),
              title: Text('Mirpur Govt High School'),
              subtitle: Text('Science'),
            ),
            // Marital Status
            const ListTile(
              leading: Icon(Icons.favorite, color: Colors.blue),
              title: Text('Marital Status'),
              subtitle: Text('Single'),
            ),
            const SizedBox(height: 30),
            // Contact Information
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  Icon(Icons.phone, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    '+88017444444',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    'Mirpur 10',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Space before the options bar
            // Options Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Posts';
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedOption == 'Posts'
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      if (selectedOption == 'Posts')
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 50,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Photos';
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedOption == 'Photos'
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      if (selectedOption == 'Photos')
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 50,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Videos';
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Videos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedOption == 'Videos'
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      if (selectedOption == 'Videos')
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 50,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Content Based on Selected Option
            if (selectedOption == 'Posts')
              Center(
                child: Text(
                  'Posts Section',
                  style: TextStyle(fontSize: 18),
                ),
              )
            else if (selectedOption == 'Photos')
              Center(
                child: Text(
                  'Photos Section',
                  style: TextStyle(fontSize: 18),
                ),
              )
            else if (selectedOption == 'Videos')
              Center(
                child: Text(
                  'Videos Section',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
