import 'package:flutter/material.dart';
import 'package:money_tree/views/start_screens/login_screen.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double sw = MediaQuery.of(context).size.width;
    // for font size
    double fs = sw;

    return Scaffold(
      backgroundColor: const Color(0xff013D5A),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: sw * 0.05),
                child: Image.asset('lib/images/tree_logo.jpg'),
              ),

              const SizedBox(height: 15),

              const Text(
                "MANAGE YOUR",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontFamily: "Inter Regular",
                    fontWeight: FontWeight.w700
                ),
              ),
              const Text(
                "FINANCES EASILY",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontFamily: "Inter Regular",
                    fontWeight: FontWeight.w700
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()));
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(const Color(0xfffff5e4)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 2.0
                        )
                      ),
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(350, 70)),
                    elevation: WidgetStateProperty.all(10)
                  ),
                  child: const Text('Get Started',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold
                    ),
                  )
              )
            ],
          ),
        ),
      )
    );
  }
}

