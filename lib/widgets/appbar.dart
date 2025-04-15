import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_the_go_demo/utils/constans/colors.dart';

class AppBar_widget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
