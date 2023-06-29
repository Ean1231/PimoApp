import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pimoapp/screens/checklist2.dart';
import 'package:pimoapp/screens/inspection/Civil%20.dart';
import 'package:pimoapp/screens/inspection/Electrical.dart';
import 'package:pimoapp/screens/inspection/FacilitiesManagement%20.dart';
import 'package:pimoapp/screens/inspection/Mechanical%20.dart';
import 'package:pimoapp/screens/inspection/buildings.dart';
import 'package:pimoapp/screens/inspection/healthSafety%20.dart';
import 'package:google_fonts/google_fonts.dart';

class LocationScreen extends StatefulWidget {
  final String email;
  final String displayName;
  int manageID;
  LocationScreen({required this.manageID, required this.email, required this.displayName});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _currentPosition;
  String? _currentAddress;
  String? _currentSuburb;
  String? _currentPostalCode;
  String? _currentMunicipality;
  String _currentDate = '';
  bool _isConfirmed = false;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getCurrentDate();
  }

  // Get the current location
  _getCurrentLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      PermissionStatus permissionStatus = await Permission.locationWhenInUse.request();
      if (permissionStatus == PermissionStatus.granted) {
         setState(() {
        _isLoading = true; // Set loading state to true
      });
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
        String suburb = place.subAdministrativeArea ?? '';
        String postalCode = place.postalCode ?? '';
        String municipality = place.administrativeArea ?? '';

        setState(() {
          _currentAddress = address;
          _currentSuburb = suburb;
          _currentPostalCode = postalCode;
          _currentMunicipality = municipality;
          _isLoading = false;
        });
        print('Permissions granted: $permissionStatus');
      } else if (permissionStatus == PermissionStatus.denied) {
        print('Permissions denied: $permissionStatus');
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        print('Permissions permanently denied: $permissionStatus');
      }
    } else {
      print('Location service is not enabled');
    }
  }

  // Get the current date
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
      title: Text('Confirm Information', textAlign: TextAlign.center),
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
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Inspection Date: $_currentDate',
                    style: TextStyle(
                      fontSize: 20,
                       fontFamily: GoogleFonts.getFont('Quicksand',
                       
                       ).fontFamily
                      ),
                    
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Inspector Name: ${widget.displayName}',
                    style: TextStyle(fontSize: 20,
                    fontFamily: GoogleFonts.getFont('Quicksand').fontFamily
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Latitude: ${_currentPosition?.latitude ?? 'Fetching latitude...'}',
                    style: TextStyle(fontSize: 20,
                    fontFamily: GoogleFonts.getFont('Quicksand').fontFamily
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Longitude: ${_currentPosition?.longitude ?? 'Fetching longitude...'}',
                    style: TextStyle(fontSize: 20,
                    fontFamily: GoogleFonts.getFont('Quicksand').fontFamily
                    ),
                    
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Inspection Address: ${_currentAddress ?? 'Getting address...'}, ${_currentPostalCode}',
                    style: TextStyle(fontSize: 20,
                    fontFamily: GoogleFonts.getFont('Quicksand').fontFamily
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Local Municipality: ${_currentSuburb ?? 'Fetching local municipality...'}',
                    style: TextStyle(fontSize: 20,
                    fontFamily: GoogleFonts.getFont('Quicksand').fontFamily
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () {
                      if (!_isConfirmed) {
                        setState(() {
                          _isConfirmed = true;
                        });
                      } else if (widget.manageID == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Buildings(
                              email: widget.email,
                              displayName: widget.displayName,
                              currentPosition: _currentPosition,
                              currentAddress: _currentAddress,
                              currentSuburb: _currentSuburb,
                              currentPostalCode: _currentPostalCode,
                              currentMunicipality: _currentMunicipality,
                              currentDate: _currentDate,
                              manageID: 2,
                            ),
                          ),
                        );
                      }else if (widget.manageID == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Civil(
                              email: widget.email,
                              displayName: widget.displayName,
                              currentPosition: _currentPosition,
                              currentAddress: _currentAddress,
                              currentSuburb: _currentSuburb,
                              currentPostalCode: _currentPostalCode,
                              currentMunicipality: _currentMunicipality,
                              currentDate: _currentDate,
                              manageID: 2,
                            ),
                          ),
                        );
                      }else if (widget.manageID == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Electrical(
                              email: widget.email,
                              displayName: widget.displayName,
                              currentPosition: _currentPosition,
                              currentAddress: _currentAddress,
                              currentSuburb: _currentSuburb,
                              currentPostalCode: _currentPostalCode,
                              currentMunicipality: _currentMunicipality,
                              currentDate: _currentDate,
                              manageID: 2,
                            ),
                          ),
                        );
                      }else if (widget.manageID == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FacilitiesManagement(
                              email: widget.email,
                              displayName: widget.displayName,
                              currentPosition: _currentPosition,
                              currentAddress: _currentAddress,
                              currentSuburb: _currentSuburb,
                              currentPostalCode: _currentPostalCode,
                              currentMunicipality: _currentMunicipality,
                              currentDate: _currentDate,
                              manageID: 2,
                            ),
                          ),
                        );
                      }else if (widget.manageID == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => healthSafety(
                              email: widget.email,
                              displayName: widget.displayName,
                              currentPosition: _currentPosition,
                              currentAddress: _currentAddress,
                              currentSuburb: _currentSuburb,
                              currentPostalCode: _currentPostalCode,
                              currentMunicipality: _currentMunicipality,
                              currentDate: _currentDate,
                              manageID: 2,
                            ),
                          ),
                        );
                      }else if (widget.manageID == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Mechanical(
                              email: widget.email,
                              displayName: widget.displayName,
                              currentPosition: _currentPosition,
                              currentAddress: _currentAddress,
                              currentSuburb: _currentSuburb,
                              currentPostalCode: _currentPostalCode,
                              currentMunicipality: _currentMunicipality,
                              currentDate: _currentDate,
                              manageID: 2,
                            ),
                          ),
                        );
                      }
                      
                       else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPage2(
                              email: widget.email,
                              displayName: widget.displayName,
                              currentPosition: _currentPosition,
                              currentAddress: _currentAddress,
                              currentSuburb: _currentSuburb,
                              currentPostalCode: _currentPostalCode,
                              currentMunicipality: _currentMunicipality,
                              currentDate: _currentDate,
                              manageID: 2,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            _isConfirmed ? 'Start Inspection' : 'Confirm Information',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                  if (!_isConfirmed)
                    ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          _isConfirmed = false;
                        });
                        Navigator.pop(context, widget.displayName);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text(
                        'Cancel Inspection',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            // if (_isLoading)
            //   Center(
            //     child: CircularProgressIndicator(),
            //   ),
          ],
        ),
      ),
    ),
  );
}


}
