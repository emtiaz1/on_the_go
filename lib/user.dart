import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_the_go_demo/get_data_page.dart';
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
  bool isLoading = true;

  String selectedOption = 'Posts'; // Default selected option
  String bio =
      'I am a traveller, I love to travel in different places. I love to keep updating traffic condition to help people.'; // Editable bio
  String jobTitle = 'Software Engineer'; // Editable job title
  String company = 'ABC Tech Ltd.'; // Editable company name
  String university =
      'Daffodil International University'; // Editable university
  String maritalStatus = 'Single'; // Editable marital status
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showFullCoverPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: InteractiveViewer(
            child: Image.asset(
              'assets/images/cover.png', // Full cover photo
              fit: BoxFit.cover,
            ),
          ),
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
            // Cover Photo with Profile Picture
            Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () => _showFullCoverPhoto(context),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/cover.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: MediaQuery.of(context).size.width / 2 - 60,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            // User Name
            Text(
              name,
              style: TextStyle(
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Bio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
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
              subtitle: const Text('Computer Science'),
            ),
            // College
            const ListTile(
              leading: Icon(Icons.account_balance, color: Colors.blue),
              title: Text('Mirpur Govt High School'),
              subtitle: Text('Science'),
            ),
            // Marital Status
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.blue),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(maritalStatus),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editInfo('Marital Status', maritalStatus, (newValue) {
                        setState(() {
                          maritalStatus = newValue;
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
                  Icon(Icons.phone, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    phone, // Error: 'phone' is not a constant
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 10),
                  Text(
                    'Mirpur 10',
                    style: TextStyle(fontSize: 16),
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
          ],
        ),
      ),
    );
  }
}
