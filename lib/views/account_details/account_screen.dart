import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_tree/views/account_details/account_birthdate_screen.dart';
import 'package:money_tree/views/account_details/account_email_screen.dart';
import 'package:money_tree/views/account_details/account_mobileno_screen.dart';
import 'package:money_tree/views/account_details/account_name_screen.dart';
import '../constants/bottom_navigation.dart';
import '../constants/fab.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final double _avatarRadiusFactor = 0.15;
  String? _userName = '';
  String? _profileImage; // URL for the profile image in Firebase

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getProfileImage();
  }

  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _userName = userData['firstName'];
      });
    }
  }

  Future<void> _getProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      try {
        // Check if the user document exists
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        // Check if the user is logged in with Google
        if (user.photoURL != null) {
          // Set the profile image to the Google profile image if available
          setState(() {
            _profileImage = user.photoURL; // Use Google profile image
          });
        } else if (userData.data() != null && userData['profileImage'] != null) {
          // Retrieve the image URL if it exists in Firestore
          setState(() {
            _profileImage = userData['profileImage']; // Update with the stored URL
          });
        }
      } catch (e) {
        print("Error fetching image from Firestore: $e"); // Added logging for debugging
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        try {
          // Upload the image to Firebase Storage
          await FirebaseStorage.instance
              .ref('profile_images/$uid.jpg')
              .putFile(file);

          // Get the download URL after upload
          String downloadURL = await FirebaseStorage.instance
              .ref('profile_images/$uid.jpg')
              .getDownloadURL();

          setState(() {
            _profileImage = downloadURL; // Update state with the new image URL
          });

          // Update the Firestore document with the new image URL
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'profileImage': downloadURL});
        } catch (e) {
          print("Error uploading image: $e"); // Added logging for debugging
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF5E4),
        title: Text(
          'Hello, ${_userName ?? 'User'}!',
          style: const TextStyle(
            color: Color(0xffF4A26B),
            fontFamily: 'Inter Regular',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffF4A26B)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffFFF5E4), Color(0xffE7BA9C)],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: CircleAvatar(
                    radius: screenWidth * _avatarRadiusFactor,
                    backgroundImage: _profileImage != null
                        ? NetworkImage(_profileImage!)
                        : const AssetImage('lib/images/pfp.jpg') as ImageProvider,
                  ),
                ),
                const SizedBox(height: 20),
                const SectionTitle(title: 'ACCOUNT DETAILS'),
                const AccountDetail(icon: Icons.person, title: 'Name'),
                const AccountDetail(icon: Icons.calendar_today, title: 'Birthdate'),
                const AccountDetail(icon: Icons.email, title: 'Email'),
                const AccountDetail(icon: Icons.phone, title: 'Mobile No.'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FAB(sw: screenWidth),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
          dashboard: Colors.white,
          fReport: Colors.white,
          history: Colors.white,
          settings: Color(0xffFE5D26),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class AccountDetail extends StatelessWidget {
  final IconData icon;
  final String title;

  const AccountDetail({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (title == 'Name') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountNameScreen()),
          );
        } else if (title == 'Birthdate') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountBirthdateScreen()),
          );
        } else if (title == 'Email') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountEmailScreen()),
          );
        } else if (title == 'Mobile No.') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountMobileNoScreen()),
          );
        }
      },
    );
  }
}