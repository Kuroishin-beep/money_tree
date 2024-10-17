import 'package:flutter/material.dart';

class TextFieldWithDropdown extends StatefulWidget {
  @override
  _TextFieldWithDropdownState createState() => _TextFieldWithDropdownState();
}

class _TextFieldWithDropdownState extends State<TextFieldWithDropdown> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedValue; // Store the selected value
  final List<String> _predefinedValues = [
    'Value 1',
    'Value 2',
    'Value 3',
    'Value 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TextField with Dropdown')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Enter Value',
                    suffixIcon: PopupMenuButton<String>(
                      icon: Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        setState(() {
                          _selectedValue = value;
                          _textController.text = value; // Set the selected value to the TextField
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return _predefinedValues.map((String value) {
                          return PopupMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TextFieldWithDropdown(),
  ));
}
