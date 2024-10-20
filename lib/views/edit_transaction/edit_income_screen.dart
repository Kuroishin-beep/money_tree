import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/bottom_navigation.dart';
import '../../controller/tracker_controller.dart';
import '../constants/fab.dart';
import '../../models/tracker_model.dart';


class EditIncomeScreen extends StatefulWidget {
  final String docID;
  const EditIncomeScreen({super.key, required this.docID});

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
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
  DateTime? _selectedDate;

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
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
          backgroundColor: const Color(0xffFFF8ED),
          title: const Text(
            'EDIT TRANSACTION',
            style: TextStyle(
                color: Color(0XFF639DF0),
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
            icon: const Icon(Icons.arrow_back, color: Color(0XFF639DF0)),
            onPressed: () {
              Navigator.pop(context);
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
              padding: EdgeInsets.symmetric(vertical: sw * 0.03, horizontal: sw * 0.05),
              child: Column(
                children: [
                  Column(
                    children: [

                      // Text for INCOME
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color(0xff093F40),
                              thickness: 1.3,
                              indent: 60.0,
                              endIndent: 10.0,
                            ),
                          ),
                          Text(
                            'INCOME',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: fs * 0.04,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Color(0xff093F40),
                              thickness: 1.3,
                              indent: 10.0,
                              endIndent: 60.0,
                            ),
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
                                        color: const Color(0xff639DF0),
                                        fontWeight: FontWeight.w700,
                                        fontSize: fs * 0.04
                                    ),
                                  ),
                                )
                            ),
                          ),
                          SizedBox(width: sw * 0.05),
                          Expanded(
                            child: _editAmount(sw, fs),
                          ),
                        ],
                      ),

                      // Item Textfield
                      _editItem(sw, fs),

                      SizedBox(height: sw * 0.02),

                      // Date Textfield
                      _editDate(sw, fs),

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

                      SizedBox(height: sw * 0.2),


                      // Confirm Button
                      _confirmButton(sw, fs)


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


  Widget _editAmount(double sw, double fs) {
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

  Widget _editItem(double sw, double fs) {
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
            color: Color(0xff9A9BEB),
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

  Widget _editDate(double sw, double fs) {
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
            color: Color(0xff9A9BEB),
          ),
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xff9A9BEB)),
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
        backgroundColor: selectedAccount == 'CASH' ? Color(0xff9A9BEB) : const Color(0xFFFAF3E0),
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
        backgroundColor: selectedAccount == 'CARD' ? Color(0xff9A9BEB) : const Color(0xFFFAF3E0),
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
        backgroundColor: selectedAccount == 'GCASH' ? Color(0xff9A9BEB) : const Color(0xFFFAF3E0),
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


        DateTime selectedDate = DateTime.parse(_dateController.text);
        code = _selectedIconData!.codePoint;

        Tracker newTrack = Tracker(
          name: _nameController.text,
          category: 'NULL',
          account: selectedAccount,
          amount: double.parse(_amountController.text),
          type: 'income',
          date: _selectedDate,
          icon: code
        );

        await firestoreService.updateIncome(widget.docID, newTrack);

        _amountController.clear();
        _nameController.clear();
        _dateController.clear();

        Navigator.pop(context);
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
