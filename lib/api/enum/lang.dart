enum VRChatLanguage {
  eng(text: "English"),
  kor(text: "한국어"),
  rus(text: "Русский"),
  spa(text: "Español"),
  por(text: "Português"),
  zho(text: "中文"),
  deu(text: "Deutsch"),
  jpn(text: "日本語"),
  fra(text: "Français"),
  swe(text: "Svenska"),
  nld(text: "Nederlands"),
  pol(text: "Polski"),
  dan(text: "Dansk"),
  nor(text: "Norsk"),
  ita(text: "Italiano"),
  tha(text: "ภาษาไทย"),
  fin(text: "Suomi"),
  hun(text: "Magyar"),
  ces(text: "Čeština"),
  tur(text: "Türkçe"),
  ara(text: "العربية"),
  ron(text: "Română"),
  vie(text: "Tiếng Việt"),
  ase(text: "American Sign Language"),
  bfi(text: "British Sign Language"),
  dse(text: "Dutch Sign Language"),
  fsl(text: "French Sign Language"),
  kvk(text: "Korean Sign Language");

  final String text;
  const VRChatLanguage({required this.text});
}
