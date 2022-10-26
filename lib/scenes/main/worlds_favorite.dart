// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/data_class/app_config.dart';
import 'package:vrc_manager/data_class/modal.dart';
import 'package:vrc_manager/data_class/state.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/extraction/favorite_world.dart';
import 'package:vrc_manager/widgets/modal/modal.dart';

class VRChatMobileWorldsFavorite extends StatefulWidget {
  final bool offline;

  const VRChatMobileWorldsFavorite({Key? key, this.offline = true}) : super(key: key);

  @override
  State<VRChatMobileWorldsFavorite> createState() => _WorldsFavoriteState();
}

class _WorldsFavoriteState extends State<VRChatMobileWorldsFavorite> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late GridConfig config = appConfig.gridConfigList.favoriteWorlds;
  late SortData sortData = SortData(config);
  GridModalConfig gridConfig = GridModalConfig();

  @override
  initState() {
    super.initState();
    gridConfig.url = "https://vrchat.com/home/worlds";
    gridConfig.removeButton = true;
    gridConfig.displayMode = [
      DisplayMode.normal,
      DisplayMode.simple,
      DisplayMode.textOnly,
    ];
    gridConfig.sortMode = [
      SortMode.normal,
      SortMode.name,
      SortMode.updatedDate,
      SortMode.labsPublicationDate,
      SortMode.heat,
      SortMode.capacity,
      SortMode.occupants,
    ];
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
    for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? []) {
      sortData.worlds(favoriteWorld.list);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoriteWorlds),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => gridModal(context, config, gridConfig).then((value) => setState(() {})),
          ),
        ],
      ),
      drawer: drawer(),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
              for (FavoriteWorldData favoriteWorld in appConfig.loggedAccount?.favoriteWorld ?? [])
                if (favoriteWorld.list.isNotEmpty) ...[
                  Text(favoriteWorld.group.displayName),
                  () {
                    switch (config.displayMode) {
                      case DisplayMode.normal:
                        return extractionWorldDefault(context, config, favoriteWorld.list, setState: setState);
                      case DisplayMode.simple:
                        return extractionWorldSimple(context, config, favoriteWorld.list, setState: setState);
                      case DisplayMode.textOnly:
                        return extractionWorldSimple(context, config, favoriteWorld.list, setState: setState);
                    }
                  }(),
                ],
            ]),
          ),
        ),
      ),
    );
  }
}
