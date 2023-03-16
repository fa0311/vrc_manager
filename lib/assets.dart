class Assets {
  static Uri svg = Uri.directory("assets/svg/");
  // cspell:disable-next-line
  static String charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

  static String userAgentBase = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36";
  static String userAgent(String version) => '$userAgentBase VRCManager/$version $repository';

  static Uri github = Uri.https("github.com");
  static Uri twitter = Uri.https("twitter.com");
  static Uri googlePlay = Uri.https("play.google.com");

  static Uri repository = Assets.github.resolve("/fa0311/vrc_manager");
  static Uri issues = Assets.github.resolve("/fa0311/vrc_manager/issues/new/choose");
  static Uri contact = Assets.twitter.resolve("/faa0311");
  static Uri rate = Assets.googlePlay.replace(path: "/store/apps/details", queryParameters: {"id": "com.yuki0311.vrc_manager"});
  static Uri release = Assets.github.resolve("/fa0311/vrc_manager/releases");
  static Uri report = Assets.github.replace(path: "/fa0311/vrc_manager/issues/new", queryParameters: {"template": "redirected-from-app.yml"});
  static Uri userPolicy = Assets.github.resolve("/fa0311/vrc_manager/blob/master/docs/user_policies/ja.md");
}
