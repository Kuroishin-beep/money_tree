import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/Models/icon_picker_icon.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import '../../controller/tracker_controller.dart';
import '../../models/tracker_model.dart';

class AddSavingsPopupscreen extends StatefulWidget {
  const AddSavingsPopupscreen({super.key});

  @override
  State<AddSavingsPopupscreen> createState() => _AddSavingsPopupscreenState();
}

class _AddSavingsPopupscreenState extends State<AddSavingsPopupscreen> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  // textfield controllers
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _savingsController = TextEditingController();

  Icon? selected_icon;
  IconData? selectedIconData;
  int code = 0;

  // Icon picker method
  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [IconPack.material],  // Specify the icon pack you want
      ),
    );

    if (icon != null) {
      setState(() {
        selectedIconData = icon.data;
        selected_icon = Icon(icon.data);

        code = selectedIconData!.codePoint;
        // fontFamily = _selectedIconData!.fontFamily;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Savings"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _savingsController,
            decoration: const InputDecoration(labelText: "Budget"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          // Icon Picker Button
          TextButton.icon(
            icon: Icon(selectedIconData ?? Icons.add_circle_outline),
            label: const Text("Pick Icon"),
            onPressed: () {
              _pickIcon();  // Use the provided _pickIcon method
            },
          )
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Add"),
          onPressed:() async {
            if (_titleController.text.isEmpty ||
                _savingsController.text.isEmpty ||
                _amountController.text.isEmpty ||
                code == 0) {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill all fields before proceeding.'),
                  //backgroundColor: Colors.red,
                ),
              );
              return;
            }
            Tracker newTrack = Tracker(
                category: _titleController.text,
                savingsAmount: double.parse(_amountController.text),
                totalSavingsAmount: double.parse(_savingsController.text),
                type: 'savings',
                icon: code
            );

            await firestoreService.addSavings(newTrack);

            _titleController.clear();
            _amountController.clear();
            _savingsController.clear();

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
