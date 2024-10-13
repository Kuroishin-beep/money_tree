import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:money_tree/models/tracker_model.dart';
import '../../bottom_navigation.dart';
import '../../fab.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
// For Cupertino icon pack


class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {

  Icon? _icon;

  // Icon picker method
  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [IconPack.cupertino],  // Specify the icon pack you want
      ),
    );

    if (icon != null) {
      _icon = Icon(icon.data);
      setState(() {});
    }
  }


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
          backgroundColor: const Color(0xffFBC29C),
          title: const Text(
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
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
                      const Expanded(
                        child: Divider(thickness: 1.5, color: Colors.black54),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          _getCurrentMonth().toUpperCase(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Expanded(
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
          const Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
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
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Progress bar
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0), // value is between 0 and 1
              backgroundColor: const Color(0xffFFCDAC),
              color: const Color(0xffFE5D26),
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
              backgroundColor: const Color(0xffFFCDAC),
              color: const Color(0xffFE5D26),
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
        ...categories.map((category) => _buildCategoryCard(category)),
        TextButton(
          onPressed: () => _showAddCategoryDialog(isExpense),
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
                  // Circle with icon
                  Container(
                    width: sw * 0.1,
                    height: sw * 0.1,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffA78062),  // Circle color
                    ),
                    child: Center(
                      // Use the saved IconData to display the icon
                      child: category.containsKey("icon")
                          ? Icon(
                        category["icon"],  // Access the saved IconData
                        size: 30,
                        color: Colors.white,  // Icon color
                      )
                          : const SizedBox(),  // Placeholder if no icon is selected
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title of the category
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
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController budgetController = TextEditingController();
    _icon = null;  // Reset the icon for each new category

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isExpense ? "Add Expense" : "Add Income"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: budgetController,
                decoration: const InputDecoration(labelText: "Budget"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Icon Picker Button
              TextButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text("Pick Icon"),
                onPressed: () {
                  _pickIcon();  // Use the provided _pickIcon method
                },
              ),
              // Display selected icon
              _icon != null ? _icon! : const SizedBox(),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Add"),
              onPressed: () {
                setState(() {
                  Map<String, dynamic> newCategory = {
                    "title": titleController.text,
                    "amount": double.parse(amountController.text),
                    "budget": double.parse(budgetController.text),
                    "icon": _icon?.icon,  // Save the selected icon
                  };
                  if (isExpense) {
                    expenseCategories.add(newCategory);
                  } else {
                    incomeCategories.add(newCategory);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Show dialog to edit a category
  void _showEditCategoryDialog(Map<String, dynamic> category) {
    TextEditingController amountController = TextEditingController(text: category["amount"].toString());
    TextEditingController budgetController = TextEditingController(text: category["budget"].toString());
    _icon = category.containsKey('icon') ? Icon(category["icon"]) : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("EDIT ${category["title"]}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xffFBC29C),
              fontFamily: 'Inter Regular',
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: budgetController,
                decoration: const InputDecoration(labelText: "Budget"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              // Icon Picker Button
              TextButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Text("Pick Icon"),
                onPressed: () {
                  _pickIcon();  // Use the provided _pickIcon method
                },
              ),
              // Display selected icon
              _icon != null ? _icon! : const SizedBox(),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () {
                setState(() {
                  category["amount"] = double.parse(amountController.text);
                  category["budget"] = double.parse(budgetController.text);
                  if (_icon != null) {
                    category["icon"] = _icon?.icon;  // Save updated icon
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }




  // Get current month as a string
  String _getCurrentMonth() {
    return DateFormat('MMMM').format(DateTime.now());
  }
}


