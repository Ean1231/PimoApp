import 'package:flutter/material.dart';
import 'package:pimoapp/screens/userprofile.dart';
import 'package:pimoapp/screens/checklist2.dart';
import 'package:pimoapp/screens/login_screen.dart';
import 'package:pimoapp/screens/home_screen.dart';
import '../backend_api/api_service.dart';
import 'package:pimoapp/screens/google-maps.dart';

class ProfileScreen extends StatefulWidget {
   final String email;
  final String displayName;
  int manageID;

  ProfileScreen({required this.email, required this.displayName, required this.manageID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Color customColor = const Color(0xFF3CB371);
  int _selectedIndex = 2;
  String? displayName;
  String? email;
  bool isLoading = true; // Added isLoading state

  void getUserData() async {
    final userDisplayName = await APIService.fetchUserData(widget.email.toString());

    if (userDisplayName != null) {
      setState(() {
        displayName = userDisplayName;
        email = widget.email; 
        isLoading = false; 
      });
      print('user $displayName and $email');
    } else {
      
      print('Failed to fetch user');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void _onItemTapped(int index) {
    if (isLoading) return; 

    setState(() {
      _selectedIndex = index;
    });

    
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage(email: widget.email, displayName: displayName!, manageID: widget.manageID)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Map(displayName: widget.displayName, email: widget.email, manageID: widget.manageID, )),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(displayName: widget.displayName, email: widget.email, manageID: widget.manageID)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Profile')),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), 
            )
          : Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
               Container(
                      width: 250,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/llogo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              
                  const SizedBox(height: 16.0),
                  Text(
                    displayName ?? '',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Software Developer',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 16.0),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(email ?? ''),
                  ),
                  const ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('086 726 8218'),
                  ),
                  const ListTile(
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
            icon: Icon(Icons.map),
            label: 'Map',
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
