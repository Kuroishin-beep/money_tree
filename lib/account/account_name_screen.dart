import 'package:flutter/material.dart';
import 'package:money_tree/dashboard/dashboard_screen.dart';
import 'package:money_tree/history/history_screen.dart';
import 'package:money_tree/settings/settings_screen.dart';
import 'package:money_tree/add_transaction/new_income_screen.dart';

import '../financial_report/monthly_screen.dart';

class AccountNameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Name',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            buildTextField('First Name', 'Andrei', true),
            buildTextField('Middle Name', '-', false),
            buildTextField('Surname', 'Quizon', true),
            buildTextField('Suffix', '-', false),
          ],
        ),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
          Divider(),
        ],
      ),
    );
  }

