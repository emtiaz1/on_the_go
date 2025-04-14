import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
              ),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                onChanged: (value) => phone = value,
              ),
              TextFormField(
                initialValue: location,
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (value) => location = value,
              ),
              TextFormField(
                initialValue: bio,
                decoration: const InputDecoration(labelText: 'Bio'),
                onChanged: (value) => bio = value,
              ),
              TextFormField(
                initialValue: jobTitle,
                decoration: const InputDecoration(labelText: 'Job Title'),
                onChanged: (value) => jobTitle = value,
              ),
              TextFormField(
                initialValue: institute,
                decoration: const InputDecoration(labelText: 'Institute'),
                onChanged: (value) => institute = value,
              ),
              TextFormField(
                initialValue: gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                onChanged: (value) => gender = value,
              ),
              TextFormField(
                initialValue: bloodGroup,
                decoration: const InputDecoration(labelText: 'Blood Group'),
                onChanged: (value) => bloodGroup = value,
              ),
              TextFormField(
                initialValue: birthday,
                decoration: const InputDecoration(labelText: 'Birthday'),
                onChanged: (value) => birthday = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfile();
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}