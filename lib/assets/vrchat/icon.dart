enum VRChatExternalServices {
  none(color: 0xFF000000),
  fivehundredpix(color: 0xFF222222),
  bandsintown(color: 0xFF1B8793),
  behance(color: 0xFF007CFF),
  codepen(color: 0xFF151515),
  dribbble(color: 0xFFea4c89),
  dropbox(color: 0xFF1081DE),
  email(color: 0xFF7f7f7f),
  facebook(color: 0xFF3b5998),
  flickr(color: 0xFF0063db),
  foursquare(color: 0xFF0072b1),
  github(color: 0xFF4183c4),
  googlePlay(color: 0xFF40BBC1, text: "google_play"),
  google(color: 0xFFdd4b39),
  instagram(color: 0xFF3f729b),
  itunes(color: 0xFFE049D1),
  linkedin(color: 0xFF007fb1),
  mailto(color: 0xFF7f7f7f),
  medium(color: 0xFF333332),
  meetup(color: 0xFFE51937),
  pinterest(color: 0xFFcb2128),
  rdio(color: 0xFF0475C5),
  reddit(color: 0xFFFF4500),
  rss(color: 0xFFEF8733),
  sharethis(color: 0xFF00BF00),
  smugmug(color: 0xFF8cca1e),
  snapchat(color: 0xFFFFC91B),
  soundcloud(color: 0xFFFF5700),
  spotify(color: 0xFF2EBD59),
  squarespace(color: 0xFF1C1C1C),
  tumblr(color: 0xFF2c4762),
  twitch(color: 0xFF6441A5),
  twitter(color: 0xFF00aced),
  vevo(color: 0xFFED1A3B),
  vimeo(color: 0xFF1ab7ea),
  vine(color: 0xFF00BF8F),
  vk(color: 0xFF45668e),
  vsco(color: 0xFF83878A),
  wechat(color: 0xFF00c80f),
  whatsapp(color: 0xFF25D366),
  yelp(color: 0xFFB90C04),
  youtube(color: 0xFFff3333);

  final int color;
  final String? text;
  const VRChatExternalServices({required this.color, this.text});
}

VRChatExternalServices getVrchatExternalServices(Uri uri) {
  for (VRChatExternalServices key in VRChatExternalServices.values) {
    if (uri.host.contains(key.name)) return key;
  }
  return VRChatExternalServices.none;
}
