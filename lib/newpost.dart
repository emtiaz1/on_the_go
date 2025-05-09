import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart'; // Firebase Auth import
import 'package:intl/intl.dart'; // For formatting the timestamp

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
  final List<String> _tags = []; // List to store tags

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _postController.dispose();
    _imageLinkController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<String?> _getLoggedInUserName() async {
    try {
      final String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return null;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData['name'] ?? 'Anonymous';
      }
    } catch (e) {
      debugPrint('Error fetching user name: $e');
    }
    return null;
  }

  Future<void> _submitPost() async {
    if (_postController.text.isEmpty ||
        _imageLinkController.text.isEmpty ||
        _selectedLocation == null ||
        _tags.isEmpty) {
      // Check if tags list is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields!')),
      );
      return;
    }

    try {
      // Get the current user's name from Firestore
      final String? username = await _getLoggedInUserName();

      if (username == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User not logged in or name not found!')),
        );
        return;
      }

      // Format the current timestamp as a string
      final String formattedTimestamp =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Save post to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'content': _postController.text,
        'image':
            _imageLinkController.text, // Updated to match `newsfeed_page.dart`
        'location': _selectedLocation,
        'tags': _tags, // Save tags as a list
        'movement': _isMovementEnabled, // Store boolean value
        'reactions': {
          'like': 0,
          'angry': 0,
          'sad': 0,
        }, // Initialize all reactions to 0
        'views': 0, // Initialize views to 0
        'timestamp': formattedTimestamp, // Save timestamp as a string
        'user': username, // Save the dynamically fetched username
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
        _tags.clear(); // Clear tags list
      });
    } catch (e) {
      debugPrint('Error while submitting post: $e'); // Log the error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
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
                prefixIcon:
                    const Icon(Icons.edit, color: Colors.blue), // Edit icon
                hintText: 'Write something...',
                fillColor: Colors.white, // White background
                filled: true, // Enable background color
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
                prefixIcon:
                    const Icon(Icons.image, color: Colors.green), // Image icon
                hintText: 'Enter image link...',
                fillColor: Colors.white, // White background
                filled: true, // Enable background color
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
              hint: const Text('Select Location'), // Placeholder text
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
                prefixIcon: const Icon(Icons.location_on,
                    color: Colors.orange), // Location icon
                fillColor: Colors.white, // White background
                filled: true, // Enable background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tags Input Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tags:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0, // Add spacing between lines
                  children: _tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.blue.shade50,
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                            ),
                            deleteIcon: const Icon(Icons.close,
                                size: 16, color: Colors.red),
                            onDeleted: () {
                              setState(() {
                                _tags.remove(tag); // Remove tag on delete
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.tag, color: Colors.purple), // Tag icon
                    hintText: 'Enter a tag and press Add...',
                    fillColor: Colors.white, // White background
                    filled: true, // Enable background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.all(15),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add,
                          color: Colors.green), // Add icon
                      onPressed: () {
                        if (_tagsController.text.trim().isNotEmpty) {
                          setState(() {
                            _tags.add(
                                _tagsController.text.trim()); // Add tag to list
                            _tagsController.clear(); // Clear input field
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Movement Toggle Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '🚨 Movement Alert',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _isMovementEnabled,
                  activeColor: Colors.red[600],
                  onChanged: (value) {
                    setState(() {
                      _isMovementEnabled = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Post Button with Full Width
            SizedBox(
              width: double.infinity, // Full width
              child: ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF104C91), // Blue button color
                  padding: const EdgeInsets.symmetric(
                      vertical: 15), // Adjust vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
