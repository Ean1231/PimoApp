import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();
    // Add your marker data here
    markers.add(Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.7749, -122.4194), // Example coordinates
      infoWindow: InfoWindow(
        title: 'Marker 1',
        snippet: 'This is marker 1',
      ),
      onTap: () {
        // Handle marker tap
        print('Marker 1 tapped');
      },
    ));

    markers.add(Marker(
      markerId: MarkerId('2'),
      position: LatLng(37.3382, -121.8863), // Example coordinates
      infoWindow: InfoWindow(
        title: 'Marker 2',
        snippet: 'This is marker 2',
      ),
      onTap: () {
        // Handle marker tap
        print('Marker 2 tapped');
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Initial map coordinates
          zoom: 10,
        ),
        markers: markers,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
