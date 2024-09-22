import 'package:budget_tracker/financial_report/monthly.dart';
import 'package:budget_tracker/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/budget/budget.dart';
import 'package:budget_tracker/add_transaction/new_income.dart';
import 'package:budget_tracker/history/history.dart';

class Dashboard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    // for font size
    double fs = sw;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background Container
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Color(0xff0A9396),
                  Color(0xffF3F9FA),
                ],
              ),
            ),
          ),

          // Main Content
          SingleChildScrollView(
              child: Stack(
                children: [

                  // header box
                  Container(
                    child: Image.asset('images/header_design.png'),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.05), // Parent Padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Hello, User!
                        Container(
                          padding: EdgeInsets.only(top: sw * 0.15, left: sw * 0.25),
                          child: Text(
                            'Hello, Andrei!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fs * 0.07,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Inter Regular',
                            ),
                          ),
                        ),

                        // User Profile Picture and Account Summary
                        Container(

                          // Account Summary Box
                            width: double.infinity,
                            height: sw * 0.35,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                                colors: [
                                  Color(0xffC2F8FA),
                                  Color(0xffE2F6F6),
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(35),
                                bottomLeft: Radius.circular(35),
                                bottomRight: Radius.circular(35),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 8,
                                  blurRadius: 5,
                                  offset: Offset(0, 3), // Shadow offset
                                ),
                              ],
                            ),

                            // Parent Padding for Account Summary Content (Balance, Cash, Card, Gcash)
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sw * 0.05),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [

                                  // Balance Section
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'BALANCE',
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(0.84),
                                              fontFamily: 'Inter Regular',
                                              fontWeight: FontWeight.w800,
                                              fontSize: fs * 0.047,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            '\$700,000',
                                            style: TextStyle(
                                              color: Colors.black.withOpacity(0.68),
                                              fontFamily: 'Inter Regular',
                                              fontWeight: FontWeight.w800,
                                              fontSize: fs * 0.047,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Divider(
                                    color: Color(0xff093F40),
                                    thickness: 2,
                                    height: sw * 0.14,
                                  ),

                                  // Cash , Card, Gcash
                                  Padding(
                                    padding: EdgeInsets.only(top: sw * 0.08),
                                    child: Column(
                                      children: [

                                        // Cash Section
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Cash',
                                                  style: TextStyle(
                                                    fontSize: fs * 0.038,
                                                    color: Colors.black.withOpacity(0.84),
                                                    fontFamily: 'Inter Regular',
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  color: Colors.black,
                                                  indent: sw * 0.02,
                                                  endIndent: sw * 0.02,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  '\$200,00',
                                                  style: TextStyle(
                                                      fontSize: fs * 0.038,
                                                      color: Colors.black.withOpacity(0.68),
                                                      fontFamily: 'Inter Regular',
                                                      fontWeight: FontWeight.w800,
                                                      fontStyle: FontStyle.italic
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Card Section
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Card',
                                                  style: TextStyle(
                                                    fontSize: fs * 0.038,
                                                    color: Colors.black.withOpacity(0.84),
                                                    fontFamily: 'Inter Regular',
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  color: Colors.black,
                                                  indent: sw * 0.02,
                                                  endIndent: sw * 0.02,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  '\$250,00',
                                                  style: TextStyle(
                                                      fontSize: fs * 0.038,
                                                      color: Colors.black.withOpacity(0.68),
                                                      fontFamily: 'Inter Regular',
                                                      fontWeight: FontWeight.w800,
                                                      fontStyle: FontStyle.italic
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Gcash Section
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Gcash',
                                                  style: TextStyle(
                                                    fontSize: fs * 0.038,
                                                    color: Colors.black.withOpacity(0.84),
                                                    fontFamily: 'Inter Regular',
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  color: Colors.black,
                                                  indent: sw * 0.02,
                                                  endIndent: sw * 0.02,
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  '\$250,00',
                                                  style: TextStyle(
                                                      fontSize: fs * 0.038,
                                                      color: Colors.black.withOpacity(0.68),
                                                      fontFamily: 'Inter Regular',
                                                      fontWeight: FontWeight.w800,
                                                      fontStyle: FontStyle.italic
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Profile Picture Section
                                  Positioned(
                                    top: -(sw * 0.18 + 10),
                                    child: CircleAvatar(
                                      radius: sw * 0.1,
                                      backgroundImage: AssetImage('images/pfp.jpg'),
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),

                        SizedBox(height: 20),

                        // Divider Month
                        Container(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Circle before line
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
                                // Left line (1 inch = 96 pixels)
                                SizedBox(
                                  width: 60,
                                  child: Divider(
                                    color: Color(0xFF093f40),
                                    thickness: 1,
                                  ),
                                ),
                                SizedBox(width: 5),
                                // "EXPENSES" text
                                Text(
                                  'September',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fs * 0.035,
                                    color: Colors.black,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,  // Shadow for the text
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 5),
                                // Right line (1 inch = 96 pixels)
                                SizedBox(
                                  width: 60,
                                  child: Divider(
                                    color: Color(0xFF093f40),
                                    thickness: 1,
                                  ),
                                ),
                                // Circle after line
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF093f40),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,  // Shadow for circles
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 25),

                        // Income, Expense, Budget
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [

                              // Income, Expense
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [

                                    // Income Section
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MonthlyReport()));
                                      },
                                      child:  Container(
                                        // Income Gradient Box
                                        width: sw * 0.45,
                                        height: sw * 0.45,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xff199C2D),
                                              Color(0xff022127),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(25.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 6,
                                              blurRadius: 10,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),

                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.06),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  width: sw * 0.1,
                                                  height: sw * 0.1,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),

                                              Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '\$25,000.00',
                                                        style: TextStyle(
                                                          fontSize: fs * 0.04,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: 'Inter Regular',
                                                        ),
                                                      ),
                                                      Text(
                                                        'Income',
                                                        style: TextStyle(
                                                          fontSize: fs * 0.033,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w200,
                                                          fontFamily: 'Inter Regular',
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              )

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    // Expenses Section
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MonthlyReport()));
                                      },
                                      child: Container(
                                        // Income Gradient Box
                                        width: sw * 0.45,
                                        height: sw * 0.45,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color(0xffE42626),
                                              Color(0xff022329),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(25.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 6,
                                              blurRadius: 10,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),

                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.06),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  width: sw * 0.1,
                                                  height: sw * 0.1,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),

                                              Align(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '\$10,800.00',
                                                        style: TextStyle(
                                                          fontSize: fs * 0.04,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: 'Inter Regular',
                                                        ),
                                                      ),
                                                      Text(
                                                        'Expenses',
                                                        style: TextStyle(
                                                          fontSize: fs * 0.033,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w200,
                                                          fontFamily: 'Inter Regular',
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              )

                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(width: 10),

                              // Budget Section
                              Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => BudgetScreen()));
                                    },
                                    child: Container(
                                      height: 2 * (sw * 0.45) + 10,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xff001219),
                                            Color(0xff0A9396),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(25.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 6,
                                            blurRadius: 10,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),

                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(vertical: sw * 0.06),
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                'Budget',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: fs * 0.04,
                                                  fontWeight: FontWeight.w200,
                                                  fontFamily: 'Inter Regular',
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Progress Bar
                                          Container(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: ProgressBar(
                                                progress: 150.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              )

                            ],
                          ),
                        ),

                        SizedBox(height: 25),

                        // Recent Purchase
                        Container(
                          width: double.infinity,
                          height: sw * 0.9,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff9FFADB),
                                Color(0xff02262C),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 6,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),

                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.04),
                            child: Column(
                              children: [

                                // Recent Purchase Text
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'RECENT PURCHASE',
                                    style: TextStyle(
                                      color: Color(0xff202828),
                                      fontSize: fs * 0.05,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Inter Regular',
                                    ),
                                  ),
                                ),

                                // Recent Purchase List
                                Expanded(
                                    child: ListView(
                                      children: [
                                        RecentPurchaseCard(
                                            date: 'September 5, 2024',
                                            category: 'Grocery',
                                            amount: 32.5
                                        ),
                                        RecentPurchaseCard(
                                            date: 'September 4, 2024',
                                            category: 'Car',
                                            amount: 70
                                        ),
                                        RecentPurchaseCard(
                                            date: 'September 3, 2024',
                                            category: 'Grocery',
                                            amount: 15.5
                                        ),
                                        RecentPurchaseCard(
                                            date: 'September 3, 2024',
                                            category: 'Shopping',
                                            amount: 15.5
                                        ),
                                        RecentPurchaseCard(
                                            date: 'September 2, 2024',
                                            category: 'Grocery',
                                            amount: 10
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 25),
                      ],
                    ),
                  )
                ],
              )
          ),
        ],
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
}

// Class for Progress Bar
class ProgressBar extends StatelessWidget {
  final double progress;

  ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    // for font size
    double fs = sw;

    return Container(
      width: sw * 0.02,
      height: sw * 0.65,
      decoration: BoxDecoration(
          color: Color(0xff5C5C5C),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 6,
              blurRadius: 10,
              offset: Offset(0, 3),
            )
          ]),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: sw * 0.02,
              height: progress,
              decoration: BoxDecoration(
                  color: Color(0xffEDF2F7),
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          )
        ],
      ),
    );
  }
}

class RecentPurchaseCard extends StatelessWidget {
  final Color color;
  final String date;
  final String category;
  final double amount;

  RecentPurchaseCard({
    this.color = Colors.black,
    required this.date,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffC2F8FA),
              Color(0xffE2F6F6),
            ],
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 8,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow offset
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            date,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Inter Regular',
            ),
          ),
          subtitle: Text(category),
          trailing: Text(
            '\$$amount',
            style: TextStyle(
              color: Colors.black.withOpacity(0.68),
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: 'Inter Regular',
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}