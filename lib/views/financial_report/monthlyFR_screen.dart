import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../bottom_navigation.dart';
import '../../fab.dart';

class MonthlyReport extends StatefulWidget {
  const MonthlyReport({super.key});

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  Map<String, double> expenses = {};
  Map<String, double> incomes = {'CASH': 0, 'CARD': 0, 'GCASH': 0};
  User? user = FirebaseAuth.instance.currentUser;
  String financialAdvice = "Your financial advice will appear here.";
  List<double> forecastedExpenses = [];

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndExpenses();
    fetchIncomes();
    fetchFinancialAdvice();
  }

  Future<void> fetchCategoriesAndExpenses() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: user?.uid)
          .get();

      Map<String, double> fetchedExpenses = {};
      for (var doc in snapshot.docs) {
        String category = doc['category'];
        double amount = doc['amount'].toDouble();
        fetchedExpenses[category] =
            (fetchedExpenses[category] ?? 0) + amount;
      }

      setState(() {
        expenses = fetchedExpenses;
      });
    } catch (e) {
      print('Error fetching expenses: $e');
    }
  }

  Future<void> fetchIncomes() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('incomes')
          .where('userId', isEqualTo: user?.uid)
          .get();

      Map<String, double> fetchedIncomes = {'CASH': 0, 'CARD': 0, 'GCASH': 0};
      for (var doc in snapshot.docs) {
        String type = doc['type'];
        double amount = doc['amount'].toDouble();
        fetchedIncomes[type] = (fetchedIncomes[type] ?? 0) + amount;
      }

      setState(() {
        incomes = fetchedIncomes;
      });
    } catch (e) {
      print('Error fetching incomes: $e');
    }
  }

  List<Color> getShades(Color baseColor, int count) {
    List<Color> shades = [];
    for (int i = 0; i < count; i++) {
      shades.add(baseColor.withOpacity(1 - (i * 0.1)));
    }
    return shades;
  }

  Future<void> fetchFinancialAdvice() async {
    try {
      double totalIncome = incomes.values.reduce((a, b) => a + b);
      double totalExpenses = expenses.values.reduce((a, b) => a + b);
      double savings = totalIncome - totalExpenses;

      final response = await http.post(
        Uri.parse('http://localhost:8000/financial_predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'income': totalIncome,
          'expenses': totalExpenses,
          'budget': totalExpenses,
          'savings': savings,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          financialAdvice = data['financial_advice'];
          forecastedExpenses = List<double>.from(data['forecasted_expenses']);
        });
      } else {
        throw Exception('Failed to load financial advice');
      }
    } catch (e) {
      print('Error fetching financial advice: $e');
      setState(() {
        financialAdvice = "Unable to fetch financial advice at this time.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

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
                colors: [Color(0xffFFF8ED), Color(0xffABC5EA)],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: sw * 0.04, vertical: sw * 0.01),
              child: Column(
                children: [
                  // Expenses Pie Chart
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

                  // Incomes Pie Chart
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
                    fontSize: sw,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
    super.key,
    required this.financialAdvice,
    required this.forecastedExpenses,
    required this.fontSize,
  });

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
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
          const SizedBox(height: 16.0),
          Text(
            financialAdvice,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize * 0.04,
            ),
          ),
          const SizedBox(height: 8.0),
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
