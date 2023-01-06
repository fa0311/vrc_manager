import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';

class SecureStorageTextEditingController extends TextEditingController {
  final String key;
  SecureStorageTextEditingController({required this.key, super.text});

  Future<SecureStorageTextEditingController> init() async {
    await read();
    return this;
  }

  Future<void> read() async {
    try {
      const storage = FlutterSecureStorage();
      text = await storage.read(key: key) ?? "";
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
    }
  }

  Future<void> write() async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: key, value: text);
    } catch (e, trace) {
      logger.w(getMessage(e), e, trace);
    }
  }
}
