import 'package:flutter/material.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'package:money_tree/views/account_details/account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication

import '../../bottom_navigation.dart';
import '../../fab.dart';
import 'package:money_tree/views/start_screens/login_screen.dart';
// CustomSectionTitle widget
class CustomSectionTitle extends StatelessWidget {
  final String title;

  const CustomSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

// CustomListTile widget
class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const CustomListTile({super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 25),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      tileColor: Colors.grey.shade200,
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsPaused = false;
  bool darkMode = false;
  bool isExpandedNotif = false;
  bool isExpandedPref = false;

  void navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Logout function
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()), // Redirect to login screen after logout
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF5E4),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffF4A26B)),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffFFF5E4),
                  Color(0xffE7BA9C),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: const Text(
                    'Settings',
                    style: TextStyle(
                      color: Color(0xffF4A26B),
                      fontFamily: 'Inter Regular',
                      fontWeight: FontWeight.w700,
                      fontSize: 35,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CustomSectionTitle(title: 'GENERAL'),
                CustomListTile(
                  icon: Icons.person,
                  title: 'Account',
                  onTap: () {
                    navigateTo(context, const AccountScreen());
                  },
                ),
                ExpansionTile(
                  leading: const Icon(Icons.notifications, color: Colors.black, size: 25),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    isExpandedNotif
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      isExpandedNotif = expanded;
                    });
                  },
                  children: [
                    SwitchListTile(
                      title: const Text("Pause all"),
                      subtitle: const Text('Indefinitely pause notifications'),
                      activeColor: const Color(0xffFFBF89),
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: const Color(0xff594839),
                      inactiveThumbColor: const Color(0xffFFBF89),
                      value: notificationsPaused,
                      onChanged: (bool value) {
                        setState(() {
                          notificationsPaused = value;
                        });
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  leading: const Icon(Icons.room_preferences, color: Colors.black, size: 25),
                  title: const Text(
                    'Preferences',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: Icon(
                    isExpandedPref
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      isExpandedPref = expanded;
                    });
                  },
                  children: [
                    SwitchListTile(
                      title: const Text("Screen Mode"),
                      subtitle: const Text('Light Mode or Dark Mode'),
                      activeColor: const Color(0xffFFBF89),
                      inactiveTrackColor: Colors.white,
                      activeTrackColor: const Color(0xff594839),
                      inactiveThumbColor: const Color(0xffFFBF89),
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
                Divider(
                  color: Colors.grey.withOpacity(0.7),
                  thickness: 2,
                  endIndent: 10,
                  indent: 10,
                ),
                const CustomSectionTitle(title: 'FEEDBACK'),
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
                CustomListTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () => _logout(context), // Call logout when tapped
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
            dashboard: Colors.white,
            fReport: Colors.white,
            history: Colors.white,
            settings: Color(0xffFE5D26)),
      ),
    );
  }
}
