import 'package:flutter/material.dart';

import '../../controller/tracker_controller.dart';
import '../../models/tracker_model.dart';

class EditCategoryDialog extends StatefulWidget {
  final String docID;


  EditCategoryDialog({required this.docID});

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  IconData? selectedIconData;

  void _pickIcon() {
    // Implement your icon picker logic here
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "EDIT TRANSACTION",
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
            decoration: const InputDecoration(labelText: "Amount"),
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
            // Create the updated Tracker object
            Tracker newTrack = Tracker(
              category: '',  // Replace with the necessary value
              savings_amount: double.parse(amountController.text),
              total_budgetamount: double.parse(budgetController.text),
            );

            await firestoreService.updateTrack(widget.docID, newTrack);

            // Clear controllers
            amountController.clear();
            budgetController.clear();

            Navigator.pop(context); // Close the dialog
          },
        ),
      ],
    );
  }
}
