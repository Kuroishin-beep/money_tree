import 'package:flutter/material.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'package:money_tree/views/transaction_history/history_screen.dart';
import 'package:money_tree/views/settings/settings_screen.dart';
import 'package:money_tree/views/budget/budget_screen.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../bottom_navigation.dart';
import '../../fab.dart';
import 'weeklyFR_screen.dart';
import 'monthlyFR_screen.dart';
import 'progress_bar.dart';

class YearlyReport extends StatefulWidget {

  @override
  State<YearlyReport> createState() => _YearlyReportState();
}

class _YearlyReportState extends State<YearlyReport> {
  Map<String, double> expenses = {
    "CAR": 5,
    "SCHOOL": 6,
    "HOUSE": 7,
    "GROCERY": 8
  };

  Map<String, double> income = {
    "CASH": 4,
    "GCASH": 2,
    "CARD": 3,
  };

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    // for font size
    double fs = sw;

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: AppBar(
          backgroundColor: Color(0xffFFF8ED),
          title: Text(
            'FINANCIAL REPORT',
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

      body: Stack(
        children: [
          // Gradient Background Container
          Container(
            width: double.infinity,
            height: double.infinity,
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
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sw * 0.01),
              child: Column(
                children: [
                  SizedBox(height: sw * 0.2),

                  // CATEGORIES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // WEEKLY button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WeeklyReport()),
                          );
                        },
                        child: Text(
                          'WEEKLY',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Inter Regular',
                            fontSize: fs * 0.04
                          ),
                        ),
                      ),

                      // MONTHLY button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MonthlyReport()),
                          );
                        },
                        child: Text(
                          'MONTHLY',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Inter Regular',
                            fontSize: fs * 0.04
                          ),
                        ),
                      ),

                      // YEARLY button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => YearlyReport()),
                          );
                        },
                        child: Text(
                          'YEARLY',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter Regular',
                            fontSize: fs * 0.04
                          ),
                        ),
                      ),
                    ],
                  ),

                  // EXPENSES Pie Chart
                  PieChart(
                    dataMap: expenses,
                    chartRadius: sw / 1.7,
                    colorList: [
                      Color(0xffCA498C),
                      Color(0xffCF9BBD),
                      Color(0xffE6BFCE),
                      Color(0xffFDE3DF),
                    ],
                    chartValuesOptions: ChartValuesOptions(),
                  ),

                  SizedBox(height: sw * 0.05),

                  //INCOME & EXPENSES Bar Chart
                  ProgressBar(progress1: 200, progress2: 270),

                  SizedBox(height: sw * 0.05),

                  // INCOME Pie Chart
                  PieChart(
                    dataMap: income,
                    chartRadius: sw / 1.7,
                    colorList: [
                      Color(0xff03045E),
                      Color(0xffA0A0DE),
                      Color(0xffE9E9F6),
                    ],
                    chartValuesOptions: ChartValuesOptions(),
                  ),

                  SizedBox(height: sw * 0.05),

                  // Financial Advice Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Color(0xffFFF8ED),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 6,
                              blurRadius: 10
                          )
                        ]
                    ),

                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.07),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'FINANCIAL ADVICE',
                              style: TextStyle(
                                  color: Color(0xff9A9BEB),
                                  fontWeight: FontWeight.w700,
                                  fontSize: fs * 0.05
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: sw * 0.2),

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
            fReport: Color(0xffFE5D26),
            history: Colors.white,
            settings: Colors.white
        ),
      ),
    );
  }
}

