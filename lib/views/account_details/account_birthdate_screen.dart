import 'package:flutter/material.dart';

import '../../bottom_navigation.dart';
import '../../fab.dart';


class AccountBirthdateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return Scaffold(

      // Changed the app bar
      appBar: AppBar(
          backgroundColor: Color(0xffFFF5E4),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xffF4A26B)),
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
            decoration: BoxDecoration(
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

          // Main Body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Birthdate Details',
                  style: TextStyle(
                      color: Color(0xffF4A26B),
                      fontFamily: 'Inter Regular',
                      fontWeight: FontWeight.w700,
                      fontSize: 35
                  ),
                ),
                SizedBox(height: 30),
                buildTextField('Month', '-', true),
                buildTextField('Day', '-', false),
                buildTextField('Year', '-', true),
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
        child: NavBottomAppBar(),
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
              Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    ),
  );
}

