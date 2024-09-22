import 'package:budget_tracker/login/login.dart';
import 'package:flutter/material.dart';


class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff001219),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20.0, top: 40.0),
              child: Text(
                'Sign up to track\nyour budget',
                style: TextStyle(
                  color: Color(0xfffff5e4),
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.05, vertical: sw * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  // Email Section
                  Text(
                    'Email',
                    style: TextStyle(
                      color: Color(0xfffff5e4),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.5
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.5
                          )
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 30),

                  // Passwords Section
                  Text(
                    'Create Password',
                    style: TextStyle(
                      color: Color(0xfffff5e4),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.5
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.5
                          )
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                      color: Color(0xfffff5e4),
                      fontSize: 18.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: false,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.5
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.5
                          )
                      ),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                  ),

                  // Sign up Button Section
                  Container(
                    padding: EdgeInsets.only(top: 30.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Login()));
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xfffff5e4)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                            ),
                            minimumSize: MaterialStateProperty.all(Size(sw * 1.0, 70))
                        ),
                        child: Text('Sign Up',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900
                          ),
                        )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 25.0, bottom: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1.0,
                              endIndent: 20.0,
                            )
                        ),
                        Text('or',
                          style: TextStyle(color: Color(0xfffff5e4)),
                        ),
                        Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 1.0,
                              indent: 20.0,
                            )
                        )
                      ],
                    ),
                  ),

                  // Google Button Section
                  Container(
                    padding: EdgeInsets.only(top: 30.0),
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xfffff5e4)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                            ),
                            minimumSize: MaterialStateProperty.all(Size(sw * 1.0, 70))
                        ),
                        child: Text('Google',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900
                          ),
                        )
                    ),
                  ),

                  // Facebook Button Section
                  Container(
                    padding: EdgeInsets.only(top: 30.0),
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xfffff5e4)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                            ),
                            minimumSize: MaterialStateProperty.all(Size(sw * 1.0, 70))
                        ),
                        child: Text('Facebook',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}