import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';

class Child {
  late String id;
  late String name;
  late bool safe;
  late bool tracking;
  late bool live;
  late LatLng currentLocation;

  Child(
      {required this.id,
      required this.name,
      required this.safe,
      required this.tracking,
      required this.live,
      required this.currentLocation});
}

class ChildrenListProvider extends ChangeNotifier {
  List childrenList = [];

  Map childrenMap = {};

  void setChildList(List list) {
    list.forEach((child) {
      childrenMap[child['_id']] = Child(
          id: child['_id'],
          name: child['name'],
          safe: child['safe'],
          tracking: child['tracking'],
          live: child['live'],
          currentLocation: LatLng(child['lastLocation']['latitude'].toDouble(),
              child['lastLocation']['longitude'].toDouble()));
    });

    childrenList = childrenMap.keys.toList();

    notifyListeners();
  }

  void updateChild(data) {
    print("called provider");
    if (childrenMap.containsKey(data['_id'])) {
      childrenMap[data['_id']].currentLocation = LatLng(
          data['lastLocation']['latitude'].toDouble(),
          data['lastLocation']['longitude'].toDouble());
      childrenMap[data['_id']].safe = data['safe'];
      childrenMap[data['_id']].tracking = data['tracking'];
      childrenMap[data['_id']].live = data['live'];
    }
    notifyListeners();
  }

  /*void setChildList(list) {
    childrenList = list;
    notifyListeners();
  }*/

  void addChild(child) {
    childrenMap[child['_id']] = Child(
        id: child['_id'],
        name: child['name'],
        safe: child['safe'],
        tracking: child['tracking'],
        live: child['live'],
        currentLocation: LatLng(child['lastLocation']['latitude'].toDouble(),
            child['lastLocation']['longitude'].toDouble()));

    notifyListeners();
  }
}
