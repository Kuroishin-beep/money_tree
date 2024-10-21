import 'package:flutter/material.dart';
import 'package:money_tree/views/add_transaction/add_income_screen.dart';


class FAB extends StatelessWidget {
  final double sw; // Add a parameter for screen width

  const FAB({super.key, required this.sw});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: sw * 0.04), // Adjust the value as needed
      child: SizedBox(
        height: 70, // Set height
        width: 70, // Set width
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewIncomeScreen(),
              ),
            );
          },
          backgroundColor: const Color(0xffFFF8ED),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 40, // Icon size
            color: Color(0xffE63636),
          ),
        ),
      ),
    );
  }
}