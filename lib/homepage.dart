import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:on_the_go_demo/utils/constans/colors.dart';
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
      backgroundColor: const Color(0xFFF3F7FA),
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
              SizedBox(
                height: 150,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
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
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage()),
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
      bottomNavigationBar: BottomAppBar(
        shape:
            const CircularNotchedRectangle(), // Use CircularNotchedRectangle for the shape
        elevation: 10, // Floating effect
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(30)), // Fully rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(
                icon: Icons.feed,
                index: 0,
                label: 'Newsfeed',
                size: 25,
              ),
              _buildBottomNavItem(
                icon: Icons.map,
                index: 1,
                label: 'Maps',
                size: 25,
              ),
              _buildBottomNavItem(
                icon: Icons.add_circle,
                index: 2,
                label: 'New Post',
                size: 45,
              ),
              _buildBottomNavItem(
                icon: Icons.notifications,
                index: 3,
                label: 'Notifications',
                size: 25,
              ),
              _buildBottomNavItem(
                icon: Icons.person,
                index: 4,
                label: 'User',
                size: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required int index,
    required String label,
    double size = 28, // Default size for icons
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xFF104C91) : Colors.black87,
            size: size, // Use the size parameter
          ),
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF104C91),
                shape: BoxShape.circle,
              ),
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
          color: _isHovered
              ? Colors.blue.shade50
              : Colors.transparent, // Change background color on hover
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
