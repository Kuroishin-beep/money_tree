import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/Models/icon_picker_icon.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

import '../../controller/tracker_controller.dart';
import '../../models/tracker_model.dart';

class EditBudgetamountPopupscreen extends StatefulWidget {
  final String docID;
  EditBudgetamountPopupscreen({required this.docID});

  @override
  State<EditBudgetamountPopupscreen> createState() => _EditBudgetamountPopupscreenState();
}

class _EditBudgetamountPopupscreenState extends State<EditBudgetamountPopupscreen> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  // Controllers for textfields
  TextEditingController amountController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "EDIT BUDGET AMOUNT",
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
            controller: amountController,
            decoration: const InputDecoration(labelText: "Amount Used"),
            keyboardType: TextInputType.number,
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
            if (amountController.text.isEmpty) {

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
                budgetAmount: double.parse(amountController.text),
                type: 'budget',
            );

            await firestoreService.updateBudgetAmount(widget.docID, newTrack);

            // Clear controllers
            amountController.clear();

            Navigator.pop(context); // Close the dialog
          },
        ),


      ],
    );
  }
}
