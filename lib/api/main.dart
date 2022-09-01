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

  Future<VRChatLogin> login(String username, String password) {
    vrchatSession.get(
      endpoint('api/1/config', {}),
    );
    return vrchatSession
        .basic(
          endpoint(
            'api/1/auth/user',
            apiKey(),
          ),
          username,
          password,
        )
        .then((value) => VRChatLogin.fromJson(value));
  }

  Future<VRChatLogin> loginTotp(String code) {
    final param = {"code": code}..addAll(
        apiKey(),
      );
    return vrchatSession.post(endpoint('api/1/auth/twofactorauth/totp/verify'), param).then((value) => VRChatLogin.fromJson(value));
  }

  // Self

  Future<VRChatUserOverload> user() {
    return vrchatSession
        .get(
          endpoint(
            'api/1/auth/user',
            apiKey(),
          ),
        )
        .then((value) => VRChatUserOverload.fromJson(value));
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

  Future<VRChatUserNotes> userNotes(String uid, String note) {
    return vrchatSession.post(
        endpoint(
          'api/1/userNotes',
          apiKey(),
        ),
        {"targetUserId": uid, "note": note}).then((value) => VRChatUserNotes.fromJson(value));
  }

  Future<VRChatfriendStatus> friendStatus(String uid) {
    return vrchatSession
        .get(
          endpoint(
            'api/1/user/$uid/friendStatus',
            apiKey(),
          ),
        )
        .then((value) => VRChatfriendStatus.fromJson(value));
  }

  Future<VRChatNotifications> sendFriendRequest(String uid) {
    return vrchatSession
        .post(
          endpoint(
            'api/1/user/$uid/friendRequest',
            apiKey(),
          ),
        )
        .then((value) => VRChatNotifications.fromJson(value));
  }

  Future<VRChatStatus> deleteFriendRequest(String uid) {
    return vrchatSession
        .delete(
          endpoint(
            'api/1/user/$uid/friendRequest',
            apiKey(),
          ),
        )
        .then((value) => VRChatStatus.fromJson(value));
  }

  Future<VRChatStatus> acceptFriendRequest(String notificationId) {
    return vrchatSession
        .put(
          endpoint(
            '/auth/user/notifications/$notificationId/accept',
            apiKey(),
          ),
        )
        .then((value) => VRChatStatus.fromJson(value));
  }

  Future<VRChatAcceptFriendRequestByUid> acceptFriendRequestByUid(String uid) {
    return vrchatSession
        .post(
          endpoint(
            'api/1/user/$uid/friendRequest',
            apiKey(),
          ),
        )
        .then((value) => VRChatAcceptFriendRequestByUid.fromJson(value));
  }

  // Friends

  Future<VRChatUserList> friends({int offset = 0, bool offline = false}) {
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
        .then((value) => VRChatUserList.fromJson(value));
  }

  Future<VRChatStatus> deleteFriend(String uid) {
    return vrchatSession
        .delete(
          endpoint(
            'api/1/auth/user/friends/$uid',
            apiKey(),
          ),
        )
        .then((value) => VRChatStatus.fromJson(value));
  }

  // Search

  Future<VRChatUserLimitedList> searchUsers(String search, {int offset = 0, String sort = "relevance", bool fuzzy = false}) {
    final param = {
      "sort": sort,
      "fuzzy": fuzzy.toString(),
      "search": search,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(
        apiKey(),
      );
    return vrchatSession
        .get(
          endpoint(
            'api/1/users',
            param,
          ),
        )
        .then((value) => VRChatUserLimitedList.fromJson(value));
  }

  Future<VRChatLimitedWorldList> searchWorlds(String search, {int offset = 0, String sort = "relevance", bool fuzzy = false}) {
    final param = {
      "sort": sort,
      "fuzzy": fuzzy.toString(),
      "search": search,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(
        apiKey(),
      );
    return vrchatSession
        .get(
          endpoint(
            'api/1/worlds',
            param,
          ),
        )
        .then((value) => VRChatLimitedWorldList.fromJson(value));
  }

  // Favorite

  Future<VRChatFavoriteGroupList> favoriteGroups(String type, {int offset = 0}) {
    final param = {
      "type": type,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(
        apiKey(),
      );
    return vrchatSession
        .get(
          endpoint('api/1/favorite/groups', param),
        )
        .then((value) => VRChatFavoriteGroupList.fromJson(value));
  }

  Future<VRChatFavorite> addFavorites(String type, String id, String tags) {
    return vrchatSession.post(
      endpoint(
        'api/1/favorites',
        apiKey(),
      ),
      {"type": type, "favoriteId": id, "tags": tags},
    ).then((value) => VRChatFavorite.fromJson(value));
  }

  Future<VRChatStatus> deleteFavorites(String fid) {
    return vrchatSession
        .delete(
          endpoint(
            'api/1/favorites/$fid',
            apiKey(),
          ),
        )
        .then((value) => VRChatStatus.fromJson(value));
  }

  // Notify

  Future<VRChatNotificationsList> notifications({String type = "all", int offset = 0, String after = "", bool hidden = true}) {
    final param = <String, String>{
      "sent": "false",
      "type": type,
      "after": after,
      "hidden": hidden.toString(),
      "offset": offset.toString(),
      "n": "50",
    }..addAll(
        apiKey(),
      );
    if (type == "friendRequest") param.remove("hidden");
    if (param["after"] == "") param.remove("after");
    return vrchatSession
        .get(
          endpoint('api/1/auth/user/notifications', param),
        )
        .then((value) => VRChatNotificationsList.fromJson(value));
  }

  Future<VRChatNotifications> notificationsSee(String fid) {
    return vrchatSession
        .get(
          endpoint(
            'api/1/auth/user/notifications/$fid/see',
            apiKey(),
          ),
        )
        .then((value) => VRChatNotifications.fromJson(value));
  }

  // World

  Future<VRChatWorld> worlds(String wid) {
    return vrchatSession
        .get(
          endpoint(
            'api/1/worlds/$wid',
            apiKey(),
          ),
        )
        .then((value) => VRChatWorld.fromJson(value));
  }

  Future<VRChatFavoriteWorldList> favoritesWorlds(String type, {int offset = 0}) {
    final param = {
      "tag": type,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(
        apiKey(),
      );
    return vrchatSession
        .get(
          endpoint('api/1/worlds/favorites', param),
        )
        .then((value) => VRChatFavoriteWorldList.fromJson(value));
  }

  // Instance

  Future<VRChatInstance> instances(String location) {
    return vrchatSession
        .get(
          endpoint(
            'api/1/instances/$location',
            apiKey(),
          ),
        )
        .then((value) => VRChatInstance.fromJson(value));
  }

  Future<VRChatNotificationsInvite> selfInvite(String location, String shortName) {
    return vrchatSession.post(
      endpoint(
        'api/1/invite/myself/to/$location',
        apiKey(),
      ),
      {"shortName": shortName},
    ).then((value) => VRChatNotificationsInvite.fromJson(value));
  }

  Future<VRChatSecureName> shortName(String location) {
    return vrchatSession
        .get(
          endpoint(
            'api/1/instances/$location/shortName',
            apiKey(),
          ),
        )
        .then((value) => VRChatSecureName.fromJson(value));
  }

  Future<VRChatStatus> selfInviteLegacy(String location) {
    return vrchatSession
        .post(
          endpoint(
            'api/1/invite/myself/to/$location',
            apiKey(),
          ),
        )
        .then((value) => VRChatStatus.fromJson(value));
  }

  // Change

  Future<VRChatUserOverload> changeName(String uid, String username, String password) {
    return vrchatSession.put(
      endpoint(
        'api/1/users/$uid',
        apiKey(),
      ),
      {"currentPassword": password, "displayName": username},
    ).then((value) => VRChatUserOverload.fromJson(value));
  }

  Future<VRChatUserPut> changeBio(String uid, String bio) {
    return vrchatSession.put(
      endpoint(
        'api/1/users/$uid',
        apiKey(),
      ),
      {"bio": bio},
    ).then((value) => VRChatUserPut.fromJson(value));
  }
}
