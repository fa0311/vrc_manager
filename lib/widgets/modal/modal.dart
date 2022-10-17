// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/widgets/share.dart';

RoundedRectangleBorder getGridShape() {
  return const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
  );
}

Future gridModal(BuildContext context, GridConfig config, GridModalConfig gridModalConfig) {
  return showModalBottomSheet(
    context: context,
    shape: getGridShape(),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, Function setState) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (gridModalConfig.sortMode.isNotEmpty)
              ListTile(
                title: Text(AppLocalizations.of(context)!.sort),
                subtitle: Text(config.sortMode.toLocalization(context)),
                onTap: () => gridSortModal(
                  context,
                  config,
                  gridModalConfig.sortMode,
                ).then((value) => setState(() {})),
              ),
            if (gridModalConfig.displayMode.isNotEmpty)
              ListTile(
                title: Text(AppLocalizations.of(context)!.display),
                subtitle: Text(config.displayMode.toLocalization(context)),
                onTap: () => gridDisplayModeModal(
                  context,
                  config,
                  gridModalConfig.displayMode,
                ).then((value) => setState(() {})),
              ),
            if (gridModalConfig.joinable)
              SwitchListTile(
                value: config.joinable,
                title: Text(AppLocalizations.of(context)!.showOnlyAvailable),
                onChanged: (bool e) => setState(() {
                  config.setJoinable(e);
                }),
              ),
            if (gridModalConfig.worldDetails)
              SwitchListTile(
                value: config.worldDetails,
                title: Text(AppLocalizations.of(context)!.worldDetails),
                onChanged: (bool e) => setState(() {
                  config.setWorldDetails(e);
                }),
              ),
            if (gridModalConfig.removeButton)
              SwitchListTile(
                value: config.removeButton,
                title: Text(AppLocalizations.of(context)!.worldUnfavoriteButton),
                onChanged: (bool e) => setState(() {
                  config.setRemoveButton(e);
                }),
              ),
            if (gridModalConfig.url != null)
              ListTile(
                title: Text(AppLocalizations.of(context)!.openInBrowser),
                onTap: () {
                  Navigator.pop(context);
                  openInBrowser(context, gridModalConfig.url!);
                },
              ),
          ],
        ),
      ),
    ),
  );
}

Future gridSortModal(BuildContext context, GridConfig config, List<SortMode> gridSortMode) {
  return showModalBottomSheet(
    context: context,
    shape: getGridShape(),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, setState) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (SortMode sort in gridSortMode)
              ListTile(
                title: Text(sort.toLocalization(context)),
                trailing: config.sortMode == sort ? const Icon(Icons.check) : null,
                onTap: () => setState(() {
                  config.setSort(sort);
                }),
              ),
            SwitchListTile(
              value: config.descending,
              title: Text(AppLocalizations.of(context)!.descending),
              onChanged: (bool e) => setState(() {
                config.setDescending(e);
              }),
            ),
          ],
        ),
      ),
    ),
  );
}

Future gridDisplayModeModal(BuildContext context, GridConfig config, List<DisplayMode> gridDisplayMode) {
  return showModalBottomSheet(
    context: context,
    shape: getGridShape(),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, setState) => SingleChildScrollView(
        child: Column(children: <Widget>[
          for (DisplayMode display in gridDisplayMode)
            ListTile(
              title: Text(display.toLocalization(context)),
              trailing: config.displayMode == display ? const Icon(Icons.check) : null,
              onTap: () => setState(() {
                config.setDisplayMode(display);
              }),
            ),
          SwitchListTile(
            value: config.descending,
            title: Text(AppLocalizations.of(context)!.descending),
            onChanged: (bool e) => setState(() {
              config.setDescending(e);
            }),
          ),
        ]),
      ),
    ),
  );
}
