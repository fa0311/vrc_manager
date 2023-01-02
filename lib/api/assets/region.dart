import 'package:vrc_manager/api/assets/assets.dart';

enum VRChatRegion {
  us(text: "/www/images/Region_US.png"),
  use(text: "/www/images/Region_US.png"),
  eu(text: "/www/images/Region_EU.png"),
  jp(text: "/www/images/Region_JP.png");

  final String text;
  Uri toUri() {
    return VRChatAssets.assets.resolve(text);
  }

  const VRChatRegion({required this.text});
}
