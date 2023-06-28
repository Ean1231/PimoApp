import 'package:flutter/material.dart';
import 'package:pimoapp/screens/fieldInspection.dart';
import 'package:pimoapp/screens/locationPage%20.dart';
import 'package:pimoapp/screens/login_screen.dart';
import 'package:pimoapp/screens/home_screen.dart';
import 'package:pimoapp/screens/inspection.dart';
import 'package:pimoapp/screens/checklist2.dart';

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
      'inspect' : (_) => LoginScreen(),
     },
     initialRoute: 'inspect',
  );
 
 }
}





