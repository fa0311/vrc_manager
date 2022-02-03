import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future getLoginSession() async {
  const storage = FlutterSecureStorage();
  return storage.read(key: "LoginSession");
}
