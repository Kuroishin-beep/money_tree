import 'package:flutter/material.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'package:money_tree/views/transaction_history/history_screen.dart';
import 'package:money_tree/views/financial_report/monthlyFR_screen.dart';
import 'package:money_tree/views/settings/settings_screen.dart';

import '../../bottom_navigation.dart';
import '../../fab.dart';

class NewExpenseScreen extends StatefulWidget {
  const NewExpenseScreen({super.key});

  @override
  State<NewExpenseScreen> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;


    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'ADD TRANSACTION',
            style: TextStyle(
                color: Color(0XFFF4A26B),
                fontFamily: 'Inter Regular',
                fontWeight: FontWeight.w800
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
            icon: const Icon(Icons.arrow_back, color: Color(0XFFF4A26B)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            },
          )
      ),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffFFFFFF),
                  Color(0xffFFF5E4),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: sw * 0.01, horizontal: sw * 0.05),
              child: Column(
                children: [
                  Column(
                    children: [

                      // OPTIONS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // First Column for "NEW INCOME"
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const NewIncomeScreen()
                                      )
                                  );
                                },
                                child: Text(
                                  "NEW INCOME",
                                  style: TextStyle(
                                    fontSize: fs * 0.04,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sw * 0.3,
                                child: const Divider(
                                  color: Color(0xFF093F40),
                                  thickness: 1.0,
                                ),
                              ),
                            ],
                          ),

                          // Second Column for "NEW EXPENSE"
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const NewExpenseScreen()
                                      )
                                  );
                                },
                                child: Text(
                                  "NEW EXPENSES",
                                  style: TextStyle(
                                    fontSize: fs * 0.04,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sw * 0.3,
                                child: const Divider(
                                  color: Color(0xFF093F40),
                                  thickness: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Amount Textfield
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: sw * 0.1),
                            child: Container(
                                width: sw * 0.17,
                                height: sw * 0.08,
                                decoration: BoxDecoration(
                                    color: const Color(0xffFFF8ED),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 4)
                                      )
                                    ]
                                ),
                                child: Center(
                                  child: Text(
                                    'Php',
                                    style: TextStyle(
                                        color: const Color(0xffF4A26B),
                                        fontWeight: FontWeight.w700,
                                        fontSize: fs * 0.04
                                    ),
                                  ),
                                )
                            ),
                          ),
                          SizedBox(width: sw * 0.05),
                          Expanded(
                            child: _editAmount(sw, fs),
                          ),
                        ],
                      ),

                      // Item Textfield
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: sw * 0.1),
                            child: _iconField(sw, fs, Icons.question_mark),
                          ),
                          SizedBox(width: sw * 0.06),
                          _editItem(sw, fs)
                        ],
                      ),

                      SizedBox(height: sw * 0.05),

                      // Date Textfield
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: sw * 0.1),
                            child: _iconField(sw, fs, Icons.calendar_today_rounded),
                          ),
                          SizedBox(width: sw * 0.06),
                          _editDate(sw, fs)
                        ],
                      ),

                      SizedBox(height: sw * 0.05),

                      // From which account
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('From account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 17)),
                      ),

                      // Account Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _fromCashButton(sw, fs),
                          _fromCardButton(sw, fs),
                          _fromGCashButton(sw, fs)
                        ],
                      ),

                      SizedBox(height: sw * 0.05),

                      // From which category
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('From category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 17)),
                      ),

                      // Category Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _schoolCatButton(sw, fs),
                          _carCatButton(sw, fs),
                          _healthCatButton(sw, fs),
                        ],
                      ),
                      SizedBox(height: sw * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _groceryCatButton(sw, fs),
                          _addCatButton(sw, fs)
                        ],
                      ),

                      SizedBox(height: sw * 0.05),

                      // Confirm Button
                      _confirmButton(sw, fs)


                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),

      // FAB
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //Navigation bar
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
            dashboard: Colors.white,
            fReport: Colors.white,
            history: Colors.white,
            settings: Colors.white
        ),
      ),
    );
  }


  Widget _editAmount(double sw, double fs) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontSize: fs * 0.12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter Regular',
          letterSpacing: 2.0
      ),
      decoration: const InputDecoration(
        filled: false,

        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none
        ),
      ),
    );
  }

  Widget _editItem(double sw, double fs) {
    return SizedBox(
      width: sw * 0.5,
      child: TextField(
        style: TextStyle(
            fontSize: fs * 0.05,
            fontWeight: FontWeight.w700
        ),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _editDate(double sw, double fs) {
    return SizedBox(
      width: sw * 0.5,
      child: TextField(
        style: TextStyle(
            fontSize: fs * 0.05,
            fontWeight: FontWeight.w700
        ),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconField(double sw, double fs, IconData icon) {
    return Container(
      width: sw * 0.12,
      height: sw * 0.12,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffCE895A)
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: sw * 0.095,
              height: sw * 0.095,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffF4A26B),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xffF4A26B),
                        blurRadius: 2,
                        spreadRadius: 4
                    )
                  ]
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _fromCashButton(double sw, double fs) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFAF3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Text(
        'CASH',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: sw * 0.05),
      ),
    );
  }

  Widget _fromCardButton(double sw, double fs) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFAF3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Text(
        'CARD',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: sw * 0.05),
      ),
    );
  }

  Widget _fromGCashButton(double sw, double fs) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFAF3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Text(
        'GCASH',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: sw * 0.05),
      ),
    );
  }

  Widget _schoolCatButton(double sw, double fs) {
    return Container(
        width: sw * 0.25,
        height: sw * 0.25,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffCE895A)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffF4A26B),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF4A26B),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.backpack, size: 70.0),
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _carCatButton(double sw, double fs) {
    return Container(
        width: sw * 0.25,
        height: sw * 0.25,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffCE895A)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffF4A26B),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF4A26B),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.directions_car_sharp, size: 70.0),
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _healthCatButton(double sw, double fs) {
    return Container(
        width: sw * 0.25,
        height: sw * 0.25,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffCE895A)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffF4A26B),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF4A26B),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.local_hospital, size: 70.0),
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _groceryCatButton(double sw, double fs) {
    return Container(
        width: sw * 0.25,
        height: sw * 0.25,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffCE895A)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffF4A26B),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF4A26B),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.shopping_bag_outlined, size: 70.0),
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _addCatButton(double sw, double fs) {
    return Container(
        width: sw * 0.25,
        height: sw * 0.25,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffCE895A)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffF4A26B),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF4A26B),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 70.0),
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
    );
  }

  Widget _confirmButton(double sw, double fs) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFAF3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Text(
        'CONFIRM',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: sw * 0.05),
      ),
    );
  }
}
