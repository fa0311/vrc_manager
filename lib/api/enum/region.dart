enum VRChatRegion {
  unknown(text: "/www/images/Region_US.png"),
  us(text: "/www/images/Region_US.png"),
  use(text: "/www/images/Region_US.png"),
  eu(text: "/www/images/Region_EU.png"),
  jp(text: "/www/images/Region_JP.png");

  final String text;
  Uri toUri() {
    return Uri.https('assets.vrchat.com', text);
  }

  const VRChatRegion({required this.text});
}
