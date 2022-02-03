import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future getLoginSession(key) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: key);
}

Future setLoginSession(key, value) async {
  const storage = FlutterSecureStorage();
  return await storage.write(key: key, value: value);
}
