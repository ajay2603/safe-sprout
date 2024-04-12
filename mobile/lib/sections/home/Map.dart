import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {
  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  LatLng _currentLocation = LatLng(30, 40);

  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _initGetCurrentLocation();
  }

  Future<void> _initGetCurrentLocation() async {
    // Check if permission is granted
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // If permission is denied, request it
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case if the permission is not granted
        return;
      }
    }

    // Get current position if permission is granted
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation, 12);
    });
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    Future.delayed(Duration(seconds: 1), _getCurrentLocation);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation,
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentLocation,
              width: 80,
              height: 80,
              child: Column(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                  Text("Current Location"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
