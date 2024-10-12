import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:table_calendar/table_calendar.dart'; // Import the TableCalendar package
import '../../bottom_navigation.dart';
import '../../fab.dart';

class AccountBirthdateScreen extends StatefulWidget {
  const AccountBirthdateScreen({super.key});

  @override
  _AccountBirthdateScreenState createState() => _AccountBirthdateScreenState();
}

class _AccountBirthdateScreenState extends State<AccountBirthdateScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime _selectedDate = DateTime.now(); // Initialize selected date
  DateTime _focusedDate = DateTime.now(); // Control focused date for calendar

  @override
  void initState() {
    super.initState();
    _fetchBirthdate(); // Fetch the birthdate when the screen loads
  }

  Future<void> _fetchBirthdate() async {
    User? user = _auth.currentUser; // Get the currently authenticated user

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc['birthday'] != null) {
        // Change 'birthdate' to 'birthday'
        String birthdateStr = userDoc['birthday'];
        DateTime birthdate = DateTime.parse(birthdateStr); // Parse string to DateTime
        setState(() {
// Set the fetched birthday
          _selectedDate = birthdate; // Set selected date to fetched birthday
          _focusedDate = birthdate; // Focus the calendar on the fetched birthday
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user is logged in.')));
    }
  }

  Future<void> _saveBirthdate() async {
    User? user = _auth.currentUser; // Get the currently authenticated user
    if (user != null) {
      // Format the birthdate to YYYY-MM-DD
      String formattedBirthday = DateFormat('yyyy-MM-dd').format(_selectedDate); // Format the date
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'birthday': formattedBirthday, // Save the formatted birthday
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Birthday updated successfully.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No user is logged in.')));
    }
  }

  // Method to show month-year picker dialog
  Future<void> _showMonthYearPicker() async {
    int selectedYear = _focusedDate.year;
    int selectedMonth = _focusedDate.month;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Month and Year'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Year Dropdown
              DropdownButton<int>(
                value: selectedYear,
                items: List.generate(100, (index) => 2024 - index)
                    .map<DropdownMenuItem<int>>((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text('$year'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                  });
                },
              ),
              // Month Dropdown
              DropdownButton<int>(
                value: selectedMonth,
                items: List.generate(12, (index) => index + 1)
                    .map<DropdownMenuItem<int>>((int month) {
                  return DropdownMenuItem<int>(
                    value: month,
                    child: Text(DateFormat.MMMM().format(DateTime(0, month))),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedMonth = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _focusedDate = DateTime(selectedYear, selectedMonth, 1);
                  _selectedDate = DateTime(selectedYear, selectedMonth, _selectedDate.day);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFFF5E4),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xffF4A26B)),
          onPressed: () {
            Navigator.pop(context);
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
                colors: [Color(0xffFFF5E4), Color(0xffE7BA9C)],
              ),
            ),
          ),
          // Main Body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Birthday Details',
                  style: TextStyle(
                    color: Color(0xffF4A26B),
                    fontFamily: 'Inter Regular',
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                  ),
                ),
                const SizedBox(height: 30),
                // Full Calendar with clickable title for month-year picker
                TableCalendar(
                  firstDay: DateTime(1900),
                  lastDay: DateTime.now(),
                  focusedDay: _focusedDate,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDate), // Check if the day is selected
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay; // Update the selected date
                      _focusedDate = focusedDay; // Focus on the selected day
                    });
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false, // Hide the format button (day/week)
                    titleCentered: true, // Center the title (Month and Year)
                    leftChevronVisible: true, // Show previous month button
                    rightChevronVisible: true, // Show next month button
                    leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xffF4A26B)), // Customize left button
                    rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xffF4A26B)), // Customize right button
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: const BoxDecoration(
                      color: Color(0xffF4A26B),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerVisible: true,
                  onHeaderTapped: (DateTime date) {
                    _showMonthYearPicker(); // Trigger month-year picker on header tap
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveBirthdate, // Save the birthday
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffF4A26B), // Button color
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // FAB
      floatingActionButton: FAB(sw: sw),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Navigation bar
      bottomNavigationBar: const SizedBox(
        height: 70,
        child: NavBottomAppBar(
          dashboard: Colors.white,
          fReport: Colors.white,
          history: Colors.white,
          settings: Color(0xffFE5D26),
        ),
      ),
    );
  }
}
