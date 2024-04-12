import 'package:flutter_secure_storage/flutter_secure_storage.dart';

FlutterSecureStorage? secureStorage;

Future<void> init() async {
  secureStorage = const FlutterSecureStorage();
}

Future<void> setKey(var key, var value) async {
  if (secureStorage == null) {
    await init();
  }
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
  await secureStorage!.delete(key: key);
}
