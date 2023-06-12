import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  Color customColor = Color(0xFF3CB371);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: customColor,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('images/profile.png'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Ean Bosman',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Software Developer',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('bosman@gmail.com'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('086 726 8218'),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Berea East london'),
            ),
          ],
        ),
      ),
    );
  }
}
