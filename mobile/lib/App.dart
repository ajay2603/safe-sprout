import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:mobile/providers/LocationProvider.dart';
import 'package:mobile/screens/ChildInfo.dart';
import 'package:mobile/screens/Home.dart';
import 'package:mobile/screens/Tracking.dart';
import 'package:mobile/utilities/secure_storage.dart';
import 'package:provider/provider.dart';
import './screens/Validation.dart';
import './screens/Auth.dart';
import './screens/NewChild.dart';

import './providers/ChildrenListProvider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this as WidgetsBindingObserver);
    var service = FlutterBackgroundService();
    var type = await getKey("type");
    if (type == "parent") {
      service.invoke("stop");
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent, // Change this to match your AppBar color
      ),
    );

    //startBackgroundService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChildrenListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
