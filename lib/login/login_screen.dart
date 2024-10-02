import 'package:flutter/material.dart';
import 'package:money_tree/dashboard/dashboard_screen.dart';
import 'package:money_tree/loading_screen.dart';
import 'package:money_tree/signup/signup_screen.dart';


class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    return Scaffold(
      backgroundColor: Color(0xff2882A5),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              SizedBox(height: sw * 0.07),
              Text(
                'Log into your',
                style: TextStyle(
                  color: Color(0xfffff5e4),
                  fontSize: fs * 0.08,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                'account',
                style: TextStyle(
                  color: Color(0xfffff5e4),
                  fontSize: fs * 0.08,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),

              SizedBox(height: sw * 0.07),

              // Email Section
              Text(
                'Email',
                style: TextStyle(
                  color: Color(0xfffff5e4),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: sw * 0.02),
              _emailTextField(),        // Email text field

              SizedBox(height: sw * 0.07),

              // Password Section
              Text(
                'Password',
                style: TextStyle(
                  color: Color(0xfffff5e4),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: sw * 0.02),
              _passwordTextField(),

              SizedBox(height: sw * 0.07),

              // Login Button
              Container(
                child: isLoading
                    ? LoadingScreen()
                    : _loginButton(),
              ),

              SizedBox(height: sw * 0.05),

              // Forgot your password Section
              Center(
                child: _forgotPassButton(),
              ),

              SizedBox(height: sw * 0.08),

              // Divider for other Login Options
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      thickness: 2.0,
                      endIndent: 20.0,
                    ),
                  ),
                  Text(
                    'or',
                    style: TextStyle(color: Color(0xfffff5e4)),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.white,
                      thickness: 2.0,
                      indent: 20.0,
                    ),
                  ),
                ],
              ),

              SizedBox(height: sw * 0.08),

              // Google Login Option
              _googleButton(),

              SizedBox(height: sw * 0.05),

              // Facebook Login Option
              _facebookButton(),

              SizedBox(height: sw * 0.08),

              // Signup option Button
              Center(
                child: _signupButton(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          Placeholder();
        });
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _passwordTextField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          Placeholder();
        });
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });

        // Navigate to the LoadingScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoadingScreen()),
        );

        await Future.delayed(Duration(seconds: 2));

        // Navigate to the Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );

        setState(() {
          isLoading = false;
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Color(0xfffff5e4)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 70)),
      ),
      child: Text(
        'Log In',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _forgotPassButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          Placeholder();
        });
      },
      child: Text(
        "Forgot your password?",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Inter Regular",
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white
        ),
      )
    );
  }

  Widget _googleButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          Placeholder();
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Color(0xfffff5e4)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 70)),
      ),
      child: Text(
        'Google',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _facebookButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          Placeholder();
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Color(0xfffff5e4)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 70)),
      ),
      child: Text(
        'Facebook',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _signupButton() {
    return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUp()),
          );
          setState(() {
            Placeholder();
          });

        },
        child: Text(
          "Need an account? Sign up",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Inter Regular",
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white
          ),
        )
    );
  }
}