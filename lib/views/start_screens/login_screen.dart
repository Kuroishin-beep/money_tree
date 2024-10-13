import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:money_tree/views/dashboard/dashboard_screen.dart';
import 'package:money_tree/views/start_screens/loading_screen.dart';
import 'package:money_tree/views/start_screens/signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  if (googleUser == null) {
    throw Exception('Google sign-in was aborted.');
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  String email = '';
  String password = '';
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    return Scaffold(
      backgroundColor: const Color(0xff2882A5),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          padding: EdgeInsets.symmetric(horizontal: sw * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              SizedBox(height: sw * 0.07),
              Text(
                'Log into your',
                style: TextStyle(
                  color: const Color(0xfffff5e4),
                  fontSize: fs * 0.08,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                'account',
                style: TextStyle(
                  color: const Color(0xfffff5e4),
                  fontSize: fs * 0.08,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: sw * 0.07),

              // Email Section
              const Text(
                'Email',
                style: TextStyle(
                  color: Color(0xfffff5e4),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w100,
                ),
              ),
              SizedBox(height: sw * 0.02),
              _emailTextField(),

              SizedBox(height: sw * 0.07),

              // Password Section
              const Text(
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
                    ? const LoadingScreen()
                    : _loginButton(),
              ),

              SizedBox(height: sw * 0.05),

              // Forgot your password Section
              Center(
                child: _forgotPassButton(),
              ),

              SizedBox(height: sw * 0.08),

              // Divider for other Login Options
              const Row(
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
          email = value;
        });
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _passwordTextField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          password = value;
        });
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: false,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
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

        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
          );
        } on FirebaseAuthException catch (e) {
          String errorMessage;

          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'No user found with this email. Please check the email and try again.';
              break;
            case 'wrong-password':
              errorMessage = 'Incorrect password. Please try again.';
              break;
            case 'invalid-email':
              errorMessage = 'The email address is not valid. Please enter a valid email.';
              break;
            case 'user-disabled':
              errorMessage = 'This user account has been disabled. Please contact support.';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many login attempts. Please try again later.';
              break;
            default:
              errorMessage = 'An error occurred. Please try again.';
          }

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Login Error'),
                content: Text(errorMessage),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xfffff5e4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size(double.infinity, 70),
      ),
      child: const Text(
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
          const Placeholder();
        });
      },
      child: const Text(
        "Forgot your password?",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Inter Regular",
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        ),
      ),
    );
  }

  Widget _googleButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          // Sign out the currently signed-in user if any
          await _googleSignIn.signOut();
          await signInWithGoogle();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Dashboard()),
          );
        } catch (e) {
          // Handle errors if necessary
          print(e);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xfffff5e4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size(double.infinity, 70),
      ),
      child: const Text(
        'Log In with Google',
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
        // Handle Facebook sign-in here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xfffff5e4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size(double.infinity, 70),
      ),
      child: const Text(
        'Log In with Facebook',
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
          MaterialPageRoute(builder: (context) => const SignUp()),
        );
      },
      child: const Text(
        "Don't have an account? Sign up",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
