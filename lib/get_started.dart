import 'package:flutter/material.dart';
import 'package:budget_tracker/login/login.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    // for font size
    double fs = sw;

    return Scaffold(
      backgroundColor: Color(0xff001219),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric( horizontal: sw * 0.05, vertical: sw * 0.07),
            child: Column(

              children: [
                Container(
                  child: Image.asset('images/tree (1).png',
                      width: double.infinity,
                      height: 650
                  ),
                ),

                Text(
                  'MANAGE YOUR',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'
                  ),
                ),
                Text('FINANCES EASILY',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter'
                  ),
                ),
                SizedBox(height: 20),
                Text('Start Managing Your Personal Finances',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fs * 0.047,
                      fontFamily: 'Inter'
                  ),
                ),
                Text('And Set Personal Goals',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fs * 0.047,
                      fontFamily: 'Inter'
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xfffff5e4)),
                        shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                        minimumSize: MaterialStateProperty.all(Size(350, 70))
                    ),
                    child: Text('Get Started',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                )
              ],
            )
        ),
      )
    );
  }
}
