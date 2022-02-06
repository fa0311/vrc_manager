import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future getLoginSession(key) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: key);
}

Future setLoginSession(key, value) async {
  const storage = FlutterSecureStorage();
  return await storage.write(key: key, value: value);
}

Future getStorage(key) async {
  final storage = await SharedPreferences.getInstance();
  return storage.getString(key);
}

Future setStorage(key, value) async {
  final storage = await SharedPreferences.getInstance();
  return await storage.setString(key, value);
}
