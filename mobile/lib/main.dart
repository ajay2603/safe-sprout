import 'package:flutter/material.dart';
import 'package:mobile/providers/ChildrenListProvider.dart';
import 'package:mobile/providers/LocationProvider.dart';
import 'package:provider/provider.dart';
import 'App.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return (MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChildrenListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
      ],
      child: App(),
    ));
  }
}
