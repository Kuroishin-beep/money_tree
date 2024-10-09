import 'package:flutter/material.dart';
import 'package:money_tree/views/account_details/account_birthdate_screen.dart';
import 'package:money_tree/views/account_details/account_email_screen.dart';
import 'package:money_tree/views/account_details/account_mobileno_screen.dart';
import 'package:money_tree/views/account_details/account_name_screen.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'package:money_tree/views/transaction_history/history_screen.dart';
import 'package:money_tree/views/settings/settings_screen.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';
import '../../bottom_navigation.dart';
import '../../fab.dart';
import '../financial_report/monthlyFR_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final double _avatarRadiusFactor = 0.15;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double sw = MediaQuery.of(context).size.width;

    return Scaffold(
      // Changed the App Bar
      appBar: AppBar(
          backgroundColor: Color(0xffFFF5E4),
          title: Text(
            'Hello, Andrei!',
            style: TextStyle(
                color: Color(0xffF4A26B),
                fontFamily: 'Inter Regular',
                fontWeight: FontWeight.w700
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xffF4A26B)),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ),

      // added a stack to enable gradient background
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffFFF5E4),
                      Color(0xffE7BA9C)
                    ]
                )
            ),
          ),

          // Main Body
          SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: screenWidth * _avatarRadiusFactor,
                  backgroundImage: AssetImage('lib/images/pfp.jpg'),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle error here
                  },
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
        ],
      ),

      // FAB
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //Navigation bar
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(),
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
