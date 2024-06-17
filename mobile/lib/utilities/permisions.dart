import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void retryLocation(BuildContext context, String description) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Location Access"),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            child: Text('Retry'),
            onPressed: () {
              requestLocationPermisionChild(context);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('cancle'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future requestLocationPermisionChild(BuildContext context) async {
  PermissionStatus permission = await Permission.locationAlways.status;

  if (permission == PermissionStatus.denied) {
    // Permissions are denied, request permission.
    permission = await Permission.locationAlways.request();
    if (permission == PermissionStatus.granted) {
      return true;
    } else {
      retryLocation(context,
          "Safe Sprout need permision to access location all time to track your child location");
      return false;
    }
  } else if (permission == PermissionStatus.granted) {
    return true;
  }
}
