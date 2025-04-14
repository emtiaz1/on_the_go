import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

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
  final List<String> bloodGroupOptions = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue.shade600,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.blue.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Your Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Name', name, (value) => name = value),
                _buildTextField('Email', email, (value) => email = value),
                _buildTextField('Phone', phone, (value) => phone = value),
                _buildTextField('Location', location, (value) => location = value),
                _buildTextField('Bio', bio, (value) => bio = value),
                _buildTextField('Job Title', jobTitle, (value) => jobTitle = value),
                _buildTextField('Institute', institute, (value) => institute = value),
                const SizedBox(height: 20),

                // Gender Dropdown
                _buildDropdown(
                  'Gender',
                  genderOptions,
                  gender,
                  (value) => setState(() => gender = value!),
                ),

                // Blood Group Dropdown
                _buildDropdown(
                  'Blood Group',
                  bloodGroupOptions,
                  bloodGroup,
                  (value) => setState(() => bloodGroup = value!),
                ),

                // Birthday Picker
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        ),
                        controller: TextEditingController(text: birthday),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProfile();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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

  Widget _buildTextField(String label, String initialValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    String selectedValue,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue.isNotEmpty ? selectedValue : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: options
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}