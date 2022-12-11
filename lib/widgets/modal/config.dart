// Dart imports:

import 'dart:io';

import 'package:vrc_manager/api/data_class.dart';

enum UserModalType {
  self,
  onlineFriends,
  offlineFriends,
  user;
}

class UserModalData {
  bool editBio = false;
  bool editNote = false;
  bool profileAction = false;
  Uri? shareUrl;
}

UserModalData getUserModalConfig({
  required UserModalType type,
  required VRChatUser user,
}) {
  switch (type) {
    case UserModalType.self:
      return UserModalData()
        ..editBio = true
        ..editNote = true
        ..shareUrl = Uri.https("vrchat.com", "/home/user/${user.id}");
    case UserModalType.onlineFriends:
      return UserModalData()
        ..editNote = true
        ..profileAction = true
        ..shareUrl = Uri.https("vrchat.com", "/home/user/${user.id}");
    case UserModalType.offlineFriends:
      return UserModalData()
        ..editNote = true
        ..profileAction = true
        ..shareUrl = Uri.https("vrchat.com", "/home/user/${user.id}");
    case UserModalType.user:
      return UserModalData()
        ..editNote = true
        ..profileAction = true
        ..shareUrl = Uri.https("vrchat.com", "/home/user/${user.id}");
  }
}

enum WorldModalType {
  instance,
  world;
}

class WorldModalData {
  bool selfInvite = false;
  bool favorite = false;
  bool shareInstance = false;
  Uri? shareUrl;
}

WorldModalData getWorldModalConfig({
  required WorldModalType type,
  required VRChatWorld world,
}) {
  switch (type) {
    case WorldModalType.instance:
      return WorldModalData()
        ..selfInvite = true
        ..favorite = true
        ..shareInstance = true;
    case WorldModalType.world:
      return WorldModalData()
        ..favorite = true
        ..shareUrl = Uri.https("vrchat.com", "/home/world/${world.id}");
  }
}

enum ShareModalType {
  url,
  world;
}

class ShareModalData {
  bool share = false;
  bool copy = false;
  bool open = false;
  Uri? shareUrl;
  Uri? openInWindows;
}

ShareModalData getShareInstanceModalData({
  required VRChatWorld world,
  required String instanceId,
}) {
  if (Platform.isWindows) {
    return ShareModalData()
      ..share = true
      ..copy = true
      ..open = true
      ..shareUrl = Uri.https("vrchat.com/", "/home/launch?worldId=${world.id}&instanceId=$instanceId");
  } else {
    return ShareModalData()
      ..share = true
      ..copy = true
      ..open = true
      ..shareUrl = Uri.https("vrchat.com/", "/home/launch?worldId=${world.id}&instanceId=$instanceId")
      ..openInWindows = Uri(scheme: "vrchat", path: "launch", queryParameters: {"ref": "vrchat.com", "id": "${world.id}:$instanceId"});
  }
}
