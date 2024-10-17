import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tree/models/tracker_model.dart';
import 'package:money_tree/views/constants/build_transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:money_tree/views/budget/budget_screen.dart';
import 'package:money_tree/views/income/income_screen.dart';
import 'package:money_tree/views/expenses/expenses_screen.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import '../../bottom_navigation.dart';
import '../../controller/tracker_controller.dart';
import '../../fab.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  // get current user
  User? user = FirebaseAuth.instance.currentUser;

  // for calculations
  double? totalIncome = 0;
  double? totalExpenses = 0;
  double? balance = 0;
  double? totalCash = 0;
  double? totalCard = 0;
  double? totalGCash = 0;
  double? totalBudget = 0;
  double? totalSavings = 0;
  double? budgetAmount = 0;
  double? savingsAmount = 0;


  @override
  void initState() {
    super.initState();
    fetchData();
    _getUserNameAndProfileImage();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('incomes')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      QuerySnapshot budgetSnapshot = await FirebaseFirestore.instance
          .collection('budgets')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      QuerySnapshot savingsSnapshot = await FirebaseFirestore.instance
          .collection('savings')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      double totalIncomeTemp = 0;
      double totalExpensesTemp = 0;
      double incomeCashTemp = 0;
      double incomeCardTemp = 0;
      double incomeGCashTemp = 0;
      double expenseCashTemp = 0;
      double expenseCardTemp = 0;
      double expenseGCashTemp = 0;
      double totalBudgetTemp = 0;
      double totalSavingsTemp = 0;
      double budgetTemp = 0;
      double savingsTemp = 0;


      // Calculate total income
      if (incomeSnapshot.docs.isNotEmpty) {
        for (var doc in incomeSnapshot.docs) {
          totalIncomeTemp += doc['amount'];

          if (doc['account'] == 'CASH') {
            incomeCashTemp += doc['amount'];
          } else if (doc['account'] == 'CARD') {
            incomeCardTemp += doc['amount'];
          } else if (doc['account'] == 'GCASH') {
            incomeGCashTemp += doc['amount'];
          }
        }
      }

      // Calculate total expenses
      if (expenseSnapshot.docs.isNotEmpty) {
        for (var doc in expenseSnapshot.docs) {
          totalExpensesTemp += doc['amount'];

          if (doc['account'] == 'CASH') {
            expenseCashTemp += doc['amount'];
          } else if (doc['account'] == 'CARD') {
            expenseCardTemp += doc['amount'];
          } else if (doc['account'] == 'GCASH') {
            expenseGCashTemp += doc['amount'];
          }
        }
      }

      // Calculate total budget
      if (budgetSnapshot.docs.isNotEmpty) {
        for (var doc in budgetSnapshot.docs) {
          totalBudgetTemp += doc['totalBudgetAmount'];
          budgetTemp += doc['budgetAmount'];
        }
      }

      // Calculate total savings
      if (savingsSnapshot.docs.isNotEmpty) {
        for (var doc in savingsSnapshot.docs) {
          totalSavingsTemp += doc['totalSavingsAmount'];
          savingsTemp += doc['savingsAmount'];
        }
      }

      // Update state with totals
      setState(() {
        totalIncome = totalIncomeTemp;
        totalExpenses = totalExpensesTemp;
        balance = totalIncome! - totalExpenses!;

        totalCash = incomeCashTemp - expenseCashTemp;
        totalCard = incomeCardTemp - expenseCardTemp;
        totalGCash = incomeGCashTemp - expenseGCashTemp;

        totalBudget = totalBudgetTemp;
        totalSavings = totalSavingsTemp;
        budgetAmount = budgetTemp;
        savingsAmount = savingsTemp;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }


  String? _userName = '';
  String? _profileImage;


  // Get user name and profile image
  Future<void> _getUserNameAndProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the user is authenticated with Google
      if (user.photoURL != null) {
        setState(() {
          _profileImage = user.photoURL; // Use the Google profile image
          _userName = user.displayName ?? 'User'; // Use display name if available
        });
      } else {
        // If not using Google account, retrieve from Firestore
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          _profileImage = userData['profileImage']; // Get profile image URL from Firestore
          _userName = userData['firstName']; // Assuming firstName is stored in Firestore
        });
      }
    }
  }

  // Number format
  final NumberFormat formatter = NumberFormat('#,###.##');


  // Get current month as a string
  String _getCurrentMonth() {
    return DateFormat('MMMM').format(DateTime.now());
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
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
                      'Hello, ${_userName ?? 'User'}!',
                      style: TextStyle(
                        color: const Color(0xff020202),
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
                      _accountSummaryBox(),

                      // Profile Picture
                      Positioned(
                        top: -(sw * 0.2 + 14),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xffABC5EA),
                                width: 4.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xff8296B2).withOpacity(0.3),
                                    spreadRadius: 4,
                                    blurRadius: 5
                                )
                              ]
                          ),
                          child: CircleAvatar(
                            radius: sw * 0.12,
                            backgroundImage: _profileImage != null 
                              ? NetworkImage(_profileImage!) // Use NetworkImage for the URL from Firestore
                              : const AssetImage('lib/images/pfp.jpg') as ImageProvider, // Fallback image
                          ),
                        ),
                      )

                    ],
                  ),

                  SizedBox(height: sw * 0.07),

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
                        _getCurrentMonth(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: fs * 0.04,
                            fontWeight: FontWeight.w500
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

                  SizedBox(height: sw * 0.07),

                  //Income, Expenses, Budget Sections
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [

                        //Income and Expenses
                        Expanded(
                            flex: 3,
                            child: Column(
                              children: [

                                // Income Section
                                _incomeBox(totalIncome!),

                                SizedBox(height: sw * 0.03),

                                // Expenses Section
                                _expensesBox(totalExpenses!)
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

  Widget _accountSummaryBox() {
    double sw = MediaQuery
        .of(context)
        .size
        .width;
    double fs = sw;

    return Container(
      width: double.infinity,
      height: sw * 0.35,
      decoration: BoxDecoration(
        color: const Color(0xff8296B2),
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
                color: const Color(0xffABC5EA),
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: const [
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
                              color: const Color(0xffFFF5E4),
                              fontFamily: 'Inter Regular',
                              fontWeight: FontWeight.w800,
                              fontSize: fs * 0.05,
                            ),
                          ),
                        ),

                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            '₱${formatter.format(balance!)}',
                            style: TextStyle(
                                color: const Color(0xffFFF5E4),
                                fontFamily: 'Inter Regular',
                                fontWeight: FontWeight.w800,
                                fontSize: fs * 0.05,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ),

                      ],
                    ),

                    const Divider(
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
                              color: const Color(0xffFFF5E4),
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
                            '₱${formatter.format(totalCash)}',
                            style: TextStyle(
                                fontSize: fs * 0.038,
                                color: const Color(0xffFFF5E4),
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
                              color: const Color(0xffFFF5E4),
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
                            '₱${formatter.format(totalCard)}',
                            style: TextStyle(
                                fontSize: fs * 0.038,
                                color: const Color(0xffFFF5E4),
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
                              color: const Color(0xffFFF5E4),
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
                            '₱${formatter.format(totalGCash)}',
                            style: TextStyle(
                                fontSize: fs * 0.038,
                                color: const Color(0xffFFF5E4),
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
            MaterialPageRoute(builder: (context) => const IncomeScreen()));
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
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        height: sw * 0.45,
        decoration: BoxDecoration(
          boxShadow: _isIncomePressed
              ? []
              : [
            const BoxShadow(
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
                  boxShadow: const [
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
                          decoration: const BoxDecoration(
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
                                  decoration: const BoxDecoration(
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
                                color: const Color(0xff080C1A),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter Regular',
                              ),
                            ),
                            Text(
                              'Income',
                              style: TextStyle(
                                fontSize: fs * 0.033,
                                color: const Color(0xff65AD53),
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
            context, MaterialPageRoute(builder: (context) => const ExpensesScreen()));
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
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        height: sw * 0.45,
        decoration: BoxDecoration(
          boxShadow: _isExpensesPressed
              ? []
              : [
            const BoxShadow(
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
                  boxShadow: const [
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
                          decoration: const BoxDecoration(
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
                                  decoration: const BoxDecoration(
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
                              '₱${formatter.format(expenses ?? 0)}',
                              style: TextStyle(
                                fontSize: fs * 0.04,
                                color: const Color(0xff080C1A),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter Regular',
                              ),
                            ),
                            Text(
                              'Expenses',
                              style: TextStyle(
                                fontSize: fs * 0.033,
                                color: const Color(0xffC68051),
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
    double progress = budgetAmount! / totalBudget!;
    double sw = MediaQuery
        .of(context)
        .size
        .width;
    double fs = sw;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BudgetScreen()),
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
        duration: const Duration(milliseconds: 100),
        height: 2 * (sw * 0.45) + 10,
        decoration: BoxDecoration(
          color: const Color(0xffBFBFBF),
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
                  boxShadow: const [
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
                          backgroundColor: const Color(0xffFFCDAC),
                          color: const Color(0xffFE5D26),
                        ),
                      ),
                    ),
                    SizedBox(height: sw * 0.07),
                    Text(
                      "Budget",
                      style: TextStyle(
                        fontFamily: 'Inter Regular',
                        fontSize: fs * 0.04,
                        color: const Color(0xffF4A26B),
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
        color: const Color(0xffABC5EA),
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
                  color: const Color(0xff202828),
                  fontSize: sw * 0.055,
                  fontFamily: 'Inter Regular',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),



            StreamBuilder<List<QuerySnapshot>>(
              stream: CombineLatestStream.list([
                firestoreService.getExpenseStream(),
                firestoreService.getIncomeStream(),
              ]),
              builder: (context, snapshot) {
                // Check for errors
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // Check if the data is available and contains documents
                if (!snapshot.hasData ||
                    (snapshot.data![0].docs.isEmpty && snapshot.data![1].docs.isEmpty)) {
                  return Center(child: Text('No transactions found.'));
                }

                // Combine documents from both streams
                var docs = [...snapshot.data![0].docs, ...snapshot.data![1].docs];

                // Sort the combined documents by date in descending order (newest first)
                docs.sort((a, b) {
                  final dateA = (a['date'] as Timestamp).toDate();
                  final dateB = (b['date'] as Timestamp).toDate();
                  return dateB.compareTo(dateA); // Sort by date descending
                });

                // Limit to the latest 5 transactions
                var limitedDocs = docs.take(5).toList();

                // Calculate income and expenses here
                //_calculateTotals(limitedDocs);

                // Display the sorted and limited list
                return Column(
                  children: limitedDocs.map((doc) {
                    // Convert each document to Tracker class model
                    final track = Tracker(
                      name: doc['name'],
                      category: doc['category'],
                      account: doc['account'],
                      amount: double.tryParse(doc['amount'].toString()) ?? 0.0,
                      type: doc['type'],
                      date: (doc['date'] as Timestamp).toDate(),
                      icon: doc['icon'], // Retrieve icon if necessary
                    );

                    // Format the date
                    String formattedDate = DateFormat('MMMM d, y').format(track.date!);

                    return TransactionList(
                      track: track,
                      formattedDate: formattedDate,
                      docID: doc.id,
                    );
                  }).toList(),
                );
              },
            ),




          ],
        ),
      ),
    );
  }
}