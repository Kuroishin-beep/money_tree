import 'package:flutter/material.dart';
import 'package:money_tree/dashboard/dashboard.dart';
import 'package:money_tree/history/history.dart';
import 'package:money_tree/budget/budget.dart';
import 'package:money_tree/settings/settings.dart';
import 'package:money_tree/add_transaction/new_income.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
        title: Text(
          'Hello, Andrei!',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter Regular'
          ),
        ),
        centerTitle: true,
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
        toolbarHeight: screenWidth * 0.2,
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
                    backgroundImage: const AssetImage(
                      'images/pfp.jpg', // Replace with your image URL or asset
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
            // Account Details Section
            SectionTitle(title: 'ACCOUNT DETAILS'),
            AccountDetail(icon: Icons.person, title: 'Name'),
            AccountDetail(icon: Icons.calendar_today, title: 'Birthdate'),
            AccountDetail(icon: Icons.email, title: 'Email'),
            AccountDetail(icon: Icons.phone, title: 'Mobile No.'),
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
  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02, horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
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

  const AccountDetail({Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Handle navigation or action
      },
    );
  }
}