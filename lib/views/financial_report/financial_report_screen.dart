import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../account_details/account_screen.dart';
import '../constants/bottom_navigation.dart';
import '../constants/fab.dart';
import '../dashboard/dashboard_screen.dart';

class FinancialReport extends StatefulWidget {
  const FinancialReport({super.key});

  @override
  State<FinancialReport> createState() => _FinancialReportState();
}

class _FinancialReportState extends State<FinancialReport> {
  Map<String, double> expenses = {};
  Map<String, double> incomes = {};
  User? user = FirebaseAuth.instance.currentUser;
  String financialAdvice = "Your financial advice will appear here.";
  List<double> forecastedExpenses = [];

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndExpenses();
    fetchIncomes();
    fetchFinancialAdvice();
    _getUserProfileImage();
  }

  // get color
  List<Color> getShades(Color baseColor, int length) {
    return List<Color>.generate(length, (index) {
      double shadeFactor = 1 - (index * 0.3);
      return baseColor.withOpacity(shadeFactor.clamp(0.4, 1.0));
    });
  }

  // get expenses and categories
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
      print('Error fetching categories or expenses: $e');
    }
  }

  // get incomes
  Future<void> fetchIncomes() async {
    try {
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('incomes')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      Map<String, double> tempIncomes = {};

      for (var doc in incomeSnapshot.docs) {
        String income = doc['account'];
        double amount = doc['amount'].toDouble();
        tempIncomes[income] = (tempIncomes[income] ?? 0) + amount;
      }

      setState(() {
        incomes = tempIncomes;
      });

    } catch (e) {
      print('Error fetching incomes: $e');
    }
  }

  // get financial advice
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

  String? _profileImage;

  // Get user profile image
  Future<void> _getUserProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the user is authenticated with Google
      if (user.photoURL != null) {
        setState(() {
          _profileImage = user.photoURL;
        });
      } else {
        // If not using Google account, retrieve profile image from Firestore
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          _profileImage = userData['profileImage'];
        });
      }
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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
            child: CircleAvatar(
              backgroundImage: _profileImage != null
                  ? NetworkImage(_profileImage!)
                  : const AssetImage('lib/images/pfp.jpg') as ImageProvider,
              radius: 20,
            ),
          ),
          SizedBox(width: 16),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0XFF639DF0)),
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

          // Main Body
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
                    colorList: getShades(Colors.pinkAccent, expenses.length),
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
