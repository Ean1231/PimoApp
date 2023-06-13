import 'package:flutter/material.dart';
import 'package:pimoapp/screens/userprofile.dart';
import 'package:pimoapp/screens/checklist2.dart';
import 'package:pimoapp/screens/login_screen.dart';
import 'package:pimoapp/screens/home_screen.dart';
// ignore: must_be_immutable

  class ProfileScreen extends StatefulWidget {
    
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
   Color customColor = Color(0xFF3CB371);

    int _selectedIndex = 2; // Index of the currently selected bottom navigation bar item

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Perform specific actions based on the selected index
    switch (index) {
      case 0:         
             Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()),);
        break;
      case 1:
       Navigator.push(context, MaterialPageRoute(builder: (context) => QuizPage2()),);
        break;
      case 2:
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()),);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: customColor,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('images/profle.png'),
              
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
         bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Inspection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User Profile',
          ),
        ],
      ),
    );
  }
}
