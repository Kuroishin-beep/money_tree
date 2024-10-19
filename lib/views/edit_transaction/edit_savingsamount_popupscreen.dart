import 'package:flutter/material.dart';

import '../../controller/tracker_controller.dart';
import '../../models/tracker_model.dart';

class EditSavingsamountPopupscreen extends StatefulWidget {
  final String docID;
  EditSavingsamountPopupscreen({required this.docID});

  @override
  State<EditSavingsamountPopupscreen> createState() => _EditSavingsamountPopupscreenState();
}

class _EditSavingsamountPopupscreenState extends State<EditSavingsamountPopupscreen> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  // Controllers for textfields
  TextEditingController amountController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "EDIT SAVINGS AMOUNT",
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
                ),
              );
              return;
            }

            // Create the updated Tracker object
            Tracker newTrack = Tracker(
              savingsAmount: double.parse(amountController.text),
              type: 'savings',
            );

            await firestoreService.updateSavingsAmount(widget.docID, newTrack);

            // Clear controllers
            amountController.clear();

            Navigator.pop(context); // Close the dialog
          },
        ),


      ],
    );
  }
}