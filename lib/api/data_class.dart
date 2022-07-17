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
  late String lastActivity;
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

  late String? bio;
  late String currentAvatarImageUrl;
  late String currentAvatarThumbnailImageUrl;
  late String developerType;
  late String displayName;
  late String? fallbackAvatar;
  late String id;
  late bool isFriend;
  late String lastPlatform;
  late String? profilePicOverride;
  late String status;
  late String? statusDescription;
  late List<String> tags;
  late String userIcon;
  late String username;
  late String location;
  late String friendKey;

  late bool allowAvatarCopying;
  late List<String> bioLinks;
  late DateTime? dateJoined;
  late String? friendRequestStatus;
  late String? instanceId;
  late String? lastActivity;
  late DateTime? lastLogin;
  late String? state;
  late String? travelingToInstance;
  late String? travelingToLocation;
  late String? travelingToWorld;
  late String worldId;

  VRChatUser.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);

    bio = json['bio'] == "" ? null : json['bio'];
    currentAvatarImageUrl = json['currentAvatarImageUrl'];
    currentAvatarThumbnailImageUrl = json['currentAvatarThumbnailImageUrl'];
    developerType = json['developerType'];
    displayName = json['displayName'];
    fallbackAvatar = json['fallbackAvatar'];
    id = json['id'];
    isFriend = json['isFriend'];
    lastPlatform = json['last_platform'];
    profilePicOverride = json['profilePicOverride'] == "" ? null : json['profilePicOverride'];
    status = json['status'];
    statusDescription = json['statusDescription'] == "" ? null : json['statusDescription'];
    tags = json['tags'].cast<String>();
    userIcon = json['userIcon'];
    username = json['username'];
    location = json['location'] == "" ? "offline" : json['location'] ?? "offline";
    friendKey = json['friendKey'];

    allowAvatarCopying = json['allowAvatarCopying'] ?? false;
    bioLinks = (json['bioLinks'] ?? []).cast<String>();
    dateJoined = json['date_joined'] == null ? null : DateTime.parse(json['date_joined']);
    friendRequestStatus = json['friendRequestStatus'];
    instanceId = json['instanceId'];
    lastActivity = json['last_activity'];
    lastLogin = json['last_login'] == null ? null : DateTime.parse(json['last_login']);
    state = json['state'];
    travelingToInstance = json['travelingToInstance'];
    travelingToLocation = json['travelingToLocation'];
    travelingToWorld = json['travelingToWorld'];
    worldId = json['worldId'] == "" ? location : json['location'] ?? location;
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
}

class VRChatWorld {
  dynamic json;

  late String assetUrl;
  late Map assetUrlObject; //default {}
  late String authorId;
  late String authorName;
  late int capacity;
  late DateTime createdAt;
  late String? description;
  late int favorites;
  late bool featured;
  late int heat;
  late String id;
  late String imageUrl;
  late List<Map<String, int>> instances = [];
  late String labsPublicationDate;
  late String name;
  late String namespace;
  late int occupants;
  late String organization;
  late Map pluginUrlObject; //default {}
  late int popularity;
  late String? previewYoutubeId;
  late int privateOccupants;
  late int publicOccupants;
  late String publicationDate;
  late String releaseStatus;
  late List<String> tags;
  late String thumbnailImageUrl;
  late Map unityPackageUrlObject; //default {}
  late List<UnityPackages> unityPackages = [];
  late DateTime updatedAt;
  late int version;
  late int visits;

  VRChatWorld.fromJson(this.json) {
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);

    assetUrl = json['assetUrl'];
    assetUrlObject = json['assetUrlObject'];
    authorId = json['authorId'];
    authorName = json['authorName'];
    capacity = json['capacity'];
    createdAt = DateTime.parse(json['created_at']);
    description = json['description'] == "" ? null : json['previewYoutubeId'];
    favorites = json['favorites'];
    featured = json['featured'] ?? false;
    heat = json['heat'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    instances = json['instances'].cast<Map<String, int>>();
    labsPublicationDate = json['labsPublicationDate'];
    name = json['name'];
    namespace = json['namespace'];
    occupants = json['occupants'];
    organization = json['organization'];
    pluginUrlObject = json['pluginUrlObject'];
    popularity = json['popularity'];
    previewYoutubeId = json['previewYoutubeId'] == "" ? null : json['previewYoutubeId'];
    privateOccupants = json['privateOccupants'];
    publicationDate = json['publicationDate'];
    publicOccupants = json['publicOccupants'];
    releaseStatus = json['releaseStatus'];
    tags = json['tags'].cast<String>();
    thumbnailImageUrl = json['thumbnailImageUrl'];
    for (dynamic unitypackage in json['unityPackages']) {
      unityPackages.add(UnityPackages.fromJson(unitypackage));
    }
    unityPackageUrlObject = json['unityPackageUrlObject'];
    updatedAt = DateTime.parse(json['updated_at']);
    version = json['version'];
    visits = json['visits'];
  }
  VRChatLimitedWorld toLimited() {
    return VRChatLimitedWorld.fromJson(json);
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
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);

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
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);

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
    if (vrchatStatusCheck(json)) throw VRChatStatus.fromJson(json);

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

class UnityPackages {
  late String assetUrl;
  late Map assetUrlObject; //default {}
  late int assetVersion;
  late String createdAt;
  late String id;
  late String platform;
  late String pluginUrl;
  late Map pluginUrlObject; //default {}
  late int unitySortNumber;
  late String unityVersion;

  UnityPackages.fromJson(dynamic json) {
    assetUrl = json['assetUrl'];
    assetUrlObject = json['assetUrlObject'];
    assetVersion = json['assetVersion'];
    createdAt = json['created_at'];
    id = json['id'];
    platform = json['platform'];
    pluginUrl = json['pluginUrl'];
    pluginUrlObject = json['pluginUrlObject'];
    unitySortNumber = json['unitySortNumber'];
    unityVersion = json['unityVersion'];
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
