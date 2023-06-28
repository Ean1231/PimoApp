import 'package:flutter/material.dart';
import 'package:flutter_map_arcgis/flutter_map_arcgis.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:pimoapp/screens/checklist2.dart';
import 'package:pimoapp/screens/home_screen.dart';
import 'package:pimoapp/screens/userprofile.dart';
import 'package:url_launcher/url_launcher.dart';

class Map extends StatefulWidget {
  final String email;
  final String displayName;
  int manageID;
  Map({required this.email, required this.displayName, required this.manageID});

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  int _selectedIndex = 1;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(email: widget.email, displayName: widget.displayName, manageID: widget.manageID,),
          ),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(displayName: widget.displayName, email: widget.email,manageID: widget.manageID),
          ),
        );
        break;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showPopup(dynamic attributes, LatLng location) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Point Details'),
          content: FutureBuilder<String>(
            future: getAddress(location),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error occurred while retrieving address');
              }
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Coordinates: ${location.latitude}, ${location.longitude}'),
                    SizedBox(height: 8),
                    Text('Address: ${snapshot.data}'),
                    SizedBox(height: 8),
                    Text('Attributes: ${attributes.toString()}'),
                  ],
                );
              }
              return Text('No data available');
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Directions'),
              onPressed: () {
                _launchDirections(location.latitude, location.longitude);
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> getAddress(LatLng location) async {
    final List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    if (placemarks.isNotEmpty) {
      final geocoding.Placemark placemark = placemarks.first;
      return placemark.street ?? '';
    }

    return '';
  }

  void _launchDirections(double latitude, double longitude) async {
    final String destination = '$latitude,$longitude';
    final String origin = '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final String url = 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination';
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch directions';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Center(child: const Text('Projects')),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.displayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.email,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Map 2'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Map 3'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FlutterMap(
  options: MapOptions(
    center: _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : LatLng(-32.98597016673679, 27.90755303092124),
    zoom: 13.0,
    plugins: [EsriPlugin()],
  ),
  layers: [
    TileLayerOptions(
      urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
    ),
    MarkerLayerOptions(
      markers: _currentPosition != null
          ? [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                builder: (ctx) => Stack(
                  children: [
                    Container(
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                    Positioned(
                      top: -30.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          'My Location',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          : [],
    ),
    FeatureLayerOptions(
      "https://services7.arcgis.com/H7dxHguUS0vPnXcn/arcgis/rest/services/east_london_schools/FeatureServer/0",
      "point",
      onTap: (attributes, LatLng location) {
        _showPopup(attributes, location);
      },
      render: (dynamic attributes) {
        return PointOptions(
          width: 90.0,
          height: 90.0,
          builder: const Icon(
            Icons.circle,
            color: Colors.green,
          ),
        );
      },
    ),
  ],
),

            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromRGBO(76, 175, 80, 1),
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
