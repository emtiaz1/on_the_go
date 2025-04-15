import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool showError = false;
  bool isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        // Create a new user with Firebase Authentication
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user information to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'email': email,
          'phone': phone,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Show success dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Account created successfully!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      Navigator.pop(context, {
                        'email': email,
                        'password': password
                      }); // Navigate back to login
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Color(0xFF104C91),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          showError = true;
        });

        String errorMessage;
        if (e.code == 'email-already-in-use') {
          errorMessage = 'This email is already in use.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'The password is too weak.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'The email address is invalid.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }

        // Show error dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(errorMessage),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Color(0xFF104C91),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        showError = true;
      });

      // Show error dialog for empty fields
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFF104C91),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Color(0xFF104C91),
            ),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            obscureText: obscureText,
          ),
        ),
        if (showError && controller.text.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              '* This field is required',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F7FA),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 150),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF104C91),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              buildInputField(label: 'Name', controller: nameController),
              const SizedBox(height: 20),
              buildInputField(label: 'Email', controller: emailController),
              const SizedBox(height: 20),
              buildInputField(
                  label: 'Phone Number', controller: phoneController),
              const SizedBox(height: 20),
              buildInputField(
                  label: 'Username', controller: usernameController),
              const SizedBox(height: 20),
              buildInputField(
                label: 'Password',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF104C91),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Navigate back to the login page
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF104C91),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
