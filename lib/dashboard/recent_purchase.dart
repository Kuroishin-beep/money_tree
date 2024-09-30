import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecentPurchaseCard extends StatelessWidget {
  final Color color;
  final String date;
  final String item;
  final double amount;

  RecentPurchaseCard({
    this.color = Colors.black,
    required this.date,
    required this.item,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {

    final formatter = NumberFormat('#,###.00');

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 8,
              blurRadius: 5,

            ),
          ],
        ),
        child: ListTile(
          title: Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Inter Regular',
            ),
          ),
          subtitle: Text(item),
          trailing: Text(
            '₱${formatter.format(amount)}',
            style: TextStyle(
              color: Colors.black.withOpacity(0.68),
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Inter Regular',
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}