// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/widgets/share.dart';

gridModal(BuildContext context, Function setState, GridConfig config, GridModalConfig gridModalConfig) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, Function setStateBuilder) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (gridModalConfig.sortMode.isNotEmpty)
              ListTile(
                title: Text(AppLocalizations.of(context)!.sort),
                subtitle: Text(config.displayMode.toLocalization(context)),
                onTap: () => setStateBuilder(() => gridSortModal(
                      context,
                      (VoidCallback fn) => setStateBuilder(() => setState(fn)),
                      config,
                      gridModalConfig.sortMode,
                    )),
              ),
            if (gridModalConfig.displayMode.isNotEmpty)
              ListTile(
                title: Text(AppLocalizations.of(context)!.display),
                subtitle: Text(config.displayMode.toLocalization(context)),
                onTap: () => setStateBuilder(() => gridDisplayModeModal(
                      context,
                      (VoidCallback fn) => setStateBuilder(() => setState(fn)),
                      config,
                      gridModalConfig.displayMode,
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
            if (gridModalConfig.removeButton)
              SwitchListTile(
                value: config.removeButton,
                title: Text(AppLocalizations.of(context)!.worldUnfavoriteButton),
                onChanged: (bool e) => setStateBuilder(() {
                  config.setRemoveButton(e);
                  setState(() {});
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

gridSortModal(BuildContext context, Function setState, GridConfig config, List<SortMode> gridSortMode) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (SortMode sort in gridSortMode)
              ListTile(
                title: Text(sort.toLocalization(context)),
                trailing: config.sortMode == sort ? const Icon(Icons.check) : null,
                onTap: () => setStateBuilder(() {
                  config.setSort(sort);
                  setState(() {});
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

gridDisplayModeModal(BuildContext context, Function setState, GridConfig config, List<DisplayMode> gridDisplayMode) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
    ),
    builder: (BuildContext context) => StatefulBuilder(
      builder: (BuildContext context, setStateBuilder) => SingleChildScrollView(
        child: Column(children: <Widget>[
          for (DisplayMode display in gridDisplayMode)
            ListTile(
              title: Text(display.toLocalization(context)),
              trailing: config.displayMode == display ? const Icon(Icons.check) : null,
              onTap: () => setStateBuilder(() {
                config.setDisplayMode(display);
                setState(() {});
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
        ]),
      ),
    ),
  );
}
