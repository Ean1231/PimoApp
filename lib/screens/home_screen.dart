import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pimoapp/screens/userprofile.dart';
import 'package:pimoapp/screens/checklist2.dart';
import 'package:pimoapp/screens/login_screen.dart';


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Index of the currently selected bottom navigation bar item

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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text(
                    'Hello Ean!',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  subtitle: Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Colors.white54,
                        ),
                  ),
                  trailing: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/profile.png'),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          Container(
            color: Colors.green,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(200),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard(
                      'Revenue', CupertinoIcons.money_dollar_circle, Colors.indigo),
                  itemDashboard('Upload', CupertinoIcons.add_circled, Colors.teal),
                  itemDashboard('About', CupertinoIcons.question_circle, Colors.blue),
                  itemDashboard('Contact', CupertinoIcons.phone, Colors.pinkAccent),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
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

  itemDashboard(String title, IconData iconData, Color background) => GestureDetector(
    onTap: () {
      // Perform specific actions based on the item tapped
      switch (title) {
        case 'Videos':
          // Videos item tapped
          // Perform actions or navigate to the videos page
          break;
        case 'Analytics':
          // Analytics item tapped
          // Perform actions or navigate to the analytics page
          break;
        case 'Audience':
          // Audience item tapped
          // Perform actions or navigate to the audience page
          break;
        case 'Comments':
          // Comments item tapped
          // Perform actions or navigate to the comments page
          break;
        case 'Revenue':
          // Revenue item tapped
          // Perform actions or navigate to the revenue page
          break;
        case 'Upload':
          // Upload item tapped
          // Perform actions or navigate to the upload page
          break;
        case 'About':
          // About item tapped
          // Perform actions or navigate to the about page
          break;
        case 'Contact':
          // Contact item tapped
          // Perform actions or navigate to the contact page
          break;
      }
    },
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Theme.of(context)
                    .primaryColor
                    .withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 5)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white)),
          const SizedBox(height: 8),
          Text(title.toUpperCase(),
              style: Theme.of(context).textTheme.headline6),
        ],
      ),
    ),
  );
}
