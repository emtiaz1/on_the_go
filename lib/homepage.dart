import 'package:flutter/material.dart';
import 'newsfeed_page.dart';
import 'maps.dart';
import 'newpost.dart';
import 'notification.dart';
import 'user.dart';
import 'faqs.dart';
import 'about_us.dart';
import 'saved_posts.dart';
import 'language.dart';
import 'settings.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const NewsFeedPage(),
    const MapsPage(),
    const NewPostPage(),
    const NotificationPage(),
    const UserPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On The Go'),
        elevation: 2,
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50, Colors.white],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade900],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'On The Go',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore & Connect',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.home,
                text: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.settings,
                text: 'Settings',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.question_answer,
                text: 'FAQs',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FaqsPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.info,
                text: 'About Us',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutUsPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.bookmark,
                text: 'Saved Posts',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SavedPostsPage()),
                  );
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.language,
                text: 'Language',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LanguagePage()),
                  );
                },
              ),
              const Divider(
                indent: 16,
                endIndent: 16,
                color: Colors.grey,
              ),
              _buildDrawerItem(
                context,
                icon: Icons.logout,
                text: 'Logout',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                iconColor: Colors.red.shade400,
                textColor: Colors.red.shade400,
              ),
            ],
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
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

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: _DrawerItem(
            icon: icon,
            text: text,
            iconColor: iconColor ?? Colors.blue.shade700,
            textColor: textColor ?? Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color textColor;

  const _DrawerItem({
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.textColor,
  });

  @override
  _DrawerItemState createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true; // Set hover state to true
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false; // Set hover state to false
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.blue.shade50 : Colors.transparent, // Change background color on hover
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.blue.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: widget.iconColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              widget.text,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
