import 'package:explore_experience/airport_markers.dart';
import 'package:explore_experience/location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'airport.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final LatLng _initialCameraPosition = const LatLng(48.8566, 2.3522);
  
  // Set to hold airport markers.
  Set<Marker> airportMarkers = {};

  // Holds the current device location.
  LocationData? currentLocation;

  @override
  void initState() {
    super.initState();
    // Displays a welcome bottom sheet once the widget is built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeBottomSheet(context);
    });
    // Adds airport markers to the map.
    _addAirportMarkers();
    // Fetches and sets the current device location.
    _getCurrentLocation();
  }

  // Fetches and sets the current device location using the location package.
  void _getCurrentLocation() async {
    LocationData? locationData = await LocationUtil.getCurrentLocation();
    if (locationData != null) {
      setState(() {
        currentLocation = locationData;
        // Animates the map camera to the current location.
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            10.0,
          ),
        );
      });
    }
  }

  // Displays a welcome bottom sheet with introductory information.
  void _showWelcomeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Welcome to ExploreXperience',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please select a departure airport.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Callback when the Google Map is created.
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  // Adds airport markers to the set.
  void _addAirportMarkers() {
    AirportMarkers.addAirportMarkers(airportMarkers, _openAirportDetails);
  }

  // Opens a new page or screen with detailed information about the selected airport.
  void _openAirportDetails(String airportName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AirportDetailsPage(airportName: airportName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold widget providing the structure of the screen.
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExploreXperience'),
      ),

      // Google Map widget displaying the map with airport markers.
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialCameraPosition,
          zoom: 6.0,
        ),
        markers: airportMarkers,
      ),
    );
  }
}
