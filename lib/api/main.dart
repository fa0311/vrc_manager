import 'package:vrchat_mobile_client/assets/session.dart';

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

  Future<Map> friends({int offset = 0, bool offline = false}) {
    final param = {"offline": offline.toString(), "offset": offset.toString(), "n": "50"};
    param.addAll(apiKey());
    return vrchatSession.get(endpoint('api/1/auth/user/friends', param));
  }

  Future<Map> users(String uid) {
    return vrchatSession.get(endpoint('api/1/users/' + uid, apiKey()));
  }

  Future<Map> worlds(String wid) {
    return vrchatSession.get(endpoint('api/1/worlds/' + wid, apiKey()));
  }

  Future<Map> instances(String location) {
    return vrchatSession.get(endpoint('api/1/instances/' + location, apiKey()));
  }

  Future<Map> invite(String wid) {
    return vrchatSession.post(endpoint('api/1/worlds/' + wid, apiKey()), {});
  }

  Future<Map> changeName(
    String uid,
    String username,
    String password,
  ) {
    return vrchatSession.put(endpoint('api/1/users/' + uid, apiKey()), {"currentPassword": password, "displayName": username});
  }
}
