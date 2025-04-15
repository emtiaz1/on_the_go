import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:on_the_go_demo/utils/constans/colors.dart'; // Import intl package

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
      // Fetch posts from Firestore and order by timestamp in descending order
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      final List<Map<String, dynamic>> loadedPosts = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        data['reactions'] = data['reactions'] ??
            {
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
        data['timestamp'] = data['timestamp']; // Keep null if not available

        loadedPosts.add(data);
      }

      if (mounted) {
        setState(() {
          posts = loadedPosts;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading posts: $e')),
        );
      }
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
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';
      final userEmail =
          FirebaseAuth.instance.currentUser?.email ?? 'unknown_email';

      final savedPostRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_posts');

      final existingPost = await savedPostRef.doc(post['id']).get();
      if (existingPost.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post already saved!')),
        );
        return;
      }

      await savedPostRef.doc(post['id']).set({
        'id': post['id'],
        'content': post['content'] ?? '',
        'image': post['image'] ?? '',
        'location': post['location'] ?? '',
        'tags': post['tags'] ?? [],
        'user': post['user'] ?? '',
        'views': post['views'] ?? 0,
        'movement': post['movement'] ?? false,
        'savedAt': Timestamp.now(),
        'savedBy': userEmail,
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

  Future<bool> _isPostSaved(String postId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return false;

      final savedPostRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_posts')
          .doc(postId);

      final doc = await savedPostRef.get();
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking if post is saved: $e');
      return false;
    }
  }

  Widget _buildNewsFeed() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: posts.map((post) {
          final reactions = post['reactions'] ?? {};
          final userReaction = post['userReaction'];
          final timestamp = post['timestamp'];

          DateTime? postDate;

          // Parse the timestamp if it's a String or Timestamp
          if (timestamp is String) {
            postDate = DateTime.tryParse(timestamp);
          } else if (timestamp is Timestamp) {
            postDate = timestamp.toDate();
          }

          final formattedTimestamp = postDate != null
              ? DateFormat('MMM d, yyyy h:mm a').format(postDate)
              : null;

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['user'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                          if (formattedTimestamp != null)
                            Text(
                              formattedTimestamp,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
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
                  Text(
                    post['content'],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (post['image'].isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildImage(post['image']),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                IonIcons.alert_circle,
                                color: userReaction == 'like'
                                    ? Colors.redAccent
                                    : Colors.grey,
                              ),
                              onPressed: () =>
                                  _updateReaction(post['id'], 'like'),
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
                              onPressed: () =>
                                  _updateReaction(post['id'], 'sad'),
                            ),
                            Text('${reactions['sad'] ?? 0}'),
                          ],
                        ),
                      ),
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
                  FutureBuilder<bool>(
                    future: _isPostSaved(post['id']),
                    builder: (context, snapshot) {
                      final isSaved = snapshot.data ?? false;
                      return Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: isSaved ? null : () => _savePost(post),
                          icon: Icon(
                            Icons.bookmark_add_outlined,
                            color: isSaved ? Colors.grey : Colors.blue,
                          ),
                          label: Text(
                            isSaved ? 'Saved' : 'Save Post',
                            style: TextStyle(
                              color: isSaved ? Colors.grey : Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      // Network image
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
        },
      );
    } else {
      // Asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildNewsFeed(),
    );
  }
}
