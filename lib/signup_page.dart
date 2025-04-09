import 'package:flutter/material.dart';

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

  void signUp() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      Navigator.pop(context, {'username': username, 'password': password});
    } else {
      setState(() {
        showError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
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
            border: Border.all(color: Colors.blue),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label, // Placeholder text
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40), // Space at the top
              const Text(
                'On the Go',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              buildInputField(label: 'Name', controller: nameController),
              const SizedBox(height: 20),
              buildInputField(label: 'Email', controller: emailController),
              const SizedBox(height: 20),
              buildInputField(label: 'Phone Number', controller: phoneController),
              const SizedBox(height: 20),
              buildInputField(label: 'Username', controller: usernameController),
              const SizedBox(height: 20),
              buildInputField(
                label: 'Password',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}