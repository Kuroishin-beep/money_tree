import 'package:flutter/material.dart';
import 'package:money_tree/account/account_birthdate_screen.dart';
import 'package:money_tree/account/account_email_screen.dart';
import 'package:money_tree/account/account_mobileno_screen.dart';
import 'package:money_tree/account/account_name_screen.dart';
import 'package:money_tree/dashboard/dashboard_screen.dart';
import 'package:money_tree/history/history_screen.dart';
import 'package:money_tree/settings/settings_screen.dart';
import 'package:money_tree/add_transaction/new_income_screen.dart';
import '../financial_report/monthly_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final double _avatarRadiusFactor = 0.15;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Set the back arrow
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black, // Make app bar solid color
        elevation: 4, // Add elevation for shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: screenWidth * _avatarRadiusFactor,
              backgroundImage: AssetImage('lib/images/pfp.jpg'),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle error here
              },
            ),
            SizedBox(height: 20), // Space between avatar and text
            Text(
              'Hello, Andrei!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter Regular',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            SectionTitle(title: 'ACCOUNT DETAILS'),
            AccountDetail(icon: Icons.person, title: 'Name'),
            AccountDetail(icon: Icons.calendar_today, title: 'Birthdate'),
            AccountDetail(icon: Icons.email, title: 'Email'),
            AccountDetail(icon: Icons.phone, title: 'Mobile No.'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewIncomeScreen()),
          );
        },
        child: Icon(
          Icons.add,
          size: 40,
          color: Color(0xffE63636),
        ),
        backgroundColor: Color(0xffFFF8ED),
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomAppBar(
          color: Color(0xff231F20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home_filled, color: Color(0xffFE5D26), size: 33),
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.bar_chart, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MonthlyReport()),
                  );
                },
              ),
              SizedBox(width: 80), // Spacer for FAB
              IconButton(
                icon: Icon(Icons.history, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => HistoryScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.settings_rounded, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

class AccountDetail extends StatelessWidget {
  final IconData icon;
  final String title;

  const AccountDetail({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (title == 'Name') {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountNameScreen()),
          );
        } else if (title == 'Birthdate') {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountBirthdateScreen()),
          );
        } else if (title == 'Email') {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountEmailScreen()),
          );
        } else if (title == 'Mobile No.') {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => AccountMobileNoScreen()),
          );
        }
      },
    );
  }
}
