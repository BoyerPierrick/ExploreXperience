import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:explore_experience/airports_details.dart';

class AirportMarkers {
  static void addAirportMarkers(Set<Marker> airportMarkers, void Function(String) openAirportDetails) {
    for (int i = 0; i < airportDetails.length; i++) {
      final airport = airportDetails[i];
      airportMarkers.add(
        Marker(
          markerId: MarkerId('airport$i'),
          position: LatLng(airport['lat'], airport['long']),
          infoWindow: InfoWindow(title: airport['name']),
          onTap: () {
            openAirportDetails(airport['name']);
          },
        ),
      );
    }
  }
}
