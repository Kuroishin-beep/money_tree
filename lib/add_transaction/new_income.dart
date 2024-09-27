import 'package:flutter/material.dart';
import 'package:money_tree/add_transaction/new_expenses.dart';
import 'package:money_tree/dashboard/dashboard.dart';
import 'package:money_tree/history/history.dart';
import 'package:money_tree/budget/budget.dart';
import 'package:money_tree/settings/settings.dart';

class NewIncomeScreen extends StatefulWidget {
  @override
  State<NewIncomeScreen> createState() => _NewIncomeScreenState();
}

class _NewIncomeScreenState extends State<NewIncomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Dashboard()), // Replace with the Dashboard page
              );
            },
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            "ADD TRANSACTION",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              shadows: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4, // Add shadow to main text
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/cat.jpg'),
              ),
            ),
          ],
          backgroundColor: Color(0xFF0A9396),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A9396), Color(0xFFF3F9FA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // First Column for "NEW INCOME"
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "NEW INCOME",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                height: .4),
                          ),
                          SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DiamondShape(size: 10.0, opacity: 1.0),
                              SizedBox(
                                width: 150,
                                child: Divider(
                                  color: Color(0xFF093F40),
                                  thickness: 1.5,
                                ),
                              ),
                              DiamondShape(size: 10.0, opacity: 1.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20), // Space between the two columns
                    // Second Column for "NEW EXPENSE"
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NewExpenseScreen()));
                            },
                            child: Text(
                              "NEW EXPENSE",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withOpacity(0.7),
                                height: 0.4,
                              ),
                            ),
                          ),
                          SizedBox(height: 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DiamondShape(size: 7.0, opacity: 0.3),
                              SizedBox(
                                width: 149,
                                child: Divider(
                                  color: Colors.black.withOpacity(0.3),
                                  thickness: 1,
                                ),
                              ),
                              DiamondShape(size: 7.0, opacity: 0.3),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Original content follows below...
                SizedBox(height: 20), // Add spacing before next section

                Container(
                  padding: EdgeInsets.all(8.0),
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '\$150,000',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                        shadows: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('To account',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 17)),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildAccountButton('CASH'),
                    _buildAccountButton('CARD'),
                    _buildAccountButton('GCASH'),
                  ],
                ),
                SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('From category',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 17)),
                ),
                SizedBox(height: 8),

                // Dynamically center grocery and plus buttons using Spacer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    _buildCategoryButton(Icons.person_outline),
                    Spacer(flex: 2),
                    _buildCategoryButton(Icons.work),
                    Spacer(flex: 2),
                    _buildCategoryButton(Icons.add, faded: true),
                    Spacer(),
                  ],
                ),

                SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    backgroundColor: Color(0xFFFAF3E0),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide.none,
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),

                // Extra spacing to ensure scrollable space at the bottom
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              ],
            ),
          ),
        ),
      ),

      // Navigation Bar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewIncomeScreen()));
        },
        child: Icon(
          Icons.add,
          size: 40,
          color: Color(0xff03045E),
        ),
        backgroundColor: Colors.white,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        children: [
          BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 15.0,
            color: Color(0xff001219),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon:
                  Icon(Icons.home_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Dashboard()));
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.savings_outlined,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BudgetScreen()));
                  },
                ),
                SizedBox(width: 80),
                IconButton(
                  icon: Icon(Icons.history, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()));
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.settings_outlined,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ElevatedButton for Accounts with removed outline and added shadow
  Widget _buildAccountButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFAF3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
        elevation: 4,
      ),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 24),
      ),
    );
  }

  // Circle buttons with drop shadow
  Widget _buildCategoryButton(IconData icon, {bool faded = false}) {
    return Material(
      elevation: 4,
      shape: CircleBorder(),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: faded ? Colors.teal.withOpacity(0.3) : Colors.teal,
        child: Icon(icon, size: 90, color: Colors.white),
      ),
    );
  }
}

// Custom widget to create diamond shape
class DiamondShape extends StatelessWidget {
  final double size;
  final double opacity;

  DiamondShape({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45 degrees to rotate the square to a diamond
      child: Container(
        width: size,
        height: size,
        color: Color(0xFF093F40).withOpacity(opacity),
      ),
    );
  }
}
