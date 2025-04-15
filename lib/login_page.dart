import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:on_the_go_demo/get_data_page.dart';
import 'package:on_the_go_demo/utils/constans/colors.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isPasswordVisible = false; // Track password visibility

  void login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String email = usernameController.text.trim();
      String password = passwordController.text.trim();

      // Ensure email format (you might want to add more validation)
      if (!email.contains('@')) {
        email = '$email@example.com'; // Adjust based on your needs
      }

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        // Show a dialog with a circular loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(
                    color: Color(0xFFA52E45), // Brown color
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    'Login Successful!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        );

        // Dismiss the dialog after 2 seconds and navigate to the next page
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop(); // Close the dialog

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GetDataPage(email: email)),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Invalid password provided.';
          break;
        case 'invalid-email':
          message = 'Invalid email format.';
          break;
        default:
          message = 'Invalid Username or Password';
      }

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Failed'),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('An error occurred. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'On the',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.lobster().fontFamily,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Go',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.lobster().fontFamily,
                      color: OColors.lightRed,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey[600],
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10), // Adjusted padding
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText:
                      !_isPasswordVisible, // Toggle password visibility
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.grey[600],
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10), // Adjusted padding
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E8AC0),
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: navigateToSignUp,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
