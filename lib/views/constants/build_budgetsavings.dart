import 'package:flutter/material.dart';
import 'package:money_tree/models/tracker_model.dart';

import '../../controller/tracker_controller.dart';
import '../edit_transaction/edit_category.dart';

class BuildBudgetlist extends StatefulWidget {
  final Tracker budget;
  final String docID;

  const BuildBudgetlist({
    super.key,
    required this.budget,
    required this.docID,
  });

  @override
  _BuildBudgetlistState createState() => _BuildBudgetlistState();
}

class _BuildBudgetlistState extends State<BuildBudgetlist> {
  bool isDeleted = false; // Track if this specific category is deleted

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;


    return GestureDetector(
      onLongPress: () {
        _showDeleteConfirmationDialog(context, widget.budget.category);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: ListTile(
          leading: Container(
            width: sw * 0.1,
            height: sw * 0.1,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffA78062), // Circle color
            ),
            child: Center(
              child: widget.budget.icon != null
                  ? Icon(
                IconData(
                  widget.budget.icon!,
                  fontFamily: 'MaterialIcons',
                ),
                color: const Color(0xffF4A26B),
              )
                  : const Icon(
                Icons.category, // Fallback icon if no icon is selected
                color: Color(0xffF4A26B),
              ),
            ),
          ),
          title: Text(
            widget.budget.category,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Php ${widget.budget.total_budgetamount ?? 0} of Php ${widget.budget.budget_amount ?? 0}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  EditCategoryDialog(docID: widget.docID); // Call edit dialog
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String docID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Transaction'),
          content: Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Call the delete method here
                FirestoreService().deleteTrack(docID);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
