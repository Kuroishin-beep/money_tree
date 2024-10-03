import 'package:flutter/material.dart';
import 'package:money_tree/add_transaction/new_income_screen.dart';
import 'package:money_tree/dashboard/dashboard_screen.dart';
import 'package:money_tree/history/history_screen.dart';
import 'package:money_tree/settings/settings_screen.dart';
import 'package:money_tree/financial_report/monthly_screen.dart';


class EditExpensesScreen extends StatefulWidget {
  @override
  State<EditExpensesScreen> createState() => _EditExpensesScreenState();
}

class _EditExpensesScreenState extends State<EditExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;


    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffFFF8ED),
          title: Text(
            'EDIT TRANSACTION',
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
              Navigator.pop(context);
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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: sw * 0.03, horizontal: sw * 0.05),
            child: Column(
              children: [
                Column(
                  children: [

                    // Text for EXPENSES
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xff093F40),
                            thickness: 1.3,
                            indent: 60.0,
                            endIndent: 10.0,
                          ),
                        ),
                        Text(
                          'EXPENSES',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: fs * 0.04,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xff093F40),
                            thickness: 1.3,
                            indent: 10.0,
                            endIndent: 60.0,
                          ),
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
                                  color: Color(0xffFFF8ED),
                                  borderRadius: BorderRadius.circular(20.0),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                        offset: Offset(0, 4)
                                    )
                                  ]
                              ),
                              child: Center(
                                child: Text(
                                  'Php',
                                  style: TextStyle(
                                      color: Color(0xff639DF0),
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
                    Align(
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
                    Align(
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
          )
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

  Widget _editAmount(double sw, double fs) {
    return TextField(
      style: TextStyle(
          color: Colors.black,
          fontSize: fs * 0.12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter Regular',
          letterSpacing: 2.0
      ),
      decoration: InputDecoration(
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
    return Container(
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
    return Container(
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
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff8586CB)
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: sw * 0.095,
              height: sw * 0.095,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff9A9BEB),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff9A9BEB),
                        blurRadius: 1,
                        spreadRadius: 3.9
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
        backgroundColor: Color(0xFFFAF3E0),
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
        backgroundColor: Color(0xFFFAF3E0),
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
        backgroundColor: Color(0xFFFAF3E0),
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
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff8586CB)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff9A9BEB),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff9A9BEB),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.backpack, size: 70.0),
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
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff8586CB)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff9A9BEB),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff9A9BEB),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.directions_car_sharp, size: 70.0),
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
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff8586CB)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff9A9BEB),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff9A9BEB),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.local_hospital, size: 70.0),
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
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff8586CB)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff9A9BEB),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff9A9BEB),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shopping_bag_outlined, size: 70.0),
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
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xff8586CB)
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: sw * 0.22,
                height: sw * 0.22,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff9A9BEB),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff9A9BEB),
                        blurRadius: 2,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add, size: 70.0),
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
        backgroundColor: Color(0xFFFAF3E0),
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
