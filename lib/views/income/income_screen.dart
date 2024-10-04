import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../financial_report/monthlyFR_screen.dart';
import '../add_transaction/add_income_screen.dart';
import '../settings/settings_screen.dart';
import '../transaction_history/history_screen.dart';
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
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff90B388),
        title: Text(
          'INCOME',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter Regular',
            fontWeight: FontWeight.w700,
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
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
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
              padding: EdgeInsets.symmetric(vertical: sw * 0.05, horizontal: sw * 0.04),
              child: Column(
                children: [

                  // Month Divider
                  Row(
                    children: [
                      Expanded(
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
                      Expanded(
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
          shape: CircularNotchedRectangle(),
          notchMargin: 15.0,
          color: Color(0xff231F20),
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home_filled, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Dashboard()));
                },
              ),
              IconButton(
                icon: Icon(Icons.bar_chart, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => MonthlyReport()));
                },
              ),
              SizedBox(width: 80), // Spacer for FAB
              IconButton(
                icon: Icon(Icons.history, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => HistoryScreen()));
                },
              ),
              IconButton(
                icon: Icon(Icons.settings_rounded, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
