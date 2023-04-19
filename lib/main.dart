import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(TerritoriesGPS());

class TerritoriesGPS extends StatefulWidget {
  @override
  _TerritoriesGPSState createState() => _TerritoriesGPSState();
}

class _TerritoriesGPSState extends State<TerritoriesGPS> {
  late GoogleMapController mapController;
  LatLng _center = LatLng(45.521563, -122.677433);
  Location _location = Location();
  Map<MarkerId, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onLocationChanged(LocationData location) {
    LatLng latLng = LatLng(location.latitude!, location.longitude!);
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: latLng,
        zoom: 15,
      ),
    ));
    Marker marker = Marker(
      markerId: MarkerId("my_location"),
      position: latLng,
      infoWindow: InfoWindow(title: "My Location"),
    );
    setState(() {
      _markers[MarkerId("my_location")] = marker;
    });
  }

  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen(_onLocationChanged);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Territories GPS'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: Set<Marker>.of(_markers.values),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _location.getLocation().then((LocationData currentLocation) {
              _onLocationChanged(currentLocation);
            });
          },
          child: Icon(Icons.my_location),
        ),
      ),
    );
  }
}
