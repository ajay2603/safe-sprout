import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/utilities/dialogs.dart';
import '../../utilities/secure_storage.dart';
import '../../global/consts.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {
  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  LatLng _currentLocation = LatLng(0, 0);
  LatLng _homeLocation = LatLng(0, 0);

  LatLng _prevHomeLocation = LatLng(0, 0);

  MapController _mapController = MapController();

  bool homeDisp = false;
  bool currentDisp = false;

  bool prevHomeDisp = false;

  bool initSt = true;

  bool updatingHome = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getHomeLocation();
  }

  Future<void> getHomeLocation() async {
    var token = await getKey("token") ?? "";
    try {
      var response = await http.Client().get(
        Uri.parse("$serverURL/user/home-location"),
        headers: {"Authorization": token},
      );
      if (response.statusCode != 200) return;
      var data = jsonDecode(response.body);
      if (data['homeLocation'] == null) return;
      setState(() {
        _homeLocation = LatLng(data['homeLocation']['latitude'],
            data['homeLocation']['longitude']);
        homeDisp = true;
      });
    } catch (err) {
      print(err);
      getHomeLocation();
    }
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
        currentDisp = true;
        _currentLocation = LatLng(position.latitude, position.longitude);
        if (initSt) {
          _mapController.move(_currentLocation, 18.8);
          initSt = !initSt;
        }
      });
    });
  }

  void handleTap(LatLng point) {
    print(point);
    if (updatingHome) {
      setState(() {
        _homeLocation = point;
        homeDisp = true;
      });
    }
  }

  Future<void> setHome() async {
    var token = await getKey("token") ?? "";
    try {
      var response = await http.Client()
          .post(Uri.parse("$serverURL/user/set-home"), body: {
        "longitude": _homeLocation.longitude.toString(),
        "latitude": _homeLocation.latitude.toString(),
      }, headers: {
        "Authorization": token
      });
      var result = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("ok");
        setState(() {
          updatingHome = false;
        });
      } else {
        alertDialog("Error", result['message'], context);
      }
    } catch (err) {
      print(err);
      retryAlertDialog(
          "Network Error", "Unable to connect server", context, setHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation,
            initialZoom: 9.2,
            onTap: ((tapPosition, point) => handleTap(point)),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                ...(currentDisp)
                    ? [
                        Marker(
                          point: _currentLocation,
                          width: 130,
                          height: 130,
                          rotate: true,
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: Colors.red,
                                size: 40,
                              ),
                              Text(
                                "Current Location",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      ]
                    : [],
                ...homeDisp
                    ? [
                        Marker(
                          point: _homeLocation,
                          width: 130,
                          height: 130,
                          child: Column(
                            children: [
                              ...(updatingHome)
                                  ? [
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setHome();
                                            },
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                updatingHome = false;
                                                homeDisp = prevHomeDisp;
                                                _homeLocation =
                                                    _prevHomeLocation;
                                              });
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      )
                                    ]
                                  : [],
                              Icon(
                                Icons.home,
                                color: Colors.blue,
                                size: 40,
                              ),
                              Text("Home"),
                            ],
                          ),
                        )
                      ]
                    : [],
              ],
            ),
          ],
        ),
        Positioned(
          right: 10,
          bottom: 20,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  _mapController.move(_currentLocation, 18.8);
                },
                child: Icon(Icons.my_location_rounded),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onLongPress: () {
                  print("long pressed");
                  setState(() {
                    _prevHomeLocation = _homeLocation;
                    prevHomeDisp = homeDisp;
                    if (!homeDisp) {
                      _homeLocation = _currentLocation;
                      homeDisp = true;
                    }
                    updatingHome = true;
                  });
                },
                child: FloatingActionButton(
                  onPressed: () {
                    _mapController.move(_homeLocation, 18.8);
                  },
                  child: Icon(Icons.home),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
