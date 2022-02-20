import 'package:vrchat_mobile_client/assets/session.dart';

class VRChatAPI {
  Map<String, String> apiKey() {
    return {"apiKey": "JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"};
  }

  final vrchatSession = Session();
  Uri endpoint(path, [Map<String, String>? queryParameters]) {
    return Uri(scheme: 'https', host: 'vrchat.com', port: 443, path: path, queryParameters: queryParameters ?? {});
  }

  VRChatAPI({String cookie = ""}) {
    vrchatSession.headers["cookie"] = cookie;
  }

  /* ログイン */

  Future<Map> login(username, password) {
    vrchatSession.get(endpoint('api/1/config', {}));
    return vrchatSession.basic(endpoint('api/1/auth/user', apiKey()), username, password);
  }

  Future<Map> loginTotp(code) {
    final param = {"code": code}..addAll(apiKey());
    return vrchatSession.post(endpoint('api/1/auth/twofactorauth/totp/verify'), param);
  }

  /* 自身 */

  Future<Map> user() {
    return vrchatSession.get(endpoint('api/1/auth/user', apiKey()));
  }

  /* ユーザー */

  Future<Map> users(String uid) {
    return vrchatSession.get(endpoint('api/1/users/' + uid, apiKey()));
  }

  Future<Map> friendStatus(String uid) {
    return vrchatSession.get(endpoint('api/1/user/' + uid + '/friendStatus', apiKey()));
  }

  Future<Map> sendFriendRequest(String uid) {
    return vrchatSession.post(endpoint('api/1/user/' + uid + '/friendRequest', apiKey()));
  }

  Future<Map> deleteFriendRequest(String uid) {
    return vrchatSession.delete(endpoint('api/1/user/' + uid + '/friendRequest', apiKey()));
  }

  /* フレンド */

  Future<Map> friends({int offset = 0, bool offline = false}) {
    final param = {"offline": offline.toString(), "offset": offset.toString(), "n": "50"}..addAll(apiKey());
    return vrchatSession.get(endpoint('api/1/auth/user/friends', param));
  }

  Future<Map> deleteFriend(String uid) {
    return vrchatSession.delete(endpoint('api/1/auth/user/friends/' + uid, apiKey()));
  }

  /* 通知 */

  Future<Map> notifications({String type = "all", int offset = 0, String after = "", bool hidden = true}) {
    final param = {"sent": "false", "type": type, "after": after, "hidden": hidden.toString(), "offset": offset.toString(), "n": "100"}..addAll(apiKey());
    if (type == "friendRequest") param.remove("hidden");
    if (param["after"] == "") param.remove("after");
    return vrchatSession.get(endpoint('/api/1/auth/user/notifications', param));
  }

  Future<Map> notificationsSee(String fid) {
    return vrchatSession.get(endpoint('/api/1/auth/user/notifications/' + fid + '/see', apiKey()));
  }

  /* その他取得 */

  Future<Map> worlds(String wid) {
    return vrchatSession.get(endpoint('api/1/worlds/' + wid, apiKey()));
  }

  Future<Map> instances(String location) {
    return vrchatSession.get(endpoint('api/1/instances/' + location, apiKey()));
  }

  /* 変更 */

  Future<Map> changeName(
    String uid,
    String username,
    String password,
  ) {
    return vrchatSession.put(endpoint('api/1/users/' + uid, apiKey()), {"currentPassword": password, "displayName": username});
  }
}
