import 'package:flutter/material.dart';
import '../../controller/tracker_controller.dart';
import '../../models/tracker_model.dart';
import 'package:intl/intl.dart';
import '../edit_transaction/edit_expenses_screen.dart';
import '../edit_transaction/edit_income_screen.dart';

class TransactionList extends StatelessWidget {
  final Tracker track;
  final String formattedDate;
  final String docID;

  const TransactionList({
    super.key,
    required this.track,
    required this.formattedDate,
    required this.docID,
  });

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text; // Check for empty string
    return text[0].toUpperCase() + text.substring(1); // Capitalize first letter and append the rest
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    final formatter = NumberFormat('#,###.00');

    return GestureDetector(
      onTap: () {
        // Navigate based on track type
        if (track.type == 'expenses') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditExpensesScreen(docID: docID,)),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditIncomeScreen(docID: docID,)),
          );
        }
      },
      onLongPress: () {
        _showDeleteConfirmationDialog(context, docID);
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.5),
        child: ListTile(
          leading: Container(
            width: sw * 0.09,
            height: sw * 0.09,
            decoration: BoxDecoration(
              color: (track.type == 'expenses' ? const Color(0xffD7A685) : const Color(0xff95BF8A)),
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: sw * 0.07,
                    height: sw * 0.07,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (track.type == 'expenses' ? const Color(0xffFBC29C) : const Color(0xffAEDFA2)),
                          blurRadius: 1,
                          spreadRadius: 3.5,
                        ),
                      ],
                    ),
                    child: Icon(
                      IconData(
                          track.icon!, // Make sure iconCode is of type Icon
                          fontFamily: 'MaterialIcons'
                      ),
                      size: 25,
                      color: Colors.white,
                    )
                  ),
                )
              ],
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: fs * 0.03
                ),
              ),
              Text(
                capitalizeFirstLetter(track.name),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: fs * 0.045
                ),
              ),
            ],
          ),
          subtitle: Text(track.type == 'expenses' ? track.category.toUpperCase() : track.account),
          trailing: Text(
            '₱ ${formatter.format(track.amount)}',
            style: TextStyle(
                fontSize: fs * 0.035,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold
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
                if (track.type == 'expenses') {
                  FirestoreService().deleteExpense(docID);
                } else if (track.type == 'income') {
                  FirestoreService().deleteIncome(docID);
                } else if (track.type == 'budget') {
                  FirestoreService().deleteBudget(docID);
                } else if (track.type == 'savings') {
                  FirestoreService().deleteSavings(docID);
                }

                // TODO: delete this line of code
                //FirestoreService().deleteTrack(docID);

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