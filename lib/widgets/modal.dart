import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

gridModal(BuildContext context, AppConfig appConfig, GridConfig config) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, Function setStateBuilder) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(AppLocalizations.of(context)!.sort),
              subtitle: {
                    "name": Text(AppLocalizations.of(context)!.sortedByName),
                    "last_login": Text(AppLocalizations.of(context)!.sortedByLastLogin),
                    "friends_in_instance": Text(AppLocalizations.of(context)!.sortedByFriendsInInstance),
                  }[config.sort] ??
                  Text(AppLocalizations.of(context)!.sortedByDefault),
              onTap: () => setStateBuilder(() => gridSortModal(context, setStateBuilder, config)),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.display),
              subtitle: {
                    "default": Text(AppLocalizations.of(context)!.default_),
                    "simple": Text(AppLocalizations.of(context)!.simple),
                    "text_only": Text(AppLocalizations.of(context)!.textOnly),
                  }[config.displayMode] ??
                  Text(AppLocalizations.of(context)!.sortedByDefault),
              onTap: () => setStateBuilder(() => gridSortModal(context, setStateBuilder, config)),
            ),
            SwitchListTile(
              value: config.joinable,
              title: Text(AppLocalizations.of(context)!.showOnlyAvailable),
              onChanged: (bool e) => setStateBuilder(() {
                config.setJoinable(e);
              }),
            ),
            SwitchListTile(
                value: config.worldDetails,
                title: Text(AppLocalizations.of(context)!.worldDetails),
                onChanged: (bool e) => setStateBuilder(() {
                      config.setWorldDetails(e);
                    })),
            ListTile(
              title: Text(AppLocalizations.of(context)!.openInBrowser),
              onTap: () {
                Navigator.pop(context);
                openInBrowser(context, appConfig, "https://vrchat.com/home/locations");
              },
            ),
          ],
        ),
      ),
    ),
  );
}

gridSortModal(BuildContext context, Function setState, GridConfig config) {
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
              title: Text(AppLocalizations.of(context)!.sortedByDefault),
              trailing: config.sort == "default" ? const Icon(Icons.check) : null,
              onTap: () => setStateBuilder(() {
                config.setSort("default");
                setState(() => {});
              }),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.sortedByName),
              trailing: config.sort == "name" ? const Icon(Icons.check) : null,
              onTap: () => setStateBuilder(() {
                config.setSort("name");
                setState(() => {});
              }),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.sortedByLastLogin),
              trailing: config.sort == "last_login" ? const Icon(Icons.check) : null,
              onTap: () => setStateBuilder(() {
                config.setSort("last_login");
                setState(() => {});
              }),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.sortedByFriendsInInstance),
              trailing: config.sort == "friends_in_instance" ? const Icon(Icons.check) : null,
              onTap: () => setStateBuilder(() {
                config.setSort("friends_in_instance");
                setState(() => {});
              }),
            ),
            SwitchListTile(
              value: config.descending,
              title: Text(AppLocalizations.of(context)!.descending),
              onChanged: (bool e) => setStateBuilder(() {
                config.setDescending(e);
                setState(() {});
              }),
            ),
          ],
        ),
      ),
    ),
  );
}

gridDispleyModeModal(BuildContext context, Function setStateBuilderParent, GridConfig config) {
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
              title: Text(AppLocalizations.of(context)!.default_),
              trailing: config.displayMode == "default" ? const Icon(Icons.check) : null,
              onTap: () => setStateBuilder(() {
                config.setDisplayMode("default");
                setStateBuilderParent(() {});
              }),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.simple),
              trailing: config.displayMode == "simple" ? const Icon(Icons.check) : null,
              onTap: () => setStateBuilder(() {
                config.setDisplayMode("simple");
                setStateBuilderParent(() {});
              }),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.textOnly),
              trailing: config.displayMode == "text_only" ? const Icon(Icons.check) : null,
              onTap: () => setStateBuilder(() {
                config.setDisplayMode("text_only");
                setStateBuilderParent(() {});
              }),
            ),
          ],
        ),
      ),
    ),
  );
}