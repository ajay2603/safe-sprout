import 'package:flutter/material.dart';
import 'package:mobile/screens/Home.dart';
import './screens/Validation.dart';
import './screens/Auth.dart';
import './screens/NewChild.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "My First App",
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: "/",
        routes: {
          "/": (context) => const Validation(),
          "/auth": (context) => Auth(),
          "/home": (context) => Home(),
          "/add-child": (context) => NewChild(),
        },
      );
}
