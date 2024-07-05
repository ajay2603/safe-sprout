import 'package:flutter/material.dart';
import 'package:mobile/providers/ChildrenListProvider.dart';
import 'package:mobile/providers/LocationProvider.dart';
import 'package:mobile/utilities/childlocation.dart';
import 'package:mobile/utilities/secure_storage.dart';
import './global/type.dart';
import 'package:provider/provider.dart';
import 'App.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      print(Type.getType());
      if (Type.getType() == "parent") stopBackgroundService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChildrenListProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
      ],
      child: App(),
    );
  }
}
