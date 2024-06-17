import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  LatLng currentLocation = LatLng(0, 0);
  bool currentDisp = false;

  void setCurrentLocationPosition(Position position) {
    currentDisp = true;
    currentLocation = LatLng(position.latitude, position.longitude);
    notifyListeners();
  }
}
