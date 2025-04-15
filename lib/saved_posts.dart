import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:on_the_go_demo/OriginalPostPage.dart';

class SavedPostsPage extends StatelessWidget {
  const SavedPostsPage({super.key});

  Future<List<Map<String, dynamic>>> fetchSavedPosts() async {
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Fetch saved posts from the user's saved_posts subcollection
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_posts')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Include the document ID for deletion
        return data;
      }).toList();
    } catch (e) {
      debugPrint('Error fetching saved posts: $e');
      return [];
    }
  }

  Future<void> deleteSavedPost(String postId) async {
    try {
      // Get the current user's ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Delete the post from the saved_posts subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('saved_posts')
          .doc(postId)
          .delete();

      debugPrint('Post deleted successfully');
    } catch (e) {
      debugPrint('Error deleting post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back.png',
            color: Colors.white,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: const Text(
          'Saved Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white, // White text for contrast
          ),
        ),
        backgroundColor: const Color(0xFF104C91),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSavedPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No saved posts yet!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final savedPosts = snapshot.data!;
          return ListView.builder(
            itemCount: savedPosts.length,
            itemBuilder: (context, index) {
              final post = savedPosts[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(post['content'] ?? 'No Content'),
                  subtitle: Text('Saved by: ${post['savedBy'] ?? 'Unknown'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Post'),
                          content: const Text(
                              'Are you sure you want to delete this saved post?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await deleteSavedPost(post['id']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Post deleted')),
                        );
                        // Refresh the page after deletion
                        (context as Element).reassemble();
                      }
                    },
                  ),
                  onTap: () {
                    // Navigate to the original post page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OriginalPostPage(post: post),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
