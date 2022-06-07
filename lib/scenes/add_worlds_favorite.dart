import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/storage.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VRChatMobileAddWorldsFavorite extends StatefulWidget {
  final String worldId;

  const VRChatMobileAddWorldsFavorite({Key? key, required this.worldId}) : super(key: key);

  @override
  State<VRChatMobileAddWorldsFavorite> createState() => _SettingPageState();
}

class _SettingPageState extends State<VRChatMobileAddWorldsFavorite> {
  List<Widget> column = [];

  _SettingPageState() {
    getLoginSession("LoginSession").then((cookie) {
      VRChatAPI(cookie: cookie).favoriteGroups("world", offset: 0).then((response) {
        if (response.containsKey("error")) {
          error(context, response["error"]["message"]);
          return;
        }
        if (response.isEmpty) {
          setState(() => column = [
                Column(
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.none),
                  ],
                )
              ]);
        } else {
          response.forEach((dynamic index, dynamic list) {
            column.add(ListTile(
              title: Text(list["displayName"]),
              onTap: () => {
                VRChatAPI(cookie: cookie).addFavorites("world", widget.worldId, list["name"]).then((response) {
                  if (response.containsKey("error")) {
                    error(context, response["error"]["message"]);
                    return;
                  }
                  Navigator.pop(context);
                })
              },
            ));
            column.add(const Divider());
          });
          setState(() => column.removeLast());
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addFavoriteWorlds),
      ),
      drawer: drawr(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: column,
          ),
        ),
      ),
    );
  }
}
