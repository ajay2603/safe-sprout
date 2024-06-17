import "dart:async";
import "package:geolocator/geolocator.dart";
import "package:flutter/widgets.dart";
import "package:mobile/providers/LocationProvider.dart";
import "package:provider/provider.dart";
import "dart:io";

Future<void> getCurrentLocationStream(BuildContext context) async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // If permission is denied, request it
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      exit(0);
    }
  }

  var positionStream = await Geolocator.getPositionStream(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.best))
      .listen((position) {
    context.read<LocationProvider>().setCurrentLocationPosition(position);
  });
}
