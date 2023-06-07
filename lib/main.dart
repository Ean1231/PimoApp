import 'package:flutter/material.dart';
import 'package:pimoapp/screens/login_screen.dart';
import 'package:pimoapp/screens/home_screen.dart';
// import 'package:pimoapp/screens/userprofile.dart';
void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     title: "App",
     routes: {
      'home' : (_) => LoginScreen(),
     },
     initialRoute: 'home',
  );
 
 }
}





