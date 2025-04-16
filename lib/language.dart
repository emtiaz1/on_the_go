import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List<Map<String, dynamic>> languages = [
    {'name': 'English', 'icon': Icons.language},
    {'name': 'Spanish', 'icon': Icons.language},
    {'name': 'French', 'icon': Icons.language},
    {'name': 'German', 'icon': Icons.language},
    {'name': 'Chinese', 'icon': Icons.language},
    {'name': 'Japanese', 'icon': Icons.language},
    {'name': 'Arabic', 'icon': Icons.language},
    {'name': 'Hindi', 'icon': Icons.language},
    {'name': 'Bengali', 'icon': Icons.language},
  ];

  String? selectedLanguage = 'English'; // Default selected language

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Language',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF104C91), // Blue background for AppBar
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final isSelected = selectedLanguage == language['name'];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedLanguage = language['name'];
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${language['name']} selected')),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              color: isSelected
                  ? const Color(0xFF104C91)
                      .withOpacity(0.1) // Highlight selected
                  : Colors.white,
              child: ListTile(
                leading: Icon(
                  language['icon'],
                  color: const Color(0xFF104C91), // AppBar color for all icons
                ),
                title: Text(
                  language['name'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF104C91) // Highlight text if selected
                        : Colors.black87,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: Color(0xFF104C91), // Check icon for selected
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
