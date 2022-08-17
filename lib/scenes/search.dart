// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/assets/flutter/text_stream.dart';
import 'package:vrchat_mobile_client/widgets/drawer.dart';

class VRChatSearch extends StatefulWidget {
  const VRChatSearch({Key? key}) : super(key: key);

  @override
  State<VRChatSearch> createState() => _SearchState();
}

class _SearchState extends State<VRChatSearch> {
  TextEditingController searchBoxController = TextEditingController();

  String searchMode = "users";

  searchModeModal(Function setStateBuilderParent) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.user),
                trailing: searchMode == "users" ? const Icon(Icons.check) : null,
                onTap: () {
                  setStateBuilder(() => searchMode = "users");
                  setStateBuilderParent(() {});
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.world),
                trailing: searchMode == "worlds" ? const Icon(Icons.check) : null,
                onTap: () {
                  setStateBuilder(() => searchMode = "worlds");
                  setStateBuilderParent(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      drawer: drawer(context),
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 0),
                  child: TextField(
                    controller: searchBoxController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.search,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(
                            () {},
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.display),
                      subtitle: {
                            "users": Text(AppLocalizations.of(context)!.user),
                            "worlds": Text(AppLocalizations.of(context)!.world),
                          }[searchMode] ??
                          Text(AppLocalizations.of(context)!.user),
                      onTap: () => setState(() => searchModeModal(setState)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
