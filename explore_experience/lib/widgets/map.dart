import 'secret.dart';
import 'map_logic.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView>{

  String _currentAddress = '';
  String _startAddress = '';
  String? _placeDistance;

  final String _destinationAddress = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();
  final CameraPosition _initialPosition = CameraPosition(target: LatLng(0.0, 0.0));

  late Position _currentPosition;
  late GoogleMapController _mapController;
  late PolylinePoints polylinePoints;
  
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _loadMap();
  }

  _loadMap() async {
    try {
      _currentPosition = await getCurrentLocation();
      _updateCameraPosition(_currentPosition.latitude, _currentPosition.longitude);
      await _getAddress();
      await _calculateAndDisplayDistance();
    } 
    catch (error) 
    {
      print(error);
    }
  }

  _updateCameraPosition(double latitude, double longitude) {
    updateCameraPosition(_mapController, latitude, longitude);
  }

  _getAddress() async {
    try {
      List<Placemark> p = await getAddressFromPosition(_currentPosition);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } 
    catch (e) 
    {
      print(e);
    }
  }

  _calculateAndDisplayDistance() async {
    bool success = await calculateDistance(
      _startAddress,
      _currentPosition,
      _destinationAddress,
      _mapController,
      markers, 
      (distance) {
        setState(() {
          _placeDistance = distance;
          print('DISTANCE: $_placeDistance km');
        });
      },
    );

    if (!success) {
      
    }
  }

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required double width,
    required Icon prefixIcon,
    Widget? sufixIcon,
    required Function(String) locationCallback,
  })
  {
    return Container(
      width: width * 0.8,

      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },

        controller: controller,
        focusNode: focusNode,

        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffix: sufixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,

          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),

          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            )
          ),

          contentPadding: const EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,

      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget> [
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialPosition,
              myLocationEnabled: true,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
            )
            ],
        ),
      ),
    );
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,

  ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, 
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    polylines[id] = polyline;
  }
}