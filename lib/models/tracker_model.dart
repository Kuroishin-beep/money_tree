//tracker_model.dart
import 'package:flutter/material.dart';

class Tracker {
  // INCOME AND EXPENSES
  final String name;                  // for income (e.g., Company Name, Freelance Work) | for expenses (e.g., Tire Repair)
  final String category;              // to which category it belongs to (expenses)
  final String account;               // to which account it belongs to (income & expenses)
  final double amount;                // placeholder for income and expenses
  final String type;                  // identify if expenses, income, budget, savings
  final DateTime? date;               // for date
  final int? icon;                    // icon code

  // BUDGET AND SAVINGS
  final double budgetAmount;         // amount for budget
  final double savingsAmount;        // amount for savings
  final double totalBudgetAmount;    // total budget amount
  final double totalSavingsAmount;   // total savings amount

  // CALCULATIONS
  final double balance;               // current balance
  final double totalCash;             // total cash amount
  final double totalCard;             // total card amount
  final double totalGCash;            // total gcash amount


  Tracker({
    this.name = '',
    this.category = '',
    this.account = '',
    this.amount = 0,
    this.type = '',
    this.date,
    this.icon,
    this.budgetAmount = 0,
    this.savingsAmount = 0,
    this.totalBudgetAmount = 0,
    this.totalSavingsAmount = 0,
    this.balance = 0,
    this.totalCash = 0,
    this.totalCard = 0,
    this.totalGCash = 0
  });

}