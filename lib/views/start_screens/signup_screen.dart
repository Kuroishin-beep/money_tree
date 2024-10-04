import 'package:money_tree/views/start_screens/login_screen.dart';
import 'package:flutter/material.dart';


class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                'Sign up to track',
                style: TextStyle(
                  color: Color(0xfffff5e4),
                  fontSize: fs * 0.08,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                'your budget',
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

              // Create Password Section
              Text(
                'Create Password',
                style: TextStyle(
                  color: Color(0xfffff5e4),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: sw * 0.02),
              _createPassTextField(),

              SizedBox(height: sw * 0.07),

              // Confirm Password Section
              Text(
                'Confirm Password',
                style: TextStyle(
                  color: Color(0xfffff5e4),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: sw * 0.02),
              _confirmPassTextField(),

              SizedBox(height: sw * 0.07),

              // Signup Button
              _signupButton(),

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

  Widget _createPassTextField() {
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

  Widget _confirmPassTextField() {
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

  Widget _signupButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
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
        'Sign Up',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      ),
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

}