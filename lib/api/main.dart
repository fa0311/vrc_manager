// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:logger/logger.dart';

// Project imports:
import 'package:vrc_manager/api/assets/assets.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/assets/session.dart';

class VRChatAPI {
  final Session vrchatSession = Session();
  final Logger? logger;
  final bool ignoreErrors = true;
  final JsonEncoder encoder = const JsonEncoder.withIndent("     ");

  VRChatAPI({String cookie = "", String userAgent = "", this.logger}) {
    vrchatSession.headers["cookie"] = cookie;
    vrchatSession.headers["user-agent"] = userAgent;
  }

  String getCookie() {
    return vrchatSession.headers["cookie"] ?? "";
  }

  setCookie(String? cookie) {
    vrchatSession.headers["cookie"] = cookie ?? "";
  }

  Map<String, String> apiKey() {
    return <String, String>{"apiKey": VRChatAssets.apiKey};
  }

  Uri endpoint(String path, [Map<String, String>? queryParameters]) {
    return VRChatAssets.vrchat.replace(path: path, queryParameters: queryParameters ?? {});
  }

  // Login

  Future<VRChatLogin> login(String username, String password) {
    vrchatSession.get(
      endpoint('api/1/config', {}),
    );
    return vrchatSession.basic(endpoint('api/1/auth/user', apiKey()), username, password).then((value) {
      try {
        return VRChatLogin.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatLogin> loginTotp(String code) {
    final param = {"code": code}..addAll(
        apiKey(),
      );
    return vrchatSession.post(endpoint('api/1/auth/twofactorauth/totp/verify'), param).then((value) {
      try {
        return VRChatLogin.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  // Self

  Future<VRChatUserSelfOverload> user() {
    return vrchatSession.get(endpoint('api/1/auth/user', apiKey())).then((value) {
      try {
        return VRChatUserSelfOverload.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  // User

  Future<VRChatUser> users(String uid) {
    return vrchatSession.get(endpoint('api/1/users/$uid', apiKey())).then((value) {
      try {
        return VRChatUser.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatUserSelf> selfUser(String uid) {
    return vrchatSession.get(endpoint('api/1/users/$uid', apiKey())).then((value) {
      try {
        return VRChatUserSelf.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatUserNotes> userNotes(String uid, String note) {
    return vrchatSession.post(endpoint('api/1/userNotes', apiKey()), {"targetUserId": uid, "note": note}).then((value) {
      try {
        return VRChatUserNotes.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatFriendStatus> friendStatus(String uid) {
    return vrchatSession.get(endpoint('api/1/user/$uid/friendStatus', apiKey())).then((value) {
      try {
        return VRChatFriendStatus.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatNotifications> sendFriendRequest(String uid) {
    return vrchatSession.post(endpoint('api/1/user/$uid/friendRequest', apiKey())).then((value) {
      try {
        return VRChatNotifications.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatStatus> deleteFriendRequest(String uid) {
    return vrchatSession.delete(endpoint('api/1/user/$uid/friendRequest', apiKey())).then((value) {
      try {
        return VRChatStatus.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatStatus> acceptFriendRequest(String notificationId) {
    return vrchatSession.put(endpoint('/auth/user/notifications/$notificationId/accept', apiKey())).then((value) {
      try {
        return VRChatStatus.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatAcceptFriendRequestByUid> acceptFriendRequestByUid(String uid) {
    return vrchatSession.post(endpoint('api/1/user/$uid/friendRequest', apiKey())).then((value) {
      try {
        return VRChatAcceptFriendRequestByUid.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  // Friends

  Future<List<VRChatFriends>> friends({int offset = 0, bool offline = false}) {
    final param = {
      "offline": offline.toString(),
      "offset": offset.toString(),
      "n": "50",
    }..addAll(apiKey());
    return vrchatSession.get(endpoint('api/1/auth/user/friends', param)).then((value) {
      return [
        for (dynamic content in value)
          () {
            try {
              return VRChatFriends.fromJson(content);
            } catch (e, trace) {
              logger?.e(e, encoder.convert(content), trace);
              if (ignoreErrors) return null;
              rethrow;
            }
          }()
      ].whereType<VRChatFriends>().toList();
    });
  }

  Future<VRChatStatus> deleteFriend(String uid) {
    return vrchatSession.delete(endpoint('api/1/auth/user/friends/$uid', apiKey())).then((value) {
      try {
        return VRChatStatus.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  // Search

  Future<List<VRChatUser>> searchUsers(String search, {int offset = 0, String sort = "relevance", bool fuzzy = false}) {
    final param = {
      "sort": sort,
      "fuzzy": fuzzy.toString(),
      "search": search,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(apiKey());
    return vrchatSession.get(endpoint('api/1/users', param)).then((value) {
      return [
        for (dynamic content in value)
          () {
            try {
              return VRChatUser.fromJson(content);
            } catch (e, trace) {
              logger?.e(e, encoder.convert(content), trace);
              if (ignoreErrors) return null;
              rethrow;
            }
          }()
      ].whereType<VRChatUser>().toList();
    });
  }

  Future<List<VRChatLimitedWorld>> searchWorlds(String search, {int offset = 0, String sort = "relevance", bool fuzzy = false}) {
    final param = {
      "sort": sort,
      "fuzzy": fuzzy.toString(),
      "search": search,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(apiKey());
    return vrchatSession.get(endpoint('api/1/worlds', param)).then((value) {
      return [
        for (dynamic content in value)
          () {
            try {
              return VRChatLimitedWorld.fromJson(content);
            } catch (e, trace) {
              logger?.e(e, encoder.convert(content), trace);
              if (ignoreErrors) return null;
              rethrow;
            }
          }()
      ].whereType<VRChatLimitedWorld>().toList();
    });
  }

  // Favorite

  Future<List<VRChatFavoriteGroup>> favoriteGroups(String type, {int offset = 0}) {
    final param = {
      "type": type,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(apiKey());
    return vrchatSession.get(endpoint('api/1/favorite/groups', param)).then((value) {
      return [
        for (dynamic content in value)
          () {
            try {
              return VRChatFavoriteGroup.fromJson(content);
            } catch (e, trace) {
              logger?.e(e, encoder.convert(content), trace);
              if (ignoreErrors) return null;
              rethrow;
            }
          }()
      ].whereType<VRChatFavoriteGroup>().toList();
    });
  }

  Future<VRChatFavorite> addFavorites(String type, String id, String tags) {
    return vrchatSession.post(
      endpoint('api/1/favorites', apiKey()),
      {"type": type, "favoriteId": id, "tags": tags},
    ).then((value) => VRChatFavorite.fromJson(value));
  }

  Future<VRChatStatus> deleteFavorites(String fid) {
    return vrchatSession.delete(endpoint('api/1/favorites/$fid', apiKey())).then((value) {
      try {
        return VRChatStatus.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  // Notify

  Future<List<VRChatNotifications>> notifications({String type = "all", int offset = 0, String after = "", bool hidden = true}) {
    final param = <String, String>{
      "sent": "false",
      "type": type,
      if (after != "") "after": after,
      if (type != "friendRequest") "hidden": hidden.toString(),
      "offset": offset.toString(),
      "n": "50",
    }..addAll(apiKey());
    return vrchatSession.get(endpoint('api/1/auth/user/notifications', param)).then((value) {
      return [
        for (dynamic content in value)
          () {
            try {
              return VRChatNotifications.fromJson(content);
            } catch (e, trace) {
              logger?.e(e, encoder.convert(content), trace);
              if (ignoreErrors) return null;
              rethrow;
            }
          }()
      ].whereType<VRChatNotifications>().toList();
    });
  }

  Future<VRChatNotifications> notificationsSee(String fid) {
    return vrchatSession.get(endpoint('api/1/auth/user/notifications/$fid/see', apiKey())).then((value) {
      try {
        return VRChatNotifications.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  // World

  Future<VRChatWorld> worlds(String wid) {
    return vrchatSession.get(endpoint('api/1/worlds/$wid', apiKey())).then((value) {
      try {
        return VRChatWorld.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<List<VRChatFavoriteWorld>> favoritesWorlds(String type, {int offset = 0}) {
    final param = {
      "tag": type,
      "offset": offset.toString(),
      "n": "50",
    }..addAll(apiKey());
    return vrchatSession.get(endpoint('api/1/worlds/favorites', param)).then((value) {
      return [
        for (dynamic content in value)
          () {
            try {
              return VRChatFavoriteWorld.fromJson(content);
            } catch (e, trace) {
              logger?.e(e, encoder.convert(content), trace);
              if (ignoreErrors) return null;
              rethrow;
            }
          }()
      ].whereType<VRChatFavoriteWorld>().toList();
    });
  }

  // Instance

  Future<VRChatInstance> instances(String location) {
    return vrchatSession.get(endpoint('api/1/instances/$location', apiKey())).then((value) {
      try {
        return VRChatInstance.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatNotificationsInvite> selfInvite(String location, String shortName) {
    return vrchatSession.post(endpoint('api/1/invite/myself/to/$location', apiKey()), {"shortName": shortName}).then((value) {
      try {
        return VRChatNotificationsInvite.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatSecureName> shortName(String location) {
    return vrchatSession.get(endpoint('api/1/instances/$location/shortName', apiKey())).then((value) {
      try {
        return VRChatSecureName.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatStatus> selfInviteLegacy(String location) {
    return vrchatSession.post(endpoint('api/1/invite/myself/to/$location', apiKey())).then((value) {
      try {
        return VRChatStatus.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  // Change

  Future<VRChatUserSelfOverload> changeName(String uid, String username, String password) {
    return vrchatSession.put(endpoint('api/1/users/$uid', apiKey()), {"currentPassword": password, "displayName": username}).then((value) {
      try {
        return VRChatUserSelfOverload.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }

  Future<VRChatUserSelf> changeBio(String uid, String bio) {
    return vrchatSession.put(endpoint('api/1/users/$uid', apiKey()), {"bio": bio}).then((value) {
      try {
        return VRChatUserSelf.fromJson(value);
      } catch (e, trace) {
        logger?.e(e, encoder.convert(value), trace);
        rethrow;
      }
    });
  }
}
