import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_the_go_demo/newpost.dart';
import 'package:on_the_go_demo/notification.dart';
import 'package:on_the_go_demo/widgets/appbar.dart';
import 'maps.dart';
import 'user.dart'; // Import the UserPage

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  int _currentIndex = 0;
  List<dynamic> posts = [];

  final List<Widget> _pages = [
    Center(child: CircularProgressIndicator()),
    Center(child: MapsPage()),
    Center(child: NewPostPage()),
    Center(child: NotificationPage()),
    const UserPage(), // Add the UserPage here
  ];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final String response = await rootBundle.loadString('assets/posts.json');
    final data = json.decode(response);
    setState(() {
      posts = data; // Assign the posts data
      _pages[0] = _buildNewsFeed(); // Replace placeholder with newsfeed
    });
  }

  Widget _buildNewsFeed() {
    return SingleChildScrollView(
      child: Column(
        children: posts.map((post) {
          return Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Author and Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post['user'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        post['location'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Post Content
                  Text(
                    post['content'],
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  // Post Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      post['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tags
                  Wrap(
                    spacing: 8.0,
                    children: (post['tags'] as List<dynamic>? ?? [])
                        .map<Widget>(
                          (tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.blue[100],
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 10),
                  // Reactions and Views
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Reactions
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.thumb_up, color: Colors.blue),
                              const SizedBox(width: 3),
                              Text('${post['reactions']['like']} Likes'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          if (post['reactions'].containsKey('angry'))
                            Row(
                              children: [
                                const Icon(Icons.sentiment_very_dissatisfied,
                                    color: Colors.red),
                                const SizedBox(width: 3),
                                Text('${post['reactions']['angry']} Angry'),
                              ],
                            ),
                          const SizedBox(width: 10),
                          if (post['reactions'].containsKey('sad'))
                            Row(
                              children: [
                                const Icon(Icons.sentiment_dissatisfied,
                                    color: Colors.orange),
                                const SizedBox(width: 3),
                                Text('${post['reactions']['sad']} Sad'),
                              ],
                            ),
                        ],
                      ),
                      // Views
                      Row(
                        children: [
                          const Icon(Icons.visibility, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text('${post['views']} Views'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Movement Indicator
                  if (post['movement'])
                    const Text(
                      '🚨 Movement Alert',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar_widget(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Newsfeed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Maps',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: 'New Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }
}
