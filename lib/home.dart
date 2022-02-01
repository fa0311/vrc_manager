import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'api/home.dart';

class VRChatMobileHome extends StatefulWidget {
  const VRChatMobileHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<VRChatMobileHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<VRChatMobileHome> {
  Future _getLoginSession() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString("LoginSession");
  }

  Column column = Column(
    children: const [
      Text('ロード中です'),
    ],
  );

  _LoginHomeState() {
    _getLoginSession().then((response) {
      if (response == null) {
        const VRChatMobileLogin(title: 'VRChat Mobile Application by fa0311');
      } else {
        VRChatMobileAPIHome(context, response).user().then((response) {
          setState(() {
            // 低画質 currentAvatarThumbnailImageUrl
            // 高画質 currentAvatarImageUrl
            column = Column(
              children: [
                Image.network(response["currentAvatarThumbnailImageUrl"], fit: BoxFit.contain),
                Text(response["displayName"]),
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
      drawer: Drawer(
        child: ListView(
          children: const <Widget>[
            ListTile(
              title: Text('My Page'),
            ),
            ListTile(
              title: Text('Friends'),
            )
          ],
        ),
      ),
      body: SizedBox(width: MediaQuery.of(context).size.width, child: column),
    );
  }
}
