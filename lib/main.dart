import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_tree/firebase_options.dart';
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
import 'views/account_details/account_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const BudgetTracker());
}


class BudgetTracker extends StatelessWidget {
  const BudgetTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: 'get_started_screen.dart',

      routes: {
        'get_started_screen.dart': (context) => const GetStarted(),
        '/signup': (context) => const SignUp(),
        '/login': (context) => Login(),
        'loading_screen.dart': (context) => const LoadingScreen(),
        '/dashboard': (context) => const Dashboard(),
        '/budget': (context) => const BudgetScreen(),
        '/history': (context) => const HistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/add_transaction': (context) => const NewIncomeScreen(),
        '/add_expense': (context) => const NewExpenseScreen(),
        '/financial_report': (context) => const MonthlyReport(),
        '/account_name': (context) => const AccountNameScreen(),
        '/account_birthdate': (context) => const AccountBirthdateScreen(),
        '/account': (context) => const AccountScreen(),
        '/account_email': (context) => const AccountEmailScreen(),
        '/account_mobileno': (context) => const AccountMobileNoScreen(),
      },
    );
  }
}
