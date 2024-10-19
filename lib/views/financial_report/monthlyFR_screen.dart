import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  User? user = FirebaseAuth.instance.currentUser ;
  String financialAdvice = "Your financial advice will appear here.";

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndExpenses();
    fetchIncomes();
    fetchFinancialAdvice();
  }

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
          .where('User Email', isEqualTo: user!.email)
          .get();

      Map<String, double> tempExpenses = {};
      for (var categoryDoc in categorySnapshot.docs) {
        List<dynamic> categoryList = categoryDoc['categoriesArray'];
        for (var category in categoryList) {
          QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
              .collection('expenses')
              .where('category', isEqualTo: category)
              .where('User Email', isEqualTo: user!.email)
              .get();

          double totalAmount = 0.0;
          for (var expenseDoc in expenseSnapshot.docs) {
            totalAmount += expenseDoc['amount'];
          }

          tempExpenses[category] = totalAmount;
        }
      }

      if (mounted) {
        setState(() {
          expenses = tempExpenses;
        });
      }
    } catch (e) {
      showError('Error fetching categories or expenses: $e');
    }
  }

  Future<void> fetchIncomes() async {
    try {
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('income')
          .where('User Email', isEqualTo: user!.email)
          .get();

      Map<String, double> tempIncomes = {'CASH': 0, 'CARD': 0, 'GCASH': 0};

      for (var incomeDoc in incomeSnapshot.docs) {
        String accountType = incomeDoc['accounts'];
        double amount = incomeDoc['amount'];

        if (tempIncomes.containsKey(accountType)) {
          tempIncomes[accountType] = tempIncomes[accountType]! + amount;
        }
      }

      if (mounted) {
        setState(() {
          incomes = tempIncomes;
        });
      }
    } catch (e) {
      showError('Error fetching incomes: $e');
    }
  }

  Future<void> fetchFinancialAdvice() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/predict'), // Adjust the URL as needed
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'income': 5000,
          'expenses': 4000,
          'budget': 600,
          'savings': 500,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            financialAdvice = jsonDecode(response.body)['financial_advice'];
          });
        }
      } else {
        showError('Failed to fetch financial advice.');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          financialAdvice = "Error: ${e.toString()}";
        });
      }
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color (0xffFFF8ED),
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
              padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sw * 0.01),
              child: Column(
                children: [
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  Text(
                    financialAdvice,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
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