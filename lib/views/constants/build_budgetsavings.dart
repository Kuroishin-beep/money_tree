import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tree/models/tracker_model.dart';

import '../../controller/tracker_controller.dart';
import '../edit_transaction/edit_category.dart';

class BuildBudgetlist extends StatelessWidget {
  final Tracker budget;
  final String docID;

  const BuildBudgetlist({
    super.key,
    required this.budget,
    required this.docID,
  });

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    
    final formatter = NumberFormat('#,###.00');

    return GestureDetector(
      onLongPress: () {
        _showDeleteConfirmationDialog(context, docID);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Container(
              width: sw * 0.12,
              height: sw * 0.12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffA78062),
              ),
              child: Center(
                child: budget.icon != null
                    ? Icon(
                        IconData(
                            budget.icon!,
                            fontFamily: 'MaterialIcons'
                        ),
                        color: Colors.white,
                        size: 30,
                      )
                    : const Icon(
                        Icons.category,
                        color: Colors.white,
                        size: 30,
                      ),
              ),
            ),
            title: Text(
              budget.category,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              '₱ ${formatter.format(budget.budget_amount) ?? 0} of ₱ ${formatter.format(budget.total_budgetamount) ?? 0}',
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey, size: 28),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EditCategoryDialog(docID: docID);
                  },
                );
              },
            ),
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
