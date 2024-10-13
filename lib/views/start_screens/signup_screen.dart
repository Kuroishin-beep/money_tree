import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In
import 'package:money_tree/views/start_screens/ProfileSetupScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

Future<void> loginWithFacebook() async {
  try {
    final LoginResult result = await FacebookAuth.instance.login();
    
    if (result.status == LoginStatus.success) {
      // User is logged in
      final AccessToken? accessToken = result.accessToken;
      print('Logged in! ${accessToken?.token}');
    } else {
      print('Login failed: ${result.status}, ${result.message}');
    }
  } catch (e) {
    print('Error during Facebook login: $e');
  }
}
class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Initialize Google Sign-In

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double fs = sw;

    return Scaffold(
      backgroundColor: const Color(0xff2882A5),
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
                  color: const Color(0xfffff5e4),
                  fontSize: fs * 0.08,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              Text(
                'your budget',
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
              _emailTextField(), // Email text field

              SizedBox(height: sw * 0.07),

              // Create Password Section
              const Text(
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
              const Text(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return TextField(
      controller: _emailController,
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

  Widget _createPassTextField() {
    return TextField(
      controller: _passwordController,
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

  Widget _confirmPassTextField() {
    return TextField(
      controller: _confirmPasswordController,
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

  Widget _signupButton() {
    return ElevatedButton(
      onPressed: () async {
        String email = _emailController.text.trim();
        String password = _passwordController.text.trim();
        String confirmPassword = _confirmPasswordController.text.trim();

        if (password != confirmPassword) {
          // Show an error message
          _showErrorDialog("Passwords do not match");
          return;
        }

        try {
          // Create user with email and password
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Add user information to Firestore
          await _firestore.collection('users').doc(userCredential.user?.uid).set({
            'email': email,
            // Add other user details as needed
          });

          // After successful sign-up
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
          );

        } catch (e) {
          // Handle error
          _showErrorDialog(e.toString());
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xfffff5e4)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 70)),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _googleButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          // Sign out the currently signed-in user if any
          await _googleSignIn.signOut();

          // Sign in with Google
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

          if (googleUser != null) {
            final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            // Sign in to Firebase
            UserCredential userCredential = await _auth.signInWithCredential(credential);

            // Check if the user is new or existing
            if (userCredential.additionalUserInfo?.isNewUser ?? false) {
              // Add user information to Firestore
              await _firestore.collection('users').doc(userCredential.user?.uid).set({
                'email': googleUser.email,
                // Add other user details as needed
              });
            }

            // After successful sign-in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
            );
          }
        } catch (e) {
          // Handle error
          _showErrorDialog(e.toString());
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xfffff5e4)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 70)),
      ),
      child: const Text(
        'Sign Up with Google',
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
    onPressed: () async {
      try {
        // Start the Facebook login process
        final LoginResult result = await FacebookAuth.instance.login();

        if (result.status == LoginStatus.success) {
          // Create a credential from the access token
          final AccessToken accessToken = result.accessToken!;

          // Create a new credential for Firebase
          final credential = FacebookAuthProvider.credential(accessToken.token);

          // Sign in to Firebase
          UserCredential userCredential = await _auth.signInWithCredential(credential);

          // Check if the user is new or existing
          if (userCredential.additionalUserInfo?.isNewUser ?? false) {
            // Add user information to Firestore
            await _firestore.collection('users').doc(userCredential.user?.uid).set({
              'email': userCredential.user?.email,
              'name': userCredential.user?.displayName,
              // Add other user details as needed
            });
          }

          // After successful sign-in
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfileSetupScreen()),
          );
        } else {
          // Handle error
          _showErrorDialog(result.message ?? 'Facebook login failed');
        }
      } catch (e) {
        // Handle error
        _showErrorDialog(e.toString());
      }
    },
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(const Color(0xfffff5e4)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      )),
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 70)),
    ),
    child: const Text(
      'Sign Up with Facebook',
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}


}
