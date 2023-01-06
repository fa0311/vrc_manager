// Package imports:

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';

enum ConfigStorageKey {
  username,
  password,
  rememberLoginInfoKey,
  selectedId;
}

class ConfigStorage {
  final String id;

  ConfigStorage({this.id = ""});

  Future<String?> getSecure({required ConfigStorageKey key}) async {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      return await storage.read(key: "$key$id");
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return null;
    }
  }

  Future<bool> setSecure({required ConfigStorageKey key, required String value}) async {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.write(key: "$key$id", value: value);
      return true;
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return false;
    }
  }

  Future<bool> removeSecure({required ConfigStorageKey key}) async {
    try {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.delete(key: "$key$id");
      return true;
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return false;
    }
  }

  Future<String?> get({required ConfigStorageKey key}) async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      return storage.getString("$key$id");
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return null;
    }
  }

  Future<bool> set({required ConfigStorageKey key, required String value}) async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      return await storage.setString("$key$id", value);
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return false;
    }
  }

  Future<bool> remove({required ConfigStorageKey key}) async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      return await storage.remove("$key$id");
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return false;
    }
  }

  Future<bool?> getBool({required ConfigStorageKey key}) async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      return storage.getBool("$key$id");
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return null;
    }
  }

  Future<bool> setBool({required ConfigStorageKey key, required bool value}) async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      return await storage.setBool("$key$id", value);
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return false;
    }
  }

  Future<List<String>> getList({required ConfigStorageKey key}) async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      return storage.getStringList("$key$id") ?? [];
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return [];
    }
  }

  Future<bool> setList({required ConfigStorageKey key, required List<String> value}) async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      return await storage.setStringList("$key$id", value);
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
      return false;
    }
  }
}
