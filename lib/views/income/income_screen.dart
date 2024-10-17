import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../bottom_navigation.dart';
import '../../controller/tracker_controller.dart';
import '../../fab.dart';
import '../account_details/account_screen.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:money_tree/models/tracker_model.dart';
import '../constants/build_transaction_list.dart';
import 'package:intl/intl.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  List<Tracker> trackerData = [
    Tracker(name: 'Freelance', account: 'CARD', amount: 250, type: 'income'),
    Tracker(name: 'XYZ Company', account: 'CASH', amount: 250, type: 'income'),
  ];

  // Get current month as a string
  String _getCurrentMonth() {
    return DateFormat('MMMM').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery
        .of(context)
        .size
        .width;
    double fs = sw;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff90B388),
        title: const Text(
          'INCOME',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter Regular',
            fontWeight: FontWeight.w800,
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
              backgroundImage: AssetImage(
                  'lib/images/pfp.jpg'),
              radius: 20,
            ),
          ),
          SizedBox(width: 16),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffffffff), Color(0xffFFF5E4)],
              ),
            ),
          ),

          // Main Body
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: sw * 0.05, horizontal: sw * 0.04),
              child: Column(
                children: [

                  // Month Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: Color(0xff093F40),
                          thickness: 2.0,
                          endIndent: 20.0,
                        ),
                      ),
                      Text(
                        _getCurrentMonth().toUpperCase(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fs * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          color: Color(0xff093F40),
                          thickness: 2.0,
                          indent: 20.0,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: sw * 0.04),

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

                      // If no income transactions exist
                      if (filteredDocs.isEmpty) {
                        return const Center(child: Text('No transactions found.'));
                      }

                      return Column(
                        children: filteredDocs.map((doc) {
                          // Convert each document to Tracker class model
                          final track = Tracker(
                            name: doc['name'],
                            category: doc['category'],
                            account: doc['account'],
                            amount: double.tryParse(doc['amount'].toString()) ?? 0.0,
                            type: doc['type'],
                            date: (doc['date'] as Timestamp).toDate(),
                            icon: doc['icon']
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      // Navigation bar
      floatingActionButton: FAB(sw: sw),
      // Use the FAB widget
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //FAB
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
            dashboard: Color(0xffFE5D26),
            fReport: Colors.white,
            history: Colors.white,
            settings: Colors.white
        ),
      ),
    );
  }
}