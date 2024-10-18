import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../bottom_navigation.dart';
import '../../fab.dart';

class MonthlyReport extends StatefulWidget {
  const MonthlyReport({super.key});

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  Map<String, double> expenses = {};
  Map<String, double> incomes = {
    'CASH': 0,
    'CARD': 0,
    'GCASH': 0,
  };
  User? user = FirebaseAuth.instance.currentUser;
  String financialAdvice = "Your financial advice will appear here.";
  List<double> forecastedExpenses = []; // Placeholder for forecasted expenses

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndExpenses();
    fetchIncomes();
  }

  // Function to generate shades of a base color
  List<Color> getShades(Color baseColor, int length) {
    return List<Color>.generate(length, (index) {
      double shadeFactor = 1 - (index * 0.1);
      return baseColor.withOpacity(shadeFactor.clamp(0.4, 1.0));
    });
  }

  Future<void> fetchCategoriesAndExpenses() async {
    try {
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      Map<String, double> tempExpenses = {};
      for (var categoryDoc in categorySnapshot.docs) {
        List<dynamic> categoryList = categoryDoc['categoriesArray'];
        for (var category in categoryList) {
          QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
              .collection('expenses')
              .where('category', isEqualTo: category)
              .where('UserEmail', isEqualTo: user!.email)
              .get();

          double totalAmount = 0.0;
          for (var expenseDoc in expenseSnapshot.docs) {
            totalAmount += expenseDoc['amount'];
          }

          tempExpenses[category] = totalAmount;
        }
      }

      setState(() {
        expenses = tempExpenses;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching categories or expenses: $e')),
      );
    }
  }

  Future<void> fetchIncomes() async {
    try {
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('income')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      Map<String, double> tempIncomes = {
        'CASH': 0,
        'CARD': 0,
        'GCASH': 0,
      };

      for (var incomeDoc in incomeSnapshot.docs) {
        String accountType = incomeDoc['accounts'];
        double amount = incomeDoc['amount'];

        if (tempIncomes.containsKey(accountType)) {
          tempIncomes[accountType] = tempIncomes[accountType]! + amount;
        }
      }

      setState(() {
        incomes = tempIncomes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching incomes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    double fs = sw;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF8ED),
        title: const Text(
          'FINANCIAL REPORT',
          style: TextStyle(
            color: Color(0XFF639DF0),
            fontFamily: 'Inter Regular',
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
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
                  // Pie Chart for Expenses
                  expenses.isNotEmpty
                      ? PieChart(
                    dataMap: expenses,
                    chartRadius: sw / 1.7,
                    colorList: getShades(Colors.red, expenses.length),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),

                  SizedBox(height: 20),

                  // Pie Chart for Incomes (CASH, CARD, GCASH)
                  incomes.isNotEmpty
                      ? PieChart(
                    dataMap: incomes,
                    chartRadius: sw / 1.7,
                    colorList: const [
                      Color(0xff03045E),
                      Color(0xffA0A0DE),
                      Color(0xffE9E9F6),
                    ],
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),

                  SizedBox(height: sw * 0.05),

                  // Financial Advice Section
                  FinancialAdviceSection(
                    financialAdvice: financialAdvice,
                    forecastedExpenses: forecastedExpenses,
                    fontSize: fs,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Navigation bar
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
          dashboard: Colors.white,
          fReport: Color(0xffFE5D26),
          history: Colors.white,
          settings: Colors.white,
        ),
      ),
    );
  }
}

class FinancialAdviceSection extends StatelessWidget {
  final String financialAdvice;
  final List<double> forecastedExpenses;
  final double fontSize;

  const FinancialAdviceSection({
    Key? key,
    required this.financialAdvice,
    required this.forecastedExpenses,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: const Color(0xffFFF8ED),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 6,
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FINANCIAL ADVICE',
            style: TextStyle(
              color: const Color(0xff9A9BEB),
              fontWeight: FontWeight.w800,
              fontSize: fontSize * 0.05,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            financialAdvice,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize * 0.04,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Forecasted Expenses: ${forecastedExpenses.join(", ")}',
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize * 0.04,
            ),
          ),
        ],
      ),
    );
  }
}
