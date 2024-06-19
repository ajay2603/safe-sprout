import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:connectivity/connectivity.dart';
import 'package:mobile/global/consts.dart';
import 'package:mobile/utilities/secure_storage.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true, // Set to true for foreground service
      autoStartOnBoot: true,
    ),
  );
}



@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  final socket = io.io(serverURL, {
    'transports': ['websocket'],
    'extraHeaders': {'Authorization': getKey('token')},
  });

  socket.onConnect((_) {
    print('Connected. Socket ID: ${socket.id}');
  });

  socket.onDisconnect((_) {
    print('Disconnected');
    // Reconnect logic
    _reconnectSocket(socket);
  });

  socket.on("event-name", (data) {
    // Handle events from the server
    print("Received event: $data");
  });

  service.on("stop").listen((event) {
    service.stopSelf();
    print("Background process stopped");
  });

  // Start geolocation updates
  _startLocationUpdates(socket);
}

void _reconnectSocket(io.Socket socket) {
  // Implement your socket reconnection logic here
  print('Attempting to reconnect...');
  socket.connect(); // Example: Attempt to reconnect immediately
}

void _startLocationUpdates(io.Socket socket) {
  Geolocator.getPositionStream().listen((position) {
    print(position);
    socket.emit("location", {
      "latitude": position.latitude,
      "longitude": position.longitude,
    });
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  // Handle iOS specific background tasks if needed
  return true;
}
