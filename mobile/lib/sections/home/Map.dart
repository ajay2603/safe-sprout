import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/providers/ChildrenListProvider.dart';
import 'package:mobile/providers/LocationProvider.dart';
import 'package:mobile/utilities/dialogs.dart';
import 'package:mobile/utilities/status.dart';
import '../../utilities/secure_storage.dart';
import '../../global/consts.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {
  @override
  _Map createState() => _Map();
}

class _Map extends State<Map> {
  LatLng _homeLocation = LatLng(0, 0);

  LatLng _prevHomeLocation = LatLng(0, 0);

  MapController _mapController = MapController();

  bool homeDisp = false;

  bool prevHomeDisp = false;

  bool initSt = true;

  bool updatingHome = false;

  @override
  void initState() {
    super.initState();
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
    LatLng _currentLocation = context.watch<LocationProvider>().currentLocation;
    bool currentDisp = context.watch<LocationProvider>().currentDisp;
    ChildrenListProvider childListProvider =
        Provider.of<ChildrenListProvider>(context, listen: true);
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
                          rotate: true,
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
                ...childListProvider.childrenMap.keys.map((id) {
                  if (id != null) {
                    return (Marker(
                      width: (childListProvider.childrenMap[id].tracking)
                          ? 150
                          : 0,
                      height: (childListProvider.childrenMap[id].tracking)
                          ? 150
                          : 0,
                      point: childListProvider.childrenMap[id].currentLocation,
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_pin_circle,
                            size: 50,
                            color: Colors.green,
                          ),
                          Text(
                            childListProvider.childrenMap[id].name,
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ));
                  } else {
                    return Marker(
                        width: 0,
                        height: 0,
                        point: LatLng(0, 0),
                        child: SizedBox());
                  }
                }),
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
        Positioned(
          top: 10,
          left: 0,
          child: SingleChildScrollView(
            child: Row(
              children: [
                ...childListProvider.childrenMap.keys.map((id) {
                  return ((childListProvider.childrenMap[id].tracking)
                      ? GestureDetector(
                          onTap: () {
                            _mapController.move(
                                childListProvider
                                    .childrenMap[id].currentLocation,
                                18.8);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                                color: setBgColor(
                                    true,
                                    childListProvider.childrenMap[id].live,
                                    childListProvider.childrenMap[id].safe),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: Text(
                                  childListProvider.childrenMap[id].name,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )),
                          ),
                        )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ));
                })
              ],
            ),
          ),
        )
      ],
    );
  }
}
