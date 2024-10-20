import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import '../constants/bottom_navigation.dart';
import '../../controller/tracker_controller.dart';
import '../constants/fab.dart';
import '../account_details/account_screen.dart';
import '../constants/build_transaction_list.dart';

import '../../models/tracker_model.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryDataListState createState() => HistoryDataListState();
}

class HistoryDataListState extends State<HistoryScreen> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  // for displaying all income and expenses
  bool _showIncome = false;
  bool _showExpense = false;

  @override
  void initState() {
    super.initState();
    _getUserProfileImage();
  }

  String? _profileImage;

  // Get user profile image
  Future<void> _getUserProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the user is authenticated with Google
      if (user.photoURL != null) {
        setState(() {
          _profileImage = user.photoURL;
        });
      } else {
        // If not using Google account, retrieve profile image from Firestore
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          _profileImage = userData['profileImage'];
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
          backgroundColor: const Color(0xffFFF8ED),
          title: const Text(
            'HISTORY',
            style: TextStyle(
                color: Color(0XFF639DF0),
                fontFamily: 'Inter Regular',
                fontWeight: FontWeight.w800
            ),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountScreen()),
                );
              },
              child: CircleAvatar(
                backgroundImage: _profileImage != null
                    ? NetworkImage(_profileImage!)
                    : const AssetImage('lib/images/pfp.jpg') as ImageProvider,
                radius: 20,
              ),
            ),
            SizedBox(width: 16),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0XFF639DF0)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            },
          )
      ),

      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xffFFF8ED),
                  Color(0xffABC5EA),
                ],
              ),
            ),
          ),

          // Main Body
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  // Search Bar
                  _searchBar(),

                  SizedBox(height: sw * 0.05),

                  // Expenses section
                  Row(
                    children: [
                      const Expanded(
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
                      const Expanded(
                        child: Divider(
                          color: Color(0xff093F40),
                          thickness: 1.3,
                          indent: 20.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sw * 0.025),

                  // List of Expenses from Firestore
                  StreamBuilder<QuerySnapshot>(
                    stream: firestoreService.getExpenseStream(),
                    builder: (context, snapshot) {
                      // If encountered an error...
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // If there are no transactions available
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No transactions found.'));
                      }

                      // Filter the documents to only include those with 'expenses' type
                      final filteredDocs = snapshot.data!.docs.where((doc) {
                        return doc['type'] == 'expenses';
                      }).toList();

                      // Sort the filtered documents by date in descending order (newest first)
                      filteredDocs.sort((a, b) {
                        final dateA = (a['date'] as Timestamp).toDate();
                        final dateB = (b['date'] as Timestamp).toDate();
                        return dateB.compareTo(dateA); // Sort by date descending
                      });

                      // If no expense transactions exist
                      if (filteredDocs.isEmpty) {
                        return const Center(child: Text('No expense transactions found.'));
                      }

                      // Limit the displayed transactions to a maximum of 3
                      final limitedDocs = _showExpense ? filteredDocs : filteredDocs.take(3).toList();

                      return Column(
                        children: limitedDocs.map((doc) {
                          // Convert each document to Tracker class model
                          final track = Tracker(
                            name: doc['name'],
                            category: doc['category'],
                            account: doc['account'],
                            amount: double.tryParse(doc['amount'].toString()) ?? 0.0,
                            type: doc['type'],
                            date: (doc['date'] as Timestamp).toDate(),
                            icon: doc['icon'],
                          );

                          // Format the date to display only the date portion
                          String formattedDate = DateFormat('MMMM d, y').format(track.date!);

                          return TransactionList(
                            track: track,
                            formattedDate: formattedDate,
                            docID: doc.id,
                          );
                        }).toList(),
                      );
                    },
                  ),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showExpense = !_showExpense;
                      });
                    },
                    child: Text(_showExpense ? 'Show less' : 'See all'),
                  ),

                  SizedBox(height: sw * 0.05),

                  // Income section
                  Row(
                    children: [
                      const Expanded(
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
                      const Expanded(
                        child: Divider(
                          color: Color(0xff093F40),
                          thickness: 1.3,
                          indent: 20.0,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: sw * 0.025),

                  // List of Income from Firestore
                  StreamBuilder<QuerySnapshot>(
                    stream: firestoreService.getIncomeStream(),
                    builder: (context, snapshot) {
                      // If encountered an error...
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // If there are no transactions available
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No transactions found.'));
                      }

                      // Filter the documents to only include those with 'income' type
                      final filteredDocs = snapshot.data!.docs.where((doc) {
                        return doc['type'] == 'income';
                      }).toList();

                      // Sort the filtered documents by date in descending order (newest first)
                      filteredDocs.sort((a, b) {
                        final dateA = (a['date'] as Timestamp).toDate();
                        final dateB = (b['date'] as Timestamp).toDate();
                        return dateB.compareTo(dateA); // Sort by date descending
                      });

                      // If no income transactions exist
                      if (filteredDocs.isEmpty) {
                        return const Center(child: Text('No income transactions found.'));
                      }

                      // Limit the displayed transactions to a maximum of 3
                      final limitedDocs = _showIncome ? filteredDocs : filteredDocs.take(3).toList();

                      return Column(
                        children: limitedDocs.map((doc) {
                          // Convert each document to Tracker class model
                          final track = Tracker(
                            name: doc['name'],
                            category: doc['category'],
                            account: doc['account'],
                            amount: double.tryParse(doc['amount'].toString()) ?? 0.0,
                            type: doc['type'],
                            date: (doc['date'] as Timestamp).toDate(),
                            icon: doc['icon'],
                          );

                          // Format the date to display only the date portion
                          String formattedDate = DateFormat('MMMM d, y').format(track.date!);

                          return TransactionList(
                            track: track,
                            formattedDate: formattedDate,
                            docID: doc.id,
                          );
                        }).toList(),
                      );
                    },
                  ),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showIncome = !_showIncome;
                      });
                    },
                    child: Text(_showIncome ? 'Show less' : 'See all'),
                  ),

                  SizedBox(height: sw * 0.04),
                ],
              ),
            ),
          )
        ],
      ),

      // Navigation bar
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //FAB
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
            dashboard: Colors.white,
            fReport: Colors.white,
            history: Color(0xffFE5D26),
            settings: Colors.white
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
            offset: const Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          fillColor: const Color(0xffFFF8ED),
          filled: true,
          hintText: 'Date, Category, Price',
          hintStyle: const TextStyle(
              color: Color(0xff545454),
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300
          ),
          suffixIcon: const Icon(
            Icons.search,
            color: Color(0xff545454),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
          ),
        ),
      ),
    );
  }


}