import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pimoapp/backend_api/api_service.dart';
import 'package:pimoapp/screens/contact_us.dart';
import 'package:pimoapp/screens/locationPage%20.dart';
import 'package:pimoapp/screens/userprofile.dart';
import 'package:pimoapp/screens/checklist2.dart';
import 'package:pimoapp/screens/login_screen.dart';
import 'package:pimoapp/screens/google-maps.dart';
import 'package:pimoapp/screens/inspection/buildings.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  final String email;
  final String displayName;
  int manageID;

  MyHomePage({required this.email, required this.displayName, required this.manageID});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? displayName;
  String? email;
  bool isLoading = true;
  String _weatherIcon = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();

String _getGreeting() {
  final hour = DateTime.now().hour;
  IconData weatherIcon;

  if (hour < 12) {
    weatherIcon = WeatherIcons.sunrise;
    return 'Good Morning';
  } else if (hour < 17) {
    weatherIcon = WeatherIcons.day_sunny;
    return 'Good Afternoon';
  } else {
    weatherIcon = WeatherIcons.night_clear;
    return 'Good Evening';
  }


}

IconData _getWeatherIcon() {
  final hour = DateTime.now().hour;

  if (hour < 6 || hour >= 18) {
    return WeatherIcons.moon_alt_waning_gibbous_4;
  } else if (hour < 12) {
    return WeatherIcons.day_sunny;
  } else if (hour < 18) {
    return WeatherIcons.day_cloudy;
  }

  return WeatherIcons.refresh; // Default icon if no condition is met
}



  void getUserData() async {
    setState(() {
      isLoading = true; 
    });

    final userDisplayName = await APIService.fetchUserData(widget.email.toString());

    if (userDisplayName != null) {
      setState(() {
        displayName = userDisplayName;
        isLoading = false; 
      });
      print('homepage $displayName , $email');
    } else {
      print('Failed to fetch user');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  int _selectedIndex = 0; 

  void _onItemTapped(int index) {
    if (isLoading) return;
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              email: '',
              displayName: '',
              manageID: 2,
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Map(
              email: widget.email,
              displayName: displayName!,
              manageID: widget.manageID,
            ),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              email: widget.email,
              displayName: displayName!,
              manageID: 2,
            ),
          ),
        );
        break;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? _buildLoadingBox() : _buildContent(),
      bottomNavigationBar: IgnorePointer(
        ignoring: isLoading, // Disable bottom navigation bar when loading
        child: BottomNavigationBar(
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
      ),
    );
  }

Widget _buildLoadingBox() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        if (displayName == null && !isLoading)
          ElevatedButton(
            onPressed: () {
              getUserData();
            },
            child: Text('Reload'),
          ),
      ],
    ),
  );
}




  Widget _buildContent() {
    return ListView(
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
    _getGreeting(),
    style: Theme.of(context).textTheme.headline6?.copyWith(
      color: Colors.white,
    ),
  ),
subtitle: Row(
  children: [
    Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Icon(
        _getWeatherIcon(),
        color: Colors.white54,
        size: 16,
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          '$displayName',
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
            color: Colors.white54,
          ),
        ),
      ),
    ),
  ],
),

  trailing: ClipRRect(
    borderRadius: BorderRadius.circular(30.0),
    child: Image.asset(
      'images/llogo.png',
      width: 120,
      height: 60,
      fit: BoxFit.cover,
    ),
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
            child: Column(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 30,
                  children: [
                    itemDashboard(
                      'logout',
                      CupertinoIcons.money_dollar_circle,
                      Colors.indigo,
                    ),
                    itemDashboard(
                      'Inspection',
                      CupertinoIcons.add_circled,
                      Colors.teal,
                    ),
                    itemDashboard(
                      'About',
                      CupertinoIcons.question_circle,
                      Colors.blue,
                    ),
                    itemDashboard(
                      'Contact',
                      CupertinoIcons.phone,
                      Colors.pinkAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF00B09B),
                        Color(0xFF96C93D),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.bottomCenter,
                    ), 
                    borderRadius: BorderRadius.circular(10), 
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), 
                        spreadRadius: 2, 
                        blurRadius: 5,
                        offset: Offset(0, 3), 
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          Icons.info,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 44.0, left: 8.0, right: 8.0, bottom: 8.0),
                        child: Text(
                          'Our commitment, your convenience. Truthful and trustworthy we are, that’s why we are best.',
                          style: TextStyle(fontSize: 16, color: Colors.white,  fontFamily: GoogleFonts.getFont('Quicksand').fontFamily),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background) {
    return GestureDetector(
      onTap: () {
        switch (title) {
          case 'logout':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
            break;
          case 'Inspection':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationScreen(
                  email: widget.email,
                  displayName: displayName!,
                  manageID: widget.manageID,
                ),
              ),
            );
            break;
          case 'Audience':
          
            break;
          case 'Comments':
         
            break;
          case 'Revenue':
          
            break;
          case 'Upload':
            
            break;
          case 'About':
            break;
          case 'Contact':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactUsPage(
                  email: widget.email,
                  displayName: displayName!,
                ),
              ),
            );
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
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
