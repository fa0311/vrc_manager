// ignore_for_file: prefer_equal_for_default_values

import '../assets/session.dart';

class VRChatAPI {
  Map<String, String> apiKey() {
    return {"apiKey": "JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"};
  }

  final vrchatSession = Session();
  Uri endpoint(path, Map<String, dynamic> queryParameters) {
    return Uri(scheme: 'https', host: 'vrchat.com', port: 443, path: path, queryParameters: queryParameters);
  }

  VRChatAPI({String cookie = ""}) {
    vrchatSession.headers["cookie"] = cookie;
  }

  Future<Map> login(username, password) {
    vrchatSession.get(endpoint('api/1/config', {}));
    return vrchatSession.basic(endpoint('api/1/auth/user', apiKey()), username, password);
  }

  Future<Map> loginTotp(code) {
    final param = {"code": code}..addAll(apiKey());
    return vrchatSession.post(endpoint('api/1/auth/twofactorauth/totp/verify', {}), param);
  }

  Future<Map> user() {
    return vrchatSession.get(endpoint('api/1/auth/user', apiKey()));
  }

  Future<Map> friends({int offset: 0, bool offline: true}) {
    final param = {"offline": offline, "offset": offset, "n": 0}..addAll(apiKey());
    return vrchatSession.get(endpoint('api/1/auth/user/friends', param));
  }
}
