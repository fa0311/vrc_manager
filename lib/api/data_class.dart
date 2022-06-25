class VRChatStatus {
  String status = "success";
  int? statusCode = 200;
  String? message;

  VRChatStatus.fromJson(dynamic json) {
    if (json.runtimeType is Map && json.containsKey("error")) {
      status = "error";
      message = json['message'];
      statusCode = json['statusCode'];
    }
  }
}

class VRChatUsers {
  late VRChatStatus vrchatStatus;
  List<VRChatUser> users = [];

  VRChatUsers.fromJson(dynamic json) {
    for (Map<String, dynamic> user in json) {
      users.add(VRChatUser.fromJson(user));
    }
    vrchatStatus = VRChatStatus.fromJson(json);
  }
}

class VRChatUser {
  late VRChatStatus vrchatStatus;
  late String id;
  late String username;
  late String displayName;
  late String userIcon;
  late String? bio;
  late List<String> bioLinks;
  late String? profilePicOverride;
  late String statusDescription;
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

  VRChatUser.fromJson(Map<String, dynamic> json) {
    vrchatStatus = VRChatStatus.fromJson(json);
    id = json['id'];
    username = json['username'];
    displayName = json['displayName'];
    userIcon = json['userIcon'];
    bio = json['bio'] == "" ? null : json['bio'];
    bioLinks = (json['bioLinks'] ?? []).cast<String>();
    profilePicOverride = json['profilePicOverride'] == "" ? null : json['profilePicOverride'];
    statusDescription = json['statusDescription'];
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

class VRChatWorld {
  String? id;
  String? name;
  String? description;
  bool? featured;
  String? authorId;
  String? authorName;
  int? capacity;
  List<String>? tags;
  String? releaseStatus;
  String? imageUrl;
  String? thumbnailImageUrl;
  String? assetUrl;
  dynamic assetUrlObject;
  dynamic pluginUrlObject;
  dynamic unityPackageUrlObject;
  String? namespace;
  List<UnityPackages>? unityPackages;
  int? version;
  String? organization;
  String? previewYoutubeId;
  int? favorites;
  String? createdAt;
  String? updatedAt;
  String? publicationDate;
  String? labsPublicationDate;
  int? visits;
  int? popularity;
  int? heat;
  int? publicOccupants;
  int? privateOccupants;
  int? occupants;
  List<VRChatInstance>? instances;

  VRChatWorld(
      {this.id,
      this.name,
      this.description,
      this.featured,
      this.authorId,
      this.authorName,
      this.capacity,
      this.tags,
      this.releaseStatus,
      this.imageUrl,
      this.thumbnailImageUrl,
      this.assetUrl,
      this.assetUrlObject,
      this.pluginUrlObject,
      this.unityPackageUrlObject,
      this.namespace,
      this.unityPackages,
      this.version,
      this.organization,
      this.previewYoutubeId,
      this.favorites,
      this.createdAt,
      this.updatedAt,
      this.publicationDate,
      this.labsPublicationDate,
      this.visits,
      this.popularity,
      this.heat,
      this.publicOccupants,
      this.privateOccupants,
      this.occupants,
      this.instances});

  VRChatWorld.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    featured = json['featured'];
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

    unityPackages = json['unityPackages'].map((value) => UnityPackages.fromJson(value)).toList();
    version = json['version'];
    organization = json['organization'];
    previewYoutubeId = json['previewYoutubeId'];
    favorites = json['favorites'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    publicationDate = json['publicationDate'];
    labsPublicationDate = json['labsPublicationDate'];
    visits = json['visits'];
    popularity = json['popularity'];
    heat = json['heat'];
    publicOccupants = json['publicOccupants'];
    privateOccupants = json['privateOccupants'];
    occupants = json['occupants'];

    instances = json['instances'].map((value) => VRChatInstance.fromJson(value)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['featured'] = featured;
    data['authorId'] = authorId;
    data['authorName'] = authorName;
    data['capacity'] = capacity;
    data['tags'] = tags;
    data['releaseStatus'] = releaseStatus;
    data['imageUrl'] = imageUrl;
    data['thumbnailImageUrl'] = thumbnailImageUrl;
    data['assetUrl'] = assetUrl;
    if (assetUrlObject != null) {
      data['assetUrlObject'] = assetUrlObject.toJson();
    }
    if (pluginUrlObject != null) {
      data['pluginUrlObject'] = pluginUrlObject.toJson();
    }
    if (unityPackageUrlObject != null) {
      data['unityPackageUrlObject'] = unityPackageUrlObject.toJson();
    }
    data['namespace'] = namespace;

    data['unityPackages'] = unityPackages == null ? null : unityPackages!.map((value) => value.toJson()).toList();

    data['version'] = version;
    data['organization'] = organization;
    data['previewYoutubeId'] = previewYoutubeId;
    data['favorites'] = favorites;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['publicationDate'] = publicationDate;
    data['labsPublicationDate'] = labsPublicationDate;
    data['visits'] = visits;
    data['popularity'] = popularity;
    data['heat'] = heat;
    data['publicOccupants'] = publicOccupants;
    data['privateOccupants'] = privateOccupants;
    data['occupants'] = occupants;

    data['instances'] = instances == null ? null : instances!.map((value) => value.toJson()).toList();

    return data;
  }
}

class UnityPackages {
  String? id;
  String? assetUrl;
  dynamic assetUrlObject;
  String? pluginUrl;
  dynamic pluginUrlObject;
  String? unityVersion;
  int? unitySortNumber;
  int? assetVersion;
  String? platform;
  String? createdAt;

  UnityPackages(
      {this.id,
      this.assetUrl,
      this.assetUrlObject,
      this.pluginUrl,
      this.pluginUrlObject,
      this.unityVersion,
      this.unitySortNumber,
      this.assetVersion,
      this.platform,
      this.createdAt});

  UnityPackages.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['assetUrl'] = assetUrl;
    if (assetUrlObject != null) {
      data['assetUrlObject'] = assetUrlObject.toJson();
    }
    data['pluginUrl'] = pluginUrl;
    if (pluginUrlObject != null) {
      data['pluginUrlObject'] = pluginUrlObject.toJson();
    }
    data['unityVersion'] = unityVersion;
    data['unitySortNumber'] = unitySortNumber;
    data['assetVersion'] = assetVersion;
    data['platform'] = platform;
    data['created_at'] = createdAt;
    return data;
  }
}

class VRChatInstance {
  String? location;
  int? people;

  VRChatInstance({this.location, this.people});

  VRChatInstance.fromJson(List<dynamic> json) {
    location = json[0];
    people = json[1];
  }

  List<dynamic> toJson() {
    final List<dynamic> data = [];
    data[0] = location;
    data[1] = people;
    return data;
  }
}
