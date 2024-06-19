import 'package:flutter/material.dart';
import 'App.dart';

import './utilities/childlocation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  runApp(const MyApp());
}
