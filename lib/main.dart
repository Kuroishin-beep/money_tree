import 'package:flutter/material.dart';
import 'package:money_tree/views/account_details/account_birthdate_screen.dart';
import 'package:money_tree/views/account_details/account_email_screen.dart';
import 'package:money_tree/views/account_details/account_mobileno_screen.dart';
import 'views/start_screens/login_screen.dart';
import 'views/dashboard/dashboard_screen.dart';
import 'views/start_screens/get_started_screen.dart';
import 'views/start_screens/signup_screen.dart';
import 'views/budget/budget_screen.dart';
import 'views/transaction_history/history_screen.dart';
import 'views/settings/settings_screen.dart';
import 'views/add_transaction/add_income_screen.dart';
import 'views/add_transaction/add_expenses_screen.dart';
import 'views/financial_report/monthlyFR_screen.dart';
import 'views/start_screens/loading_screen.dart';
import 'views/account_details/account_name_screen.dart';
import 'views/account_details/account_birthdate_screen.dart';
import 'views/account_details/account_screen.dart';

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
