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

  Map<String, double> expenses = {}; // Map to store expenses by category
  Map<String, double> incomes = {
    'CASH': 0,
    'CARD': 0,
    'GCASH': 0,
  }; // Map to store incomes for CASH, CARD, and GCASH
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndExpenses(); // Fetch categories and their related expenses
    fetchIncomes(); // Fetch incomes
  }

  // Function to generate shades of a base color
  List<Color> getShades(Color baseColor, int length) {
    return List<Color>.generate(length, (index) {
      // Generate shades by adjusting the opacity or brightness of the base color
      double shadeFactor = 1 - (index * 0.1); // Adjust the shade factor for each iteration
      return baseColor.withOpacity(shadeFactor.clamp(0.4, 1.0)); // Ensure opacity stays between 0.4 and 1.0
    });
  }

  // Function to fetch categories and their corresponding expenses
  Future<void> fetchCategoriesAndExpenses() async {
    try {
      // Fetch categories from Firestore where UserEmail matches the current user's email
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      // Temporary map to store fetched expenses
      Map<String, double> tempExpenses = {};

      // Loop through each document (each category)
      for (var categoryDoc in categorySnapshot.docs) {
        List<dynamic> categoryList = categoryDoc['categoriesArray'];

        // Loop through each category in the categoriesArray
        for (var category in categoryList) {
          // Fetch expenses for the given category
          QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
              .collection('expenses')
              .where('category', isEqualTo: category)
              .where('UserEmail', isEqualTo: user!.email)
              .get();

          // Sum the total amount for the category
          double totalAmount = 0.0;
          for (var expenseDoc in expenseSnapshot.docs) {
            totalAmount += expenseDoc['amount'];
          }

          // Add the total expenses for this category to the temporary map
          tempExpenses[category] = totalAmount;
        }
      }

      // Update the state with the fetched data
      setState(() {
        expenses = tempExpenses;
      });
    } catch (e) {
      print('Error fetching categories or expenses: $e');
    }
  }

  // Function to fetch incomes (CASH, CARD, GCASH)
  Future<void> fetchIncomes() async {
    try {
      // Fetch income documents from Firestore
      QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
          .collection('income')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      // Temporary map to store income sums
      Map<String, double> tempIncomes = {
        'CASH': 0,
        'CARD': 0,
        'GCASH': 0,
      };

      // Sum the incomes for CASH, CARD, and GCASH
      for (var incomeDoc in incomeSnapshot.docs) {
        String accountType = incomeDoc['accounts'];


        if (accountType == incomeDoc['accounts']) {
          double amount = incomeDoc['amount'];

          if (tempIncomes.containsKey(accountType)) {
            tempIncomes[accountType] = tempIncomes[accountType]! + amount;
          }
        }
      }

      // Update the state with the fetched income data
      setState(() {
        incomes = tempIncomes;
      });
    } catch (e) {
      print('Error fetching incomes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    // for font size
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
                    dataMap: expenses, // Use dynamically fetched expenses data
                    chartRadius: sw / 1.7,
                    colorList: getShades(Colors.red, expenses.length), // Use shades of red
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),

                  SizedBox(height: 20),

                  // Pie Chart for Incomes (CASH, CARD, GCASH)
                  incomes.isNotEmpty
                      ? PieChart(
                    dataMap: incomes, // Use dynamically fetched incomes data
                    chartRadius: sw / 1.7,
                    colorList: const [
                       Color(0xff03045E),
                       Color(0xffA0A0DE),
                       Color(0xffE9E9F6),
                    ], // Use shades of blue
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),

                  SizedBox(height: sw * 0.05),

                  // Financial Advice Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: const Color(0xffFFF8ED),
                        boxShadow: const [
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
                                  color: const Color(0xff9A9BEB),
                                  fontWeight: FontWeight.w800,
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
          ),
        ],
      ),

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
