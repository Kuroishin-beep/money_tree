import 'package:cloud_firestore/cloud_firestore.dart';

class FinancialDataService {
  // Function to insert low-income bracket data into Firestore
  Future<void> insertLowIncomeData() async {
    // Example data for low income bracket
    final lowIncomeData = {
      'monthly_income': 'PHP 32,511',
      'total_weekly_expenses': 'PHP 1,697',
      'expenses': [
        {
          'day': 'Monday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Rice (1kg)', 'cost': 50},
            {'category': 'Food & Groceries', 'item_description': 'Eggs (12 pcs)', 'cost': 83},
            {'category': 'Transportation', 'item_description': 'Local Transport Ticket', 'cost': 16},
            {'category': 'Utilities', 'item_description': 'Mobile Phone (1/30th of plan)', 'cost': 50},
          ],
        },
        {
          'day': 'Tuesday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Chicken Fillet (1kg)', 'cost': 170},
            {'category': 'Transportation', 'item_description': 'Local Transport Ticket', 'cost': 16},
            {'category': 'Food & Groceries', 'item_description': 'Lettuce (1kg)', 'cost': 53},
          ],
        },
        {
          'day': 'Wednesday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Meal, Inexpensive Restaurant', 'cost': 175},
            {'category': 'Utilities', 'item_description': 'Internet (1/30th of monthly plan)', 'cost': 58.33},
            {'category': 'Transportation', 'item_description': 'Local Transport Ticket', 'cost': 16},
          ],
        },
        {
          'day': 'Thursday',
          'expenses_details': [
            {'category': 'Entertainment', 'item_description': 'Domestic Beer (0.5L bottle)', 'cost': 43},
            {'category': 'Food & Groceries', 'item_description': 'Milk (1L)', 'cost': 83},
            {'category': 'Transportation', 'item_description': 'Local Transport Ticket', 'cost': 16},
          ],
        },
        {
          'day': 'Friday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Rice (1kg)', 'cost': 50},
            {'category': 'Food & Groceries', 'item_description': 'Eggs (12 pcs)', 'cost': 83},
            {'category': 'Transportation', 'item_description': 'Local Transport Ticket', 'cost': 16},
          ],
        },
        {
          'day': 'Saturday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Meal, Inexpensive Restaurant', 'cost': 175},
            {'category': 'Entertainment', 'item_description': 'Domestic Beer (0.5L bottle)', 'cost': 43},
            {'category': 'Food & Groceries', 'item_description': 'Potatoes (1kg)', 'cost': 95},
          ],
        },
        {
          'day': 'Sunday',
          'expenses_details': [
            {'category': 'Utilities', 'item_description': 'Basic Utilities (1/30th of monthly)', 'cost': 263.67},
            {'category': 'Food & Groceries', 'item_description': 'Apples (1kg)', 'cost': 120},
          ],
        },
      ],
    };

    // Calculate total_for_day for low income data
    final expensesLowIncome = lowIncomeData['expenses'] as List?;
    if (expensesLowIncome != null) {
      for (var day in expensesLowIncome) {
        day['total_for_day'] = (day['expenses_details'] as List?)
            ?.fold<int>(0, (total, expense) => (total + (expense['cost']?.toInt() ?? 0)).toInt()) ?? 0;
      }
    }

    try {
      // Insert data into Firestore
      await FirebaseFirestore.instance.collection('financial_data').add(lowIncomeData);
      print('Low Income Data Inserted Successfully!');
    } catch (e) {
      print('Error inserting low income data: $e');
    }
  }

  // Function to insert middle-income bracket data into Firestore
  Future<void> insertMiddleIncomeData() async {
    // Example data for middle income bracket
    final middleIncomeData = {
      'monthly_income': 'PHP 60,248.50',
      'total_weekly_expenses': 'PHP 6,072',
      'expenses': [
        {
          'day': 'Monday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Milk (1L)', 'cost': 83},
            {'category': 'Food & Groceries', 'item_description': 'Rice (1kg)', 'cost': 50},
            {'category': 'Transportation', 'item_description': 'Gasoline (5L)', 'cost': 324.8},
            {'category': 'Utilities', 'item_description': 'Mobile Phone (1/30th of plan)', 'cost': 50},
          ],
        },
        {
          'day': 'Tuesday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Beef Round (1kg)', 'cost': 410},
            {'category': 'Transportation', 'item_description': 'Gasoline (5L)', 'cost': 324.8},
            {'category': 'Entertainment', 'item_description': 'Domestic Beer (0.5L bottle)', 'cost': 43},
          ],
        },
        {
          'day': 'Wednesday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Meal for 2 (Mid-range)', 'cost': 1000},
            {'category': 'Utilities', 'item_description': 'Internet (1/30th of monthly plan)', 'cost': 58.33},
            {'category': 'Transportation', 'item_description': 'Gasoline (5L)', 'cost': 324.8},
          ],
        },
        {
          'day': 'Thursday',
          'expenses_details': [
            {'category': 'Entertainment', 'item_description': 'Domestic Beer (0.5L bottle)', 'cost': 43},
            {'category': 'Food & Groceries', 'item_description': 'Oranges (1kg)', 'cost': 130},
            {'category': 'Transportation', 'item_description': 'Gasoline (5L)', 'cost': 324.8},
          ],
        },
        {
          'day': 'Friday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Meal for 2 (Mid-range)', 'cost': 1000},
            {'category': 'Transportation', 'item_description': 'Gasoline (5L)', 'cost': 324.8},
          ],
        },
        {
          'day': 'Saturday',
          'expenses_details': [
            {'category': 'Utilities', 'item_description': 'Basic Utilities (1/30th of monthly)', 'cost': 263.67},
            {'category': 'Transportation', 'item_description': 'Gasoline (5L)', 'cost': 324.8},
          ],
        },
        {
          'day': 'Sunday',
          'expenses_details': [
            {'category': 'Entertainment', 'item_description': 'Cinema (1 seat)', 'cost': 250},
            {'category': 'Food & Groceries', 'item_description': 'Beef Round (1kg)', 'cost': 410},
          ],
        },
      ],
    };

    // Calculate total_for_day for middle income data
    final expensesMiddleIncome = middleIncomeData['expenses'] as List?;
    if (expensesMiddleIncome != null) {
      for (var day in expensesMiddleIncome) {
        day['total_for_day'] = (day['expenses_details'] as List?)
            ?.fold<int>(0, (total, expense) => (total + (expense['cost']?.toInt() ?? 0)).toInt()) ?? 0;
      }
    }

    try {
      // Insert middle-income data into Firestore
      await FirebaseFirestore.instance.collection('financial_data').add(middleIncomeData);
      print('Middle Income Data Inserted Successfully!');
    } catch (e) {
      print('Error inserting middle income data: $e');
    }
  }

  // Function to insert high-income bracket data into Firestore
  Future<void> insertHighIncomeData() async {
    // Example data for high income bracket
    final highIncomeData = {
      'monthly_income': 'PHP 175,312',
      'total_weekly_expenses': 'PHP 9,054.93',
      'expenses': [
        {
          'day': 'Monday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Salmon (1kg)', 'cost': 1800},
            {'category': 'Transportation', 'item_description': 'Gasoline (10L)', 'cost': 649.4},
            {'category': 'Utilities', 'item_description': 'Mobile Phone (1/30th of plan)', 'cost': 50},
          ],
        },
        {
          'day': 'Tuesday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Shrimp (1kg)', 'cost': 850},
            {'category': 'Utilities', 'item_description': 'Electricity (1/30th of monthly)', 'cost': 105},
            {'category': 'Transportation', 'item_description': 'Gasoline (10L)', 'cost': 649.4},
          ],
        },
        {
          'day': 'Wednesday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Steak (1kg)', 'cost': 1500},
            {'category': 'Utilities', 'item_description': 'Internet (1/30th of monthly plan)', 'cost': 58.33},
            {'category': 'Transportation', 'item_description': 'Gasoline (10L)', 'cost': 649.4},
          ],
        },
        {
          'day': 'Thursday',
          'expenses_details': [
            {'category': 'Entertainment', 'item_description': 'Fine Dining (1 meal)', 'cost': 3000},
            {'category': 'Food & Groceries', 'item_description': 'Cheese (1kg)', 'cost': 600},
            {'category': 'Transportation', 'item_description': 'Gasoline (10L)', 'cost': 649.4},
          ],
        },
        {
          'day': 'Friday',
          'expenses_details': [
            {'category': 'Food & Groceries', 'item_description': 'Gourmet Meal for 2', 'cost': 6000},
            {'category': 'Transportation', 'item_description': 'Gasoline (10L)', 'cost': 649.4},
          ],
        },
        {
          'day': 'Saturday',
          'expenses_details': [
            {'category': 'Utilities', 'item_description': 'Luxury Gym Membership (1/30th)', 'cost': 220},
            {'category': 'Transportation', 'item_description': 'Gasoline (10L)', 'cost': 649.4},
          ],
        },
        {
          'day': 'Sunday',
          'expenses_details': [
            {'category': 'Entertainment', 'item_description': 'Weekend Getaway', 'cost': 12000},
            {'category': 'Food & Groceries', 'item_description': 'Artisan Chocolate (1kg)', 'cost': 800},
          ],
        },
      ],
    };

// Calculate total_for_day for high income data
    final expensesHighIncome = highIncomeData['expenses'] as List?;
    if (expensesHighIncome != null) {
      for (var day in expensesHighIncome) {
        day['total_for_day'] = (day['expenses_details'] as List?)
            ?.fold<int>(0, (total, expense) => (total + (expense['cost']?.toInt() ?? 0)).toInt()) ?? 0;
      }
    }
    try {
      // Insert high-income data into Firestore
      await FirebaseFirestore.instance.collection('financial_data').add(highIncomeData);
      print('High Income Data Inserted Successfully!');
    } catch (e) {
      print('Error inserting high income data: $e');
    }
  }
}