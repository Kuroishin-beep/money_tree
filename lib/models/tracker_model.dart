import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tracker {
  final String name;        // for income (e.g., Company Name, Freelance Work) | for expenses (e.g., Tire Repair)
  final String category;    // to which category it belongs to (expenses)
  final String account;     // to which account it belongs to (income & expenses)
  final double amount;      // placeholder for income and expenses
  final String type;        // identify if expenses or income
  final DateTime date;

  Tracker({
    required this.name,
    this.category = '',
    this.account = '',
    required this.amount,
    required this.type,
    DateTime? date,
  }) : date = date ?? DateTime.now();


  static Map<String, IconData> categoryIcons = {
    "GROCERIES": Icons.shopping_cart,
    "CAR": Icons.directions_car,
    "SCHOOL": Icons.school,
    "HEALTH": Icons.local_hospital,
  };

  static Map<String, IconData> accountIcons = {
    "CASH": Icons.attach_money_rounded,
    "CARD": Icons.credit_card,
    "GCASH": Icons.money_rounded,
  };

  static Map<String, List<String>> categoryItems = {
    "GROCERIES": [],
    "CAR": [],
    "SCHOOL": [],
    "HEALTH": [],
  };

  static Map<String, List<String>> categoryAccounts = {
    "CASH": [],
    "CARD": [],
    "GCASH": []
  };

  void main() {
    print(Tracker.categoryIcons.keys);
  }

}