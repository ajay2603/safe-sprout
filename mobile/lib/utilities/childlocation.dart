import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile/sockets/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

Future<void> startChildBackgroundService() async {
  await initializeChildService();
  final service = FlutterBackgroundService();
  service.startService();
}

Future<void> stopBackgroundService() async {
  final service = FlutterBackgroundService();
  service.invoke("stop");
  socketInit();
}

Future<void> startParentBackgroundService() async {
  await initializeParentService();
  final service = FlutterBackgroundService();
  service.startService();
}

Future<void> initializeParentService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onChildStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: false,
      onStart: onParentStart,
      isForegroundMode: false, // Set to true for foreground service
      autoStartOnBoot: false,
    ),
  );
}

Future<void> initializeChildService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onChildStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onChildStart,
      isForegroundMode: true, // Set to true for foreground service
      autoStartOnBoot: false,
    ),
  );
}

@pragma('vm:entry-point')
void onParentStart(ServiceInstance service) async {
  socketInit();

  service.on("stop").listen((event) {
    service.stopSelf();
    print("Background process stopped");
  });
}

@pragma('vm:entry-point')
void onChildStart(ServiceInstance service) async {
  socketInit();

  socket?.on("event-name", (data) {
    // Handle events from the server
    print("Received event: $data");
  });

  service.on("stop").listen((event) {
    service.stopSelf();
    print("Background process stopped");
  });

  // Start geolocation updates
  _startLocationUpdates();
}

void _reconnectSocket() {
  // Implement your socket reconnection logic here
  print('Attempting to reconnect...');
  io.Socket? socket = getSocket();
  socket?.connect(); // Example: Attempt to reconnect immediately
}

void _startLocationUpdates() {
  Geolocator.getPositionStream().listen((position) {
    print(position);
    io.Socket? socket = getSocket();
    socket?.emit("location", {
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
