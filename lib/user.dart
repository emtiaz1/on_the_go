import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_the_go_demo/get_data_page.dart';
import 'package:on_the_go_demo/login_page.dart';
import 'package:video_player/video_player.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String name = '';
  String email = '';
  String phone = '';
  String location = ''; // Added location field
  String imageUrl = ''; // URL for the user's profile picture
  String selectedOption = ''; // Default selected option
  String bio = ''; // Editable bio
  String jobTitle = ''; // Editable job title
  String company = ''; // Editable company name
  String university = ''; // Editable university
  bool isLoading = true;
  VideoPlayerController? _videoController; // Video player controller

  final List<String> posts = [
    'Avois Mirpur 10 circle, Protest is going on. huge traffic here!',
    'Traffic update: Heavy traffic on Savar Birulia Road. Avoid if possible.',
    'Fire on Gazipur Steelteck Factory!'
  ];

  final List<String> images = [
    'assets/images/post1.png',
    'assets/images/post2.png',
    'assets/images/post3.png'
  ];

  final List<String> videos = [
    'assets/videos/vid1.mp4',
  ];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    if (documentId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Fetch user data from Firestore using the global document ID
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          name = userData['name'] ?? '';
          email = userData['email'] ?? '';
          phone = userData['phone'] ?? '';
          location = userData['location'] ?? ''; // Load location
          imageUrl = userData['imageUrl'] ?? '';
          bio = userData['bio'] ?? '';
          jobTitle = userData['jobTitle'] ?? '';
          company = userData['company'] ?? '';
          university = userData['university'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  Future<void> saveUserData() async {
    if (documentId == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(documentId).set({
        'name': name,
        'email': email,
        'phone': phone,
        'location': location, // Save location
        'imageUrl': imageUrl,
        'bio': bio,
        'jobTitle': jobTitle,
        'company': company,
        'university': university,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving user data: $e')),
      );
    }
  }

  void _editInfo(String title, String currentValue, Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text); // Save the new value
                saveUserData(); // Save updated data to Firestore
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _playVideo(String videoPath) {
    if (_videoController != null) {
      _videoController!.dispose(); // Dispose the previous controller
    }

    _videoController = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        setState(() {}); // Refresh the UI after initialization
        _videoController!.play(); // Start playing the video
      });
  }

  void _editProfilePicture() {
    TextEditingController controller = TextEditingController(text: imageUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile Picture'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter image URL',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  imageUrl = controller.text; // Update the profile picture URL
                });
                saveUserData(); // Save updated data to Firestore
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _videoController?.dispose(); // Dispose the video controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50), // Add spacing at the top
            // Profile Picture
            GestureDetector(
              onTap: _editProfilePicture, // Open dialog to edit profile picture
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl)
                        : const AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius:
                      BorderRadius.circular(8), // Slightly rounded corners
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.circular(4), // Match the square shape
                    ),
                    child:
                        const Icon(Icons.edit, color: Colors.white, size: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // User Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // User Email
            Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            // About Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'About',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      bio,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editInfo('Bio', bio, (newValue) {
                        setState(() {
                          bio = newValue;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Job
            ListTile(
              leading: const Icon(Icons.work, color: Colors.blue),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(jobTitle),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editInfo('Job Title', jobTitle, (newValue) {
                        setState(() {
                          jobTitle = newValue;
                        });
                      });
                    },
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(company),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editInfo('Company', company, (newValue) {
                        setState(() {
                          company = newValue;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            // University
            ListTile(
              leading: const Icon(Icons.school, color: Colors.blue),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(university),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editInfo('University', university, (newValue) {
                        setState(() {
                          university = newValue;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Contact Information
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    phone,
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editInfo('Phone', phone, (newValue) {
                        setState(() {
                          phone = newValue;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 10),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editInfo('Location', location, (newValue) {
                        setState(() {
                          location = newValue;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Space before the options bar
            // Options Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Posts';
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedOption == 'Posts'
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      if (selectedOption == 'Posts')
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 50,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Photos';
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Photos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedOption == 'Photos'
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      if (selectedOption == 'Photos')
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 50,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Videos';
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Videos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: selectedOption == 'Videos'
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                      if (selectedOption == 'Videos')
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 2,
                          width: 50,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Content Based on Selected Option
            if (selectedOption == 'Posts')
              Column(
                children: posts
                    .map((post) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                post,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              )
            else if (selectedOption == 'Photos')
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                padding: const EdgeInsets.all(16.0),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              )
            else if (selectedOption == 'Videos')
              Column(
                children: videos
                    .map((video) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            elevation: 2,
                            child: Column(
                              children: [
                                if (_videoController != null &&
                                    _videoController!.value.isInitialized &&
                                    _videoController!.dataSource == video)
                                  AspectRatio(
                                    aspectRatio:
                                        _videoController!.value.aspectRatio,
                                    child: VideoPlayer(_videoController!),
                                  )
                                else
                                  ListTile(
                                    leading: const Icon(Icons.play_circle_fill,
                                        color: Colors.blue, size: 40),
                                    title: Text(
                                      video
                                          .split('/')
                                          .last, // Display video name
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    onTap: () {
                                      _playVideo(
                                          video); // Play the selected video
                                    },
                                  ),
                                if (_videoController != null &&
                                    _videoController!.value.isInitialized &&
                                    _videoController!.dataSource == video)
                                  VideoProgressIndicator(
                                    _videoController!,
                                    allowScrubbing: true,
                                  ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut(); // Sign out the user
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  ); // Navigate back to the login page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
