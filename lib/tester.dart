import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'firebase_options.dart';
import 'package:money_tree/models/tracker_model.dart';
import 'package:money_tree/views/constants/build_transaction_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optional, hides the debug banner
      title: 'Test Search',
      home: const TestSearch(),
    );
  }
}

class FirestoreService {
  User? user = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> getExpenseSearch({String searchQuery = ''}) {
    final collection = FirebaseFirestore.instance
        .collection('expenses');

    // Apply search filter only if searchQuery is not empty
    if (searchQuery.isNotEmpty) {
      // Convert the search query to lowercase
      String lowercaseSearchQuery = searchQuery.toLowerCase();

      return collection
          .where('name', isGreaterThanOrEqualTo: lowercaseSearchQuery)
          .where('name', isLessThanOrEqualTo: lowercaseSearchQuery + '\uf8ff')
          .snapshots();
    } else {
      return collection.snapshots();
    }
  }
}


class TestSearch extends StatefulWidget {
  const TestSearch({super.key});

  @override
  State<TestSearch> createState() => _TestSearchState();
}

class _TestSearchState extends State<TestSearch> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController _searchController = TextEditingController();

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CupertinoSearchTextField(
          controller: _searchController,
          placeholder: 'Search by name',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getExpenseSearch(searchQuery: _searchText),
        builder: (context, snapshot) {
          // Handle error state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Handle no data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          // Filter to only include documents of type 'expenses'
          final filteredDocs = snapshot.data!.docs.where((doc) {
            return doc['type'] == 'expenses';
          }).toList();

          // Sort by date in descending order
          filteredDocs.sort((a, b) {
            final dateA = (a['date'] as Timestamp).toDate();
            final dateB = (b['date'] as Timestamp).toDate();
            return dateB.compareTo(dateA);
          });

          // If no expense transactions found after filtering
          if (filteredDocs.isEmpty) {
            return const Center(child: Text('No expense transactions found.'));
          }

          // Build the list of transactions using a Column
          return Column(
            children: filteredDocs.map((doc) {
              // Create Tracker model from Firestore document
              final track = Tracker(
                name: doc['name'],
                category: doc['category'],
                account: doc['account'],
                amount: double.tryParse(doc['amount'].toString()) ?? 0.0,
                type: doc['type'],
                date: (doc['date'] as Timestamp).toDate(),
                icon: doc['icon'],
              );

              // Format the date
              String formattedDate =
              DateFormat('MMMM d, y').format(track.date!);

              // Return each transaction widget
              return TransactionList(
                track: track,
                formattedDate: formattedDate,
                docID: doc.id,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
