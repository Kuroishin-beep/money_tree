import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/Models/icon_picker_icon.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import '../../controller/tracker_controller.dart';
import '../../models/tracker_model.dart';

class EditSavingsPopupscreen extends StatefulWidget {
  final String docID;

  EditSavingsPopupscreen({required this.docID});

  @override
  State<EditSavingsPopupscreen> createState() => _EditSavingsPopupscreenState();
}

class _EditSavingsPopupscreenState extends State<EditSavingsPopupscreen> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  // Controllers for textfields
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialSavingsData();
  }

  Future<void> initialSavingsData() async {
    try {
      DocumentSnapshot savingsDoc = await FirebaseFirestore.instance
          .collection('savings')
          .doc(widget.docID)
          .get();

      if (savingsDoc.exists) {
        setState(() {
          amountController.text = savingsDoc['savingsAmount'].toString();
          nameController.text = savingsDoc['category'];
          budgetController.text = savingsDoc['totalSavingsAmount'].toString();

          // If icon was saved, display the icon again
          if (savingsDoc['icon'] != null) {
            code = savingsDoc['icon'];
            selectedIconData = IconData(code, fontFamily: 'MaterialIcons');
            selected_icon = Icon(selectedIconData, size: 30, color: const Color(0xff9A9BEB));
          }
        });
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching expense data: $e');
    }
  }

  // for icon picker
  Icon? selected_icon;
  IconData? selectedIconData;
  int code = 0;

  // Icon picker method
  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [IconPack.material],
      ),
    );

    if (icon != null) {
      setState(() {
        selectedIconData = icon.data;
        selected_icon = Icon(icon.data);

        code = selectedIconData!.codePoint;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "EDIT FULL SAVINGS",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xffFBC29C),
          fontFamily: 'Inter Regular',
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(labelText: "Amount Used"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: budgetController,
            decoration: const InputDecoration(labelText: "Savings"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            icon: Icon(selectedIconData ?? Icons.add_circle_outline),
            label: const Text("Pick Icon"),
            onPressed: _pickIcon,
          ),
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
          child: const Text("Save"),
          onPressed: () async {
            if (amountController.text.isEmpty ||
                budgetController.text.isEmpty ||
                nameController.text.isEmpty ||
                code == 0) {

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill all fields before proceeding.'),
                  //backgroundColor: Colors.red,
                ),
              );
              return;
            }

            // Create the updated Tracker object
            Tracker newTrack = Tracker(
              category: nameController.text,
              savingsAmount: double.parse(amountController.text),
              totalSavingsAmount: double.parse(budgetController.text),
              type: 'savings',
              icon: code
            );

            await firestoreService.updateSavings(widget.docID, newTrack);

            // Clear controllers
            amountController.clear();
            budgetController.clear();
            nameController.clear();

            Navigator.pop(context); // Close the dialog
          },
        ),


      ],
    );
  }
}
