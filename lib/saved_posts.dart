import 'package:flutter/material.dart';

class SavedPostsPage extends StatelessWidget {
  const SavedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
      ),
      body: const Center(
        child: Text('FAQs Page Content'),
      ),
    );
  }
}