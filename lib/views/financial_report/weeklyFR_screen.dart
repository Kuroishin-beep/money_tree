import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math'; // To generate random colors

class MonthlyReport extends StatefulWidget {
  const MonthlyReport({super.key});

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  Map<String, double> expenses = {}; // Map to store expenses by category
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndExpenses(); // Fetch categories and their related expenses
  }

  // Function to generate random colors
  List<Color> getColorList(int length) {
    final Random random = Random();
    return List<Color>.generate(
      length,
          (index) => Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      ),
    );
  }

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
                    colorList: getColorList(expenses.length), // Dynamic color list
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValuesInPercentage: true,
                    ),
                  )
                      : const Center(child: CircularProgressIndicator()),

                  // You can add other sections here like progress bars or income pie charts
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
