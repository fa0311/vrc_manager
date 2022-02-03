import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/scenes/login.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatMobileHome extends StatefulWidget {
  const VRChatMobileHome({Key? key}) : super(key: key);

  @override
  State<VRChatMobileHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<VRChatMobileHome> {
  Column column = Column(
    children: const [
      Text('ロード中です'),
    ],
  );

  _LoginHomeState() {
    getLoginSession().then((response) {
      if (response == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const VRChatMobileLogin(),
            ),
            (_) => false);
      } else {
        VRChatAPI(cookie: response).user().then((response) {
          setState(() {
            // 低画質 currentAvatarThumbnailImageUrl
            // 高画質 currentAvatarImageUrl
            column = Column(
              children: [
                SizedBox(
                  height: 250,
                  child: Image.network(response["currentAvatarThumbnailImageUrl"], fit: BoxFit.fitWidth),
                ),
                Text(response["displayName"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Text(response["bio"]),
                Text(response["status"]),
                Text(response["state"]),
                Text(response["date_joined"]),
                Text(response["last_activity"])
              ],
            );
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: drawr(context),
      body: SafeArea(child: SizedBox(width: MediaQuery.of(context).size.width, child: column)),
    );
  }
}
