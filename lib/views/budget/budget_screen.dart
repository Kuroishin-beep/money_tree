import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:money_tree/models/tracker_model.dart';
import 'package:money_tree/views/account_details/account_screen.dart';
import 'package:money_tree/views/add_transaction/add_budget_popupscreen.dart';
import 'package:money_tree/views/add_transaction/add_savings_popupscreen.dart';
import 'package:money_tree/views/constants/build_budgetsave_list.dart';
import '../../bottom_navigation.dart';
import '../../controller/tracker_controller.dart';
import '../../fab.dart';
import '../dashboard/dashboard_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});


  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final FirestoreService firestoreService = FirestoreService();

  // get current user
  User? user = FirebaseAuth.instance.currentUser;

  // for calculation
  double? totalBudget = 0;
  double? totalSavings = 0;
  double? budgetAmount = 0;
  double? savingsAmount = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot budgetSnapshot = await FirebaseFirestore.instance
          .collection('budgets')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      QuerySnapshot savingsSnapshot = await FirebaseFirestore.instance
          .collection('savings')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      double totalBudgetTemp = 0;
      double totalSavingsTemp = 0;
      double budgetTemp = 0;
      double savingsTemp = 0;



      // Calculate total budget
      if (budgetSnapshot.docs.isNotEmpty) {
        for (var doc in budgetSnapshot.docs) {
          totalBudgetTemp += doc['totalBudgetAmount'];
          budgetTemp += doc['budgetAmount'];
        }
      }

      // Calculate total savings
      if (savingsSnapshot.docs.isNotEmpty) {
        for (var doc in savingsSnapshot.docs) {
          totalSavingsTemp += doc['totalSavingsAmount'];
          savingsTemp += doc['savingsAmount'];
        }
      }

      // Update state with totals
      setState(() {
        totalBudget = totalBudgetTemp;
        totalSavings = totalSavingsTemp;
        budgetAmount = budgetTemp;
        savingsAmount = savingsTemp;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  // Number format
  final NumberFormat formatter = NumberFormat('#,###.##');

  final String docID = '';


  TextEditingController amountController = TextEditingController();
  TextEditingController budgetController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  int _icon =  0 ;

  // Instance of the model to use for icons
  final Tracker track = Tracker(name: '', budgetAmount: 0, type: 'income', savingsAmount: 0, amount: 0 );


  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: const Color(0xffFBC29C),
          title: const Text(
            'BUDGET',
            style: TextStyle(
                color: Colors.white,
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
          )
      ),

      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xffffffff),
                      Color(0xffFFF5E4)
                    ]
                )
            ),
          ),

          // Main Body
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Month Divider
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(thickness: 1.5, color: Colors.black54),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          _getCurrentMonth().toUpperCase(),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                      ),
                      const Expanded(
                        child: Divider(thickness: 1.5, color: Colors.black54),
                      ),
                    ],
                  ),

                  const SizedBox(height: 3),

                  // Budget Summary Card
                  _buildBudgetSummaryCard(),

                  const SizedBox(height: 3),

                  // Display the list of Budgets
                  StreamBuilder<QuerySnapshot>(
                    stream: firestoreService.getBudgetStream(),
                    builder: (context, snapshot) {
                      // If encountered an error...
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // If there are no transactions available
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No transactions found.'));
                      }

                      return Column(
                        children: snapshot.data!.docs.map((doc) {
                          // Convert each document to Tracker class model
                          final track = Tracker(
                            category: doc['category'],
                            budgetAmount: doc['budgetAmount'],
                            totalBudgetAmount: doc['totalBudgetAmount'],
                            type: doc['type'],
                            icon: doc['icon'],
                          );


                          return BuildBudgetSavelist(
                            budget: track,
                            docID: doc.id,
                          );
                        }).toList(),
                      );
                    },
                  ),

                  // Add Button for Budget
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed:()  {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddBudgetPopupscreen();
                            },
                          );
                        },
                        child: Text(
                          'Add Budget',
                          style: TextStyle(
                              color: Color(0xffFE5D26)
                          ),
                        )
                    ),
                  ),

                  const SizedBox(height: 64),

                  // Savings Summary Card
                  _buildSavingsSummaryCard(),

                  const SizedBox(height: 3),

                  // Display the list of Savings
                  StreamBuilder<QuerySnapshot>(
                    stream: firestoreService.getSavingsStream(),
                    builder: (context, snapshot) {
                      // If encountered an error...
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      // If there are no transactions available
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No transactions found.'));
                      }

                      return Column(
                        children: snapshot.data!.docs.map((doc) {
                          // Convert each document to Tracker class model
                          final track = Tracker(
                            category: doc['category'],
                            savingsAmount: doc['savingsAmount'],
                            totalSavingsAmount: doc['totalSavingsAmount'],
                            type: doc['type'],
                            icon: doc['icon'],
                          );


                          return BuildBudgetSavelist(
                            budget: track,
                            docID: doc.id,
                          );
                        }).toList(),
                      );
                    },
                  ),

                  // Add Button for Savings
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed:()  {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AddSavingsPopupscreen();
                            },
                          );
                        },
                        child: Text(
                          'Add Savings',
                          style: TextStyle(
                              color: Color(0xffFE5D26)
                          ),
                        )
                    ),
                  ),
                  //_buildBudgetCategoryList("INCOME", incomeCategories, false),
                ],
              ),
            ),
          ),],
      ),

      // Navigation bar
      floatingActionButton: FAB(sw: sw),
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


  // Build the Budget Summary Card
  Widget _buildBudgetSummaryCard() {
    double progress = budgetAmount! / totalBudget!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 8),

            const Text(
              "Budget",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              "₱${formatter.format(budgetAmount)} of ₱${formatter.format(totalBudget)}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            // Progress bar
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0), // value is between 0 and 1
              backgroundColor: const Color(0xffFFCDAC),
              color: const Color(0xffFE5D26),
            ),
          ],
        ),
      ),
    );
  }

  // changed the color of linear progress indicator
  Widget _buildSavingsSummaryCard() {
    double progress = savingsAmount! / totalSavings!;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Savings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),
            Text(
              "₱${formatter.format(savingsAmount)} of ₱${formatter.format(totalSavings)}",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 8),

            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0), // Ensure value is between 0 and 1
              backgroundColor: const Color(0xffFFCDAC),
              color: const Color(0xffFE5D26),
            ),
          ],
        ),
      ),
    );
  }

  // // Build the Budget Category List
  // Widget _buildBudgetCategoryList(String title, List<Map<String, dynamic>> categories, bool isExpense) {
  //   List<Map<String, dynamic>> filteredCategories = categories
  //       .where((category) => category['category'] != 'NULL')
  //       .toList();
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
  //       const SizedBox(height: 8),
  //       ...categories.map((category) => _buildCategoryCard(category)),
  //       TextButton(
  //         onPressed: () => _showAddCategoryDialog(isExpense),
  //         child: const Text("Add Card", style: TextStyle(color: Color(0xffFE5D26), fontSize: 16)),
  //       ),
  //     ],
  //   );
  // }

// Function to build month divider
  Widget _buildMonthDivider() {
    return Row(
      children: [
        const Expanded(
          child: Divider(thickness: 1.5, color: Colors.black54),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            _getCurrentMonth().toUpperCase(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
        const Expanded(
          child: Divider(thickness: 1.5, color: Colors.black54),
        ),
      ],
    );
  }


  // Get current month as a string
  String _getCurrentMonth() {
    return DateFormat('MMMM').format(DateTime.now());
  }

  Icon? selected_icon;
  IconData? selectedIconData;

  // Icon picker method
  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [IconPack.material],  // Specify the icon pack you want
      ),
    );

    if (icon != null) {
      setState(() {
        selectedIconData = icon.data;
        selected_icon = Icon(icon.data);

        _icon = selectedIconData!.codePoint;
        // fontFamily = _selectedIconData!.fontFamily;
      });
    }
  }

// Show dialog to edit a category
// void _showEditCategoryDialog(BuildContext context) {
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("EDIT TRANSACTION",
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: Color(0xffFBC29C),
//             fontFamily: 'Inter Regular',
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: amountController,
//               decoration: const InputDecoration(labelText: "Amount"),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: budgetController,
//               decoration: const InputDecoration(labelText: "Budget"),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 10),
//             // Icon Picker Button
//             TextButton.icon(
//               icon: Icon(selectedIconData ?? Icons.add_circle_outline),
//               label: const Text("Pick Icon"),
//               onPressed: () {
//                 _pickIcon();  // Use the provided _pickIcon method
//               },
//             )
//           ],
//         ),
//         actions: [
//           TextButton(
//             child: const Text("Cancel"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           TextButton(
//             child: const Text("Save"),
//             onPressed: () async {
//               Tracker newTrack = Tracker(
//                   category: titleController.text,
//                   savings_amount: double.parse(amountController.text),
//                   total_budgetamount: double.parse(budgetController.text)
//               );
//
//               await firestoreService.updateTrack(docID, newTrack);
//
//               amountController.clear();
//               budgetController.clear();
//
//               Navigator.pop(context);
//
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
// Show dialog to add a new category
// void _showAddCategoryDialog() {
//    // Reset the icon for each new category
//
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//
//     },
//   );
// }
}
