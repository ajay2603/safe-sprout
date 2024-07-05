import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "../global/type.dart";

FlutterSecureStorage? secureStorage;

Future<void> init() async {
  secureStorage = const FlutterSecureStorage();
}

Future<void> setKey(var key, var value) async {
  if (secureStorage == null) {
    await init();
  }
  if (key == "type") Type.setType(value);
  await secureStorage!.write(key: key, value: value);
}

Future<String?> getKey(String key) async {
  if (secureStorage == null) {
    await init();
  }
  var result = await secureStorage!.read(key: key);
  return result;
}

Future<void> removeKey(var key) async {
  if (secureStorage == null) {
    await init();
  }
  if (key == "type") Type.setType("");
  await secureStorage!.delete(key: key);
}
