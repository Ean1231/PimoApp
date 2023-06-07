import 'package:flutter/material.dart';
import 'package:pimoapp/screens/userprofile.dart';
import 'package:pimoapp/screens/login_screen.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
    Color customColor = Color(0xFF3CB371);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:customColor,
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: customColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Handle menu item 1 tap
                 Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
              },
            ),
            ListTile(
              title: Text('Log out'),
              onTap: () {
                // Handle menu item 2 tap
                    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
              },
            ),
            // Add more ListTile widgets for additional menu items
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
