import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress1;
  final double progress2;

  const ProgressBar({super.key, 
    required this.progress1,
    required this.progress2,

  });

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    // for font size
    double fs = sw;

    return Column(
      children: [
        Container(
            width: sw * 0.8,
            height: sw * 0.09,
            decoration: BoxDecoration(
              color: const Color(0xffE6BFCE),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  width: progress1,
                  height: sw * 0.8,
                  decoration: BoxDecoration(
                      color: const Color(0xffCA498C),
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.02),
                    child: Text(
                      'EXPENSES ${progress1-170} %',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  )
              ),
            )
        ),

        SizedBox(height: sw * 0.02),

        Container(
          width: sw * 0.8,
          height: sw * 0.09,
          decoration: BoxDecoration(
            color: const Color(0xffC8C9E9),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child:Align(
            alignment: Alignment.centerLeft,
            child: Container(
                width: progress2,
                height: sw * 0.8,
                decoration: BoxDecoration(
                    color: const Color(0xff03045E),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.02),
                  child: Text(
                    'INCOME ${progress2-200} %',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                )
            ),
          ),
        )
      ],
    );
  }
}
