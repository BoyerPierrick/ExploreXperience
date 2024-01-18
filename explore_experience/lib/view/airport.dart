import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AirportDetailsPage extends StatefulWidget {
  final String airportName;

  List<Map<String, dynamic>> airportDetails = [
    {"name": "Charles de Gaulle Airport", "lat": 49.0097, "long": 2.5479},
    {"name": "Orly Airport", "lat": 48.7262, "long": 2.3659},
    {"name": "Nice Côte d'Azur Airport", "lat": 43.6584, "long": 7.2159},
    {"name": "Lyon–Saint-Exupéry Airport", "lat": 45.7219, "long": 5.0900},
    {"name": "Marseille Provence Airport", "lat": 43.4367, "long": 5.2151},
    {"name": "Toulouse-Blagnac Airport", "lat": 43.6307, "long": 1.3676},
    {"name": "Bordeaux-Mérignac Airport", "lat": 44.8286, "long": -0.7159},

    // USA
    {"name": "Hartsfield-Jackson Atlanta International Airport", "lat": 33.6407, "long": -84.4277},
    {"name": "Los Angeles International Airport", "lat": 33.9416, "long": -118.4085},
    {"name": "O'Hare International Airport", "lat": 41.9786, "long": -87.9048},
    
    // China
    {"name": "Beijing Capital International Airport", "lat": 40.0799, "long": 116.6031},
    {"name": "Shanghai Pudong International Airport", "lat": 31.1443, "long": 121.8083},
    {"name": "Guangzhou Baiyun International Airport", "lat": 23.3925, "long": 113.2988},
    
    // Japan
    {"name": "Tokyo Haneda Airport", "lat": 35.5533, "long": 139.7811},
    {"name": "Osaka Kansai International Airport", "lat": 34.4342, "long": 135.2441},
    {"name": "Chubu Centrair International Airport", "lat": 34.8584, "long": 136.8057},
    
    // Canada
    {"name": "Toronto Pearson International Airport", "lat": 43.6777, "long": -79.6248},
    {"name": "Vancouver International Airport", "lat": 49.1947, "long": -123.1792},
    {"name": "Montreal-Pierre Elliott Trudeau International Airport", "lat": 45.4700, "long": -73.7408},
    
    // Turkey
    {"name": "Istanbul Airport", "lat": 41.2756, "long": 28.7519},
    {"name": "Antalya Airport", "lat": 36.8986, "long": 30.8017},
    
    // Africa
    {"name": "OR Tambo International Airport", "lat": -26.1367, "long": 28.2411},
    {"name": "Cairo International Airport", "lat": 30.1114, "long": 31.4139},
    {"name": "Jomo Kenyatta International Airport", "lat": -1.3192, "long": 36.9275},
    
    // Brazil
    {"name": "Guarulhos–Governador André Franco Montoro International Airport", "lat": -23.4346, "long": -46.4731},
    {"name": "Congonhas Airport", "lat": -23.6261, "long": -46.6576},
    {"name": "Brasília–Presidente Juscelino Kubitschek International Airport", "lat": -15.8620, "long": -47.9122},
  ];

  AirportDetailsPage({super.key, required this.airportName});

  @override
  // ignore: library_private_types_in_public_api
  _AirportDetailsPageState createState() => _AirportDetailsPageState();
}

class _AirportDetailsPageState extends State<AirportDetailsPage> {
  late String selectedAirport;
  String distanceText = '';

  @override
  void initState() {
    super.initState();
    selectedAirport = widget.airportName;
  }
 
  // Function to calculate and set the distance between two airports
  void calculateAndSetDistance(String selectedAirport) {
    var initialAirportDetails = widget.airportDetails.firstWhere((airport) => airport['name'] == widget.airportName);
    var selectedAirportDetails = widget.airportDetails.firstWhere((airport) => airport['name'] == selectedAirport);
    
    // Function to calculate distance between two coordinates on Earth
    double calculateDistance(double startLat, double startLong, double endLat, double endLong) {
      const int earthRadius = 6371; 
      double lat1 = startLat * pi / 180;
      double lon1 = startLong * pi / 180;
      double lat2 = endLat * pi / 180;
      double lon2 = endLong * pi / 180;

      double dLat = lat2 - lat1;
      double dLon = lon2 - lon1;

      double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
      double c = 2 * atan2(sqrt(a), sqrt(1 - a));

      double distance = earthRadius * c;
      return distance;
    }
    
    // Calculate the distance and update the state
    double distance = calculateDistance(
      initialAirportDetails['lat'],
      initialAirportDetails['long'],
      selectedAirportDetails['lat'],
      selectedAirportDetails['long'],
    );

    setState(() {
      distanceText = 'Distance between ${widget.airportName} and $selectedAirport is ${distance.toStringAsFixed(2)} km';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(widget.airportName),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Details for ${widget.airportName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(

                  children: [
                    const Text(
                      'Select destination',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: selectedAirport,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedAirport = newValue;
                            calculateAndSetDistance(selectedAirport);
                          });
                        }
                      },
                      items: widget.airportDetails.map<DropdownMenuItem<String>>((airport) {
                        return DropdownMenuItem<String>(
                          value: airport['name'] as String,
                          child: Text(airport['name'] as String),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                    ),

                    const SizedBox(height: 20),
                    Text(
                      distanceText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Flight Route',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(48.8566, 2.3522),
                          zoom: 5,
                        ),
                        
                        markers: {
                          Marker(
                            markerId: const MarkerId('departure'),
                            position: LatLng(widget.airportDetails.firstWhere((airport) => airport['name'] == widget.airportName)['lat'] as double,
                                widget.airportDetails.firstWhere((airport) => airport['name'] == widget.airportName)['long'] as double),
                            infoWindow: InfoWindow(title: widget.airportName),
                          ),
                          Marker(
                            markerId: const MarkerId('selected'),
                            position: LatLng(widget.airportDetails.firstWhere((airport) => airport['name'] == selectedAirport)['lat'] as double,
                                widget.airportDetails.firstWhere((airport) => airport['name'] == selectedAirport)['long'] as double),
                            infoWindow: InfoWindow(title: selectedAirport),
                          ),
                        },

                        polylines: {
                          Polyline(
                            polylineId: const PolylineId('flightPath'),
                            color: Colors.red,
                            points: [
                              LatLng(widget.airportDetails.firstWhere((airport) => airport['name'] == widget.airportName)['lat'] as double,
                                widget.airportDetails.firstWhere((airport) => airport['name'] == widget.airportName)['long'] as double),
                              LatLng(widget.airportDetails.firstWhere((airport) => airport['name'] == selectedAirport)['lat'] as double,
                                widget.airportDetails.firstWhere((airport) => airport['name'] == selectedAirport)['long'] as double),
                            ],
                          ),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}