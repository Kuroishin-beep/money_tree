import 'package:flutter/material.dart';
import 'package:money_tree/edit_transaction/edit_expenses_screen.dart';
import 'package:money_tree/dashboard/dashboard_screen.dart';
import 'package:money_tree/financial_report/monthly_screen.dart';
import 'package:money_tree/settings/settings.dart';
import 'package:money_tree/add_transaction/new_income_screen.dart';
import 'package:money_tree/edit_transaction/edit_income_screen.dart';


class HistoryScreen extends StatefulWidget {
  @override
  HistoryDataListState createState() => HistoryDataListState();
}

class HistoryDataListState extends State<HistoryScreen> {
  // List of expenses
  List<Expense> expenseList = [
    Expense(icon: Icons.directions_car, item: 'Tire Repair', date: 'August 17, 2024', category: 'CAR', amount: '\$1,500'),
    Expense(icon: Icons.shopping_bag, item: 'Weekly Groceries', date: 'August 28, 2024', category: 'GROCERIES', amount: '\$700'),
  ];

  // List of incomes
  List<Income> incomeList = [
    Income(icon: Icons.person, name: 'Personal', date: 'September 4, 2024', category: 'CASH', amount: '\$1,500'),
    Income(icon: Icons.work, name: 'XYZ Company', date: 'August 30, 2024', category: 'CASH', amount: '\$55,000'),
  ];

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    return Scaffold(
      backgroundColor: Color(0xffABC5EA),

      appBar: AppBar(
          backgroundColor: Color(0xffFFF8ED),
          title: Text(
            'HISTORY',
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

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xffFFF8ED),
              Color(0xffABC5EA),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // Search Bar
            _searchBar(),

            SizedBox(height: sw * 0.05),

            // Expenses section
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Color(0xff093F40),
                    thickness: 1.3,
                    endIndent: 20.0,
                  ),
                ),
                Text(
                  'EXPENSES',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fs * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xff093F40),
                    thickness: 1.3,
                    indent: 20.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: sw * 0.025),
            Expanded(
              child: ListView.builder(
                itemCount: expenseList.length,
                itemBuilder: (context, index) {
                  return _buildExpenseCard(
                      expenseList[index],
                      fs,
                      sw
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  expenseList.addAll([
                    Expense(icon: Icons.fastfood, item: 'Dinner', date: 'September 6, 2024', category: 'FOOD', amount: '\$100'),
                    Expense(icon: Icons.coffee, item: 'Coffee', date: 'September 7, 2024', category: 'FOOD', amount: '\$10'),
                  ]);
                });
              },
              child: Text('See all'),
            ),

            SizedBox(height: sw * 0.05),

            // Income section
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Color(0xff093F40),
                    thickness: 1.3,
                    endIndent: 20.0,
                  ),
                ),
                Text(
                  'INCOME',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fs * 0.04,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Color(0xff093F40),
                    thickness: 1.3,
                    indent: 20.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: sw * 0.025),
            Expanded(
              child: ListView.builder(
                itemCount: incomeList.length,
                itemBuilder: (context, index) {
                  return _buildIncomeCard(
                      incomeList[index],
                      fs,
                      sw
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  incomeList.addAll([
                    Income(icon: Icons.attach_money, name: 'Freelance', date: 'September 7, 2024', category: 'CARD', amount: '\$100'),
                  ]);
                });
              },
              child: Text('See all'),
            ),


          ],
        ),
      ),

      // Navigation bar
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: sw * 0.04), // Adjust the value as needed
        child: SizedBox(
          height: 70, // Set height
          width: 70,  // Set width
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewIncomeScreen()));
            },
            child: Icon(
              Icons.add,
              size: 40, // Icon size
              color: Color(0xffE63636),
            ),
            backgroundColor: Color(0xffFFF8ED),
            shape: CircleBorder(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomAppBar(
          color: Color(0xff231F20),
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
                icon: Icon(Icons.history, color: Color(0xffFE5D26), size: 33),
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

  Widget _searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5), // Background color of the container
        borderRadius: BorderRadius.circular(30.0), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 5, // Blur radius
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          fillColor: Color(0xffFFF8ED),
          filled: true,
          hintText: 'Date, Category, Price',
          hintStyle: TextStyle(
              color: Color(0xff545454),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300
          ),
          suffixIcon: Icon(
            Icons.search,
            color: Color(0xff545454),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.transparent, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.transparent, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense, double fs, double sw) {

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditExpensesScreen(),
          ),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.5),
        child: ListTile(
          leading: Container(
            width: sw * 0.09,
            height: sw * 0.09,
            decoration: BoxDecoration(
              color: Color(0xffABC5EA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              expense.icon,
              size: 25,
              color: Colors.white, // Icon color
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.date,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fs * 0.035
                ),
              ),
              Text(
                expense.item,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fs * 0.05
                ),
              ),
            ],
          ),
          subtitle: Text(expense.category),
          trailing: Text(
            expense.amount,
            style: TextStyle(
                fontSize: fs * 0.05,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeCard(Income income, double fs, double sw) {

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditIncomeScreen(),
          ),
        );
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.grey.withOpacity(0.5),
        child: ListTile(
          leading: Container(
            width: sw * 0.09,
            height: sw * 0.09,
            decoration: BoxDecoration(
              color: Color(0xffABC5EA),
              shape: BoxShape.circle,
            ),
            child: Icon(
              income.icon,
              size: 25,
              color: Colors.white, // Icon color
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                income.date,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fs * 0.03
                ),
              ),

              Text(
                income.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fs * 0.05
                ),
              )
            ],
          ),
          subtitle: Text(income.category),
          trailing: Text(income.amount),
        ),
      ),
    );
  }
}

// Define the models for Expense and Income
class Expense {
  final IconData icon;
  final String item;
  final String date;
  final String category;
  final String amount;

  Expense({
    required this.icon,
    required this.item,
    required this.date,
    required this.category,
    required this.amount,
  });
}

class Income {
  final IconData icon;
  final String name;
  final String date;
  final String category;
  final String amount;

  Income({
    required this.icon,
    required this.name,
    required this.date,
    required this.category,
    required this.amount,
  });
}