import 'package:vrc_manager/api/data_class.dart';

class VRChatWorldInstance {
  final VRChatWorld _world;
  final VRChatInstance _instance;

  VRChatWorld get world => _world;
  VRChatInstance get instance => _instance;

  VRChatWorldInstance(this._world, this._instance);
}

class VRChatUserFriendsStatus {
  final VRChatUser _user;
  final VRChatFriendStatus _status;

  VRChatUser get user => _user;
  VRChatFriendStatus get status => _status;

  VRChatUserFriendsStatus(this._user, this._status);
}
