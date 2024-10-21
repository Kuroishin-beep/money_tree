import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/tracker_model.dart';

class FirestoreService {
  // get current user
  User? user = FirebaseAuth.instance.currentUser;

  // Collections
  final CollectionReference incomes = FirebaseFirestore.instance.collection('incomes');
  final CollectionReference expenses = FirebaseFirestore.instance.collection('expenses');
  final CollectionReference budgets = FirebaseFirestore.instance.collection('budgets');
  final CollectionReference savings = FirebaseFirestore.instance.collection('savings');
  final CollectionReference categories = FirebaseFirestore.instance.collection('categories');


  // CREATE: add new income, expenses, budget, savings, and calculations
  // FOR INCOME
  Future<void> addIncome(Tracker income) {
    return incomes.add({
      'UserEmail': user!.email,
      'name': income.name,
      'category': income.category,
      'account': income.account,
      'amount': income.amount,
      'type': income.type,
      'date': income.date,
      'icon': income.icon
    });
  }
  // FOR EXPENSE
  Future<void> addExpense(Tracker expense) {
    return expenses.add({
      'UserEmail': user!.email,
      'name': expense.name,
      'category': expense.category,
      'account': expense.account,
      'amount': expense.amount,
      'type': expense.type,
      'date': expense.date,
      'icon': expense.icon,
    });
  }
  // FOR BUDGET
  Future<void> addBudget(Tracker budget) {
    return budgets.add({
      'UserEmail': user!.email,
      'category': budget.category,
      'budgetAmount': budget.budgetAmount,
      'totalBudgetAmount': budget.totalBudgetAmount,
      'type': budget.type,
      'icon': budget.icon
    });
  }
  // FOR SAVINGS
  Future<void> addSavings(Tracker save) {
    return savings.add({
      'UserEmail': user!.email,
      'category': save.category,
      'savingsAmount': save.savingsAmount,
      'totalSavingsAmount': save.totalSavingsAmount,
      'type': save.type,
      'icon': save.icon
    });
  }


  // FOR CATEGORIES: Accepting a list (array in Dart) and storing it in Firestore
  Future<void> addCategory(List<String> categoriesList) async {
    await FirebaseFirestore.instance.collection('categories').add({
      'UserEmail': user!.email,
      'categoriesArray': categoriesList,
    });
  }

  Future<void> updateCategory(String docId, List<String> categoriesList) async {
    await FirebaseFirestore.instance.collection('categories').doc(docId).set({
      'categoriesArray': categoriesList,
    });
  }





  // READ: get data from database
  //FOR INCOME
  Stream<QuerySnapshot> getIncomeStream() {
    return incomes
        .where('UserEmail', isEqualTo: user!.email) // Filter by current user's email
        .snapshots();
  }
  //FOR Expenses
  Stream<QuerySnapshot> getExpenseStream() {
    return expenses
        .where('UserEmail', isEqualTo: user!.email) // Filter by current user's email
        .snapshots();
  }
  //FOR BUDGET
  Stream<QuerySnapshot> getBudgetStream() {
    return budgets
        .where('UserEmail', isEqualTo: user!.email) // Filter by current user's email
        .snapshots();
  }
  //FOR SAVINGS
  Stream<QuerySnapshot> getSavingsStream() {
    return savings
        .where('UserEmail', isEqualTo: user!.email) // Filter by current user's email
        .snapshots();
  }

  // FOR DISPLAYING SEARCH IN EXPENSES
  Stream<QuerySnapshot> getExpenseSearch({String searchQuery = ''}) {
    final collection = FirebaseFirestore.instance.collection('expenses');

    // Apply search filter only if searchQuery is not empty
    if (searchQuery.isNotEmpty) {
      // Convert the search query to lowercase
      String lowercaseSearchQuery = searchQuery.toLowerCase();

      return collection
          .where('name', isGreaterThanOrEqualTo: lowercaseSearchQuery)
          .where('name', isLessThanOrEqualTo: lowercaseSearchQuery + '\uf8ff')
          .snapshots();
    } else {
      return collection
          .where('UserEmail', isEqualTo: user!.email) // Filter by current user's email
          .snapshots();
    }
  }

  // FOR DISPLAYING SEARCH IN INCOMES
  Stream<QuerySnapshot> getIncomeSearch({String searchQuery = ''}) {
    final collection = FirebaseFirestore.instance.collection('incomes');


    // Apply search filter only if searchQuery is not empty
    if (searchQuery.isNotEmpty) {
      // Convert the search query to lowercase
      String lowercaseSearchQuery = searchQuery.toLowerCase();

      return collection
          .where('name', isGreaterThanOrEqualTo: lowercaseSearchQuery)
          .where('name', isLessThanOrEqualTo: lowercaseSearchQuery + '\uf8ff')
          .snapshots();
    } else {
      return collection
          .where('UserEmail', isEqualTo: user!.email) // Filter by current user's email
          .snapshots();
    }
  }







  // UPDATE: edit income, expenses, budget, and savings

  // FOR INCOME
  Future<void> updateIncome(String docID, Tracker newIncome) async {
    try {
      DocumentSnapshot existingDoc = await incomes.doc(docID).get();

      if (!existingDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic> updates = {};

      if (newIncome.name != null) {
        updates['name'] = newIncome.name;
      }
      if (newIncome.category != null) {
        updates['category'] = newIncome.category;
      }
      if (newIncome.account != null) {
        updates['account'] = newIncome.account;
      }
      if (newIncome.amount != null && newIncome.amount != 0) {
        updates['amount'] = newIncome.amount;
      }
      if (newIncome.type != null) {
        updates['type'] = newIncome.type;
      }
      if (newIncome.date != null) {
        updates['date'] = newIncome.date;
      }
      if (newIncome.icon != 0) {
        updates['icon'] = newIncome.icon;
      }

      return incomes.doc(docID).update(updates);
    } catch (e) {
      print("Error updating expense: $e");
    }
  }

  // FOR EXPENSE
  Future<void> updateExpense(String docID, Tracker newExpense) async {
    try {
      DocumentSnapshot existingDoc = await expenses.doc(docID).get();

      if (!existingDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic> updates = {};

      if (newExpense.name != null) {
        updates['name'] = newExpense.name;
      }
      if (newExpense.category != null) {
        updates['category'] = newExpense.category;
      }
      if (newExpense.account != null) {
        updates['account'] = newExpense.account;
      }
      if (newExpense.amount != null && newExpense.amount != 0) {
        updates['amount'] = newExpense.amount;
      }
      if (newExpense.type != null) {
        updates['type'] = newExpense.type;
      }
      if (newExpense.date != null) {
        updates['date'] = newExpense.date;
      }
      if (newExpense.icon != 0) {
        updates['icon'] = newExpense.icon;
      }

      return expenses.doc(docID).update(updates);
    } catch (e) {
      print("Error updating expense: $e");
    }
  }

  // FOR BUDGET
  Future<void> updateBudget(String docID, Tracker newBudget) async {
    try {
      DocumentSnapshot existingDoc = await budgets.doc(docID).get();

      if (!existingDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic> updates = {};

      if (newBudget.category != null) {
        updates['category'] = newBudget.category;
      }
      if (newBudget.budgetAmount != null && newBudget.budgetAmount != 0) {
        updates['budgetAmount'] = newBudget.budgetAmount;
      }
      if (newBudget.totalBudgetAmount != null && newBudget.totalBudgetAmount != 0) {
        updates['totalBudgetAmount'] = newBudget.totalBudgetAmount;
      }
      if (newBudget.type != null) {
        updates['type'] = newBudget.type;
      }
      if (newBudget.icon != null) {
        updates['icon'] = newBudget.icon;
      }

      return budgets.doc(docID).update(updates);
    } catch (e) {
      print("Error updating budget: $e");
    }
  }

  Future<void> updateBudgetAmount(String docID, Tracker newBudget) async {
    try {
      DocumentSnapshot existingDoc = await budgets.doc(docID).get();

      if (!existingDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic> updates = {};

      if (newBudget.budgetAmount != null && newBudget.budgetAmount != 0) {
        updates['budgetAmount'] = newBudget.budgetAmount;
      }
      if (newBudget.type != null) {
        updates['type'] = newBudget.type;
      }

      return budgets.doc(docID).update(updates);
    } catch (e) {
      print("Error updating budget: $e");
    }
  }

  Future<void> updateTotalBudgetAmount(String docID, Tracker newBudget) async {
    try {
      DocumentSnapshot existingDoc = await budgets.doc(docID).get();

      if (!existingDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic> updates = {};

      if (newBudget.totalBudgetAmount != null && newBudget.totalBudgetAmount != 0) {
        updates['totalBudgetAmount'] = newBudget.totalBudgetAmount;
      }
      if (newBudget.type != null) {
        updates['type'] = newBudget.type;
      }

      return budgets.doc(docID).update(updates);
    } catch (e) {
      print("Error updating budget: $e");
    }
  }

  // FOR SAVINGS
  Future<void> updateSavings(String docID, Tracker newSavings) async {
    try {
      DocumentSnapshot existingDoc = await savings.doc(docID).get();

      if (!existingDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic> updates = {};

      if (newSavings.category != null) {
        updates['category'] = newSavings.category;
      }
      if (newSavings.savingsAmount != null && newSavings.savingsAmount != 0) {
        updates['savingsAmount'] = newSavings.savingsAmount;
      }
      if (newSavings.totalSavingsAmount != null && newSavings.totalSavingsAmount != 0) {
        updates['totalSavingsAmount'] = newSavings.totalSavingsAmount;
      }
      if (newSavings.type != null) {
        updates['type'] = newSavings.type;
      }
      if (newSavings.icon != null) {
        updates['icon'] = newSavings.icon;
      }

      return savings.doc(docID).update(updates);
    } catch (e) {
      print("Error updating savings: $e");
    }
  }

  Future<void> updateSavingsAmount(String docID, Tracker newSavings) async {
    try {
      DocumentSnapshot existingDoc = await savings.doc(docID).get();

      if (!existingDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic> updates = {};

      if (newSavings.savingsAmount != null && newSavings.savingsAmount != 0) {
        updates['savingsAmount'] = newSavings.savingsAmount;
      }
      if (newSavings.type != null) {
        updates['type'] = newSavings.type;
      }

      return savings.doc(docID).update(updates);
    } catch (e) {
      print("Error updating savings: $e");
    }
  }

  Future<void> updateTotalSavingsAmount(String docID, Tracker newSavings) async {
    try {
      DocumentSnapshot existingDoc = await savings.doc(docID).get();

      if (!existingDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic> updates = {};

      if (newSavings.totalSavingsAmount != null && newSavings.totalSavingsAmount != 0) {
        updates['totalSavingsAmount'] = newSavings.totalSavingsAmount;
      }
      if (newSavings.type != null) {
        updates['type'] = newSavings.type;
      }

      return savings.doc(docID).update(updates);
    } catch (e) {
      print("Error updating savings: $e");
    }
  }




  // DELETE: delete transactions
  // FOR INCOME
  Future<void> deleteIncome(String docID) async {
    try {
      await incomes.doc(docID).delete();
      print("Income document with ID: $docID deleted successfully.");
    } catch (e) {
      print("Error deleting income document: $e");
    }
  }
  // FOR EXPENSE
  Future<void> deleteExpense(String docID) async {
    try {
      await expenses.doc(docID).delete();
      print("Expense document with ID: $docID deleted successfully.");
    } catch (e) {
      print("Error deleting expense document: $e");
    }
  }
  // FOR BUDGET
  Future<void> deleteBudget(String docID) async {
    try {
      await budgets.doc(docID).delete();
      print("Budget document with ID: $docID deleted successfully.");
    } catch (e) {
      print("Error deleting budget document: $e");
    }
  }
  //  FIXME: Cannot perform delete category yet
  // FOR SAVINGS
  Future<void> deleteSavings(String docID) async {
    try {
      await savings.doc(docID).delete();
      print("Savings document with ID: $docID deleted successfully.");
    } catch (e) {
      print("Error deleting savings document: $e");
    }
  }
  // FOR CATEGORIES
  Future<void> deleteCategory(String docID) async {
    try {
      await categories.doc(docID).delete();
      print("Category document with ID: $docID deleted successfully.");
    } catch (e) {
      print("Error deleting category document: $e");
    }
  }

}