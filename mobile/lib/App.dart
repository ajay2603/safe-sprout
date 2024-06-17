import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/providers/LocationProvider.dart';
import 'package:mobile/screens/ChildInfo.dart';
import 'package:mobile/screens/Home.dart';
import 'package:provider/provider.dart';
import './screens/Validation.dart';
import './screens/Auth.dart';
import './screens/NewChild.dart';

import './providers/ChildrenListProvider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent, // Change this to match your AppBar color
      ),
    );

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
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: "/",
        routes: {
          "/": (context) => const Validation(),
          "/auth": (context) => Auth(),
          "/home": (context) => Home(),
          "/add-child": (context) => NewChild(),
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
