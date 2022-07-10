bool vrchatStatusCheck(dynamic json) {
  try {
    return json.containsKey("error");
  } on NoSuchMethodError {
    return false;
  }
}

class VRChatStatus {
  dynamic json;
  late String status;
  late int statusCode;
  late String message;

  VRChatStatus.fromJson(this.json) {
    if (json.containsKey("error")) {
      status = "error";
    } else if (json.containsKey("success")) {
      status = "success";
    }
    message = json[status]['message'];
    statusCode = json[status]['status_code'];
  }
}

class VRChatLogin {
  dynamic json;
  bool verified = false;
  bool requiresTwoFactorAuth = false;

  VRChatLogin.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);
    verified = json['verified'] ?? true;
    if (json.containsKey('requiresTwoFactorAuth')) requiresTwoFactorAuth = true;
  }
}

class VRChatUserOverload {
  dynamic json;

  late int acceptedTOSVersion;
  late DateTime? accountDeletionDate;
  late List<String> activeFriends;
  late bool allowAvatarCopying;
  late String bio;
  late List<String> bioLinks;
  late String currentAvatarImageUrl;
  late String currentAvatarThumbnailImageUrl;
  late String currentAvatar;
  late String currentAvatarAssetUrl;
  late String dateJoined;
  late String developerType;
  late String displayName;
  late bool emailVerified;
  late String fallbackAvatar;
  late List<String> friendGroupNames;
  late List<String> friends;
  late String friendKey;
  late bool hasBirthday;
  late bool hasEmail;
  late bool hasLoggedInFromClient;
  late bool hasPendingEmail;
  late String homeLocation;
  late String id;
  late bool isFriend;
  late String lastLogin;
  late String lastPlatform;
  late String obfuscatedEmail;
  late String obfuscatedPendingEmail;
  late String oculusId;
  late List<String> offlineFriends;
  late List<String> onlineFriends;
  late List<Map<String, String>> pastDisplayNames = [];
  late String profilePicOverride;
  late String state;
  late String status;
  late String statusDescription;
  late bool statusFirstTime;
  late List<String> statusHistory;
  late Map steamDetails; //default {}
  late String steamId;
  late List<String> tags;
  late bool twoFactorAuthEnabled;
  late DateTime? twoFactorAuthEnabledDate;
  late bool unsubscribe;
  late String userIcon;
  late String username;
  late String lastActivity;

  VRChatUserOverload.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);

    acceptedTOSVersion = json['acceptedTOSVersion'];
    accountDeletionDate = json['accountDeletionDate'] == null ? null : DateTime.parse(json['accountDeletionDate']);
    activeFriends = json['activeFriends'] == null ? [] : json['activeFriends'].cast<String>();
    allowAvatarCopying = json['allowAvatarCopying'];
    bio = json['bio'];
    bioLinks = json['bioLinks'].cast<String>();
    currentAvatar = json['currentAvatar'];
    currentAvatarAssetUrl = json['currentAvatarAssetUrl'];
    currentAvatarImageUrl = json['currentAvatarImageUrl'];
    currentAvatarThumbnailImageUrl = json['currentAvatarThumbnailImageUrl'];
    dateJoined = json['date_joined'];
    developerType = json['developerType'];
    displayName = json['displayName'];
    emailVerified = json['emailVerified'];
    fallbackAvatar = json['fallbackAvatar'];
    friendGroupNames = json['friendGroupNames'].cast<String>();
    friendKey = json['friendKey'];
    friends = json['friends'].cast<String>();
    hasBirthday = json['hasBirthday'];
    hasEmail = json['hasEmail'];
    hasLoggedInFromClient = json['hasLoggedInFromClient'];
    hasPendingEmail = json['hasPendingEmail'];
    homeLocation = json['homeLocation'];
    id = json['id'];
    isFriend = json['isFriend'];
    lastActivity = json['last_activity'];
    lastLogin = json['last_login'];
    lastPlatform = json['last_platform'];
    obfuscatedEmail = json['obfuscatedEmail'];
    obfuscatedPendingEmail = json['obfuscatedPendingEmail'];
    oculusId = json['oculusId'];
    offlineFriends = json['offlineFriends'].cast<String>();
    onlineFriends = json['onlineFriends'].cast<String>();
    pastDisplayNames = json['pastDisplayNames'].cast<Map<String, String>>();
    profilePicOverride = json['profilePicOverride'];
    state = json['state'];
    status = json['status'];
    statusDescription = json['statusDescription'];
    statusFirstTime = json['statusFirstTime'];
    statusHistory = json['statusHistory'].cast<String>();
    steamDetails = json['steamDetails'];
    steamId = json['steamId'];
    tags = json['tags'].cast<String>();
    twoFactorAuthEnabled = json['twoFactorAuthEnabled'];
    twoFactorAuthEnabledDate = json['twoFactorAuthEnabledDate'] == null ? null : DateTime.parse(json['twoFactorAuthEnabledDate']);
    unsubscribe = json['unsubscribe'];
    userIcon = json['userIcon'];
    username = json['username'];
  }
}

class VRChatUserList {
  dynamic json;
  List<VRChatUser> users = [];

  VRChatUserList.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);
    for (Map<String, dynamic> user in json) {
      users.add(VRChatUser.fromJson(user));
    }
  }
}

class VRChatUser {
  dynamic json;
  late String id;
  late String username;
  late String displayName;
  late String userIcon;
  late String? bio;
  late List<String> bioLinks;
  late String? profilePicOverride;
  late String? statusDescription;
  late String currentAvatarImageUrl;
  late String currentAvatarThumbnailImageUrl;
  late String? state;
  late List<String> tags;
  late String developerType;
  late DateTime? lastLogin;
  late String lastPlatform;
  late bool allowAvatarCopying;
  late String status;
  late DateTime? dateJoined;
  late bool isFriend;
  late String friendKey;
  late String? lastActivity;
  late String? instanceId;
  late String location;
  late String worldId;
  late String? travelingToWorld;
  late String? travelingToInstance;
  late String? travelingToLocation;
  late String? friendRequestStatus;

  VRChatUser.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);
    id = json['id'];
    username = json['username'];
    displayName = json['displayName'];
    userIcon = json['userIcon'];
    bio = json['bio'] == "" ? null : json['bio'];
    bioLinks = (json['bioLinks'] ?? []).cast<String>();
    profilePicOverride = json['profilePicOverride'] == "" ? null : json['profilePicOverride'];
    statusDescription = json['statusDescription'] == "" ? null : json['statusDescription'];
    currentAvatarImageUrl = json['currentAvatarImageUrl'];
    currentAvatarThumbnailImageUrl = json['currentAvatarThumbnailImageUrl'];
    state = json['state'];
    tags = json['tags'].cast<String>();
    developerType = json['developerType'];
    lastLogin = json['last_login'] == null ? null : DateTime.parse(json['last_login']);
    lastPlatform = json['last_platform'];
    allowAvatarCopying = json['allowAvatarCopying'] ?? false;
    status = json['status'];
    dateJoined = json['date_joined'] == null ? null : DateTime.parse(json['date_joined']);
    isFriend = json['isFriend'];
    friendKey = json['friendKey'];
    lastActivity = json['last_activity'];
    instanceId = json['instanceId'];
    location = json['location'] == "" ? "offline" : json['location'] ?? "offline";
    worldId = json['worldId'] == "" ? location : json['location'] ?? location;
    travelingToWorld = json['travelingToWorld'];
    travelingToInstance = json['travelingToInstance'];
    travelingToLocation = json['travelingToLocation'];
    friendRequestStatus = json['friendRequestStatus'];
  }
}

class VRChatWorldList {
  dynamic json;
  List<VRChatWorld> world = [];

  VRChatWorldList.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);
    for (dynamic user in json) {
      world.add(VRChatWorld.fromJson(user));
    }
  }

  void forEach(Null Function(dynamic list) param0) {}
}

class VRChatWorld {
  dynamic json;
  late String id;
  late String name;
  late String? description;
  late bool featured;
  late String authorId;
  late String authorName;
  late int capacity;
  late List<String> tags;
  late String releaseStatus;
  late String imageUrl;
  late String thumbnailImageUrl;
  late String assetUrl;
  late dynamic assetUrlObject;
  late dynamic pluginUrlObject;
  late dynamic unityPackageUrlObject;
  late String namespace;
  late List<UnityPackages> unityPackages = [];
  late int version;
  late String organization;
  late String? previewYoutubeId;
  late int favorites;
  late DateTime createdAt;
  late DateTime updatedAt;
  late String publicationDate;
  late String labsPublicationDate;
  late int visits;
  late int popularity;
  late int heat;
  late int publicOccupants;
  late int privateOccupants;
  late int occupants;
  late List<Map<String, int>> instances = [];

  VRChatWorld.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);
    id = json['id'];
    name = json['name'];
    description = json['description'] == "" ? null : json['previewYoutubeId'];
    featured = json['featured'] ?? false;
    authorId = json['authorId'];
    authorName = json['authorName'];
    capacity = json['capacity'];
    tags = json['tags'].cast<String>();
    releaseStatus = json['releaseStatus'];
    imageUrl = json['imageUrl'];
    thumbnailImageUrl = json['thumbnailImageUrl'];
    assetUrl = json['assetUrl'];
    assetUrlObject = json['assetUrlObject'];
    pluginUrlObject = json['pluginUrlObject'];
    unityPackageUrlObject = json['unityPackageUrlObject'];
    namespace = json['namespace'];
    for (dynamic unitypackage in json['unityPackages']) {
      unityPackages.add(UnityPackages.fromJson(unitypackage));
    }
    version = json['version'];
    organization = json['organization'];
    previewYoutubeId = json['previewYoutubeId'] == "" ? null : json['previewYoutubeId'];
    favorites = json['favorites'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    publicationDate = json['publicationDate'];
    labsPublicationDate = json['labsPublicationDate'];
    visits = json['visits'];
    popularity = json['popularity'];
    heat = json['heat'];
    publicOccupants = json['publicOccupants'];
    privateOccupants = json['privateOccupants'];
    occupants = json['occupants'];
    instances = json['instances'].cast<Map<String, int>>();
  }
  VRChatLimitedWorld toLimited() {
    return VRChatLimitedWorld.fromJson(json);
  }
}

class UnityPackages {
  late String id;
  late String assetUrl;
  late dynamic assetUrlObject;
  late String pluginUrl;
  late dynamic pluginUrlObject;
  late String unityVersion;
  late int unitySortNumber;
  late int assetVersion;
  late String platform;
  late String createdAt;

  UnityPackages.fromJson(dynamic json) {
    id = json['id'];
    assetUrl = json['assetUrl'];
    assetUrlObject = json['assetUrlObject'];
    pluginUrl = json['pluginUrl'];
    pluginUrlObject = json['pluginUrlObject'];
    unityVersion = json['unityVersion'];
    unitySortNumber = json['unitySortNumber'];
    assetVersion = json['assetVersion'];
    platform = json['platform'];
    createdAt = json['created_at'];
  }
}

class LimitedUnityPackages {
  late String unityVersion;
  late String platform;

  LimitedUnityPackages.fromJson(dynamic json) {
    unityVersion = json['unityVersion'];
    platform = json['platform'];
  }
}

class VRChatLimitedWorldList {
  dynamic json;
  List<VRChatLimitedWorld> world = [];

  VRChatLimitedWorldList.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);
    for (dynamic w in json) {
      world.add(VRChatLimitedWorld.fromJson(w));
    }
  }
}

class VRChatLimitedWorld {
  dynamic json;
  late String authorId;
  late String authorName;
  late int capacity;
  late DateTime createdAt;
  late int favorites;
  late int heat;
  late String id;
  late String imageUrl;
  late String labsPublicationDate;
  late String name;
  late int occupants;
  late String organization;
  late int popularity;
  late String publicationDate;
  late String releaseStatus;
  late List<String> tags;
  late String thumbnailImageUrl;
  late List<LimitedUnityPackages> unityPackages = [];
  late DateTime updatedAt;

  VRChatLimitedWorld.fromJson(this.json) {
    authorId = json['authorId'];
    authorName = json['authorName'];
    capacity = json['capacity'];
    createdAt = DateTime.parse(json['created_at']);
    favorites = json['favorites'];
    heat = json['heat'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    labsPublicationDate = json['labsPublicationDate'];
    name = json['name'];
    occupants = json['occupants'];
    organization = json['organization'];
    popularity = json['popularity'];
    publicationDate = json['publicationDate'];
    releaseStatus = json['releaseStatus'];
    tags = json['tags'].cast<String>();
    thumbnailImageUrl = json['thumbnailImageUrl'];
    for (dynamic unityPackage in json['unityPackages']) {
      unityPackages.add(LimitedUnityPackages.fromJson(unityPackage));
    }
    updatedAt = DateTime.parse(json['updated_at']);
  }
}

class VRChatFavoriteWorldList {
  dynamic json;
  List<VRChatFavoriteWorld> world = [];

  VRChatFavoriteWorldList.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);
    for (dynamic w in json) {
      world.add(VRChatFavoriteWorld.fromJson(w));
    }
  }
}

class VRChatFavoriteWorld {
  dynamic json;
  late String authorId;
  late String authorName;
  late int capacity;
  late DateTime createdAt;
  late int favorites;
  late int heat;
  late String id;
  late String imageUrl;
  late String labsPublicationDate;
  late String name;
  late int occupants;
  late String organization;
  late int popularity;
  late String publicationDate;
  late String releaseStatus;
  late List<String> tags;
  late String thumbnailImageUrl;
  late List<LimitedUnityPackages> unityPackages = [];
  late DateTime updatedAt;
  late String favoriteId;
  late String favoriteGroup;

  VRChatFavoriteWorld.fromJson(this.json) {
    authorId = json['authorId'];
    authorName = json['authorName'];
    capacity = json['capacity'];
    createdAt = DateTime.parse(json['created_at']);
    favorites = json['favorites'];
    heat = json['heat'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    labsPublicationDate = json['labsPublicationDate'];
    name = json['name'];
    occupants = json['occupants'];
    organization = json['organization'];
    popularity = json['popularity'];
    publicationDate = json['publicationDate'];
    releaseStatus = json['releaseStatus'];
    tags = json['tags'].cast<String>();
    thumbnailImageUrl = json['thumbnailImageUrl'];
    for (dynamic unityPackage in json['unityPackages']) {
      unityPackages.add(LimitedUnityPackages.fromJson(unityPackage));
    }
    updatedAt = DateTime.parse(json['updated_at']);
    favoriteId = json['favoriteId'];
    favoriteGroup = json['favoriteGroup'];
  }
}

class VRChatFavoriteGroupList {
  dynamic json;
  List<VRChatFavoriteGroup> group = [];

  VRChatFavoriteGroupList.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);
    for (dynamic user in json) {
      group.add(VRChatFavoriteGroup.fromJson(user));
    }
  }
}

class VRChatFavoriteGroup {
  dynamic json;
  late String ownerDisplayName;
  late String id;
  late String name;
  late String displayName;
  late String ownerId;
  late List<Map<String, int>> tags;
  late String type;
  late String visibility;

  VRChatFavoriteGroup.fromJson(this.json) {
    id = json['id'];
    ownerId = json['ownerId'];
    ownerDisplayName = json['ownerDisplayName'];
    name = json['name'];
    displayName = json['displayName'];
    type = json['type'];
    visibility = json['visibility'];
    tags = json['tags'].cast<Map<String, int>>();
  }
}
