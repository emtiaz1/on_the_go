import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsFeedPage extends StatefulWidget {
  const NewsFeedPage({super.key});

  @override
  State<NewsFeedPage> createState() => _NewsFeedPageState();
}

class _NewsFeedPageState extends State<NewsFeedPage> {
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final userId = "currentUserId";

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('posts').get();

      final List<Map<String, dynamic>> loadedPosts = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        data['reactions'] = data['reactions'] ?? {
          'like': 0,
          'angry': 0,
          'sad': 0,
        };
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
      final currentReactionType = posts[postIndex]['userReaction'];

      if (newReactionType.isEmpty) {
        throw Exception('Reaction type cannot be null or empty');
      }

      if (currentReactionType != null && currentReactionType != newReactionType) {
        final previousCount = currentReactions[currentReactionType] ?? 0;
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'reactions.$currentReactionType':
              previousCount > 0 ? previousCount - 1 : 0,
        });
      }

      final newCount = currentReactions[newReactionType] ?? 0;
      await FirebaseFirestore.instance.collection('posts').doc(postId).update({
        'reactions.$newReactionType': newCount + 1,
      });

      setState(() {
        if (currentReactionType != null &&
            currentReactionType != newReactionType) {
          posts[postIndex]['reactions'][currentReactionType] =
              (currentReactions[currentReactionType] ?? 1) - 1;
        }
        posts[postIndex]['reactions'][newReactionType] = newCount + 1;
        posts[postIndex]['userReaction'] = newReactionType;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating reaction: $e')),
      );
    }
  }

  Future<void> _savePost(Map<String, dynamic> post) async {
    try {
      // Get the current user's ID and email
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';
      final userEmail = FirebaseAuth.instance.currentUser?.email ?? 'unknown_email';

      // Reference to the saved_posts subcollection
      final savedPostRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_posts');

      // Check if the post is already saved
      final existingPost = await savedPostRef.doc(post['id']).get();
      if (existingPost.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post already saved!')),
        );
        return;
      }

      // Save the post with all its details
      await savedPostRef.doc(post['id']).set({
        'id': post['id'], // Unique ID of the post
        'content': post['content'] ?? 'No content available',
        'image': post['image'] ?? '', // Image URL or path
        'location': post['location'] ?? 'Unknown Location',
        'tags': post['tags'] ?? [], // Tags associated with the post
        'user': post['user'] ?? 'Unknown User', // Author of the post
        'views': post['views'] ?? 0, // Number of views
        'movement': post['movement'] ?? false, // Movement alert flag
        'reactions': post['reactions'] ?? {}, // Reactions (like, angry, sad, etc.)
        'savedAt': Timestamp.now(), // Timestamp when the post was saved
        'savedBy': userEmail, // Email of the user who saved the post
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving post: $e')),
      );
    }
  }

  Widget _buildNewsFeed() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: posts.map((post) {
          final reactions = post['reactions'] ?? {};
          final userReaction = post['userReaction'];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Author & Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post['user'],
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      Text(
                        post['location'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  /// Content
                  Text(
                    post['content'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Image
                  if (post['image'].isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        post['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 10),

                  /// Tags
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

                  /// Reactions & Views
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Reactions
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              IonIcons.alert_circle,
                              color: userReaction == 'like'
                                  ? Colors.redAccent
                                  : Colors.grey,
                            ),
                            onPressed: () => _updateReaction(post['id'], 'like'),
                          ),
                          Text('${reactions['like'] ?? 0}'),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_satisfied_rounded,
                              color: userReaction == 'angry'
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: () =>
                                _updateReaction(post['id'], 'angry'),
                          ),
                          Text('${reactions['angry'] ?? 0}'),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(
                              Icons.sentiment_dissatisfied_rounded,
                              color: userReaction == 'sad'
                                  ? Colors.orangeAccent
                                  : Colors.grey,
                            ),
                            onPressed: () => _updateReaction(post['id'], 'sad'),
                          ),
                          Text('${reactions['sad'] ?? 0}'),
                        ],
                      ),

                      /// Views
                      Row(
                        children: [
                          const Icon(Icons.remove_red_eye_outlined,
                              size: 18, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${post['views']} views',
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// Save Post Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _savePost(post),
                      icon: const Icon(Icons.bookmark_add_outlined,
                          color: Colors.blue),
                      label: const Text(
                        'Save Post',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),

                  /// Movement alert
                  if (post['movement'] == true) ...[
                    const SizedBox(height: 6),
                    Text(
                      '🚨 Movement Alert',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ]
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
      backgroundColor: const Color(0xFFF3F7FA),
      appBar: AppBar(
        title: Text(
          'NewsFeed',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildNewsFeed(),
    );
  }
}
