import 'dart:async';
import 'package:biolensproto/screens/signup.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';  // Make sure this path is correct

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Duration to show the splash screen
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color or gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[100]!,Colors.blue[400]!,],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Centering the splash image
          Center(
            child: Image.asset(
              'assets/images/splash_image.png',
              width: 500,
              height: 500,
            ),
          ),
        ],
      ),
    );
  }
}
