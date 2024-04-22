import 'dart:ffi';

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

  bool initSt = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
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

    var positionStream = await Geolocator.getPositionStream(
            locationSettings: LocationSettings(accuracy: LocationAccuracy.best))
        .listen((position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        if (initSt) {
          _mapController.move(_currentLocation, 18.5);
          initSt = !initSt;
        }
      });
    });
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
              rotate: true,
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
