import 'package:flutter/material.dart';
import 'package:money_tree/add_transaction/new_income.dart';
import 'package:money_tree/dashboard/dashboard.dart';
import 'package:money_tree/history/history.dart';
import 'package:money_tree/settings/settings.dart';
import 'package:pie_chart/pie_chart.dart';
import 'weekly.dart';
import 'yearly.dart';

class MonthlyReport extends StatefulWidget {

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  Map<String, double> expenses = {
    "CAR": 5,
    "SCHOOL": 2,
    "HOUSE": 3,
    "GROCERY": 2
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
                begin: Alignment.topCenter,
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
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Inter Regular',
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
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Inter Regular',
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

                  SizedBox(height: sw * 0.1),

                  //INCOME & EXPENSES Bar Chart
                  ProgressBar(
                    progress1: 200,
                    progress2: 270,
                  ),

                  SizedBox(height: sw * 0.1),

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
                    height: sw * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Color(0xffFFF8ED),
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

// Class for Progress Bar
class ProgressBar extends StatelessWidget {
  final double progress1;
  final double progress2;

  ProgressBar({
    required this.progress1,
    required this.progress2,

  });

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    // for font size
    double fs = sw;

    return Column(
      children: [
        Container(
            width: sw * 0.8,
            height: sw * 0.09,
            decoration: BoxDecoration(
              color: Color(0xffE6BFCE),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: progress1,
                height: sw * 0.8,
                decoration: BoxDecoration(
                  color: Color(0xff9A386B),
                  borderRadius: BorderRadius.circular(20.0)
                ),
              )
            )
        ),

        SizedBox(height: sw * 0.02),

        Container(
          width: sw * 0.8,
          height: sw * 0.09,
          decoration: BoxDecoration(
            color: Color(0xffC8C9E9),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child:Align(
            alignment: Alignment.centerLeft,
            child: Container(
                width: progress2,
                height: sw * 0.8,
                decoration: BoxDecoration(
                    color: Color(0xff03045E),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.02),
                  child: Text(
                    'INCOME ${progress2-200} %',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                )
            ),
          ),
        )
      ],
    );
  }
}

