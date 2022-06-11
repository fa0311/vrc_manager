// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*

Future<String?> getLoginSession(key) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: key);
}


Future setLoginSession(key, value) async {
  const storage = FlutterSecureStorage();
  return await storage.write(key: key, value: value);
}
*/

Future<String?> getLoginSession(String key) async {
  String accountIndex = await getStorage("account_index") ?? "0";
  const storage = FlutterSecureStorage();
  return await storage.read(key: "$key$accountIndex");
}

Future setLoginSession(String key, String value) async {
  String accountIndex = await getStorage("account_index") ?? "0";
  const storage = FlutterSecureStorage();
  return await storage.write(key: "$key$accountIndex", value: value);
}

Future<String?> getStorage(String key) async {
  final storage = await SharedPreferences.getInstance();
  return storage.getString(key);
}

Future setStorage(String key, String value) async {
  final storage = await SharedPreferences.getInstance();
  return await storage.setString(key, value);
}
