import 'dart:math';

class DistanceCalculation {
  static double calculateDistance(double startLat, double startLong, double endLat, double endLong) {
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
}
