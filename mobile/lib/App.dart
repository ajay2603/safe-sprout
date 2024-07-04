import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:mobile/providers/LocationProvider.dart';
import 'package:mobile/screens/ChildInfo.dart';
import 'package:mobile/screens/Home.dart';
import 'package:mobile/screens/Tracking.dart';
import 'package:mobile/utilities/childlocation.dart';
import 'package:mobile/utilities/secure_storage.dart';
import 'package:provider/provider.dart';
import './screens/Validation.dart';
import './screens/Auth.dart';
import './screens/NewChild.dart';

import './providers/ChildrenListProvider.dart';

class App extends StatelessWidget {
  const App({super.key});

  void handleEvents(BuildContext context) async {
    FlutterBackgroundService service = FlutterBackgroundService();

    // Check if the service is running
    bool isRunning = await service.isRunning();

    // If the service is running, stop it
    if (isRunning) {
      service.invoke("stop");
    }

    // Start a new instance of the service
    await service.startService();

    // Set up listeners for the new service instance
    service.on("demo").listen((event) {
      print(event);
    });

    service.on("updateChild").listen((event) {
      if (event != null) {
        print(event);
        Provider.of<ChildrenListProvider>(context, listen: false)
            .updateChild(event['data']);
      }
    });

    service.on("upDateTracking").listen((event) {
      print(event);
      print("blab blab");
      if (event != null) {
        Provider.of<ChildrenListProvider>(context, listen: false)
            .updateTracking(event['data']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    handleEvents(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent, // Change this to match your AppBar color
      ),
    );

    //startBackgroundService();

    return MaterialApp(
      title: "My First App",
      theme: ThemeData(primaryColor: Colors.blue),
      initialRoute: "/",
      routes: {
        "/": (context) => const Validation(),
        "/auth": (context) => Auth(),
        "/home": (context) => Home(),
        "/add-child": (context) => NewChild(),
        "/tracking": (context) => Tracking()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/child') {
          final Child child = settings.arguments as Child;
          return MaterialPageRoute(
            builder: (context) => ChildInfo(child: child),
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
