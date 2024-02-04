import 'package:location/location.dart';

class LocationUtil {
  static Future<LocationData?> getCurrentLocation() async {
    var location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}
