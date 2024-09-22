import 'package:budget_tracker/signup/signup.dart';
import 'package:flutter/material.dart';
import 'account/account.dart';
import 'login/login.dart';
import 'dashboard/dashboard.dart';
import 'get_started.dart';
import 'signup/signup.dart';
import 'budget/budget.dart';
import 'history/history.dart';
import 'settings/settings.dart';
import 'add_transaction/new_income.dart';
import 'add_transaction/new_expenses.dart';

void main() {
  runApp(BudgetTracker());
}

class BudgetTracker extends StatelessWidget {
  const BudgetTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: 'get_started.dart',
      routes: {
        'get_started.dart': (context) => GetStarted(),
        'signup/signup.dart': (context) => SignUp(),
        'login/login.dart': (context) => Login(),
        'dashboard/dashboard.dart': (context) => Dashboard(),
        // 'budget/budget.dart': (context) => BudgetScreen(),
        // '/history': (context) => HistoryScreen(),
        '/account': (context) => AccountScreen(),
        // 'add_transaction/new_income.dart': (context) => NewIncomeScreen(),
        // 'add_transaction/new_expenses.dart': (context) => NewExpenseScreen(),
      },
    );
  }
}
