import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_the_go_demo/utils/constans/colors.dart';
import 'package:on_the_go_demo/widgets/app_drawer.dart';
import 'newsfeed_page.dart';
import 'maps.dart';
import 'newpost.dart';
import 'notification.dart';
import 'user.dart';

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
        title: Row(
          children: [
            Text(
              'On the',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.lobster().fontFamily,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Go',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.lobster().fontFamily,
                color: OColors.lightRed,
              ),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Color(0xFF104C91),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset(
                height: 28,
                'assets/icons/menus.png',
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      backgroundColor: const Color(0xFFF3F7FA),
      drawer: AppDrawer(
        onIndexSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        elevation: 10,
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
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
    double size = 28,
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
            color: isSelected ? const Color(0xFF104C91) : Colors.black87,
            size: size,
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
}
