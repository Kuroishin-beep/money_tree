import 'package:flutter/material.dart';
import 'package:money_tree/account/account_birthdate_screen.dart';
import 'package:money_tree/account/account_email_screen.dart';
import 'package:money_tree/account/account_mobileno_screen.dart';
import 'login/login_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'get_started_screen.dart';
import 'signup/signup_screen.dart';
import 'budget/budget_screen.dart';
import 'history/history_screen.dart';
import 'settings/settings_screen.dart';
import 'add_transaction/new_income_screen.dart';
import 'add_transaction/new_expenses_screen.dart';
import 'financial_report/monthly_screen.dart';
import 'loading_screen.dart';
import 'account/account_name_screen.dart';
import 'account/account_birthdate_screen.dart';
import 'account/account_screen.dart';

void main() {
  runApp(BudgetTracker());
}

class BudgetTracker extends StatelessWidget {
  const BudgetTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: 'get_started_screen.dart',

      routes: {
        'get_started_screen.dart': (context) => GetStarted(),
        '/signup': (context) => SignUp(),
        '/login': (context) => Login(),
        'loading_screen.dart': (context) => LoadingScreen(),
        '/dashboard': (context) => Dashboard(),
        '/budget': (context) => BudgetScreen(),
        '/history': (context) => HistoryScreen(),
        '/settings': (context) => SettingsScreen(),
        '/add_transaction': (context) => NewIncomeScreen(),
        '/add_expense': (context) => NewExpenseScreen(),
        '/financial_report': (context) => MonthlyReport(),
        '/account_name': (context) => AccountNameScreen(),
        '/account_birthdate': (context) => AccountBirthdateScreen(),
        '/account': (context) => AccountScreen(),
        '/account_email': (context) => AccountEmailScreen(),
        '/account_mobileno': (context) => AccountMobileNoScreen(),
      },
    );
  }
}
