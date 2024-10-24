import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:money_tree/controller/tracker_controller.dart';
import 'package:money_tree/models/tracker_model.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import '../constants/bottom_navigation.dart';
import '../constants/fab.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class NewExpenseScreen extends StatefulWidget {
  const NewExpenseScreen({super.key});

  @override
  State<NewExpenseScreen> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends State<NewExpenseScreen> {

  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  // text field controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // get current user
  User? user = FirebaseAuth.instance.currentUser;

  // for popup menu
  List<String> predefinedValues = [];
  String selectedValue = '';

  // for fetching category
  String? fetchCategory= '';

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchExistingCategories();
  }

  Future<void> fetchData() async {
    try {
      // Fetch categories from the Firestore categories collection
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('UserEmail', isEqualTo: user!.email)
          .get();

      List<String> categoryTempList = [];

      // Collect category names
      for (var doc in categorySnapshot.docs) {
        // Assuming categoriesArray is an array of strings
        if (doc['categoriesArray'] is List) {
          List<String> categories = List<String>.from(doc['categoriesArray']);
          categoryTempList.addAll(categories); // Append categories to the list
        } else {
          print('Error: categoriesArray is not a list for document ID: ${doc.id}');
        }
      }

      // Update state with fetched categories
      setState(() {
        predefinedValues = categoryTempList; // Assign the list of categories to predefinedValues
      });

      print('Fetched categories: $predefinedValues'); // Debug print to see fetched categories
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  List<String> existingCategories = [];

  Future<void> fetchExistingCategories() async {
    try {
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance.collection('categories').get();
      existingCategories.clear();

      for (var doc in categorySnapshot.docs) {
        // Assuming categoriesArray is an array of strings in your Firestore
        List<String> categories = List<String>.from(doc['categoriesArray']);
        existingCategories.addAll(categories);
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }


  // Variable to hold the selected account
  String selectedAccount = '';


  // for Icon picker
  Icon? _icon;
  IconData? _selectedIconData;
  int code = 0;


  // Icon picker function
  _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [IconPack.material],
      ),
    );

    if (icon != null) {
      setState(() {
        _selectedIconData = icon.data;
        _icon = Icon(
          icon.data,
          size: 30,
          color: const Color(0xffF4A26B),
        );

        code = _selectedIconData!.codePoint;
        // fontFamily = _selectedIconData!.fontFamily;
      });
    }
  }

  // Select date function
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100)
    );

    if(picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'ADD TRANSACTION',
            style: TextStyle(
                color: Color(0XFFF4A26B),
                fontFamily: 'Inter Regular',
                fontWeight: FontWeight.w800
            ),
          ),
          centerTitle: true,
          actions: const [
            CircleAvatar(
              backgroundImage: AssetImage(
                  'lib/images/pfp.jpg'),
              radius: 20,
            ),
            SizedBox(width: 16),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0XFFF4A26B)),
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
                  Color(0xffFFFFFF),
                  Color(0xffFFF5E4),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: sw * 0.01, horizontal: sw * 0.05),
              child: Column(
                children: [
                  Column(
                    children: [

                      // OPTIONS: New Income or New Expenses
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // First Column for "NEW INCOME"
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const NewIncomeScreen()
                                      )
                                  );
                                },
                                child: Text(
                                  "NEW INCOME",
                                  style: TextStyle(
                                    fontSize: fs * 0.04,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sw * 0.3,
                                child: const Divider(
                                  color: Color(0xFF093F40),
                                  thickness: 1.0,
                                ),
                              ),
                            ],
                          ),

                          // Second Column for "NEW EXPENSE"
                          Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const NewExpenseScreen()
                                      )
                                  );
                                },
                                child: Text(
                                  "NEW EXPENSES",
                                  style: TextStyle(
                                    fontSize: fs * 0.04,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sw * 0.3,
                                child: const Divider(
                                  color: Color(0xFF093F40),
                                  thickness: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Amount Textfield
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: sw * 0.1),
                            child: Container(
                                width: sw * 0.17,
                                height: sw * 0.08,
                                decoration: BoxDecoration(
                                    color: const Color(0xffFFF8ED),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 4)
                                      )
                                    ]
                                ),
                                child: Center(
                                  child: Text(
                                    'Php',
                                    style: TextStyle(
                                        color: const Color(0xffF4A26B),
                                        fontWeight: FontWeight.w700,
                                        fontSize: fs * 0.04
                                    ),
                                  ),
                                )
                            ),
                          ),
                          SizedBox(width: sw * 0.05),
                          Expanded(
                            child: _addAmount(sw, fs),
                          ),
                        ],
                      ),

                      // Item Textfield
                      _addItem(sw, fs),

                      SizedBox(height: sw * 0.01),

                      // Date Textfield
                      _addDate(sw, fs),

                      SizedBox(height: sw * 0.05),

                      // From which account
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('From account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 17)),
                      ),

                      // Account Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _fromCashButton(sw, fs),
                          _fromCardButton(sw, fs),
                          _fromGCashButton(sw, fs)
                        ],
                      ),

                      SizedBox(height: sw * 0.1),

                      // // From which category
                      // const Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Text('From category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 17)),
                      // ),

                      // Category Buttons
                      _addCategory(sw, fs),

                      SizedBox(height: sw * 0.05),

                      // Confirm Button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _confirmButton(sw, fs)
                        ],
                      ),




                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),

      // FAB
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      //Navigation bar
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
            dashboard: Colors.white,
            fReport: Colors.white,
            history: Colors.white,
            settings: Colors.white
        ),
      ),
    );
  }


  Widget _addAmount(double sw, double fs) {
    return TextField(
      controller: _amountController,
      style: TextStyle(
          color: Colors.black,
          fontSize: fs * 0.08,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter Regular',
          letterSpacing: 2.0
      ),
      decoration: const InputDecoration(
        filled: false,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _addItem(double sw, double fs) {
    return SizedBox(
      width: sw * 0.6,
      child: TextField(
        controller: _nameController,
        style: TextStyle(
            fontSize: fs * 0.05,
            fontWeight: FontWeight.w700
        ),
        decoration: InputDecoration(
          labelText: 'Item Name',
          labelStyle: TextStyle(
              fontSize: fs * 0.05,
              color: Colors.grey
          ),
          prefixIcon: Icon(
            Icons.edit_note,
            size: 35,
            color: Color(0xffF4A26B),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _addDate(double sw, double fs) {
    return SizedBox(
      width: sw * 0.6,
      child: TextField(
        onTap: () {
          _selectDate();
        },
        controller: _dateController,
        readOnly: true,
        style: TextStyle(
            fontSize: fs * 0.05,
            fontWeight: FontWeight.w700
        ),
        decoration: InputDecoration(
          labelText: 'Date',
          labelStyle: TextStyle(
            fontSize: fs * 0.05,
            color: Colors.grey
          ),
          prefixIcon: Icon(
            Icons.calendar_today_rounded,
            size: 30,
            color: Color(0xffF4A26B),
          ),
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xffF4A26B)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _addCategory(double sw, double fs) {
    return SizedBox(
      width: sw * 0.7,
      child: TextField(
        controller: _categoryController,
        style: TextStyle(
          fontSize: fs * 0.05,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          labelText: 'Category',
          labelStyle: TextStyle(
            fontSize: fs * 0.05,
            color: Colors.grey,
          ),
          suffixIcon: PopupMenuButton<String>(
            icon: Icon(Icons.arrow_drop_down),
            onSelected: (String value) {
              setState(() {
                selectedValue = value;
                _categoryController.text = value;
              });
            },
            itemBuilder: (BuildContext context) {
              if (predefinedValues.isEmpty) {
                return [
                  const PopupMenuItem<String>(
                    enabled: false,
                    child: Text('No Categories'),
                  ),
                ];
              }
              return predefinedValues.map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          ),
          prefixIcon: IconButton(
            onPressed: () async {
              _pickIcon();
            },
            icon: Icon(
              _selectedIconData ?? Icons.add_circle_outline,
              size: 40,
              color: const Color(0xffF4A26B),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.4),
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }



  Widget _fromCashButton(double sw, double fs) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedAccount = 'CASH';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedAccount == 'CASH' ? Color(0xffF4A26B) : const Color(0xFFFAF3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Text(
        'CASH',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: sw * 0.05),
      ),
    );
  }

  Widget _fromCardButton(double sw, double fs) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedAccount = 'CARD';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedAccount == 'CARD' ? Color(0xffF4A26B) : const Color(0xFFFAF3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Text(
        'CARD',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: sw * 0.05),
      ),
    );
  }

  Widget _fromGCashButton(double sw, double fs) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedAccount = 'GCASH';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedAccount == 'GCASH' ? Color(0xffF4A26B) : const Color(0xFFFAF3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Text(
        'GCASH',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: sw * 0.05),
      ),
    );
  }

  Widget _confirmButton(double sw, double fs) {
    return ElevatedButton(
      onPressed: () async {
        if (_amountController.text.isEmpty ||
            _categoryController.text.isEmpty ||
            _nameController.text.isEmpty ||
            _dateController.text.isEmpty ||
            selectedAccount.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all fields before proceeding.'),
            ),
          );
          return;
        } else if (_selectedIconData == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please pick an icon before proceeding.'),
            ),
          );
          return;
        }

        DateTime selectedDate = DateTime.parse(_dateController.text);

        Tracker newTrack = Tracker(
          name: _nameController.text.toLowerCase(),
          category: _categoryController.text ?? selectedValue,
          account: selectedAccount,
          amount: double.parse(_amountController.text),
          type: 'expenses',
          date: selectedDate,
          icon: code,
        );

        await firestoreService.addExpense(newTrack);

        String category = _categoryController.text.toUpperCase(); // Use uppercase for uniformity

        // Check if category already exists
        if (!existingCategories.contains(category)) {
          List<String> categories = [category];
          await firestoreService.addCategory(categories);
          existingCategories.add(category); // Add to the local list
        }

        _amountController.clear();
        _nameController.clear();
        _categoryController.clear();
        _dateController.clear();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Dashboard()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFEACA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Text(
        'CONFIRM',
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: sw * 0.05),
      ),
    );
  }
}