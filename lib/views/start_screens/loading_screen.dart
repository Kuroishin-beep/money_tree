import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    return Scaffold(
      backgroundColor: const Color(0xff013D5A),
      body: Padding(
        padding: EdgeInsets.only(top: sw * 0.85),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    heightFactor: 0.9,
                    widthFactor: 0.7,
                    child: Image.asset(
                      'lib/images/tree_logo.jpg',
                      width: sw * 0.4,
                      height: sw * 0.4,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: sw * 0.09),
                    Text(
                      'MANAGE',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter Regular',
                          fontSize: fs *0.05,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      'YOUR',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter Regular',
                          fontSize: fs *0.05,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      'FINANCES',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter Regular',
                          fontSize: fs *0.05,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Text(
                      'EASILY',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Inter Regular',
                          fontSize: fs *0.05,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: sw * 0.05),


            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                minHeight: 5,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ],
        )

      ),
    );
  }
}
