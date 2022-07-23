class VRChatStatus {
  dynamic content;
  late int statusCode;
  late String message;

  VRChatStatus.fromJson(this.content) {
    message = content['success']['message'];
    statusCode = content['success']['status_code'];
  }
}

class VRChatError {
  dynamic content;
  late int statusCode;
  late String message;

  VRChatError.fromJson(this.content) {
    message = content['error']['message'];
    statusCode = content['error']['status_code'];
  }
}

class VRChatLogin {
  dynamic content;
  bool verified = false;
  bool requiresTwoFactorAuth = false;

  VRChatLogin.fromJson(this.content) {
    verified = content['verified'] ?? content.containsKey('username');
    if (content.containsKey('requiresTwoFactorAuth')) requiresTwoFactorAuth = true;
  }
}

class VRChatUserOverload {
  dynamic content;

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

  VRChatUserOverload.fromJson(this.content) {
    acceptedTOSVersion = content['acceptedTOSVersion'];
    accountDeletionDate = content['accountDeletionDate'] == null ? null : DateTime.parse(content['accountDeletionDate']);
    activeFriends = content['activeFriends'] == null ? [] : content['activeFriends'].cast<String>();
    allowAvatarCopying = content['allowAvatarCopying'];
    bio = content['bio'];
    bioLinks = content['bioLinks'].cast<String>();
    currentAvatar = content['currentAvatar'];
    currentAvatarAssetUrl = content['currentAvatarAssetUrl'];
    currentAvatarImageUrl = content['currentAvatarImageUrl'];
    currentAvatarThumbnailImageUrl = content['currentAvatarThumbnailImageUrl'];
    dateJoined = content['date_joined'];
    developerType = content['developerType'];
    displayName = content['displayName'];
    emailVerified = content['emailVerified'];
    fallbackAvatar = content['fallbackAvatar'];
    friendGroupNames = content['friendGroupNames'].cast<String>();
    friendKey = content['friendKey'];
    friends = content['friends'].cast<String>();
    hasBirthday = content['hasBirthday'];
    hasEmail = content['hasEmail'];
    hasLoggedInFromClient = content['hasLoggedInFromClient'];
    hasPendingEmail = content['hasPendingEmail'];
    homeLocation = content['homeLocation'];
    id = content['id'];
    isFriend = content['isFriend'];
    lastActivity = content['last_activity'];
    lastLogin = content['last_login'];
    lastPlatform = content['last_platform'];
    obfuscatedEmail = content['obfuscatedEmail'];
    obfuscatedPendingEmail = content['obfuscatedPendingEmail'];
    oculusId = content['oculusId'];
    offlineFriends = content['offlineFriends'].cast<String>();
    onlineFriends = content['onlineFriends'].cast<String>();
    pastDisplayNames = content['pastDisplayNames'].cast<Map<String, String>>();
    profilePicOverride = content['profilePicOverride'];
    state = content['state'];
    status = content['status'];
    statusDescription = content['statusDescription'];
    statusFirstTime = content['statusFirstTime'];
    statusHistory = content['statusHistory'].cast<String>();
    steamDetails = content['steamDetails'];
    steamId = content['steamId'];
    tags = content['tags'].cast<String>();
    twoFactorAuthEnabled = content['twoFactorAuthEnabled'];
    twoFactorAuthEnabledDate = content['twoFactorAuthEnabledDate'] == null ? null : DateTime.parse(content['twoFactorAuthEnabledDate']);
    unsubscribe = content['unsubscribe'];
    userIcon = content['userIcon'];
    username = content['username'];
  }
}

class VRChatUserList {
  dynamic content;
  List<VRChatUser> users = [];

  VRChatUserList.fromJson(this.content) {
    for (dynamic user in content) {
      users.add(VRChatUser.fromJson(user));
    }
  }
}

class VRChatUser {
  dynamic content;

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

  VRChatUser.fromJson(this.content) {
    bio = content['bio'] == "" ? null : content['bio'];
    currentAvatarImageUrl = content['currentAvatarImageUrl'];
    currentAvatarThumbnailImageUrl = content['currentAvatarThumbnailImageUrl'];
    developerType = content['developerType'];
    displayName = content['displayName'];
    fallbackAvatar = content['fallbackAvatar'];
    id = content['id'];
    isFriend = content['isFriend'];
    lastPlatform = content['last_platform'];
    profilePicOverride = content['profilePicOverride'] == "" ? null : content['profilePicOverride'];
    status = content['status'];
    statusDescription = content['statusDescription'] == "" ? null : content['statusDescription'];
    tags = content['tags'].cast<String>();
    userIcon = content['userIcon'];
    username = content['username'];
    location = content['location'] == "" ? "offline" : content['location'] ?? "offline";
    friendKey = content['friendKey'];

    allowAvatarCopying = content['allowAvatarCopying'] ?? false;
    bioLinks = (content['bioLinks'] ?? []).cast<String>();
    dateJoined = content['date_joined'] == null ? null : DateTime.parse(content['date_joined']);
    friendRequestStatus = content['friendRequestStatus'];
    instanceId = content['instanceId'];
    lastActivity = content['last_activity'];
    lastLogin = content['last_login'] == null || content['last_login'] == "" ? null : DateTime.parse(content['last_login']);
    state = content['state'];
    travelingToInstance = content['travelingToInstance'];
    travelingToLocation = content['travelingToLocation'];
    travelingToWorld = content['travelingToWorld'];
    worldId = content['worldId'] == "" ? location : content['location'] ?? location;
  }
}

class VRChatfriendStatus {
  dynamic content;

  late bool incomingRequest;
  late bool isFriend;
  late bool outgoingRequest;

  VRChatfriendStatus.fromJson(this.content) {
    incomingRequest = content['incomingRequest'];
    isFriend = content['isFriend'];
    outgoingRequest = content['outgoingRequest'];
  }
}

class VRChatWorldList {
  dynamic content;
  List<VRChatWorld> world = [];

  VRChatWorldList.fromJson(this.content) {
    for (dynamic user in content) {
      world.add(VRChatWorld.fromJson(user));
    }
  }
}

class VRChatWorld {
  dynamic content;

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

  VRChatWorld.fromJson(this.content) {
    assetUrl = content['assetUrl'];
    assetUrlObject = content['assetUrlObject'];
    authorId = content['authorId'];
    authorName = content['authorName'];
    capacity = content['capacity'];
    createdAt = DateTime.parse(content['created_at']);
    description = content['description'] == "" ? null : content['previewYoutubeId'];
    favorites = content['favorites'] ?? 0;
    featured = content['featured'] ?? false;
    heat = content['heat'];
    id = content['id'];
    imageUrl = content['imageUrl'];
    instances = content['instances'].cast<Map<String, int>>();
    labsPublicationDate = content['labsPublicationDate'];
    name = content['name'];
    namespace = content['namespace'];
    occupants = content['occupants'];
    organization = content['organization'];
    pluginUrlObject = content['pluginUrlObject'];
    popularity = content['popularity'];
    previewYoutubeId = content['previewYoutubeId'] == "" ? null : content['previewYoutubeId'];
    privateOccupants = content['privateOccupants'];
    publicationDate = content['publicationDate'];
    publicOccupants = content['publicOccupants'];
    releaseStatus = content['releaseStatus'];
    tags = content['tags'].cast<String>();
    thumbnailImageUrl = content['thumbnailImageUrl'];
    for (dynamic unitypackage in content['unityPackages']) {
      unityPackages.add(UnityPackages.fromJson(unitypackage));
    }
    unityPackageUrlObject = content['unityPackageUrlObject'];
    updatedAt = DateTime.parse(content['updated_at']);
    version = content['version'];
    visits = content['visits'];
  }
  VRChatLimitedWorld toLimited() {
    return VRChatLimitedWorld.fromJson(content);
  }
}

class VRChatLimitedWorldList {
  dynamic content;

  List<VRChatLimitedWorld> world = [];

  VRChatLimitedWorldList.fromJson(this.content) {
    for (dynamic w in content) {
      world.add(VRChatLimitedWorld.fromJson(w));
    }
  }
}

class VRChatLimitedWorld {
  dynamic content;

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

  VRChatLimitedWorld.fromJson(this.content) {
    authorId = content['authorId'];
    authorName = content['authorName'];
    capacity = content['capacity'];
    createdAt = DateTime.parse(content['created_at']);
    favorites = content['favorites'];
    heat = content['heat'];
    id = content['id'];
    imageUrl = content['imageUrl'];
    labsPublicationDate = content['labsPublicationDate'];
    name = content['name'];
    occupants = content['occupants'];
    organization = content['organization'];
    popularity = content['popularity'];
    publicationDate = content['publicationDate'];
    releaseStatus = content['releaseStatus'];
    tags = content['tags'].cast<String>();
    thumbnailImageUrl = content['thumbnailImageUrl'];
    for (dynamic unityPackage in content['unityPackages']) {
      unityPackages.add(LimitedUnityPackages.fromJson(unityPackage));
    }
    updatedAt = DateTime.parse(content['updated_at']);
  }
}

class VRChatInstance {
  dynamic content;

  late bool active;
  late bool canRequestInvite;
  late int capacity;
  late String clientNumber; //default unknown
  late bool full;
  late String id;
  late String instanceId;
  late String location;
  late int nUsers;
  late String name;
  late String? ownerId;
  late bool permanent;
  late String photonRegion;
  late VRChatPlatforms platforms;
  late String region;
  late String shortName;
  late List<String> tags;
  late String type;
  late String worldId;
  late String? hidden;
  late String? friends;
  late String? private;

  VRChatInstance.fromJson(this.content) {
    active = content['active'];
    canRequestInvite = content['canRequestInvite'];
    capacity = content['capacity'];
    clientNumber = content['clientNumber'];
    full = content['full'];
    id = content['id'];
    instanceId = content['instanceId'];
    location = content['location'];
    nUsers = content['n_users'];
    name = content['name'];
    ownerId = content['ownerId'];
    permanent = content['permanent'];
    photonRegion = content['photonRegion'];
    platforms = VRChatPlatforms.fromJson(content['platforms']);
    region = content['region'];
    shortName = content['shortName'];
    tags = content['tags'].cast<String>();
    type = content['type'];
    worldId = content['worldId'];
    hidden = content['hidden'];
    friends = content['friends'];
    private = content['private'];
  }
}

class VRChatPlatforms {
  dynamic content;

  late int android;
  late int standalonewindows;

  VRChatPlatforms.fromJson(this.content) {
    android = content['android'];
    standalonewindows = content['standalonewindows'];
  }
}

class VRChatFavoriteWorldList {
  dynamic content;

  List<VRChatFavoriteWorld> world = [];

  VRChatFavoriteWorldList.fromJson(this.content) {
    for (dynamic w in content) {
      world.add(VRChatFavoriteWorld.fromJson(w));
    }
  }
}

class VRChatFavoriteWorld {
  dynamic content;

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

  VRChatFavoriteWorld.fromJson(this.content) {
    authorId = content['authorId'];
    authorName = content['authorName'];
    capacity = content['capacity'];
    createdAt = DateTime.parse(content['created_at']);
    favorites = content['favorites'];
    heat = content['heat'];
    id = content['id'];
    imageUrl = content['imageUrl'];
    labsPublicationDate = content['labsPublicationDate'];
    name = content['name'];
    occupants = content['occupants'];
    organization = content['organization'];
    popularity = content['popularity'];
    publicationDate = content['publicationDate'];
    releaseStatus = content['releaseStatus'];
    tags = content['tags'].cast<String>();
    thumbnailImageUrl = content['thumbnailImageUrl'];
    for (dynamic unityPackage in content['unityPackages']) {
      unityPackages.add(LimitedUnityPackages.fromJson(unityPackage));
    }
    updatedAt = DateTime.parse(content['updated_at']);
    favoriteId = content['favoriteId'];
    favoriteGroup = content['favoriteGroup'];
  }
}

class VRChatFavoriteGroupList {
  dynamic content;
  List<VRChatFavoriteGroup> group = [];

  VRChatFavoriteGroupList.fromJson(this.content) {
    for (dynamic user in content) {
      group.add(VRChatFavoriteGroup.fromJson(user));
    }
  }
}

class VRChatFavoriteGroup {
  dynamic content;

  late String ownerDisplayName;
  late String id;
  late String name;
  late String displayName;
  late String ownerId;
  late List<Map<String, int>> tags;
  late String type;
  late String visibility;

  VRChatFavoriteGroup.fromJson(this.content) {
    id = content['id'];
    ownerId = content['ownerId'];
    ownerDisplayName = content['ownerDisplayName'];
    name = content['name'];
    displayName = content['displayName'];
    type = content['type'];
    visibility = content['visibility'];
    tags = content['tags'].cast<Map<String, int>>();
  }
}

class VRChatNotificationsList {
  dynamic content;

  List<VRChatNotifications> notifications = [];

  VRChatNotificationsList.fromJson(this.content) {
    for (dynamic notification in content) {
      notifications.add(VRChatNotifications.fromJson(notification));
    }
  }
}

class VRChatNotifications {
  dynamic content;

  late DateTime createdAt;
  late String details;
  late String id;
  late String message;
  late bool seen;
  late String senderUserId;
  late String senderUsername;
  late String type;

  VRChatNotifications.fromJson(this.content) {
    createdAt = DateTime.parse(content['created_at']);
    details = content['details'];
    id = content['id'];
    message = content['message'];
    seen = content['seen'];
    senderUserId = content['senderUserId'];
    senderUsername = content['senderUsername'];
    type = content['type'];
  }
}

class VRChatAcceptFriendRequestByUid {
  dynamic content;

  late String details;
  late String message;
  late bool seen;
  late String type;

  VRChatAcceptFriendRequestByUid.fromJson(this.content) {
    details = content['details'];
    message = content['message'];
    seen = content['seen'];
    type = content['type'];
  }
}

class VRChatFavorite {
  dynamic content;

  late String favoriteId;
  late String id;
  late List<String> tags;
  late String type;

  VRChatFavorite.fromJson(this.content) {
    favoriteId = content['favoriteId'];
    id = content['id'];
    tags = content['tags'];
    type = content['type'];
  }
}

class UnityPackages {
  dynamic content;

  late String assetUrl;
  late Map? assetUrlObject; //default {}
  late int assetVersion;
  late DateTime? createdAt;
  late String id;
  late String platform;
  late String pluginUrl;
  late Map? pluginUrlObject; //default {}
  late int unitySortNumber;
  late String unityVersion;

  UnityPackages.fromJson(this.content) {
    assetUrl = content['assetUrl'];
    assetUrlObject = content['assetUrlObject'];
    assetVersion = content['assetVersion'];
    createdAt = content['created_at'] == null ? null : DateTime.parse(content['created_at']);
    id = content['id'];
    platform = content['platform'];
    pluginUrl = content['pluginUrl'];
    pluginUrlObject = content['pluginUrlObject'];
    unitySortNumber = content['unitySortNumber'];
    unityVersion = content['unityVersion'];
  }
}

class LimitedUnityPackages {
  dynamic content;

  late String unityVersion;
  late String platform;

  LimitedUnityPackages.fromJson(this.content) {
    unityVersion = content['unityVersion'];
    platform = content['platform'];
  }
}
