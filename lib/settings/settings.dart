import 'package:flutter/material.dart';
import 'package:budget_tracker/dashboard/dashboard.dart';
import 'package:budget_tracker/history/history.dart';
import 'package:budget_tracker/budget/budget.dart';
import 'package:budget_tracker/add_transaction/new_income.dart';
import 'package:budget_tracker/account/account.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        title: const Text('Hello, Andrei!'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture and Account Details
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/564x/0a/1d/5a/0a1d5aa8670073bc742f056d7a03b8ea.jpg', // Replace with your image URL or asset
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
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
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 40,
          color: Color(0xff03045E),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        children: [
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 15.0,
            color: const Color(0xff001219),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.home_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboard()));
                  },
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.savings_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BudgetScreen()));
                  },
                ),
                const SizedBox(width: 80),
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()));
                  },
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 40),
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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