import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tree/models/tracker_model.dart';
import 'package:money_tree/views/edit_transaction/edit_budgetamount_popupscreen.dart';
import 'package:money_tree/views/edit_transaction/edit_savings_popupscreen.dart';
import 'package:money_tree/views/edit_transaction/edit_savingsamount_popupscreen.dart';
import 'package:money_tree/views/edit_transaction/edit_totalbudget_popupscreen.dart';
import 'package:money_tree/views/edit_transaction/edit_totalsavings_popupscreen.dart';
import '../../controller/tracker_controller.dart';
import '../edit_transaction/edit_budget_popupscreen.dart';

class BuildBudgetSavelist extends StatelessWidget {
  final Tracker budget;
  final String docID;

  const BuildBudgetSavelist({
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
        margin: const EdgeInsets.symmetric(vertical: 5.0),
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
                child: Icon(
                          IconData(
                              budget.icon!,
                              fontFamily: 'MaterialIcons'
                          ),
                          color: Colors.white,
                          size: 30,
                        )
              ),
            ),
            title: Text(
              budget.category.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            subtitle: Row(
              children: [
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {

                        if (budget.type == 'budget') {
                          return EditBudgetamountPopupscreen(docID: docID);
                        }
                        return EditSavingsamountPopupscreen(docID: docID);
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    (budget.type == 'budget'
                        ? '₱ ${formatter.format(budget.budgetAmount) ?? 0}'
                        : '₱ ${formatter.format(budget.savingsAmount) ?? 0}'
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black
                    ),
                  )
                ),
                Text(
                  '  of  ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {

                          if (budget.type == 'budget') {
                            return EditTotalbudgetPopupscreen(docID: docID);
                          }
                          return EditTotalsavingsPopupscreen(docID: docID);
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Remove the default padding
                      minimumSize: Size(0, 0),  // Set minimum size to zero to remove extra space
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Shrink the button size
                    ),
                    child: Text(
                      (budget.type == 'budget'
                          ? '₱ ${formatter.format(budget.totalBudgetAmount) ?? 0}'
                          : '₱ ${formatter.format(budget.totalSavingsAmount) ?? 0}'
                      ),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black
                      ),
                    )
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey, size: 28),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {

                    if (budget.type == 'budget') {
                      return EditBudgetPopupscreen(docID: docID);
                    }
                    return EditSavingsPopupscreen(docID: docID);
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
                if (budget.type == 'budget') {
                  FirestoreService().deleteBudget(docID);
                } else {
                  FirestoreService().deleteSavings(docID);
                }

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
