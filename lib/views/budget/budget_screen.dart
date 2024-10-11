import 'package:flutter/material.dart';
import 'package:money_tree/models/tracker_model.dart';
import '../../bottom_navigation.dart';
import '../../fab.dart';
import '../add_transaction/add_income_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../financial_report/monthlyFR_screen.dart';
import '../transaction_history/history_screen.dart';
import '../settings/settings_screen.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  List<Map<String, dynamic>> expenseCategories = [
    {"title": "SCHOOL", "amount": 100, "budget": 500},
    {"title": "CAR", "amount": 467, "budget": 500},
    {"title": "HEALTH", "amount": 156, "budget": 2000},
    {"title": "GROCERIES", "amount": 637, "budget": 1500},
  ];

  List<Map<String, dynamic>> incomeCategories = [
    {"title": "SCHOOL", "amount": 100, "budget": 500},
    {"title": "CAR", "amount": 467, "budget": 500},
    {"title": "HEALTH", "amount": 156, "budget": 2000},
    {"title": "GROCERIES", "amount": 637, "budget": 1500},
  ];

  // Instance of the model to use for icons
  final Tracker track = Tracker(name: '', amount: 0, type: 'income');

  double totalSavings = 4500; // Example total savings amount
  double totalBudget = 5000; // Example total budget for expenses

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffFBC29C),
          title: Text(
            'BUDGET',
            style: TextStyle(
                color: Colors.white,
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
            icon: Icon(Icons.arrow_back, color: Colors.white),
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
          // Gradient Background
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffffffff),
                      Color(0xffFFF5E4)
                    ]
                )
            ),
          ),

          // Main Body
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Month Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1.5, color: Colors.black54),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          _getCurrentMonth().toUpperCase(),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1.5, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  _buildBudgetSummaryCard(),
                  const SizedBox(height: 3),
                  _buildBudgetCategoryList("EXPENSES", expenseCategories, true),
                  const SizedBox(height: 64),
                  _buildSavingsSummaryCard(),
                  const SizedBox(height: 3),
                  _buildBudgetCategoryList("INCOME", incomeCategories, false),
                ],
              ),
            ),
          ),
        ],
      ),

      // Navigation bar
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //FAB
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
            dashboard: Color(0xffFE5D26),
            fReport: Colors.white,
            history: Colors.white,
            settings: Colors.white
        ),
      ),
    );
  }

  // TODO: turn this widget into another dart file to be called by other screens
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFBC29C),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text(
                  "BUDGET",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xffE63636)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("lib/images/pfp.jpg"),
            ),
          ),
        ],
      ),
    );
  }


  // changed the color of linear progress indicator
  // Build the Budget Summary Card
  Widget _buildBudgetSummaryCard() {
    double spentAmount = expenseCategories.fold(0, (sum, category) => sum + category["amount"]);
    double progress = spentAmount / totalBudget;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 8),

            const Text(
              "Budget",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              "\$${spentAmount.toStringAsFixed(2)} of \$${totalBudget.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Progress bar
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0), // value is between 0 and 1
              backgroundColor: Color(0xffFFCDAC),
              color: Color(0xffFE5D26),
            ),
          ],
        ),
      ),
    );
  }

  // changed the color of linear progress indicator
  Widget _buildSavingsSummaryCard() {
    double progress = totalSavings / 10000; // Example goal for savings

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Savings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("\$${totalSavings.toStringAsFixed(2)}"),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0), // Ensure value is between 0 and 1
              backgroundColor: Color(0xffFFCDAC),
              color: Color(0xffFE5D26),
            ),
          ],
        ),
      ),
    );
  }

  // Build the Budget Category List
  Widget _buildBudgetCategoryList(String title, List<Map<String, dynamic>> categories, bool isExpense) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...categories.map((category) => _buildCategoryCard(category)).toList(),
        TextButton(
          onPressed: () {
            // Implement add category functionality
            _showAddCategoryDialog(isExpense);
          },
          child: const Text("Add Card", style: TextStyle(color: Color(0xffFE5D26), fontSize: 16)),
        ),
      ],
    );
  }

  // added a circle background container
  // Build each category card
  Widget _buildCategoryCard(Map<String, dynamic> category) {
    double sw = MediaQuery.of(context).size.width;

    return GestureDetector(
      onLongPress: () {
        _showDeleteConfirmationDialog(category);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: sw * 0.1,
                    height: sw * 0.1,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffA78062),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: sw * 0.08,
                            height: sw * 0.08,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffC29472),
                                  blurRadius: 1,
                                  spreadRadius: 2
                                )
                              ]
                            ),
                            child: Icon(
                              Tracker.categoryIcons[category["title"]],
                              size: 30,
                              color: Colors.white,     // Icon color (optional)
                            ),
                          )
                        )
                      ],
                    )
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category["title"],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("\$${category["amount"]}", style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Implement edit functionality (navigate to edit screen)
                      _showEditCategoryDialog(category);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialog to delete category
  void _showDeleteConfirmationDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: Text("Are you sure you want to delete ${category["title"]}?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () {
                setState(() {
                  // Remove the category from the list (Implement logic as per your needs)
                  expenseCategories.remove(category); // Remove from expenseCategories or incomeCategories
                  // Update your state
                });
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Show dialog to add a new category
  void _showAddCategoryDialog(bool isExpense) {
    // Implement add category functionality here

  }

  // Show dialog to edit a category
  void _showEditCategoryDialog(Map<String, dynamic> category) {
    // Implement edit functionality here
  }

  // Get current month as a string
  String _getCurrentMonth() {
    return DateFormat('MMMM').format(DateTime.now());
  }
}
