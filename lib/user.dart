import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:on_the_go_demo/EditProfilePage.dart';
import 'package:on_the_go_demo/login_page.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String name = '';
  String email = '';
  String phone = '';
  String location = '';
  String imageUrl = '';
  String selectedOption = 'Posts';
  String bio = '';
  String jobTitle = '';
  String institute = '';
  String gender = '';
  String bloodGroup = '';
  String birthday = '';
  String accountCreated = '';
  String facebook = '';

  bool isLoading = true;
  VideoPlayerController? _videoController;

  final List<String> posts = [
    'Avoid Mirpur 10 circle, protest is going on. Huge traffic here!',
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
    final documentId = FirebaseAuth.instance.currentUser?.uid;
    if (documentId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
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
          location = userData['location'] ?? '';
          imageUrl = userData['imageUrl'] ?? '';
          bio = userData['bio'] ?? '';
          jobTitle = userData['jobTitle'] ?? '';
          institute = userData['institute'] ?? '';
          gender = userData['gender'] ?? '';
          bloodGroup = userData['blood'] ?? '';
          birthday = userData['birthday'] ?? '';
          accountCreated = userData['accountCreated'] ?? '';
          facebook = userData['facebook'] ?? '';
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

  void _playVideo(String videoPath) {
    _videoController?.dispose();
    _videoController = VideoPlayerController.asset(videoPath)
      ..initialize().then((_) {
        setState(() {
          _videoController!.play();
        });
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000), // Replaced Colors.grey.withOpacity(0.2)
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? 'Not provided' : value,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableInfoCard(IconData icon, String title, String value, String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication, // Ensures the URL opens in the browser
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch URL')),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBioSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            bio.isEmpty ? 'No bio provided.' : bio,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade400],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 30.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : const AssetImage(
                                    'assets/images/default_profile.png')
                                as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      name.isEmpty ? 'User' : name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email.isEmpty ? 'No email' : email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xE6FFFFFF),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // About Section with Edit Profile Button
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              name: name,
                              email: email,
                              phone: phone,
                              location: location,
                              bio: bio,
                              jobTitle: jobTitle,
                              institute: institute,
                              gender: gender,
                              bloodGroup: bloodGroup,
                              birthday: birthday,
                            ),
                          ),
                        ).then((_) {
                          // Refresh user data after editing
                          fetchUserData();
                        });
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Bio Section
            _buildBioSection(),

            // Other Information
            if (jobTitle.isNotEmpty)
              _buildInfoCard(Icons.work, 'Job Title', jobTitle),
            if (institute.isNotEmpty)
              _buildInfoCard(Icons.school, 'Institute', institute),
            if (bloodGroup.isNotEmpty)
              _buildInfoCard(Icons.water_drop, 'Blood Group', bloodGroup),
            if (gender.isNotEmpty)
              _buildInfoCard(Icons.person, 'Gender', gender),
            if (birthday.isNotEmpty)
              _buildInfoCard(Icons.cake, 'Birthday', birthday),
            if (accountCreated.isNotEmpty)
              _buildInfoCard(
                  Icons.date_range, 'Account Created', accountCreated),

            // Contact Information Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            if (phone.isNotEmpty) _buildInfoCard(Icons.phone, 'Phone', phone),
            if (location.isNotEmpty)
              _buildInfoCard(Icons.location_on, 'Location', location),
            if (facebook.isNotEmpty)
              _buildClickableInfoCard(
                Icons.facebook,
                'Facebook',
                facebook,
                'https://$facebook', // Ensure the URL is properly formatted
              ),

            const SizedBox(height: 30),

            // Tabs for Posts, Photos, Videos
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['Posts', 'Photos', 'Videos'].map((option) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOption = option;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: selectedOption == option
                              ? Colors.blue.shade700
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selectedOption == option
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Content based on selected tab
            if (selectedOption == 'Posts')
              Column(
                children: posts
                    .map((post) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                post,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
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
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
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
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(
                              children: [
                                if (_videoController != null &&
                                    _videoController!.value.isInitialized &&
                                    _videoController!.dataSource == video)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: AspectRatio(
                                      aspectRatio:
                                          _videoController!.value.aspectRatio,
                                      child: VideoPlayer(_videoController!),
                                    ),
                                  )
                                else
                                  ListTile(
                                    leading: Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.blue.shade700,
                                      size: 40,
                                    ),
                                    title: Text(
                                      video.split('/').last,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    onTap: () {
                                      _playVideo(video);
                                    },
                                  ),
                                if (_videoController != null &&
                                    _videoController!.value.isInitialized &&
                                    _videoController!.dataSource == video)
                                  VideoProgressIndicator(
                                    _videoController!,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      playedColor: Colors.blue.shade700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),

            const SizedBox(height: 30),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
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
