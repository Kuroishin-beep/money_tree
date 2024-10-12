import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_tree/views/account_details/account_birthdate_screen.dart';
import 'package:money_tree/views/account_details/account_email_screen.dart';
import 'package:money_tree/views/account_details/account_mobileno_screen.dart';
import 'package:money_tree/views/account_details/account_name_screen.dart';
import '../../bottom_navigation.dart';
import '../../fab.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final double _avatarRadiusFactor = 0.15;
  String? _userName = '';

  @override
    void initState() {
    super.initState();
    _getUserName();
  }
  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      setState(() {
        _userName = userData['firstName']; 
      });
    }
  }
  
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
          backgroundColor: const Color(0xffFFF5E4),
          title: Text(
            'Hello, ${_userName ?? 'User'}!',
            style: const TextStyle(
                color: Color(0xffF4A26B),
                fontFamily: 'Inter Regular',
                fontWeight: FontWeight.w700
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xffF4A26B)),
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
            decoration: const BoxDecoration(
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
                  backgroundImage: const AssetImage('lib/images/pfp.jpg'),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle error here
                  },
                ),

                const SizedBox(height: 20),

                const SectionTitle(title: 'ACCOUNT DETAILS'),
                const AccountDetail(icon: Icons.person, title: 'Name'),
                const AccountDetail(icon: Icons.calendar_today, title: 'Birthdate'),
                const AccountDetail(icon: Icons.email, title: 'Email'),
                const AccountDetail(icon: Icons.phone, title: 'Mobile No.'),
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
        child: NavBottomAppBar(
            dashboard: Colors.white,
            fReport: Colors.white,
            history: Colors.white,
            settings: Color(0xffFE5D26)
        ),
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

  const AccountDetail({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (title == 'Name') {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AccountNameScreen()),
          );
        } else if (title == 'Birthdate') {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AccountBirthdateScreen()),
          );
        } else if (title == 'Email') {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AccountEmailScreen()),
          );
        } else if (title == 'Mobile No.') {
          Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AccountMobileNoScreen()),
          );
        }
      },
    );
  }
}
