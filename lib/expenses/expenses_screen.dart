import 'package:flutter/material.dart';
import 'package:money_tree/dashboard/dashboard_screen.dart';
import 'package:money_tree/financial_report/monthly_screen.dart';
import 'package:money_tree/add_transaction/new_income_screen.dart';
import 'package:money_tree/settings/settings.dart';
import 'package:money_tree/history/history_screen.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String month = 'September';

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: AppBar(
          backgroundColor: Color(0xffFBC29C),
          title: Text(
            'EXPENSES',
            style: TextStyle(
                color: Colors.white,
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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          )
      ),

      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffffffff),
                      Color(0xffFFF5E4)
                    ]
                )
            ),
          ),

          SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: sw * 0.05, horizontal: sw * 0.06),
                child: Column(
                  children: [
                    SizedBox(height: sw * 0.18),

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
                          '$month',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: fs * 0.04,
                              fontWeight: FontWeight.w500
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

                    ExpenseCard(
                      income: 1500,
                      icon: Icons.backpack,
                      date: 'September 5, 2024',
                      name: 'Tuition Fee',
                      category: 'School',
                    ),

                    ExpenseCard(
                      income: 1500,
                      icon: Icons.home,
                      date: 'September 5, 2024',
                      name: 'Renovation',
                      category: 'Home',
                    ),

                    ExpenseCard(
                      income: 1500,
                      icon: Icons.work,
                      date: 'September 5, 2024',
                      name: 'Tire Repair',
                      category: 'Car',
                    ),

                    ExpenseCard(
                      income: 1500,
                      icon: Icons.work,
                      date: 'September 5, 2024',
                      name: 'Weekly groc.',
                      category: 'Groceries',
                    ),


                  ],
                ),
              )

          )

        ],
      ),

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

class ExpenseCard extends StatelessWidget {
  final double income;
  final IconData icon;
  final String date;
  final String name;
  final String category;

  ExpenseCard({
    required this.income,
    required this.icon,
    required this.date,
    required this.name,
    required this.category
  });

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    final formatter = NumberFormat('#,###.00');

    return Stack(
      children: [
        Container(
            width: double.infinity,
            height: sw * 0.22,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 7
                  )
                ]
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Category Icon
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: sw * 0.03, horizontal: sw *0.04),
                      child: Container(
                        alignment: Alignment.center,
                        width: sw * 0.15,
                        height: sw * 0.15,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffD7A685)
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: sw * 0.12,
                                height: sw * 0.12,
                                decoration: BoxDecoration(
                                  color: Color(0xffFBC29C),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xffFBC29C),
                                      blurRadius: 3,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.center,
                              child: Icon(
                                icon,
                                color: Colors.white,
                                size: 48,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // Income Details
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: sw * 0.035),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter Regular',
                                fontWeight: FontWeight.w600,
                                fontSize: fs * 0.03
                            ),
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter Regular',
                                fontWeight: FontWeight.w700,
                                fontSize: fs * 0.045
                            ),
                          ),
                          Text(
                            category,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Inter Regular',
                                fontWeight: FontWeight.w300,
                                fontSize: fs * 0.025
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(width: sw * 0.08),

                    // Income Amount
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '₱${formatter.format(income)}',
                        style: TextStyle(
                            fontFamily: 'Inter Regular',
                            fontSize: fs * 0.05,
                            fontWeight: FontWeight.w800,
                            color: Colors.black.withOpacity(0.6),
                            fontStyle: FontStyle.italic
                        ),
                      ),
                    )

                  ],
                )
              ],
            )
        ),

        SizedBox(height: sw * 0.24),
      ],
    );
  }
}
