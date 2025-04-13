import 'package:flutter/material.dart';
import 'newsfeed_page.dart'; // Import the NewsFeedPage
import 'package:image_picker/image_picker.dart'; // Add this import
import 'dart:io'; // For File

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final TextEditingController _postController = TextEditingController();
  String? _selectedLocation;
  final List<String> _locations = ['Dhaka', 'Chittagong', 'Sylhet', 'Khulna'];
  File? _selectedImageFile; // Update to use File for the selected image
  File? _selectedVideoFile; // Update to use File for the selected video

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
      });
    }
  }

  Future<void> _recordVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.camera);

    if (video != null) {
      setState(() {
        _selectedVideoFile = File(video.path);
      });
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
            onPressed: () {
              // Handle post submission
              if (_postController.text.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post Published!')),
                );

                // Navigate to NewsFeedPage after posting
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsFeedPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please write something!')),
                );
              }
            },
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
            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                      'assets/images/profile.png'), // Replace with your profile image
                ),
                const SizedBox(width: 15),
                const Text(
                  "What's on your mind?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

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

            // Add Image Button
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage, // Call the _pickImage method
                  icon: const Icon(Icons.image),
                  label: const Text('Photo/Video'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (_selectedImageFile != null)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            if (_selectedImageFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _selectedImageFile!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Add Video Button
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _recordVideo, // Call the _recordVideo method
                  icon: const Icon(Icons.videocam),
                  label: const Text('Live Video'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (_selectedVideoFile != null)
                  const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
            if (_selectedVideoFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.black12,
                  child: const Center(
                    child:
                        Icon(Icons.play_circle, size: 50, color: Colors.blue),
                  ),
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

            // Preview Selected Location
            if (_selectedLocation != null)
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 5),
                  Text(
                    _selectedLocation!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
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
