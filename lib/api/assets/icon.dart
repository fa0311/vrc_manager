// Flutter imports:
import 'package:flutter/material.dart';

enum VRChatExternalServices {
  none(color: 0xFF000000, text: "none"),
  fivehundredpix(color: 0xFF222222, text: "fivehundredpix"),
  bandsintown(color: 0xFF1B8793, text: "bandsintown"),
  behance(color: 0xFF007CFF, text: "behance"),
  codepen(color: 0xFF151515, text: "codepen"),
  dribbble(color: 0xFFea4c89, text: "dribbble"),
  dropbox(color: 0xFF1081DE, text: "dropbox"),
  email(color: 0xFF7f7f7f, text: "email"),
  facebook(color: 0xFF3b5998, text: "facebook"),
  flickr(color: 0xFF0063db, text: "flickr"),
  foursquare(color: 0xFF0072b1, text: "foursquare"),
  github(color: 0xFF4183c4, text: "github"),
  googlePlay(color: 0xFF40BBC1, text: "google_play"),
  google(color: 0xFFdd4b39, text: "google"),
  instagram(color: 0xFF3f729b, text: "instagram"),
  itunes(color: 0xFFE049D1, text: "itunes"),
  linkedin(color: 0xFF007fb1, text: "linkedin"),
  mailto(color: 0xFF7f7f7f, text: "mailto"),
  medium(color: 0xFF333332, text: "medium"),
  meetup(color: 0xFFE51937, text: "meetup"),
  pinterest(color: 0xFFcb2128, text: "pinterest"),
  rdio(color: 0xFF0475C5, text: "rdio"),
  reddit(color: 0xFFFF4500, text: "reddit"),
  rss(color: 0xFFEF8733, text: "rss"),
  sharethis(color: 0xFF00BF00, text: "sharethis"),
  smugmug(color: 0xFF8cca1e, text: "smugmug"),
  snapchat(color: 0xFFFFC91B, text: "snapchat"),
  soundcloud(color: 0xFFFF5700, text: "soundcloud"),
  spotify(color: 0xFF2EBD59, text: "spotify"),
  squarespace(color: 0xFF1C1C1C, text: "squarespace"),
  tumblr(color: 0xFF2c4762, text: "tumblr"),
  twitch(color: 0xFF6441A5, text: "twitch"),
  twitter(color: 0xFF00aced, text: "twitter"),
  vevo(color: 0xFFED1A3B, text: "vevo"),
  vimeo(color: 0xFF1ab7ea, text: "vimeo"),
  vine(color: 0xFF00BF8F, text: "vine"),
  vk(color: 0xFF45668e, text: "vk"),
  vsco(color: 0xFF83878A, text: "vsco"),
  wechat(color: 0xFF00c80f, text: "wechat"),
  whatsapp(color: 0xFF25D366, text: "whatsapp"),
  yelp(color: 0xFFB90C04, text: "yelp"),
  youtube(color: 0xFFff3333, text: "youtube");

  Color toColor() {
    return Color(color);
  }

  final int color;
  final String text;
  const VRChatExternalServices({required this.color, required this.text});
}

VRChatExternalServices byVrchatExternalServices(Uri uri) {
  for (VRChatExternalServices key in VRChatExternalServices.values) {
    if (uri.toString().contains(key.text)) return key;
  }
  return VRChatExternalServices.none;
}
