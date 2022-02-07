Map<String, int> getVrchatIcon() {
  return {
    "fivehundredpix": 0xFF222222,
    "bandsintown": 0xFF1B8793,
    "behance": 0xFF007CFF,
    "codepen": 0xFF151515,
    "dribbble": 0xFFea4c89,
    "dropbox": 0xFF1081DE,
    "email": 0xFF7f7f7f,
    "facebook": 0xFF3b5998,
    "flickr": 0xFF0063db,
    "foursquare": 0xFF0072b1,
    "github": 0xFF4183c4,
    "google_play": 0xFF40BBC1,
    "google": 0xFFdd4b39,
    "instagram": 0xFF3f729b,
    "itunes": 0xFFE049D1,
    "linkedin": 0xFF007fb1,
    "mailto": 0xFF7f7f7f,
    "medium": 0xFF333332,
    "meetup": 0xFFE51937,
    "pinterest": 0xFFcb2128,
    "rdio": 0xFF0475C5,
    "reddit": 0xFFFF4500,
    "rss": 0xFFEF8733,
    "sharethis": 0xFF00BF00,
    "smugmug": 0xFF8cca1e,
    "snapchat": 0xFFFFC91B,
    "soundcloud": 0xFFFF5700,
    "spotify": 0xFF2EBD59,
    "squarespace": 0xFF1C1C1C,
    "tumblr": 0xFF2c4762,
    "twitch": 0xFF6441A5,
    "twitter": 0xFF00aced,
    "vevo": 0xFFED1A3B,
    "vimeo": 0xFF1ab7ea,
    "vine": 0xFF00BF8F,
    "vk": 0xFF45668e,
    "vsco": 0xFF83878A,
    "wechat": 0xFF00c80f,
    "whatsapp": 0xFF25D366,
    "yelp": 0xFFB90C04,
    "youtube": 0xFFff3333
  };
}

String getVrchatIconContains(String text) {
  for (String key in getVrchatIcon().keys) {
    if (text.contains(key)) return key;
  }
  return "sharethis";
}
