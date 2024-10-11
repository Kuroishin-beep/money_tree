import 'package:flutter/material.dart';
import '../../bottom_navigation.dart';
import '../../fab.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:money_tree/models/tracker_model.dart';
import '../constants/build_transaction_list.dart';
import 'package:intl/intl.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {

  List<Tracker> trackerData = [
    Tracker(name: 'Freelance', account: 'CARD', amount: 250, type: 'income'),
    Tracker(name: 'XYZ Company', account: 'CASH', amount: 250, type: 'income'),
  ];

  // Get current month as a string
  String _getCurrentMonth() {
    return DateFormat('MMMM').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery
        .of(context)
        .size
        .width;
    double fs = sw;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff90B388),
        title: const Text(
          'INCOME',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter Regular',
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: const [
          CircleAvatar(
            backgroundImage: AssetImage('lib/images/pfp.jpg'),
            radius: 20,
          ),
          SizedBox(width: 16),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffffffff), Color(0xffFFF5E4)],
              ),
            ),
          ),

          // Main Body
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: sw * 0.05, horizontal: sw * 0.04),
              child: Column(
                children: [

                  // Month Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Color(0xff093F40),
                          thickness: 2.0,
                          endIndent: 20.0,
                        ),
                      ),
                      Text(
                        _getCurrentMonth().toUpperCase(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fs * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color(0xff093F40),
                          thickness: 2.0,
                          indent: 20.0,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: sw * 0.04),

                  // List of income
                  Column(
                    children: trackerData.map((track) {
                      return TransactionList(track: track);
                    }).toList(),
                  ),
                ],
              ),
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
        child: NavBottomAppBar(
            dashboard: Color(0xffFE5D26),
            fReport: Colors.white,
            history: Colors.white,
            settings: Colors.white
        ),
      ),
    );
  }
}