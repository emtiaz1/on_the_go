import 'package:flutter/material.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqs = [
      {
        'question': 'What is On The Go?',
        'answer':
            'On The Go is a mobile application designed to help users explore, connect, and share their experiences on the go.',
      },
      {
        'question': 'How do I create a new post?',
        'answer':
            'To create a new post, navigate to the "New Post" section from the bottom navigation bar, fill in the required details, and click the "Post" button.',
      },
      {
        'question': 'How can I save a post?',
        'answer':
            'You can save a post by clicking the "Save Post" button available on each post in the newsfeed.',
      },
      {
        'question': 'How do I edit my profile?',
        'answer':
            'To edit your profile, go to the "Account" section and click on "Edit Profile." You can update your details there.',
      },
      {
        'question': 'How do I change the app language?',
        'answer':
            'To change the app language, go to the "Settings" section and select "Language." Choose your preferred language from the list.',
      },
      {
        'question': 'How do I report an issue?',
        'answer':
            'If you encounter any issues, you can report them by navigating to the "Settings" section and selecting "Report an Issue."',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white, // White text for contrast
          ),
        ),
        backgroundColor: const Color(0xFF104C91), // Blue background for AppBar
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white), // White icons
      ),
      body: Container(
        color: const Color(0xFFF5F5F5), // Light gray background for the body
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 600 + (index * 100)),
              curve: Curves.easeOutExpo,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, (1 - value) * 20),
                  child: child,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white, // White card background
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    unselectedWidgetColor: const Color(
                        0xFF104C91), // Blue color for collapsed icon
                    colorScheme: const ColorScheme.light(), // Light theme
                  ),
                  child: ExpansionTile(
                    collapsedIconColor:
                        const Color(0xFF104C91), // Blue icon when collapsed
                    iconColor:
                        const Color(0xFF104C91), // Blue icon when expanded
                    leading: const Icon(
                      Icons.help_outline,
                      color: Color(0xFF104C91), // Blue icon for questions
                    ),
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF104C91), // Blue color for questions
                      ),
                    ),
                    children: [
                      Container(
                        color: Colors.white, // White background for the answer
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                faq['answer']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors
                                      .black87, // Slightly lighter black for answers
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
