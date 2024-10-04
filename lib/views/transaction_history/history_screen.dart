import 'package:flutter/material.dart';
import 'package:money_tree/views/edit_transaction/edit_expenses_screen.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'package:money_tree/views/financial_report/monthlyFR_screen.dart';
import 'package:money_tree/views/settings/settings_screen.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';
import 'package:money_tree/views/edit_transaction/edit_income_screen.dart';
import '../constants/build_transaction_list.dart';

import '../../models/tracker_model.dart';


class HistoryScreen extends StatefulWidget {
  @override
  HistoryDataListState createState() => HistoryDataListState();
}

class HistoryDataListState extends State<HistoryScreen> {
  List<Tracker> trackerData = [
    // List of expenses
    Tracker(name: 'Tire Repair', category: 'CAR', amount: 250, type: 'expenses'),
    Tracker(name: 'Tuition fee', category: 'SCHOOL', amount: 250, type: 'expenses'),

    // List of income
    Tracker(name: 'Freelance', account: 'CARD', amount: 250, type: 'income'),
    Tracker(name: 'XYZ Company', account: 'CASH', amount: 250, type: 'income'),
  ];


  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    return Scaffold(
      backgroundColor: Color(0xffABC5EA),

      appBar: AppBar(
          backgroundColor: Color(0xffFFF8ED),
          title: Text(
            'HISTORY',
            style: TextStyle(
                color: Color(0XFF639DF0),
                fontFamily: 'Inter Regular',
                fontWeight: FontWeight.w700
            ),
          ),
          centerTitle: true,
          actions: const [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'lib/images/pfp.jpg'),
              radius: 20,
            ),
            SizedBox(width: 16),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0XFF639DF0)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          )
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFF8ED),
              Color(0xffABC5EA),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // Search Bar
            _searchBar(),

            SizedBox(height: sw * 0.05),

            // Expenses section
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Color(0xff093F40),
                    thickness: 1.3,
                    endIndent: 20.0,
                  ),
                ),
                Text(
                  'EXPENSES',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fs * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xff093F40),
                    thickness: 1.3,
                    indent: 20.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: sw * 0.025),
            Column(
              children: trackerData
                  .where((track) => track.type == 'expenses') // Filter for income only
                  .map((track) {
                return TransactionList(track: track);
              }).toList(),
            ),
            TextButton(
              onPressed: () {
                // setState(() {
                //   expenseList.addAll([
                //     Expense(icon: Icons.fastfood, item: 'Dinner', date: 'September 6, 2024', category: 'FOOD', amount: '\$100'),
                //     Expense(icon: Icons.coffee, item: 'Coffee', date: 'September 7, 2024', category: 'FOOD', amount: '\$10'),
                //   ]);
                // });
              },
              child: Text('See all'),
            ),

            SizedBox(height: sw * 0.05),

            // Income section
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Color(0xff093F40),
                    thickness: 1.3,
                    endIndent: 20.0,
                  ),
                ),
                Text(
                  'INCOME',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fs * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xff093F40),
                    thickness: 1.3,
                    indent: 20.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: sw * 0.025),
            Column(
              children: trackerData
                  .where((track) => track.type == 'income') // Filter for income only
                  .map((track) {
                return TransactionList(track: track);
              }).toList(),
            ),
            TextButton(
              onPressed: () {
                // setState(() {
                //   incomeList.addAll([
                //     Income(icon: Icons.attach_money, name: 'Freelance', date: 'September 7, 2024', category: 'CARD', amount: '\$100'),
                //   ]);
                // });
              },
              child: Text('See all'),
            ),


          ],
        ),
      ),

      // Navigation bar
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: sw * 0.04), // Adjust the value as needed
        child: SizedBox(
          height: 70, // Set height
          width: 70,  // Set width
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewIncomeScreen()));
            },
            child: Icon(
              Icons.add,
              size: 40, // Icon size
              color: Color(0xffE63636),
            ),
            backgroundColor: Color(0xffFFF8ED),
            shape: CircleBorder(),
          ),
        ),
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
                icon: Icon(Icons.history, color: Color(0xffFE5D26), size: 33),
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

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5), // Background color of the container
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          fillColor: Color(0xffFFF8ED),
          filled: true,
          hintText: 'Date, Category, Price',
          hintStyle: TextStyle(
              color: Color(0xff545454),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300
          ),
          suffixIcon: Icon(
            Icons.search,
            color: Color(0xff545454),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.transparent, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.transparent, width: 1.5),
          ),
        ),
      ),
    );
  }


}

// Define the models for Expense and Income
class Expense {
  final IconData icon;
  final String item;
  final String date;
  final String category;
  final String amount;

  Expense({
    required this.icon,
    required this.item,
    required this.date,
    required this.category,
    required this.amount,
  });
}

class Income {
  final IconData icon;
  final String name;
  final String date;
  final String category;
  final String amount;

  Income({
    required this.icon,
    required this.name,
    required this.date,
    required this.category,
    required this.amount,
  });
}