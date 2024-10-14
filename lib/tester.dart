import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IconCodePointScreen(),
    );
  }
}

class IconCodePointScreen extends StatefulWidget {
  const IconCodePointScreen({super.key});

  @override
  _IconCodePointScreenState createState() => _IconCodePointScreenState();
}

class _IconCodePointScreenState extends State<IconCodePointScreen> {
  int codePoint = 0; // Initialize codePoint
  IconData? displayedIcon; // To store the displayed icon

  // Method to pick an icon
  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [
          // IconPack.cupertino,
          // IconPack.material,
          // IconPack.fontAwesomeIcons,
          IconPack.allMaterial,
          // IconPack.lineAwesomeIcons,
          // IconPack.outlinedMaterial,
          // IconPack.roundedMaterial,
          // IconPack.sharpMaterial,
        ],
      ),
    );

    if (icon != null) {
      setState(() {
        // Update the displayed icon and its code point
        displayedIcon = IconData(icon.data.codePoint, fontFamilyFallback: const [
          // 'CupertinoIcons',
          'MaterialIcons',
          // 'FontAwesome',
          // 'LineAwesomeIcons',
          // 'OutlinedMaterialIcons',
          // 'RoundedMaterialIcons',
          // 'SharpMaterialIcons',
        ],);
        codePoint = icon.data.codePoint; // Get the code point from the selected icon
      });

      // Print to console (optional)
      print('Picked Icon Code Point: ${codePoint.toRadixString(16)}'); // Print code point in hexadecimal
      print('Picked Icon Font Family: ${icon.data.fontFamily}'); // Print font family
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Get Icon Code Point')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _pickIcon, // Call the _pickIcon method when the button is pressed
              child: Text('Pick an Icon'),
            ),
          ),
          SizedBox(height: 20), // Add some space between button and text
          Text(
            'Code Point: $codePoint', // Display codePoint in hexadecimal
            style: TextStyle(fontSize: 24), // Text style
          ),
          SizedBox(height: 20), // Add space between code point and icon
          if (displayedIcon != null) // Check if there is an icon to display
            Icon(
              displayedIcon,
              size: 50, // Set desired icon size
              color: Colors.blue, // Set desired icon color
            ),
        ],
      ),
    );
  }
}
