import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pimoapp/screens/checklist2.dart';
import 'package:pimoapp/screens/fieldInspection.dart';

class LocationScreen extends StatefulWidget {
  final String email;
  final String displayName;
  int manageID;
  LocationScreen({required this.manageID ,required this.email, required this.displayName});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _currentPosition;
  String? _currentAddress;
  String _currentDate = '';
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getCurrentDate();
  }

  // get the current location
  _getCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      PermissionStatus permissionStatus = await Permission.locationWhenInUse.request();
      if (permissionStatus == PermissionStatus.granted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentPosition = position;
        });

        // Get the geocoded address
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        Placemark place = placemarks[0];
        String address = "${place.street}, ${place.locality}, ${place.country}";
        setState(() {
          _currentAddress = address;
        });
        print('permissions Granted $permissionStatus');
      } else if (permissionStatus == PermissionStatus.denied) {
        print('permissions denied $permissionStatus');
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        print('permissions permanently denied $permissionStatus');
      }
    } else {
      print('No other');
    }
  }

  // current date
  void _getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = '${now.day}-${now.month}-${now.year}';
    setState(() {
      _currentDate = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm information', textAlign: TextAlign.center),
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Inspection Date: $_currentDate',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'Inspector Name: ${widget.displayName}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  'Latitude: ${_currentPosition?.latitude ?? 'Fetching latitude...'}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  'Longitude: ${_currentPosition?.longitude ?? 'Fetching longitude...'}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  'Inspection Address: ${_currentAddress ?? 'Getting address...'}',
                  style: TextStyle(fontSize: 20),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (!_isConfirmed) {
                      setState(() {
                        _isConfirmed = true;
                      });
                    } 
                    else if(widget.manageID == 2){
                           Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizPage2(
                            email: widget.email,
                            displayName: widget.displayName,
                            currentPosition: _currentPosition,
                            currentAddress: _currentAddress,
                            currentDate: _currentDate,
                            manageID: 2
                          ),
                        ),
                      );
                    }
                    else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InspectionForm(
                            email: widget.email,
                            displayName: widget.displayName,
                            currentPosition: _currentPosition,
                            currentAddress: _currentAddress,
                            currentDate: _currentDate,
                            manageID: 2
                          ),
                        ),

                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    _isConfirmed ? 'Start Inspection' : 'Confirm Information',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (!_isConfirmed)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isConfirmed = false;
                      });
                      Navigator.pop(context, widget.displayName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    child: Text(
                      'Cancel inspection',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
