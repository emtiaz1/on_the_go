import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBar_widget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
      'On the Go',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.lobster().fontFamily,
      ),),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
