// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:vrchat_mobile_client/widgets/share.dart';

class GridModalConfig {
  GridSortConfig? sort = GridSortConfig();
  GridDispleyModeConfig? displayMode = GridDispleyModeConfig();
  bool worldDetails = false;
  bool joinable = false;
  String? url;
  GridModalConfig();
}

class GridSortConfig {
  bool name = true;

  bool lastLogin = false;
  bool frendsInInstance = false;
  bool updatedDate = false;
  bool labsPublicationDate = false;
  bool heat = false;
  bool capacity = false;
  bool occupants = false;
}

class GridDispleyModeConfig {
  bool normal = true;
  bool simple = true;
  bool textOnly = true;
}

gridModal(BuildContext context, AppConfig appConfig, Function setState, GridConfig config, GridModalConfig gridModalConfig) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, Function setStateBuilder) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (gridModalConfig.sort != null)
              ListTile(
                title: Text(AppLocalizations.of(context)!.sort),
                subtitle: {
                      "name": Text(AppLocalizations.of(context)!.sortedByName),
                      "last_login": Text(AppLocalizations.of(context)!.sortedByLastLogin),
                      "friends_in_instance": Text(AppLocalizations.of(context)!.sortedByFriendsInInstance),
                    }[config.sort] ??
                    Text(AppLocalizations.of(context)!.sortedByDefault),
                onTap: () => setStateBuilder(() => gridSortModal(
                      context,
                      (VoidCallback fn) => setStateBuilder(() => setState(fn)),
                      config,
                      gridModalConfig.sort!,
                    )),
              ),
            if (gridModalConfig.displayMode != null)
              ListTile(
                title: Text(AppLocalizations.of(context)!.display),
                subtitle: {
                      "normal": Text(AppLocalizations.of(context)!.normal),
                      "simple": Text(AppLocalizations.of(context)!.simple),
                      "text_only": Text(AppLocalizations.of(context)!.textOnly),
                    }[config.displayMode] ??
                    Text(AppLocalizations.of(context)!.sortedByDefault),
                onTap: () => setStateBuilder(() => gridDispleyModeModal(
                      context,
                      (VoidCallback fn) => setStateBuilder(() => setState(fn)),
                      config,
                      gridModalConfig.displayMode!,
                    )),
              ),
            if (gridModalConfig.joinable)
              SwitchListTile(
                value: config.joinable,
                title: Text(AppLocalizations.of(context)!.showOnlyAvailable),
                onChanged: (bool e) => setStateBuilder(() {
                  config.setJoinable(e);
                  setState(() {});
                }),
              ),
            if (gridModalConfig.worldDetails)
              SwitchListTile(
                value: config.worldDetails,
                title: Text(AppLocalizations.of(context)!.worldDetails),
                onChanged: (bool e) => setStateBuilder(() {
                  config.setWorldDetails(e);
                  setState(() {});
                }),
              ),
            if (gridModalConfig.url != null)
              ListTile(
                title: Text(AppLocalizations.of(context)!.openInBrowser),
                onTap: () {
                  Navigator.pop(context);
                  openInBrowser(context, appConfig, gridModalConfig.url!);
                },
              ),
          ],
        ),
      ),
    ),
  );
}

gridSortModal(BuildContext context, Function setState, GridConfig config, GridSortConfig gridSortConfig) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ...<String, String>{
              "normal": AppLocalizations.of(context)!.sortedByDefault,
              if (gridSortConfig.name) "name": AppLocalizations.of(context)!.sortedByName,
              if (gridSortConfig.lastLogin) "last_login": AppLocalizations.of(context)!.sortedByLastLogin,
              if (gridSortConfig.frendsInInstance) "friends_in_instance": AppLocalizations.of(context)!.sortedByFriendsInInstance,
              if (gridSortConfig.updatedDate) "updated_date": AppLocalizations.of(context)!.sortedByUpdatedDate,
              if (gridSortConfig.labsPublicationDate) "labs_publication_date": AppLocalizations.of(context)!.sortedByLabsPublicationDate,
              if (gridSortConfig.heat) "heat": AppLocalizations.of(context)!.sortedByHeat,
              if (gridSortConfig.capacity) "capacity": AppLocalizations.of(context)!.sortedByCapacity,
              if (gridSortConfig.occupants) "occupants": AppLocalizations.of(context)!.sortedByOccupants,
            }
                .entries
                .map((e) => ListTile(
                      title: Text(e.value),
                      trailing: config.sort == e.key ? const Icon(Icons.check) : null,
                      onTap: () => setStateBuilder(() {
                        config.setSort(e.key);
                        setState(() {});
                      }),
                    ))
                .toList(),
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

gridDispleyModeModal(BuildContext context, Function setState, GridConfig config, GridDispleyModeConfig gridDisplayModeConfig) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ...<String, String>{
              "normal": AppLocalizations.of(context)!.normal,
              if (gridDisplayModeConfig.simple) "simple": AppLocalizations.of(context)!.simple,
              if (gridDisplayModeConfig.textOnly) "text_only": AppLocalizations.of(context)!.textOnly,
            }
                .entries
                .map((e) => ListTile(
                      title: Text(e.value),
                      trailing: config.displayMode == e.key ? const Icon(Icons.check) : null,
                      onTap: () => setStateBuilder(() {
                        config.setDisplayMode(e.key);
                        setState(() {});
                      }),
                    ))
                .toList(),
          ],
        ),
      ),
    ),
  );
}
