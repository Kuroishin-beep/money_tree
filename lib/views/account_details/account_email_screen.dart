import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/bottom_navigation.dart';
import '../constants/fab.dart';

class AccountEmailScreen extends StatefulWidget {
  const AccountEmailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccountEmailScreenState createState() => _AccountEmailScreenState();
}

class _AccountEmailScreenState extends State<AccountEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _recoveryEmailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the screen loads
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser; // Get the currently authenticated user

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _emailController.text = userDoc['email'] ?? ''; // Set current email in the controller
          _recoveryEmailController.text = userDoc['recoveryEmail'] ?? ''; // Set current recovery email in the controller
        });
      }
    } else {
      // Handle the case when there is no user logged in
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user is logged in.')));
    }
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser; // Get the currently authenticated user

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': _emailController.text,
          'recoveryEmail': _recoveryEmailController.text,
        }, SetOptions(merge: true)); // Merge to avoid overwriting other fields

        // Optionally, show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email details updated!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF5E4),
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
                colors: [
                  Color(0xffFFF5E4),
                  Color(0xffE7BA9C),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form( // Use Form widget for validation
              key: _formKey, // Assign the form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email Details',
                    style: TextStyle(
                      color: Color(0xffF4A26B),
                      fontFamily: 'Inter Regular',
                      fontWeight: FontWeight.w700,
                      fontSize: 35,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildTextField('Email', _emailController, true),
                  const SizedBox(height: 12),
                  buildTextField('Recovery Email', _recoveryEmailController, false),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveUserData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF4A26B), // Set the button color
                      foregroundColor: Colors.white, // Set the text color to white
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FAB(sw: sw),
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

  Widget buildTextField(String label, TextEditingController controller, bool required) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller, // Connect the controller to the TextField
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
            ),
            validator: required
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your $label'; // Validation message
                    }
                    return null; // Return null if input is valid
                  }
                : null, // No validation for optional fields
          ),
        ],
      ),
    );
  }
}