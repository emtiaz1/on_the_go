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
      final userId = "currentUserId"; // Replace with the actual user ID

      // Fetch posts from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      // Map Firestore documents to a list of posts
      final List<Map<String, dynamic>> loadedPosts = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add document ID for updating reactions

        // Ensure reactions field exists
        data['reactions'] = data['reactions'] ??
            {
              'like': 0,
              'angry': 0,
              'sad': 0,
            };

        // Provide default values for other fields
        data['content'] = data['content'] ?? 'No content available';
        data['image'] = data['image'] ?? '';
        data['location'] = data['location'] ?? 'Unknown Location';
        data['tags'] = data['tags'] ?? [];
        data['user'] = data['user'] ?? 'Unknown User';
        data['views'] = data['views'] ?? 0;
        data['movement'] = data['movement'] ?? false;

        loadedPosts.add(data);
      }

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

  Future<void> _updateReaction(String postId, String newReactionType) async {
    try {
      final postIndex = posts.indexWhere((post) => post['id'] == postId);
      if (postIndex == -1) return;

      final currentReactions = posts[postIndex]['reactions'] ?? {};
      final currentReactionType =
          posts[postIndex]['userReaction']; // Track current user reaction

      // Ensure newReactionType is not null
      if (newReactionType.isEmpty) {
        throw Exception('Reaction type cannot be null or empty');
      }

      // Decrement the previous reaction count if the user had already reacted
      if (currentReactionType != null &&
          currentReactionType != newReactionType) {
        final previousCount = currentReactions[currentReactionType] ?? 0;
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'reactions.$currentReactionType':
              previousCount > 0 ? previousCount - 1 : 0,
        });
      }

      // Increment the new reaction count
      final newCount = currentReactions[newReactionType] ?? 0;
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'reactions.$newReactionType': newCount + 1,
      });

      // Update local state
      setState(() {
        if (currentReactionType != null &&
            currentReactionType != newReactionType) {
          posts[postIndex]['reactions'][currentReactionType] =
              (currentReactions[currentReactionType] ?? 1) -
                  1; // Decrement previous reaction
        }
        posts[postIndex]['reactions'][newReactionType] =
            newCount + 1; // Increment new reaction
        posts[postIndex]['userReaction'] =
            newReactionType; // Update user reaction
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating reaction: $e')),
      );
    }
  }

  Widget _buildNewsFeed() {
    return SingleChildScrollView(
      child: Column(
        children: posts.map((post) {
          final reactions = post['reactions'] ?? {};
          final userReaction = post['userReaction']; // Track user reaction

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
                        post['user'] ?? 'Unknown User', // Default value
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        post['location'] ?? 'Unknown Location', // Default value
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
                    post['content'] ?? 'No content available', // Default value
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  // Post Image
                  if (post['image'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        post['image'] ?? '', // Default value
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
                              label: Text(tag ?? ''), // Default value
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
                          IconButton(
                            icon: Icon(
                              Icons.thumb_up,
                              color: userReaction == 'like'
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _updateReaction(post['id'], 'like');
                            },
                          ),
                          Text('${reactions['like'] ?? 0}'), // Default value
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_very_dissatisfied,
                              color: userReaction == 'angry'
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _updateReaction(post['id'], 'angry');
                            },
                          ),
                          Text('${reactions['angry'] ?? 0}'), // Default value
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_dissatisfied,
                              color: userReaction == 'sad'
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _updateReaction(post['id'], 'sad');
                            },
                          ),
                          Text('${reactions['sad'] ?? 0}'), // Default value
                        ],
                      ),
                      // Views
                      Row(
                        children: [
                          const Icon(Icons.visibility, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text('${post['views'] ?? 0} Views'), // Default value
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
