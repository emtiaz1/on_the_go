import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
=======
import 'package:intl/intl.dart';
>>>>>>> 8afd4ef5e5a64a389f1a5395719389116c6fc7d1

class EditProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String bio;
  final String jobTitle;
  final String institute;
  final String gender;
  final String bloodGroup;
  final String birthday;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.bio,
    required this.jobTitle,
    required this.institute,
    required this.gender,
    required this.bloodGroup,
    required this.birthday,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late String name;
  late String email;
  late String phone;
  late String location;
  late String bio;
  late String jobTitle;
  late String institute;
  late String gender;
  late String bloodGroup;
  late String birthday;

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> bloodGroupOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  late TextEditingController birthdayController; // Persistent controller

  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
    phone = widget.phone;
    location = widget.location;
    bio = widget.bio;
    jobTitle = widget.jobTitle;
    institute = widget.institute;
    gender = widget.gender;
    bloodGroup = widget.bloodGroup;
    birthday = widget.birthday;

    // Initialize the controller with the initial birthday value
    birthdayController = TextEditingController(text: birthday);
  }

  @override
  void dispose() {
    // Dispose the controller to free resources
    birthdayController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'bio': bio,
        'jobTitle': jobTitle,
        'institute': institute,
        'gender': gender,
        'blood': bloodGroup,
        'birthday': birthday,
      });

      // Show success alert dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Profile updated successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pop(context); // Navigate back
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
    } catch (e) {
      // Show error alert dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error updating profile: $e'),
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
    }
  }

  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: birthday.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(birthday)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthday = DateFormat('dd/MM/yyyy').format(pickedDate);
        birthdayController.text = birthday; // Update the controller
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
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
        title: Text('Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            )),
        backgroundColor: const Color(0xFF104C91),
      ),
      backgroundColor: const Color(0xFFF3F7FA),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
=======
        title: const Text('Edit Profile'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF104C91),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
>>>>>>> 8afd4ef5e5a64a389f1a5395719389116c6fc7d1
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
<<<<<<< HEAD
                _buildTextField('Name', name, (value) => name = value),
                _buildTextField('Email', email, (value) => email = value),
                _buildTextField('Phone', phone, (value) => phone = value),
                _buildTextField(
                    'Location', location, (value) => location = value),
                _buildTextField('Bio', bio, (value) => bio = value),
                _buildTextField(
                    'Job Title', jobTitle, (value) => jobTitle = value),
                _buildTextField(
                    'Institute', institute, (value) => institute = value),
                const SizedBox(height: 20),

=======
                
                // Name Field
                _buildFieldContainer(
                  child: _buildTextField('Name', name, (value) => name = value),
                ),
                
                // Email Field
                _buildFieldContainer(
                  child: _buildTextField('Email', email, (value) => email = value),
                ),
                
                // Phone Field
                _buildFieldContainer(
                  child: _buildTextField('Phone', phone, (value) => phone = value),
                ),
                
                // Location Field
                _buildFieldContainer(
                  child: _buildTextField('Location', location, (value) => location = value),
                ),
                
                // Bio Field
                _buildFieldContainer(
                  child: _buildTextField('Bio', bio, (value) => bio = value),
                ),
                
                // Job Title Field
                _buildFieldContainer(
                  child: _buildTextField('Job Title', jobTitle, (value) => jobTitle = value),
                ),
                
                // Institute Field
                _buildFieldContainer(
                  child: _buildTextField('Institute', institute, (value) => institute = value),
                ),
                
>>>>>>> 8afd4ef5e5a64a389f1a5395719389116c6fc7d1
                // Gender Dropdown
                _buildFieldContainer(
                  child: _buildDropdown(
                    'Gender',
                    genderOptions,
                    gender,
                    (value) => setState(() => gender = value!),
                  ),
                ),
                
                // Blood Group Dropdown
                _buildFieldContainer(
                  child: _buildDropdown(
                    'Blood Group',
                    bloodGroupOptions,
                    bloodGroup,
                    (value) => setState(() => bloodGroup = value!),
                  ),
                ),
                
                // Birthday Picker
                _buildFieldContainer(
                  child: GestureDetector(
                    onTap: () => _selectBirthday(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Birthday',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        controller:
                            birthdayController, // Use persistent controller
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProfile();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF104C91),
<<<<<<< HEAD
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 15),
=======
                      padding: const EdgeInsets.symmetric(vertical: 16),
>>>>>>> 8afd4ef5e5a64a389f1a5395719389116c6fc7d1
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildTextField(
    String label,
    String initialValue,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF104C91), // Custom color for label
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded edges
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Color(0xFF104C91), // Custom color for focused border
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
=======
  Widget _buildFieldContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: child,
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onChanged) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
>>>>>>> 8afd4ef5e5a64a389f1a5395719389116c6fc7d1
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String selectedValue,
    Function(String?) onChanged,
  ) {
<<<<<<< HEAD
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue.isNotEmpty ? selectedValue : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded edges
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: Color(0xFF104C91), // Custom color for focused border
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        dropdownColor: Colors.white, // Background color of the dropdown
        icon: const Icon(Icons.arrow_drop_down,
            color: Color(0xFF104C91)), // Dropdown icon color
        items: options
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(
                    option,
                    style: const TextStyle(color: Colors.black), // Text color
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        style: const TextStyle(
          color: Colors.black, // Text color inside the dropdown
          fontSize: 16,
        ),
=======
    return DropdownButtonFormField<String>(
      value: selectedValue.isNotEmpty ? selectedValue : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        filled: true,
        fillColor: Colors.white,
>>>>>>> 8afd4ef5e5a64a389f1a5395719389116c6fc7d1
      ),
      items: options
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
