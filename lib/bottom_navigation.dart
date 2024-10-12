import 'package:flutter/material.dart';
import 'package:money_tree/views/financial_report/monthlyFR_screen.dart';
import 'package:money_tree/views/settings/settings_screen.dart';
import 'package:money_tree/views/transaction_history/history_screen.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';

class NavBottomAppBar extends StatelessWidget {
  final Color dashboard;
  final Color fReport;
  final Color history;
  final Color settings;

  const NavBottomAppBar({super.key, 
    required this.dashboard,
    required this.fReport,
    required this.history,
    required this.settings
});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xff231F20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home_filled, color: dashboard, size: 33),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const Dashboard()));
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart, color: fReport, size: 33),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const MonthlyReport()));
            },
          ),
          const SizedBox(width: 80), // Spacer for FAB
          IconButton(
            icon: Icon(Icons.history, color: history, size: 33),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_rounded, color: settings, size: 33),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
            },

          ),
        ],
      ),
    );
  }
}