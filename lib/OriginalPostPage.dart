import 'package:flutter/material.dart';

class OriginalPostPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const OriginalPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Original Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post['content'] ?? 'No Content',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (post['image'] != null && post['image'].isNotEmpty)
                Image.network(
                  post['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Image could not be loaded');
                  },
                ),
              const SizedBox(height: 10),
              Text(
                'Location: ${post['location'] ?? 'Unknown'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              if (post['tags'] != null && post['tags'].isNotEmpty)
                Wrap(
                  spacing: 6.0,
                  children: (post['tags'] as List)
                      .map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.blue.shade50,
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 10),
              Text(
                'Saved by: ${post['savedBy'] ?? 'Unknown'}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Text(
                'Views: ${post['views'] ?? 0}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SomeOtherWidget extends StatelessWidget {
  final Map<String, dynamic> post;

  const SomeOtherWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Ensure the post object is valid before navigating
        if (post.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OriginalPostPage(post: post),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid post data')),
          );
        }
      },
      child: Container(
        // Your widget content here
      ),
    );
  }
}