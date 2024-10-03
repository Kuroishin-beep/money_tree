import 'package:flutter/material.dart';
import 'package:money_tree/dashboard/dashboard_screen.dart';
import 'package:money_tree/history/history_screen.dart';
import 'package:money_tree/budget/budget_screen.dart';
import 'package:money_tree/add_transaction/new_income_screen.dart';
import 'package:money_tree/account/account_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsPaused = false; // On/off state for notifications
  bool darkMode = false; // On/off state for screen mode

  void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            navigateTo(context, Dashboard());
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 100,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter Regular',

          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff00B9BD), Color(0xff005557)],
            ),
          ),
        ),
        toolbarHeight: sw * 0.3,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // GENERAL Section
            CustomSectionTitle(title: 'GENERAL'),

            CustomListTile(
              icon: Icons.person,
              title: 'Account',
              onTap: () {
                navigateTo(context, AccountScreen());
              },
            ),

            // Notifications
            ExpansionTile(
              leading: Icon(Icons.notifications, color: Colors.black, size: 25),
              title: Text(
                'Notifications',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
              children: [
                SwitchListTile(
                  title: Text("Pause all"),
                  subtitle: Text('Indefinitely pause notifications'),
                  value: notificationsPaused,
                  onChanged: (bool value) {
                    setState(() {
                      notificationsPaused = value;
                    });
                  },
                ),
              ],
            ),

            // Preferences
            ExpansionTile(
              leading: Icon(Icons.room_preferences, color: Colors.black, size: 25),
              title: Text(
                'Preferences',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
              children: [
                ListTile(
                  title: Text("Screen Mode"),
                  subtitle: Text('Light mode or Dark mode'),
                  trailing: Switch(
                    value: darkMode,
                    onChanged: (bool value) {
                      setState(() {
                        darkMode = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            CustomListTile(
              icon: Icons.security,
              title: 'Security',
              onTap: () {},
            ),

            // FEEDBACK Section
            CustomSectionTitle(title: 'FEEDBACK'),
            CustomListTile(
              icon: Icons.notification_important,
              title: 'Report a bug',
              onTap: () {},
            ),
            CustomListTile(
              icon: Icons.chat_rounded,
              title: 'Send feedback',
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateTo(context, NewIncomeScreen());
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
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 15.0,
        color: Color(0xff231F20),
        elevation: 0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home_filled, color: Colors.white, size: 33),
                onPressed: () {
                  navigateTo(context, Dashboard());
                },
              ),
              IconButton(
                icon: Icon(Icons.bar_chart, color: Colors.white, size: 33),
                onPressed: () {
                  navigateTo(context, BudgetScreen());
                },
              ),
              SizedBox(width: 80), // Spacer for FAB
              IconButton(
                icon: Icon(Icons.history, color: Colors.white, size: 33),
                onPressed: () {
                  navigateTo(context, HistoryScreen());
                },
              ),
              IconButton(
                icon: Icon(Icons.settings_rounded, color: Colors.white, size: 33),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You are already in Settings.')),
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

// Custom section title to match the image design
class CustomSectionTitle extends StatelessWidget {
  final String title;

  CustomSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.underline, // Underline to match design
            ),
          ),
        ],
      ),
    );
  }
}

// Custom ListTile to style list items according to the provided design
class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  CustomListTile({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 25), // Matching icon size
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18), // Small forward arrow
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust padding
      tileColor: Colors.grey.shade200, // Optional: background color for each item
    );
  }
}
