import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _imageLinkController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  String? _selectedLocation;
  bool _isMovementEnabled = false; // Toggle button state
  final List<String> _locations = ['Dhaka', 'Chittagong', 'Sylhet', 'Khulna'];

  Future<void> _submitPost() async {
    if (_postController.text.isEmpty ||
        _imageLinkController.text.isEmpty ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    try {
      // Save post to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'content': _postController.text,
        'imageLink': _imageLinkController.text,
        'location': _selectedLocation,
        'tags': _tagsController.text,
        'movement': _isMovementEnabled, // Store boolean value
        'reactions': 0,
        'views': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post Published!')),
      );

      // Clear fields after submission
      _postController.clear();
      _imageLinkController.clear();
      _tagsController.clear();
      setState(() {
        _selectedLocation = null;
        _isMovementEnabled = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Post'),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: _submitPost,
            child: const Text(
              'Post',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text Box for Post Content
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write something...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 20),

            // Image Link Input
            TextField(
              controller: _imageLinkController,
              decoration: InputDecoration(
                hintText: 'Enter image link...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 20),

            // Location Dropdown
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              items: _locations
                  .map((location) => DropdownMenuItem(
                        value: location,
                        child: Text(location),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tags Input
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                hintText: 'Enter tags (comma-separated)...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 20),

            // Movement Toggle Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Movement:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _isMovementEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isMovementEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
