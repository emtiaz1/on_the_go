import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  List<Map<String, dynamic>> posts = []; // List to store posts
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      // Fetch posts from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      // Map Firestore documents to a list of posts
      final List<Map<String, dynamic>> loadedPosts = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      setState(() {
        posts = loadedPosts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $e')),
      );
    }
  }

  Widget _buildNewsFeed() {
    return SingleChildScrollView(
      child: Column(
        children: posts.map((post) {
          return Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post Author and Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post['user'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        post['location'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Post Content
                  Text(
                    post['content'] ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  // Post Image
                  if (post['image'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        post['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 10),
                  // Tags
                  if (post['tags'] != null)
                    Wrap(
                      spacing: 8.0,
                      children: (post['tags'] as List<dynamic>)
                          .map<Widget>(
                            (tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.blue[100],
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 10),
                  // Reactions and Views
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Reactions
                      Row(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.thumb_up, color: Colors.blue),
                              const SizedBox(width: 3),
                              Text('${post['reactions']['like']} Likes'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          if (post['reactions'].containsKey('angry'))
                            Row(
                              children: [
                                const Icon(Icons.sentiment_very_dissatisfied,
                                    color: Colors.red),
                                const SizedBox(width: 3),
                                Text('${post['reactions']['angry']} Angry'),
                              ],
                            ),
                          const SizedBox(width: 10),
                          if (post['reactions'].containsKey('sad'))
                            Row(
                              children: [
                                const Icon(Icons.sentiment_dissatisfied,
                                    color: Colors.orange),
                                const SizedBox(width: 3),
                                Text('${post['reactions']['sad']} Sad'),
                              ],
                            ),
                        ],
                      ),
                      // Views
                      Row(
                        children: [
                          const Icon(Icons.visibility, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text('${post['views']} Views'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Movement Indicator
                  if (post['movement'] == true)
                    const Text(
                      '🚨 Movement Alert',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Newsfeed'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildNewsFeed(),
    );
  }
}
