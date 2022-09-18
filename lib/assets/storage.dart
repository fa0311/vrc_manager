// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getLoginSession(String key, String id) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  return await storage.read(key: "$key$id");
}

Future<void> setLoginSession(String key, String value, String id) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  return await storage.write(key: "$key$id", value: value);
}

Future<void> removeLoginSession(String key, String id) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  return await storage.delete(key: "$key$id");
}

Future<String?> getStorage(String key, {String id = ""}) async {
  try {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString("$key$id");
  } catch (e) {
    return null;
  }
}

Future<bool> setStorage(String key, String value, {String id = ""}) async {
  final SharedPreferences storage = await SharedPreferences.getInstance();
  return await storage.setString("$key$id", value);
}

Future<bool> removeStorage(String key, {String id = ""}) async {
  final SharedPreferences storage = await SharedPreferences.getInstance();
  return await storage.remove("$key$id");
}

Future<List<String>> getStorageList(String key, {String id = ""}) async {
  try {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getStringList("$key$id") ?? [];
  } catch (e) {
    return [];
  }
}

Future<bool> setStorageList(String key, List<String> value, {String id = ""}) async {
  final SharedPreferences storage = await SharedPreferences.getInstance();
  return await storage.setStringList("$key$id", value);
}
