import 'package:flutter/material.dart';
import 'package:budget_tracker/edit_transaction/edit_transaction.dart';
import 'package:budget_tracker/dashboard/dashboard.dart';
import 'package:budget_tracker/history/history.dart';
import 'package:budget_tracker/budget/budget.dart';
import 'package:budget_tracker/settings/settings.dart';
import 'package:budget_tracker/add_transaction/new_income.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryDataListState createState() => HistoryDataListState();
}

class HistoryDataListState extends State<HistoryScreen> {
// List of expenses
  List<Expense> expenseList = [
    Expense(icon: Icons.directions_car, title: 'CAR', date: 'August 17, 2024', amount: '\$1,500'),
    Expense(icon: Icons.shopping_bag, title: 'GROCERIES', date: 'August 28, 2024', amount: '\$700'),
  ];

// List of incomes
  List<Income> incomeList = [
    Income(icon: Icons.person, title: 'PERSONAL', date: 'September 4, 2024', amount: '\$1,500'),
    Income(icon: Icons.work, title: 'XYZ COMPANY', date: 'August 30, 2024', amount: '\$55,000'),
  ];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HISTORY'),
        centerTitle: true,
        actions: const [
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://i.pinimg.com/564x/0a/1d/5a/0a1d5aa8670073bc742f056d7a03b8ea.jpg'),
            radius: 20,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(10, 147, 150, .6),
              Color.fromRGBO(243, 249, 250, .1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
// Search Bar
            Container(
              width: screenWidth * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Date, Category, Price',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

// Expenses section
            _buildSectionTitle('EXPENSES'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: expenseList.length,
                itemBuilder: (context, index) {
                  return _buildExpenseCard(
                    screenWidth,
                    expenseList[index],
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  expenseList.addAll([
                    Expense(icon: Icons.fastfood, title: 'DINNER', date: 'September 6, 2024', amount: '\$100'),
                    Expense(icon: Icons.coffee, title: 'COFFEE', date: 'September 7, 2024', amount: '\$10'),
                  ]);
                });
              },
              child: const Text('See all'),
            ),

// Income section
            _buildSectionTitle('INCOME'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: incomeList.length,
                itemBuilder: (context, index) {
                  return _buildIncomeCard(
                    screenWidth,
                    incomeList[index],
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  incomeList.addAll([
                    Income(icon: Icons.attach_money, title: 'FREELANCE', date: 'September 7, 2024', amount: '\$3,000'),
                  ]);
                });
              },
              child: const Text('See all'),
            ),
          ],
        ),
      ),

      // Navigation Bar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewIncomeScreen()));
        },
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 40,
          color: Color(0xff03045E),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Stack(
        children: [
          BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 15.0,
            color: const Color(0xff001219),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.home_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Dashboard()));
                  },
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.savings_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BudgetScreen()));
                  },
                ),
                const SizedBox(width: 80),
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryScreen()));
                  },
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildExpenseCard(
      double screenWidth,
      Expense expense,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTransactionScreen(),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Icon(expense.icon, size: 40, color: Colors.teal),
          title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(expense.date),
          trailing: Text(expense.amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildIncomeCard(
      double screenWidth,
      Income income,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTransactionScreen(),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: Icon(income.icon, size: 40, color: Colors.teal),
          title: Text(income.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(income.date),
          trailing: Text(income.amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// Define the models for Expense and Income
class Expense {
  final IconData icon;
  final String title;
  final String date;
  final String amount;

  Expense({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
  });
}

class Income {
  final IconData icon;
  final String title;
  final String date;
  final String amount;

  Income({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
  });
}