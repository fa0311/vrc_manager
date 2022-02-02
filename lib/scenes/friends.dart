import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/widgets/users.dart';
import '../widgets/drawer.dart';

class VRChatMobileFriends extends StatefulWidget {
  const VRChatMobileFriends({Key? key}) : super(key: key);

  @override
  State<VRChatMobileFriends> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<VRChatMobileFriends> {
  get user => null;

  Future _getLoginSession() async {
    const storage = FlutterSecureStorage();
    return storage.read(key: "LoginSession");
  }

  int offset = 0;

  Column column = Column(
    children: const [
      Text('ロード中です'),
    ],
  );

  Users dataColumn = Users();
  _FriendsPageState() {
    moreOver();
  }
  moreOver() {
    _getLoginSession().then((response) {
      VRChatAPI(cookie: response).friends(offline: false, offset: offset).then((response) {
        offset += 50;
        setState(() {
          column = Column(
            children: dataColumn.adds(response),
          );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: drawr(context),
      body: SafeArea(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                  child: Column(children: [
                column,
                if (dataColumn.children.length == offset)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        ElevatedButton(
                          child: const Text('続きを読み込む'),
                          onPressed: () => moreOver(),
                        ),
                      ],
                    ),
                  )
              ])))),
    );
  }
}
