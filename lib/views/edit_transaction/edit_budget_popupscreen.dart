import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/Models/icon_picker_icon.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import '../../controller/tracker_controller.dart';
import '../../models/tracker_model.dart';

class EditBudgetPopupscreen extends StatefulWidget {
  final String docID;
  EditBudgetPopupscreen({required this.docID});

  @override
  _EditBudgetPopupscreenState createState() => _EditBudgetPopupscreenState();
}

class _EditBudgetPopupscreenState extends State<EditBudgetPopupscreen> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  // Controllers for textfields
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController budgetController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialBudgetData();
  }

  Future<void> initialBudgetData() async {
    try {
      DocumentSnapshot budgetDoc = await FirebaseFirestore.instance
          .collection('budgets')
          .doc(widget.docID)
          .get();

      if (budgetDoc.exists) {
        setState(() {
          amountController.text = budgetDoc['budgetAmount'].toString();
          nameController.text = budgetDoc['category'];
          budgetController.text = budgetDoc['totalBudgetAmount'].toString();

          // If icon was saved, display the icon again
          if (budgetDoc['icon'] != null) {
            code = budgetDoc['icon'];
            selectedIconData = IconData(code, fontFamily: 'MaterialIcons');
            _icon = Icon(selectedIconData, size: 30, color: const Color(0xff9A9BEB));
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
  Icon? _icon;
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
        _icon = Icon(icon.data);

        code = selectedIconData!.codePoint;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "EDIT FULL BUDGET",
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
            decoration: const InputDecoration(labelText: "Budget"),
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
              budgetAmount: double.parse(amountController.text),
              totalBudgetAmount: double.parse(budgetController.text),
              type: 'budget',
              icon: code
            );

            await firestoreService.updateBudget(widget.docID, newTrack);

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