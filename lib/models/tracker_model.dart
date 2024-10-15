import 'package:flutter/material.dart';

class Tracker {
  final String name;        // for income (e.g., Company Name, Freelance Work) | for expenses (e.g., Tire Repair)
  final String category;    // to which category it belongs to (expenses)
  final String account;     // to which account it belongs to (income & expenses)
  final double amount;      // placeholder for income and expenses
  final String type;        // identify if expenses or income
  final DateTime? date;
  final int? icon;
  final double budget_amount;
  final double savings_amount;
  final double total_budgetamount;


  Tracker({
    this.name = '',
    this.category = '',
    this.account = '',
    this.amount = 0,
    this.type ='',
    this.date,
    this.icon,
    this.budget_amount = 0,
    this.savings_amount = 0,
    this.total_budgetamount = 0,
  });


  static Map<String, IconData> categoryIcons = {
    "GROCERIES": Icons.shopping_cart,
    "CAR": Icons.directions_car,
    "SCHOOL": Icons.school,
    "HEALTH": Icons.local_hospital,
  };

  static Map<String, IconData> catIcons = {};

  static Map<String, IconData> accountIcons = {
    "CASH": Icons.attach_money_rounded,
    "CARD": Icons.credit_card,
    "GCASH": Icons.money_rounded,
  };



}