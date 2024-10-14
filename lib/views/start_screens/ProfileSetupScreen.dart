import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'ImagePickerService.dart';

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
      String birthday = _selectedBirthday != null
          ? DateFormat('yyyy-MM-dd').format(_selectedBirthday!)
          : '';

      DocumentReference userDocRef = _firestore.collection('users').doc(user.uid);

      try {
        String? imageUrl;
        if (_profileImage != null) {
          imageUrl = await _uploadImage(); // Upload and get URL
        }

        DocumentSnapshot docSnapshot = await userDocRef.get();

        if (docSnapshot.exists) {
          await userDocRef.update({
            'firstName': firstName,
            'lastName': lastName,
            'birthday': birthday,
            'profileImage': imageUrl,
          });
        } else {
          await userDocRef.set({
            'firstName': firstName,
            'lastName': lastName,
            'birthday': birthday,
            'profileImage': imageUrl,
            'email': email,
          });
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      } catch (e) {
        print("Error updating user document: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile: $e")),
        );
      }
    }
  }

  Future<String?> _uploadImage() async {
    if (_profileImage == null) return null;

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String filePath = 'profile_images/${_auth.currentUser!.uid}.png';

      TaskSnapshot snapshot = await storage.ref(filePath).putFile(_profileImage!);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image upload failed: $e")),
      );
      return null;
    }
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
            Center(
              child: GestureDetector(
                onTap: _showImageSourceSelection,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.add_a_photo, size: 40)
                      : null,
                ),
              ),
            ),
            SizedBox(height: sw * 0.05),
            const Text('First Name', style: TextStyle(fontSize: 18)),
            TextField(controller: _firstNameController),
            SizedBox(height: sw * 0.02),
            const Text('Last Name', style: TextStyle(fontSize: 18)),
            TextField(controller: _lastNameController),
            SizedBox(height: sw * 0.02),
            const Text('Birthday', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedBirthday != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedBirthday!)
                        : 'Select your birthday',
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
            const Text('Confirm Email', style: TextStyle(fontSize: 18)),
            Text(
              _auth.currentUser?.email ?? '',
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(height: sw * 0.05),
            ElevatedButton(
              onPressed: _submit,
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 50)),
              ),
              child: const Text('Proceed to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
