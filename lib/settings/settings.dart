import 'package:flutter/material.dart';
import 'package:budget_tracker/dashboard/dashboard.dart';
import 'package:budget_tracker/history/history.dart';
import 'package:budget_tracker/budget/budget.dart';
import 'package:budget_tracker/add_transaction/new_income.dart';
import 'package:budget_tracker/account/account.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter Regular'
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff00B9BD),
                    Color(0xff005557)
                  ]
              )
          ),
        ),
        toolbarHeight: sw * 0.3,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // GENERAL Section
            SectionTitle(title: 'GENERAL'),
            AccountDetail(icon: Icons.person, title: 'Account',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountScreen()));
              },),
            AccountDetail(icon: Icons.notifications, title: 'Notifications',
                onTap: () {}
            ),
            AccountDetail(icon: Icons.room_preferences, title: 'Preferences',
                onTap: () {}
            ),
            AccountDetail(icon: Icons.security, title: 'Security',
                onTap: () {}
            ),
// FEEDBACK Section
            SectionTitle(title: 'FEEDBACK'),
            AccountDetail(icon: Icons.notification_important, title: 'Report a bug',
                onTap: () {}
            ),
            AccountDetail(icon: Icons.chat_rounded, title: 'Send Feedback',
                onTap: () {}
            ),
          ],
        ),
      ),
      // Navigation Bar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewIncomeScreen()));
        },
        child: Icon(
          Icons.add,
          size: 40,
          color: Color(0xff03045E),
        ),
        backgroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        children: [
          BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 15.0,
            color: Color(0xff001219),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Dashboard()));
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.savings_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BudgetScreen()));
                  },
                ),
                SizedBox(width: 80),
                IconButton(
                  icon: Icon(Icons.history, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()));
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.settings_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AccountDetail extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  AccountDetail({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal.shade600),
      title: Text(title),
      onTap: onTap, // Handle tap actions for each entry
    );
  }
}