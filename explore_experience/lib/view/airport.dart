import 'package:explore_experience/solar_irradiance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:explore_experience/airports_details.dart';
import 'package:explore_experience/calculate_distance.dart';

class AirportDetailsPage extends StatefulWidget {
  final String airportName;

  const AirportDetailsPage({Key? key, required this.airportName}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AirportDetailsPageState createState() => _AirportDetailsPageState();
}

class _AirportDetailsPageState extends State<AirportDetailsPage> {
  late String selectedAirport;
  String distanceText = '';
  late double solarIrradiance = 0.0;

  @override
  void initState() {
    super.initState();
    selectedAirport = widget.airportName;
    fetchSolarIrradiance(selectedAirport);
  }
  
  // Function to calculate and set the distance between two airports
  void calculateAndSetDistance(String selectedAirport) {
    var initialAirportDetails = airportDetails.firstWhere((airport) => airport['name'] == widget.airportName);
    var selectedAirportDetails = airportDetails.firstWhere((airport) => airport['name'] == selectedAirport);

    double distance = DistanceCalculation.calculateDistance(
      initialAirportDetails['lat'],
      initialAirportDetails['long'],
      selectedAirportDetails['lat'],
      selectedAirportDetails['long'],
    );

    setState(() {
      distanceText =
          'Distance between ${widget.airportName} and $selectedAirport is ${distance.toStringAsFixed(2)} km';
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
                      items: airportDetails.map<DropdownMenuItem<String>>((airport) {
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
                    SizedBox(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(48.8566, 2.3522),
                          zoom: 5,
                        ),

                        markers: {
                          Marker(
                            markerId: const MarkerId('departure'),
                            position: LatLng(airportDetails.firstWhere((airport) => airport['name'] == widget.airportName)['lat'] as double,
                                airportDetails.firstWhere((airport) => airport['name'] == widget.airportName)['long'] as double),
                            infoWindow: InfoWindow(title: widget.airportName),
                          ),
                          Marker(
                            markerId: const MarkerId('selected'),
                            position: LatLng(airportDetails.firstWhere((airport) => airport['name'] == selectedAirport)['lat'] as double,
                                airportDetails.firstWhere((airport) => airport['name'] == selectedAirport)['long'] as double),
                            infoWindow: InfoWindow(title: selectedAirport),
                          ),
                        },

                        polylines: {
                          Polyline(
                            polylineId: const PolylineId('flightPath'),
                            color: Colors.red,
                            points: [
                              LatLng(airportDetails.firstWhere((airport) => airport['name'] == widget.airportName)['lat'] as double,
                                airportDetails.firstWhere((airport) => airport['name'] == widget.airportName)['long'] as double),
                              LatLng(airportDetails.firstWhere((airport) => airport['name'] == selectedAirport)['lat'] as double,
                                airportDetails.firstWhere((airport) => airport['name'] == selectedAirport)['long'] as double),
                            ],
                          ),
                        },
                      ),
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
                      'Solar Irradiance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Solar Irradiance at ${widget.airportName}: $solarIrradiance W/m²',
                      style: const TextStyle(
                        fontSize: 16,
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