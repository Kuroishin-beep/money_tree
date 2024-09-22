import 'package:flutter/material.dart';
import 'package:budget_tracker/add_transaction/new_income.dart';
import 'package:budget_tracker/dashboard/dashboard.dart';
import 'package:budget_tracker/history/history.dart';
import 'package:budget_tracker/budget/budget.dart';
import 'package:budget_tracker/settings/settings.dart';


class EditIncomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            "EDIT TRANSACTION",
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
                // "EXPENSES" with lines and dots
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0xFF093f40),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 60,
                        child: Divider(
                          color: Color(0xFF093f40),
                          thickness: 1,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'INCOME',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                          shadows: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        width: 60,
                        child: Divider(
                          color: Color(0xFF093f40),
                          thickness: 1,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(0xFF093f40),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),

                // Car description container
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            elevation: 6,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundColor: Colors.teal,
                              radius: 30,
                              child: Icon(Icons.person, color: Colors.white, size: 50),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'PERSONAL',
                                            style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'Description',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                              height: 0.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0, top: 20.0),
                                      child: Text(
                                        '\$467 of \$500',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: 467 / 500,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                    minHeight: 5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // $1000 Container matching the size of Car Description container
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
                      '\$1,000',
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
                  child: Text('To account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 17)),
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
                  child: Text('From category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 17)),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryButton(Icons.shopping_bag),
                    _buildCategoryButton(Icons.directions_car),
                    _buildCategoryButton(Icons.favorite),
                  ],
                ),
                SizedBox(height: 10),

                // Dynamically center grocery and plus buttons using Spacer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    _buildCategoryButton(Icons.local_grocery_store),
                    Spacer(flex: 2),
                    _buildCategoryButton(Icons.add, faded: true),
                    Spacer(),
                  ],
                ),

                SizedBox(height: 10),

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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewIncomeScreen()));
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
                  icon: Icon(Icons.home_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Dashboard()));
                  },
                ),
                SizedBox(width: 5),
                IconButton(
                  icon: Icon(Icons.savings_outlined, color: Colors.white, size: 40),
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
                  icon: Icon(Icons.settings_outlined, color: Colors.white, size: 40),
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
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 24),
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
