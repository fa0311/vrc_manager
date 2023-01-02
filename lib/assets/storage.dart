// Package imports:
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';

Future<String?> getLoginSession(String key, String id) async {
  try {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: "$key$id");
  } catch (e) {
    logger.w(getMessage(e), e);
    return null;
  }
}

Future<void> setLoginSession(String key, String value, String id) async {
  try {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.write(key: "$key$id", value: value);
  } catch (e) {
    logger.w(getMessage(e), e);
  }
}

Future<void> removeLoginSession(String key, String id) async {
  try {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.delete(key: "$key$id");
  } catch (e) {
    logger.w(getMessage(e), e);
  }
}

Future<String?> getStorage(String key, {String id = ""}) async {
  try {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getString("$key$id");
  } catch (e) {
    logger.w(getMessage(e), e);
    return null;
  }
}

Future<bool> setStorage(String key, String value, {String id = ""}) async {
  try {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return await storage.setString("$key$id", value);
  } catch (e) {
    logger.w(getMessage(e), e);
    return false;
  }
}

Future<bool> removeStorage(String key, {String id = ""}) async {
  try {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return await storage.remove("$key$id");
  } catch (e) {
    logger.w(getMessage(e), e);
    return false;
  }
}

Future<List<String>> getStorageList(String key, {String id = ""}) async {
  try {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return storage.getStringList("$key$id") ?? [];
  } catch (e) {
    logger.w(getMessage(e), e);
    return [];
  }
}

Future<bool> setStorageList(String key, List<String> value, {String id = ""}) async {
  try {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    return await storage.setStringList("$key$id", value);
  } catch (e) {
    logger.w(getMessage(e), e);
    return false;
  }
}
