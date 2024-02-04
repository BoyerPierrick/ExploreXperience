import 'package:explore_experience/airports_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double?> fetchSolarIrradiance(String selectedAirport) async {
  const apiUrl = 'http://api.openweathermap.org/data/2.5/solar_radiation/forecast?lat={LATITUDE}&lon={LONGITUDE}&appid=';
  var selectedAirportDetails = airportDetails.firstWhere((airport) => airport['name'] == selectedAirport);
  
  final apiUrlWithCoords = apiUrl
      .replaceFirst('{LATITUDE}', selectedAirportDetails['lat'].toString())
      .replaceFirst('{LONGITUDE}', selectedAirportDetails['long'].toString());

  final response = await http.get(Uri.parse(apiUrlWithCoords));
  if (response.statusCode == 200) {
    final Map<String, dynamic> solarData = jsonDecode(response.body);
    return solarData['value']; 
  } else {
    print('Failed to fetch solar irradiance');
    return null;
  }
}
