import 'dart:math' show cos, sqrt, asin;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Position> getCurrentLocation() async {
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

Future<List<Placemark>> getAddressFromPosition(Position position) async {
  return await placemarkFromCoordinates(position.latitude, position.longitude);
}

Future<bool> calculateDistance(
  String startAddress,
  Position currentPosition,
  String destinationAddress,
  GoogleMapController mapController,
  Set<Marker> markers,
  Function(String) updatePlaceDistance,
) async {
  try {
    // Retrieving placemarks from addresses.
    List<Location> startPlacemark = await locationFromAddress(startAddress);
    List<Location> destinationPlacemark = await locationFromAddress(destinationAddress);

    // Use the retrieved coordinates of the current position.
    double startLatitude = startAddress == currentPosition.toString()
        ? currentPosition.latitude
        : startPlacemark[0].latitude;

    double startLongitude = startAddress == currentPosition.toString()
        ? currentPosition.longitude
        : startPlacemark[0].longitude;

    double destinationLatitude = destinationPlacemark[0].latitude;
    double destinationLongitude = destinationPlacemark[0].longitude;

    String startCoordinatesString = '($startLatitude, $startLongitude)';
    String destinationCoordinatesString = '($destinationLatitude, $destinationLongitude)';

    // Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId(startCoordinatesString),
      position: LatLng(startLatitude, startLongitude),
      infoWindow: InfoWindow(
        title: 'Start $startCoordinatesString',
        snippet: startAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId(destinationCoordinatesString),
      position: LatLng(destinationLatitude, destinationLongitude),
      infoWindow: InfoWindow(
        title: 'Destination $destinationCoordinatesString',
        snippet: destinationAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

    // Adding the markers to the map
    markers.add(startMarker);
    markers.add(destinationMarker);

    // Calculate the distance between two coordinates
    double distance = coordinateDistance(
      startLatitude,
      startLongitude,
      destinationLatitude,
      destinationLongitude,
    );

    updatePlaceDistance(distance.toStringAsFixed(2));

    return true;
  } 
  catch (e) 
  {
    print(e);
    return false;
  }
}

// Formula for calculating distance between two coordinates.
double coordinateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;

  return 12742 * asin(sqrt(a));
}

void updateCameraPosition(GoogleMapController mapController, double latitude, double longitude) {
  mapController.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 18.00,
      ),
    ),
  );
}