import 'package:flutter/material.dart';
import '../../bottom_navigation.dart';
import '../../fab.dart';

class AccountMobileNoScreen extends StatelessWidget {
  const AccountMobileNoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,

      // Changed the app bar
      appBar: AppBar(
          backgroundColor: const Color(0xffFFF5E4),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xffF4A26B)),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ),

      // added a stack to enable gradient background
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffFFF5E4),
                      Color(0xffE7BA9C)
                    ]
                )
            ),
          ),

          // Main body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mobile No.',
                  style: TextStyle(
                      color: Color(0xffF4A26B),
                      fontFamily: 'Inter Regular',
                      fontWeight: FontWeight.w700,
                      fontSize: 35
                  ),
                ),
                const SizedBox(height: 30),
                buildTextField('Mobile No', '-', true),
              ],
            ),
          ),
        ],
      ),
      // FAB
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //Navigation bar
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
            dashboard: Colors.white,
            fReport: Colors.white,
            history: Colors.white,
            settings: Color(0xffFE5D26)
        ),
      ),
    );
  }
}
// Helper method to build text fields with a label
Widget buildTextField(String label, String value, bool required) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black.withOpacity(0.4)),
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
          initialValue: value,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    ),
  );
}

