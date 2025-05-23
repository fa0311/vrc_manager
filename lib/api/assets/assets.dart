class VRChatAssets {
  static Uri vrchat = Uri.https("vrchat.com");
  static Uri vrchatScheme = Uri(scheme: "vrchat");
  static Uri assets = Uri.https("assets.vrchat.com");

  // cspell:disable-next-line
  static String apiKey = "JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26";

  static String homeTitle = "Home - VRChat";
  static String loginTitle = "Login - VRChat";

  static Uri login = VRChatAssets.vrchat.resolve("/home/login");
  static Uri user = VRChatAssets.vrchat.resolve("/home/user/");
  static Uri launch = VRChatAssets.vrchat.resolve("/home/launch");
  static Uri locations = VRChatAssets.vrchat.resolve("/home/locations");
  static Uri groups = VRChatAssets.vrchat.resolve("/home/groups");
  static Uri download = VRChatAssets.vrchat.resolve("/home/download");
  static Uri worlds = VRChatAssets.vrchat.resolve("/home/worlds/");
  static Uri content = VRChatAssets.vrchat.resolve("/home/content");
  static Uri avatars = VRChatAssets.vrchat.resolve("/home/avatars");
  static Uri favoritesWorlds = VRChatAssets.vrchat.resolve("/home/favorites/world/");
  static Uri favoritesAvatars = VRChatAssets.vrchat.resolve("/home/favorites/avatar/");
  // cspell:disable-next-line
  static Uri accountLink = VRChatAssets.vrchat.resolve("/home/accountlink");
  // cspell:disable-next-line
  static Uri playerModerations = VRChatAssets.vrchat.resolve("/home/playermoderations");
  static Uri messages = VRChatAssets.vrchat.resolve("/home/messages");
  static Uri profile = VRChatAssets.vrchat.resolve("/home/profile");
  static Uri search = VRChatAssets.vrchat.resolve("/home/search/");

  static Uri defaultPrivateImage = assets.resolve("/www/images/default_private_image.png");
  static Uri defaultBetweenImage = assets.resolve("/www/images/default_between_image.png");
}
