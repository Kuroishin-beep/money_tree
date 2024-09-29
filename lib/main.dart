import 'package:flutter/material.dart';
import 'login/login.dart';
import 'dashboard/dashboard.dart';
import 'get_started.dart';
import 'signup/signup.dart';
import 'budget/budget.dart';
import 'history/history.dart';
import 'settings/settings.dart';
import 'add_transaction/new_income.dart';
import 'add_transaction/new_expenses.dart';
import 'financial_report/monthly.dart';
import 'loading_screen.dart';
import 'dashboard/dashboard2.dart';

void main() {
  runApp(BudgetTracker());
}

class BudgetTracker extends StatelessWidget {
  const BudgetTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Dashboard2(),

      //initialRoute: 'dashboard2.dart',

      routes: {
        'get_started.dart': (context) => GetStarted(),
        '/signup': (context) => SignUp(),
        '/login': (context) => Login(),
        'loading_screen.dart': (context) => LoadingScreen(),
        '/dashboard': (context) => Dashboard2(),
        //'/dashboard': (context) => Dashboard2(),
        '/budget': (context) => BudgetScreen(),
        '/history': (context) => HistoryScreen(),
        '/settings': (context) => SettingsScreen(),
        '/add_transaction': (context) => NewIncomeScreen(),
        '/add_transaction ': (context) => NewExpenseScreen(),
        '/financial_report': (context) => MonthlyReport(),
      },
    );
  }
}
