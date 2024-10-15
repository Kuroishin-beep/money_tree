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
  final double budget_amount;         // amount for budget
  final double savings_amount;        // amount for savings
  final double total_budgetamount;    // total budget amount
  final double total_savingsamount;   // total savings amount

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
    this.type ='',
    this.date,
    this.icon,
    this.budget_amount = 0,
    this.savings_amount = 0,
    this.total_budgetamount = 0,
    this.total_savingsamount = 0,
    this.balance = 0,
    this.totalCash = 0,
    this.totalCard = 0,
    this.totalGCash = 0
  });


  // ICONS FOR ACCOUNTS
  static Map<String, IconData> accountIcons = {
    "CASH": Icons.attach_money_rounded,
    "CARD": Icons.credit_card,
    "GCASH": Icons.money_rounded,
  };

}