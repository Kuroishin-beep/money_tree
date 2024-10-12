import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'ImagePickerService.dart'; // Import the ImagePickerService


class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  DateTime? _selectedBirthday;
  File? _profileImage;
  final ImagePickerService _imagePickerService = ImagePickerService();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showImageSourceSelection() {
    _imagePickerService.showImageSourceSelection(context, (image) {
      setState(() {
        _profileImage = image;
      });
    });
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  void _submit() async {
    final user = _auth.currentUser;

    if (user != null) {
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String email = user.email ?? '';
      String birthday = _selectedBirthday != null ? DateFormat('yyyy-MM-dd').format(_selectedBirthday!) : '';

      await _firestore.collection('users').doc(user.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'birthday': birthday,
        'profileImage': _profileImage != null ? await _uploadImage() : null,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()), // Replace with your Dashboard widget
      );
    }
  }

  Future<String?> _uploadImage() async {
    // Implement image upload to Firebase Storage and return the URL
    return 'url_to_uploaded_image';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: sw * 0.05),

            // Profile Picture
            Center(
              child: GestureDetector(
                onTap: _showImageSourceSelection, // Use the new method
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null ? const Icon(Icons.add_a_photo, size: 40) : null,
                ),
              ),
            ),
            SizedBox(height: sw * 0.05),

            // First Name
            const Text('First Name', style: TextStyle(fontSize: 18)),
            TextField(controller: _firstNameController),

            SizedBox(height: sw * 0.02),

            // Last Name
            const Text('Last Name', style: TextStyle(fontSize: 18)),
            TextField(controller: _lastNameController),

            SizedBox(height: sw * 0.02),

            // Birthday
            const Text('Birthday', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedBirthday != null ? DateFormat('yyyy-MM-dd').format(_selectedBirthday!) : 'Select your birthday',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: _showDatePicker,
                  child: const Text('Select Date'),
                ),
              ],
            ),

            SizedBox(height: sw * 0.05),

            // Confirm Email
            const Text('Confirm Email', style: TextStyle(fontSize: 18)),
            Text(
              _auth.currentUser?.email ?? '',
              style: const TextStyle(fontSize: 16),
            ),

            SizedBox(height: sw * 0.05),

            // Submit Button
            ElevatedButton(
              onPressed: _submit,
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
              ),
              child: const Text('Proceed to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}



