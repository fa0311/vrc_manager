// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getLoginSession(String key, String accountUid) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  return await storage.read(key: "$key$accountUid");
}

Future<void> setLoginSession(String key, String value, String accountUid) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  return await storage.write(key: "$key$accountUid", value: value);
}

Future<void> removeLoginSession(String key, String accountUid) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();
  return await storage.delete(key: "$key$accountUid");
}

Future<String?> getStorage(String key) async {
  try {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString(key);
  } catch (e) {
    return null;
  }
}

Future<bool> setStorage(String key, String value) async {
  final SharedPreferences storage = await SharedPreferences.getInstance();
  return await storage.setString(key, value);
}

Future<bool> removeStorage(String key) async {
  final SharedPreferences storage = await SharedPreferences.getInstance();
  return await storage.remove(key);
}

Future<List<String>> getStorageList(String key) async {
  try {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getStringList(key) ?? [];
  } catch (e) {
    return [];
  }
}

Future<bool> setStorageList(String key, List<String> value) async {
  final SharedPreferences storage = await SharedPreferences.getInstance();
  return await storage.setStringList(key, value);
}
