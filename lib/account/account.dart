import 'package:flutter/material.dart';
import 'package:budget_tracker/dashboard/dashboard.dart';
import 'package:budget_tracker/history/history.dart';
import 'package:budget_tracker/budget/budget.dart';
import 'package:budget_tracker/settings/settings.dart';
import 'package:budget_tracker/add_transaction/new_income.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

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
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.15,
                    backgroundImage: const NetworkImage(
                      'https://i.pinimg.com/564x/0a/1d/5a/0a1d5aa8670073bc742f056d7a03b8ea.jpg', // Replace with your image URL or asset
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
            // Account Details Section
            const SectionTitle(title: 'ACCOUNT DETAILS'),
            const AccountDetail(icon: Icons.person, title: 'Name'),
            const AccountDetail(icon: Icons.calendar_today, title: 'Birthdate'),
            const AccountDetail(icon: Icons.email, title: 'Email'),
            const AccountDetail(icon: Icons.phone, title: 'Mobile No.'),
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
        shape: CircleBorder(),
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
                            builder: (context) => const SettingsScreen()));
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
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02, horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class AccountDetail extends StatelessWidget {
  final IconData icon;
  final String title;

  const AccountDetail({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Handle navigation or action
      },
    );
  }
}