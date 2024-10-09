import 'package:money_tree/models/tracker_model.dart';
import 'package:money_tree/views/constants/build_transaction_list.dart';
import 'package:money_tree/views/financial_report/monthlyFR_screen.dart';
import 'package:money_tree/views/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:money_tree/views/budget/budget_screen.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';
import 'package:money_tree/views/transaction_history/history_screen.dart';
import 'package:money_tree/views/income/income_screen.dart';
import 'package:money_tree/views/expenses/expenses_screen.dart';
import 'package:intl/intl.dart';
import '../../bottom_navigation.dart';
import '../../fab.dart';



class Dashboard extends StatefulWidget {
  const Dashboard({super.key});


  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final NumberFormat formatter = NumberFormat('#,###.00');

  // List of
  List<Tracker> trackerData = [
    Tracker(name: 'Freelance', account: 'CARD', amount: 250, type: 'income'),
    Tracker(
        name: 'Tire Repair', category: 'CAR', amount: 250, type: 'expenses'),
    Tracker(name: 'Freelance', account: 'CASH', amount: 1200, type: 'income'),
    Tracker(name: 'Freelance', account: 'GCASH', amount: 10, type: 'income'),
  ];

  // FOR ACCOUNT SUMMARY BOX
  double _getBalance() {
    double balance = 0;

    for (var tracker in trackerData) {
      if (tracker.type == 'income') {
        balance += tracker.amount;
      }
    }
    return balance;
  }

  double _getCash() {
    double cash = 0;

    for (var tracker in trackerData) {
      if (tracker.type == 'income' && tracker.account == 'CASH') {
        cash += tracker.amount;
      }
    }
    return cash;
  }

  double _getCard() {
    double card = 0;

    for (var tracker in trackerData) {
      if (tracker.type == 'income' && tracker.account == 'CARD') {
        card += tracker.amount;
      }
    }
    return card;
  }

  double _getGCash() {
    double gcash = 0;

    for (var tracker in trackerData) {
      if (tracker.type == 'income' && tracker.account == 'GCASH') {
        gcash += tracker.amount;
      }
    }
    return gcash;
  }

  // Get current month as a string
  String _getCurrentMonth() {
    return DateFormat('MMMM').format(DateTime.now());
  }

  double _getTotalIncome() {
    double income = 0;

    for (var tracker in trackerData) {
      if (tracker.type == 'income') {
        income += tracker.amount;
      }
    }
    return income;
  }

  double _getTotalExpenses() {
    double expenses = 0;

    for (var tracker in trackerData) {
      if (tracker.type == 'expenses') {
        expenses += tracker.amount;
      }
    }
    return expenses;
  }

  // for button animation
  bool _isIncomePressed = false;
  bool _isExpensesPressed = false;
  bool _isBudgetPressed = false;


  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery
        .of(context)
        .size
        .width;
    double fs = sw;

    return Scaffold(

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
              padding: EdgeInsets.symmetric(
                  vertical: sw * 0.08, horizontal: sw * 0.05),
              child: Column(
                children: [
                  // Hello, User!
                  Container(
                    padding: EdgeInsets.only(top: sw * 0.05, left: sw * 0.2),
                    child: Text(
                      'Hello, Andrei!',
                      style: TextStyle(
                        color: Color(0xff020202),
                        fontSize: fs * 0.08,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter Regular',
                      ),
                    ),
                  ),

                  SizedBox(height: sw * 0.07),

                  // Pfp and Account Summary Section
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Account Summary (Balance, Cash, Card, Gcash)
                      _accountSummaryBox(
                          _getBalance(),
                          _getCash(),
                          _getCard(),
                          _getGCash()
                      ),

                      // Profile Picture
                      Positioned(
                        top: -(sw * 0.2 + 14),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xffABC5EA),
                                width: 4.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff8296B2).withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: CircleAvatar(
                            radius: sw * 0.12,
                            backgroundImage: AssetImage('lib/images/pfp.jpg'),
                          ),
                        ),
                      )

                    ],
                  ),

                  SizedBox(height: sw * 0.07),

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
                        '${_getCurrentMonth()}',
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

                  SizedBox(height: sw * 0.07),

                  //Income, Expenses, Budget Sections
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: [

                        //Income and Expenses
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: [

                                // Income Section
                                _incomeBox(_getTotalIncome()),

                                SizedBox(height: sw * 0.03),

                                // Expenses Section
                                _expensesBox(_getTotalExpenses())
                              ],
                            )
                        ),

                        SizedBox(width: sw * 0.03),

                        // Budget Section
                        Expanded(
                            flex: 3,
                            child: _budgetBox()
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: sw * 0.04),

                  // Recent Transaction Section
                  _recentTransactionBox(),

                  SizedBox(height: sw * 0.01),
                ],
              ),
            ),
          )
        ],
      ),

      // Navigation bar
      floatingActionButton: FAB(sw: sw),
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

  Widget _accountSummaryBox(double balance, double cash, double card,
      double gcash) {
    double sw = MediaQuery
        .of(context)
        .size
        .width;
    double fs = sw;

    return Container(
      width: double.infinity,
      height: sw * 0.35,
      decoration: BoxDecoration(
        color: Color(0xff8296B2),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: sw * 0.87,
              height: sw * 0.32,
              decoration: BoxDecoration(
                color: Color(0xffABC5EA),
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffABC5EA),
                    blurRadius: 3,
                    spreadRadius: 5,
                    offset: Offset(0, -5),
                  ),
                ],
              ),


              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: sw * 0.01, horizontal: sw * 0.02),
                child: Column(
                  children: [

                    // Balance Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'BALANCE',
                            style: TextStyle(
                              color: Color(0xffFFF5E4),
                              fontFamily: 'Inter Regular',
                              fontWeight: FontWeight.w800,
                              fontSize: fs * 0.05,
                            ),
                          ),
                        ),

                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            '₱${formatter.format(balance)}',
                            style: TextStyle(
                                color: Color(0xffFFF5E4),
                                fontFamily: 'Inter Regular',
                                fontWeight: FontWeight.w800,
                                fontSize: fs * 0.05,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ),

                      ],
                    ),

                    Divider(
                      color: Colors.white,
                      thickness: 2,

                    ),

                    // Cash Section
                    Row(
                        children: [
                          Text(
                            'Cash',
                            style: TextStyle(
                              fontSize: fs * 0.038,
                              color: Color(0xffFFF5E4),
                              fontFamily: 'Inter Regular',
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              indent: sw * 0.02,
                              endIndent: sw * 0.02,
                            ),
                          ),

                          Text(
                            '₱${formatter.format(cash)}',
                            style: TextStyle(
                                fontSize: fs * 0.038,
                                color: Color(0xffFFF5E4),
                                fontFamily: 'Inter Regular',
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ]
                    ),

                    // Card Section
                    Row(
                        children: [
                          Text(
                            'Card',
                            style: TextStyle(
                              fontSize: fs * 0.038,
                              color: Color(0xffFFF5E4),
                              fontFamily: 'Inter Regular',
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              indent: sw * 0.02,
                              endIndent: sw * 0.02,
                            ),
                          ),

                          Text(
                            '₱${formatter.format(card)}',
                            style: TextStyle(
                                fontSize: fs * 0.038,
                                color: Color(0xffFFF5E4),
                                fontFamily: 'Inter Regular',
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ]
                    ),

                    // Gcash Section
                    Row(
                        children: [
                          Text(
                            'GCash',
                            style: TextStyle(
                              fontSize: fs * 0.038,
                              color: Color(0xffFFF5E4),
                              fontFamily: 'Inter Regular',
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          Expanded(
                            child: Divider(
                              color: Colors.white,
                              indent: sw * 0.02,
                              endIndent: sw * 0.02,
                            ),
                          ),

                          Text(
                            '₱${formatter.format(gcash)}',
                            style: TextStyle(
                                fontSize: fs * 0.038,
                                color: Color(0xffFFF5E4),
                                fontFamily: 'Inter Regular',
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ]
                    )

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _incomeBox(double income) {
    double sw = MediaQuery
        .of(context)
        .size
        .width;
    double fs = sw;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IncomeScreen()));
      },
      onTapDown: (_) {
        setState(() {
          _isIncomePressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isIncomePressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isIncomePressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: double.infinity,
        height: sw * 0.45,
        decoration: BoxDecoration(
          boxShadow: _isIncomePressed
              ? []
              : [
            BoxShadow(
                color: Color(0xffBFBFBF)
            )
          ],
          borderRadius: BorderRadius.circular(30.0),
        ),
        transform: Matrix4.translationValues(0, _isIncomePressed ? 5 : 0, 0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: sw * 0.424,
                height: sw * 0.43,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 1,
                      spreadRadius: 2,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05, vertical: sw * 0.06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: sw * 0.1,
                          height: sw * 0.1,
                          decoration: BoxDecoration(
                            color: Color(0xffA9C6A2),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: sw * 0.3,
                                  height: sw * 0.09,
                                  decoration: BoxDecoration(
                                    color: Color(0xffDAFFD1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xffDAFFD1),
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(0, -1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₱${formatter.format(income)}',
                              style: TextStyle(
                                fontSize: fs * 0.04,
                                color: Color(0xff080C1A),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter Regular',
                              ),
                            ),
                            Text(
                              'Income',
                              style: TextStyle(
                                fontSize: fs * 0.033,
                                color: Color(0xff65AD53),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter Regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expensesBox(double expenses) {
    double sw = MediaQuery
        .of(context)
        .size
        .width;
    double fs = sw;

    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ExpensesScreen()));
      },
      onTapDown: (_) {
        setState(() {
          _isExpensesPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isExpensesPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isExpensesPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: double.infinity,
        height: sw * 0.45,
        decoration: BoxDecoration(
          boxShadow: _isExpensesPressed
              ? []
              : [
            BoxShadow(
                color: Color(0xffBFBFBF)
            )
          ],
          borderRadius: BorderRadius.circular(30.0),
        ),
        transform: Matrix4.translationValues(0, _isExpensesPressed ? 5 : 0, 0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: sw * 0.424,
                height: sw * 0.43,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 1,
                      spreadRadius: 2,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: sw * 0.05, vertical: sw * 0.06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: sw * 0.1,
                          height: sw * 0.1,
                          decoration: BoxDecoration(
                            color: Color(0xffC7997B),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: sw * 0.3,
                                  height: sw * 0.09,
                                  decoration: BoxDecoration(
                                    color: Color(0xffFBC29C),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xffFBC29C),
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(0, -1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₱${formatter.format(expenses)}',
                              style: TextStyle(
                                fontSize: fs * 0.04,
                                color: Color(0xff080C1A),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter Regular',
                              ),
                            ),
                            Text(
                              'Expenses',
                              style: TextStyle(
                                fontSize: fs * 0.033,
                                color: Color(0xffC68051),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Inter Regular',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetBox() {
    double progress = 5000 /
        10000; // Ensure the progress is within a reasonable range (between 0 and 1)
    double sw = MediaQuery
        .of(context)
        .size
        .width;
    double fs = sw;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BudgetScreen()),
        );
      },
      onTapDown: (_) {
        setState(() {
          _isBudgetPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isBudgetPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isBudgetPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        height: 2 * (sw * 0.45) + 10,
        decoration: BoxDecoration(
          color: Color(0xffBFBFBF),
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0,
                  _isBudgetPressed ? 2 : 4), // Adjust the offset when pressed
            ),
          ],
        ),
        transform: Matrix4.translationValues(0, _isBudgetPressed ? 5 : 0, 0),
        // Moves the box down when pressed
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 2 * (sw * 0.435) + 10,
                width: sw * 0.42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: sw * 0.1),
                    SizedBox(
                      height: sw * 0.6,
                      width: 10,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: Color(0xffFFCDAC),
                          color: Color(0xffFE5D26),
                        ),
                      ),
                    ),
                    SizedBox(height: sw * 0.07),
                    Text(
                      "Budget",
                      style: TextStyle(
                        fontFamily: 'Inter Regular',
                        fontSize: fs * 0.04,
                        color: Color(0xffF4A26B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _recentTransactionBox() {
    double sw = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffABC5EA),
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 3,
          )
        ],
      ),


      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: sw * 0.04, horizontal: sw * 0.05),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'RECENT TRANSACTION',
                style: TextStyle(
                  color: Color(0xff202828),
                  fontSize: sw * 0.055,
                  fontFamily: 'Inter Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Column(
              children: trackerData.map((track) {
                return TransactionList(track: track);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}