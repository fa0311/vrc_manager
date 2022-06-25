// Project imports:
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/assets/session.dart';

class VRChatAPI {
  VRChatAPI({String cookie = ""}) {
    vrchatSession.headers["cookie"] = cookie;
  }

  Map<String, String> apiKey() {
    return <String, String>{"apiKey": "JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"};
  }

  final Session vrchatSession = Session();
  Uri endpoint(String path, [Map<String, String>? queryParameters]) {
    return Uri(
      scheme: 'https',
      host: 'vrchat.com',
      port: 443,
      path: path,
      queryParameters: queryParameters ?? {},
    );
  }

  // Login

  Future<Map<dynamic, dynamic>> login(String username, String password) {
    vrchatSession.get(
      endpoint('api/1/config', {}),
    );
    return vrchatSession.basic(
        endpoint(
          'api/1/auth/user',
          apiKey(),
        ),
        username,
        password);
  }

  Future<Map<dynamic, dynamic>> loginTotp(String code) {
    final param = {"code": code}..addAll(
        apiKey(),
      );
    return vrchatSession.post(endpoint('api/1/auth/twofactorauth/totp/verify'), param);
  }

  // Self

  Future<dynamic> user() {
    return vrchatSession.get(
      endpoint(
        'api/1/auth/user',
        apiKey(),
      ),
    );
  }

  // User

  Future<VRChatUser> users(String uid) {
    return vrchatSession
        .get(
          endpoint(
            'api/1/users/$uid',
            apiKey(),
          ),
        )
        .then((value) => VRChatUser.fromJson(value));
  }

  Future<dynamic> friendStatus(String uid) {
    return vrchatSession.get(
      endpoint(
        'api/1/user/$uid/friendStatus',
        apiKey(),
      ),
    );
  }

  Future<Map<dynamic, dynamic>> sendFriendRequest(String uid) {
    return vrchatSession.post(
      endpoint(
        'api/1/user/$uid/friendRequest',
        apiKey(),
      ),
    );
  }

  Future<Map<dynamic, dynamic>> deleteFriendRequest(String uid) {
    return vrchatSession.delete(
      endpoint(
        'api/1/user/$uid/friendRequest',
        apiKey(),
      ),
    );
  }

  // Friends

  Future<VRChatUsers> friends({int offset = 0, bool offline = false}) {
    final param = {
      "offline": offline.toString(),
      "offset": offset.toString(),
      "n": "50",
    }..addAll(
        apiKey(),
      );
    return vrchatSession
        .get(
          endpoint('api/1/auth/user/friends', param),
        )
        .then((value) => VRChatUsers.fromJson(value));
  }

  Future<Map<dynamic, dynamic>> deleteFriend(String uid) {
    return vrchatSession.delete(
      endpoint(
        'api/1/auth/user/friends/$uid',
        apiKey(),
      ),
    );
  }

  // Favorite

  Future<dynamic> favoriteGroups(String type, {int offset = 0}) {
    final param = {
      "type": type,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(
        apiKey(),
      );
    return vrchatSession.get(
      endpoint('api/1/favorite/groups', param),
    );
  }

  Future<Map<dynamic, dynamic>> addFavorites(String type, String id, String tags) {
    return vrchatSession.post(
      endpoint(
        'api/1/favorites',
        apiKey(),
      ),
      {"type": type, "favoriteId": id, "tags": tags},
    );
  }

  Future<Map<dynamic, dynamic>> deleteFavorites(String fid) {
    return vrchatSession.delete(
      endpoint(
        'api/1/favorites/$fid',
        apiKey(),
      ),
    );
  }

  // Notify

  Future<dynamic> notifications({String type = "all", int offset = 0, String after = "", bool hidden = true}) {
    final param = <String, String>{
      "sent": "false",
      "type": type,
      "after": after,
      "hidden": hidden.toString(),
      "offset": offset.toString(),
      "n": "100",
    }..addAll(
        apiKey(),
      );
    if (type == "friendRequest") param.remove("hidden");
    if (param["after"] == "") param.remove("after");
    return vrchatSession.get(
      endpoint('/api/1/auth/user/notifications', param),
    );
  }

  Future<dynamic> notificationsSee(String fid) {
    return vrchatSession.get(
      endpoint(
        '/api/1/auth/user/notifications/$fid/see',
        apiKey(),
      ),
    );
  }

  // World

  Future<dynamic> worlds(String wid) {
    return vrchatSession.get(
      endpoint(
        'api/1/worlds/$wid',
        apiKey(),
      ),
    );
  }

  Future<dynamic> favoritesWorlds(String type, {int offset = 0}) {
    final param = {
      "tag": type,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(
        apiKey(),
      );
    return vrchatSession.get(
      endpoint('api/1/worlds/favorites', param),
    );
  }

  // Instance

  Future<dynamic> instances(String location) {
    return vrchatSession.get(
      endpoint(
        'api/1/instances/$location',
        apiKey(),
      ),
    );
  }

  Future<Map<dynamic, dynamic>> selfInvite(String location) {
    return vrchatSession.post(
      endpoint(
        'api/1/instances/$location/invite',
        apiKey(),
      ),
    );
  }

  // Change

  Future<Map<dynamic, dynamic>> changeName(String uid, String username, String password) {
    return vrchatSession.put(
      endpoint(
        'api/1/users/$uid',
        apiKey(),
      ),
      {"currentPassword": password, "displayName": username},
    );
  }
}
