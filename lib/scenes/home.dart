import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login.dart';
import '../api/main.dart';
import '../widgets/drawer.dart';

class VRChatMobileHome extends StatefulWidget {
  const VRChatMobileHome({Key? key}) : super(key: key);

  @override
  State<VRChatMobileHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<VRChatMobileHome> {
  Future _getLoginSession() async {
    const storage = FlutterSecureStorage();
    return storage.read(key: "LoginSession");
  }

  Column column = Column(
    children: const [
      Text('ロード中です'),
    ],
  );

  _LoginHomeState() {
    _getLoginSession().then((response) {
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
                  width: MediaQuery.of(context).size.width * 0.8,
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
