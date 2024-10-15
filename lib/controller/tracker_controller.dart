import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/tracker_model.dart';

class FirestoreService {
  // get current user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection of tracks
  final CollectionReference tracks = FirebaseFirestore.instance.collection('tracks');
  final CollectionReference income = FirebaseFirestore.instance.collection('income');
  final CollectionReference expenses = FirebaseFirestore.instance.collection('expenses');

  // CREATE: add new income, expenses, budget, and savings
  // FOR INCOME
  Future<void> addIncome(Tracker income) {
    return income.add({
      'UserEmail': user!.email,
      'name': income.name,
      'category': income.category,
      'account': income.account,
      'amount': income.amount,
      'type': income.type,         // also for budget and savings
      'date': income.date,
      'icon': income.icon,
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
      'type': expense.type,         // also for budget and savings
      'date': expense.date,
      'icon': expense.icon,
    });
  }


  Future<void> addTrack(Tracker track) {
    return tracks.add({
      'UserEmail': user!.email,

      // INCOME AND EXPENSES
      'name': track.name,
      'category': track.category,
      'account': track.account,
      'amount': track.amount,
      'type': track.type,         // also for budget and savings
      'date': track.date,
      'icon': track.icon,

      // BUDGET AND SAVINGS
      'budget_amount': track.budget_amount,
      'savings_amount': track.savings_amount,
      'total_budgetamount': track.total_budgetamount,
      'total_savaingsamount': track.total_savingsamount,

      // CALCULATIONS
      'balance': track.balance,
      'totalCash': track.totalCash,
      'totalCard': track.totalCard,
      'totalGCash': track.totalGCash
    });
  }






  // READ: get data from database
  Stream<QuerySnapshot> getTracksStream() {
    final tracksStream = tracks.orderBy('date', descending: true).snapshots();

    return tracksStream;
  }





  // Stream<QuerySnapshot> getTracksStream() {
  //   // Ensure user is logged in
  //   if (user == null) {
  //     throw Exception("User not logged in");
  //   }
  //
  //   // Filter tracks by the current user's email
  //   final tracksStream = tracks
  //       .where('UserEmail', isEqualTo: user!.email)  // Only fetch tracks for the current user
  //       .orderBy('date', descending: true).snapshots();
  //
  //   return tracksStream;
  // }

  // Stream<QuerySnapshot> getTracksStream() {
  //   final tracksStream = FirebaseFirestore.instance.collection('tracks')
  //       .orderBy('date', descending: true)
  //       .snapshots();
  //
  //   return tracksStream;
  // }

  Future<DocumentSnapshot> getExpenseById(String docID) async {
    return await FirebaseFirestore.instance.collection('your_collection_name').doc(docID).get();
  }









  // UPDATE: edit income, expenses, budget, and savings
  // Future<void> updateTrack(String docID, Tracker newTrack) {
  //   return tracks.doc(docID).update({
  //     // INCOME AND EXPENSES
  //     'name': newTrack.name,
  //     'category': newTrack.category,
  //     'account': newTrack.account,
  //     'amount': newTrack.amount,
  //     'type': newTrack.type,    // also for budget and savings
  //     'date': newTrack.date,
  //     'icon': newTrack.icon,
  //
  //     // BUDGET AND SAVINGS
  //     'budget_amount': newTrack.budget_amount,
  //     'savings_amount': newTrack.savings_amount,
  //     'total_budgetamount': newTrack.total_budgetamount,
  //     'total_savaingsamount': newTrack.total_savingsamount,
  //
  //     // CALCULATIONS
  //     'balance': newTrack.balance,
  //     'totalCash': newTrack.totalCash,
  //     'totalCard': newTrack.totalCard,
  //     'totalGCash': newTrack.totalGCash
  //   });
  // }

  Future<void> updateTrack(String docID, Tracker newTrack) async {
    try {
      DocumentSnapshot existingDoc = await tracks.doc(docID).get();

      if (!existingDoc.exists) {
        throw Exception("Document does not exist");
      }

      Map<String, dynamic> updates = {};

      // Updating fields only if they have valid new value different from null or, for strings, not empty.
      if (newTrack.name != null && newTrack.name.isNotEmpty) {
        updates['name'] = newTrack.name;
      }
      if (newTrack.category != null && newTrack.category.isNotEmpty) {
        updates['category'] = newTrack.category;
      }
      if (newTrack.account != null && newTrack.account.isNotEmpty) {
        updates['account'] = newTrack.account;
      }
      if (newTrack.amount != null && newTrack.amount != 0) {
        updates['amount'] = newTrack.amount;
      }
      if (newTrack.type != null && newTrack.type.isNotEmpty) {
        updates['type'] = newTrack.type;
      }
      if (newTrack.date != null) {
        updates['date'] = newTrack.date;
      }
      if (newTrack.icon != 0) {
        updates['icon'] = newTrack.icon;
      }
      if (newTrack.budget_amount != null && newTrack.budget_amount != 0) {
        updates['budget_amount'] = newTrack.budget_amount;
      }
      if (newTrack.savings_amount != null && newTrack.savings_amount != 0) {
        updates['savings_amount'] = newTrack.savings_amount;
      }
      if (newTrack.total_budgetamount != null && newTrack.total_budgetamount != 0) {
        updates['total_budgetamount'] = newTrack.total_budgetamount;
      }
      if (newTrack.total_savingsamount != null && newTrack.total_savingsamount !=0) {
        updates['total_savaingsamount'] = newTrack.total_savingsamount;
      }
      if (newTrack.balance != null) {
        updates['balance'] = newTrack.balance;
      }
      if (newTrack.totalCash != null) {
        updates['totalCash'] = newTrack.totalCash;
      }
      if (newTrack.totalCard != null) {
        updates['totalCard'] = newTrack.totalCard;
      }
      if (newTrack.totalGCash != null) {
        updates['totalGCash'] = newTrack.totalGCash;
      }

      return tracks.doc(docID).update(updates);
    } catch (e) {
      print("Error updating track: $e");
    }
  }




  // DELETE: delete transactions
  Future<void> deleteTrack(String docID) {
    return tracks.doc(docID).delete();
  }
}