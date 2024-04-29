import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:my_flutter_app/features/user_auth/presentation/pages/cart.dart';

import 'package:my_flutter_app/features/user_auth/presentation/pages/login_page.dart';
import 'package:my_flutter_app/features/user_auth/presentation/pages/home_page.dart';
import 'package:my_flutter_app/features/user/splash_screen/splash_sreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDDlSJdy--u1xMucDn5-cHywz1uoo-HkfM',
          appId: "1:345420445950:web:bd7eb70adb8a9695ff8daf",
          messagingSenderId: "345420445950",
          projectId: "food-delivery-app-9b247"));
  runApp(
    DevicePreview(
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // Assuming you have defined SplashSreen widget
      routes: {
        '/home': (context) => HomePage(),
        '/Login': (context) => LoginPage(),
        '/cart': (context) => Cart(),
        // Add more routes here if needed
      },

    );
  }
}
