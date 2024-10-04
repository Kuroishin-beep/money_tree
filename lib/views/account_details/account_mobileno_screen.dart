import 'package:flutter/material.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'package:money_tree/views/transaction_history/history_screen.dart';
import 'package:money_tree/views/settings/settings_screen.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';

import '../financial_report/monthlyFR_screen.dart';

class AccountMobileNoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Changed the app bar
      appBar: AppBar(
          backgroundColor: Color(0xffFFF5E4),
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

          // Main body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mobile No.',
                  style: TextStyle(
                      color: Color(0xffF4A26B),
                      fontFamily: 'Inter Regular',
                      fontWeight: FontWeight.w700,
                      fontSize: 35
                  ),
                ),
                SizedBox(height: 30),
                buildTextField('Mobile No', '-', true),
              ],
            ),
          ),
        ],
      ),
      // Floating Action Button (FAB) to navigate to NewIncomeScreen
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
                icon: Icon(
                    Icons.home_filled, color: Color(0xffFE5D26), size: 33),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.bar_chart, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MonthlyReport()),
                  );
                },
              ),
              SizedBox(width: 80), // Spacer for FAB
              IconButton(
                icon: Icon(Icons.history, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                    Icons.settings_rounded, color: Colors.white, size: 33),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
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
// Helper method to build text fields with a label
Widget buildTextField(String label, String value, bool required) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black.withOpacity(0.4)),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    ),
  );
}

