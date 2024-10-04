import 'package:flutter/material.dart';
import '../../models/tracker_model.dart';
import 'package:intl/intl.dart';
import '../edit_transaction/edit_expenses_screen.dart';
import '../edit_transaction/edit_income_screen.dart';

class TransactionList extends StatelessWidget {
  final Tracker track;  // List of tracker items

  TransactionList({super.key, required this.track});

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
            MaterialPageRoute(builder: (context) => EditExpensesScreen()), // Navigate to EditExpensesScreen
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditIncomeScreen()), // Navigate to EditIncomeScreen
          );
        }
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.5),
        child: ListTile(
          leading: Container(
            width: sw * 0.09,
            height: sw * 0.09,
            decoration: BoxDecoration(
              color: (track.type == 'expenses' ? Color(0xffD7A685) : Color(0xff95BF8A)),
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
                          color: (track.type == 'expenses' ? Color(0xffFBC29C) : Color(0xffAEDFA2)),
                          blurRadius: 1,
                          spreadRadius: 3.5,
                        ),
                      ],
                    ),
                    child: Icon(
                      (track.type == 'expenses'
                          ? Tracker.categoryIcons[track.category] ?? Icons.error
                          : Tracker.accountIcons[track.account]
                      ),
                      size: 25,
                      color: Colors.white, // Icon color
                    ),
                  ),
                )
              ],
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(track.date),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: fs * 0.035
                ),
              ),
              Text(
                track.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fs * 0.05
                ),
              ),
            ],
          ),
          subtitle: Text(track.type == 'expenses' ? track.category : track.account),
          trailing: Text(
            '₱ ${formatter.format(track.amount)}',
            style: TextStyle(
                fontSize: fs * 0.05,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
