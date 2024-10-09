import 'package:flutter/material.dart';
import 'package:money_tree/views/financial_report/monthlyFR_screen.dart';
import 'package:money_tree/views/settings/settings_screen.dart';
import 'package:money_tree/views/transaction_history/history_screen.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';

class NavBottomAppBar extends StatelessWidget {
  const NavBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xff231F20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home_filled, color: Color(0xffFE5D26), size: 33),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Dashboard()));
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.white, size: 33),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MonthlyReport()));
            },
          ),
          SizedBox(width: 80), // Spacer for FAB
          IconButton(
            icon: Icon(Icons.history, color: Colors.white, size: 33),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HistoryScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_rounded, color: Colors.white, size: 33),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
