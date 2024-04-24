import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/user_auth/presentation/pages/login_page.dart';
 // Adjust the import path as needed 
class SplashSreen extends StatefulWidget {
  const SplashSreen({Key? key}) : super(key: key);

  @override
  _SplashSreenState createState() => _SplashSreenState();
}

class _SplashSreenState extends State<SplashSreen> {
  late BuildContext _context; // Declare a variable to store the context

  @override
  void initState() {
    super.initState();
    // Store the context when the widget is initialized
    _context = context;

    // Use Future.delayed to navigate after a delay
    Future.delayed(const Duration(seconds: 3), () {
      // Use the stored context to navigate
      Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Welcome to Flutter Firebase",
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
