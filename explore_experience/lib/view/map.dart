import 'airport.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// This class represents the main screen that displays a map with airport markers.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  // Creates the mutable state for this widget at a given location in the tree.
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Controller for the Google Map.
  late GoogleMapController mapController;

  // Initial camera position for the map.
  final LatLng _initialCameraPosition = const LatLng(48.8566, 2.3522);

  // Details of various airports.
  List<Map<String, dynamic>> airportDetails = [
    {"name": "Charles de Gaulle Airport", "lat": 49.0097, "long": 2.5479},
    {"name": "Orly Airport", "lat": 48.7262, "long": 2.3659},
    {"name": "Nice Côte d'Azur Airport", "lat": 43.6584, "long": 7.2159},
    {"name": "Lyon–Saint-Exupéry Airport", "lat": 45.7219, "long": 5.0900},
    {"name": "Marseille Provence Airport", "lat": 43.4367, "long": 5.2151},
    {"name": "Toulouse-Blagnac Airport", "lat": 43.6307, "long": 1.3676},
    {"name": "Bordeaux-Mérignac Airport", "lat": 44.8286, "long": -0.7159},
  ];

  // Set to hold airport markers.
  Set<Marker> airportMarkers = Set();

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
    var location = Location();
    try {
      currentLocation = await location.getLocation();
      // Animates the map camera to the current location.
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          10.0,
        ),
      );
    } catch (e) {
      print('Error getting location: $e');
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
    for (int i = 0; i < airportDetails.length; i++) {
      final airport = airportDetails[i];
      airportMarkers.add(
        Marker(
          markerId: MarkerId('airport$i'),
          position: LatLng(airport['lat'], airport['long']),
          infoWindow: InfoWindow(title: airport['name']),
          onTap: () {
            _openAirportDetails(airport['name']);
          },
        ),
      );
    }
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
