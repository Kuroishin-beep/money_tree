import 'package:flutter/material.dart';

class BudgetBar extends StatelessWidget {
  final double progress;

  BudgetBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    // for font size
    double fs = sw;

    return Container(
      width: sw * 0.03,
      height: sw * 0.65,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffFCF3E3),
          width: 1.5
        ),
          color: Color(0xffF7BC95),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ]
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: sw * 0.03,
              height: progress,
              decoration: BoxDecoration(
                color: Color(0xffFE5D26),
                borderRadius: BorderRadius.circular(20.0)
              ),
            ),
          )
        ],
      ),
    );
  }
}