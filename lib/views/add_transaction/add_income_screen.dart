import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:money_tree/views/add_transaction/add_expenses_screen.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import '../constants/bottom_navigation.dart';
import '../../controller/tracker_controller.dart';
import '../constants/fab.dart';
import '../../models/tracker_model.dart';

class NewIncomeScreen extends StatefulWidget {
  const NewIncomeScreen({super.key});

  @override
  State<NewIncomeScreen> createState() => _NewIncomeScreenState();
}

class _NewIncomeScreenState extends State<NewIncomeScreen> {
  // call firestore service
  final FirestoreService firestoreService = FirestoreService();

  // Variable to hold the selected account & default category
  String selectedAccount = '';

  // for icons
  IconData? _selectedIconData;
  int code = 0;


  // text field controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();



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
                                  onPressed: () {},
                                  child: Text(
                                    "NEW INCOME",
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
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black,
                                        height: sw * 0.001
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

                        SizedBox(height: sw * 0.15),

                        // Confirm Button
                        _confirmButton(sw, fs)


                      ],
                    ),
                  ],
                ),
              )
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

  Widget _fromCashButton(double sw, double fs) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedAccount = 'CASH';
          _selectedIconData = Icons.attach_money_rounded;
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
          _selectedIconData = Icons.credit_card;
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
          _selectedIconData = Icons.money_rounded;
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
            _nameController.text.isEmpty ||
            _dateController.text.isEmpty ||
            selectedAccount.isEmpty) {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please fill all fields before proceeding.'),
              //backgroundColor: Colors.red,
            ),
          );
          return;
        }

        DateTime selectedDate = DateTime.parse(_dateController.text);
        code = _selectedIconData!.codePoint;

        Tracker newTrack = Tracker(
            name: _nameController.text.toLowerCase(),
            category: 'NULL',
            account: selectedAccount,
            amount: double.parse(_amountController.text),
            type: 'income',
            date: selectedDate,
            icon: code
        );

        await firestoreService.addIncome(newTrack);

        _amountController.clear();
        _nameController.clear();
        _dateController.clear();

        setState(() {
          selectedAccount = '';
          _selectedIconData = null;
        });

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Dashboard()));

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFAF3E0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      child: Text(
        'CONFIRM',
        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87, fontSize: sw * 0.05),
      ),
    );
  }
}