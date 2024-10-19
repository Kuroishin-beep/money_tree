import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tree/models/finance_data_model.dart';


class FinancialDataService {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<FinancialDataModel> getFinancialData(String uid) async {
        final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestore.collection('users').doc(uid).get();

        if (documentSnapshot.exists) {
            final Map<String, dynamic> data = documentSnapshot.data()!;
            return FinancialDataModel(
                income: data['income'],
                expenses: data['expenses'],
                budget: data['budget'],
                savings: data['savings'],
            );
        } else {
            return FinancialDataModel(
                income: 0,
                expenses: 0,
                budget: 0,
                savings: 0,
            );
        }
    }
}