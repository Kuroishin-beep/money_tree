import 'package:flutter/material.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'package:money_tree/views/transaction_history/history_screen.dart';
import 'package:money_tree/views/budget/budget_screen.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';
import 'package:money_tree/views/account_details/account_screen.dart';

import '../../bottom_navigation.dart';
import '../../fab.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsPaused = false; // On/off state for notifications
  bool darkMode = false; // On/off state for screen mode
  bool isExpandedNotif = false;
  bool isExpandedPref = false;

  // TODO: make this a constant
  void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery
        .of(context)
        .size
        .width;

    // Changed the Layout of the App bar
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffFFF5E4),
          centerTitle: true,

          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xffF4A26B)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
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

          //Main Body
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // part of app bar: "Settings"
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                        color: Color(0xffF4A26B),
                        fontFamily: 'Inter Regular',
                        fontWeight: FontWeight.w700,
                        fontSize: 35
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // GENERAL Section
                CustomSectionTitle(title: 'GENERAL'),

                CustomListTile(
                  icon: Icons.person,
                  title: 'Account',
                  onTap: () {
                    navigateTo(context, AccountScreen());
                  },
                ),

                // the arrow icon changes to downward when u click Notification or Preferences
                // changed the switch button color
                // Notifications
                ExpansionTile(
                  leading: Icon(
                      Icons.notifications, color: Colors.black, size: 25),
                  title: Text(
                    'Notifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    isExpandedNotif
                        ? Icons
                        .keyboard_arrow_down_rounded // Downward arrow when expanded
                        : Icons.arrow_forward_ios, // Right arrow when collapsed
                    size: 18,
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      isExpandedNotif = expanded; // Update the expansion state
                    });
                  },
                  children: [
                    SwitchListTile(
                      title: Text("Pause all"),
                      subtitle: Text('Indefinitely pause notifications'),
                      activeColor: Color(0xffFFBF89),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Color(0xff594839),
                      inactiveThumbColor: Color(0xffFFBF89),
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
                  leading: Icon(
                      Icons.room_preferences, color: Colors.black, size: 25),
                  title: Text(
                    'Preferences',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    isExpandedPref
                        ? Icons
                        .keyboard_arrow_down_rounded // Downward arrow when expanded
                        : Icons.arrow_forward_ios, // Right arrow when collapsed
                    size: 18,
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      isExpandedPref = expanded; // Update the expansion state
                    });
                  },
                  children: [
                    SwitchListTile(
                      title: Text("Screen Mode"),
                      subtitle: Text('Light Mode or Dark Mode'),
                      activeColor: Color(0xffFFBF89),
                      inactiveTrackColor: Colors.white,
                      activeTrackColor: Color(0xff594839),
                      inactiveThumbColor: Color(0xffFFBF89),
                      value: darkMode,
                      onChanged: (bool value) {
                        setState(() {
                          darkMode = value;
                        });
                      },
                    ),
                  ],
                ),

                CustomListTile(
                  icon: Icons.security,
                  title: 'Security',
                  onTap: () {},
                ),

                // Added a divider to separate General from Feedback
                Divider(
                  color: Colors.grey.withOpacity(0.7),
                  thickness: 2,
                  endIndent: 10,
                  indent: 10,
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
        ],
      ),
      // Navigation bar
      floatingActionButton: FAB(sw: sw),
      // Use the FAB widget
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //FAB
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(),
      ),
    );
  }
}


class CustomSectionTitle extends StatelessWidget {
  final String title;

  const CustomSectionTitle({super.key, required this.title});

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

            ),
          ),
        ],
      ),
    );
  }
}


class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  CustomListTile({required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 25),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      tileColor: Colors.grey.shade200,
    );
  }
}
