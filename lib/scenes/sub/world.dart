// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/world.dart';
import 'package:vrc_manager/widgets/world.dart';

class VRChatMobileWorld extends StatefulWidget {
  final String worldId;

  const VRChatMobileWorld({Key? key, required this.worldId}) : super(key: key);

  @override
  State<VRChatMobileWorld> createState() => _WorldState();
}

class _WorldState extends State<VRChatMobileWorld> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  VRChatWorld? world;

  @override
  initState() {
    super.initState();
    get().then((value) => setState(() {}));
  }

  Future get() async {
    world = await vrchatLoginSession.worlds(widget.worldId).catchError((status) {
      apiError(context, status);
    });
  }

  @override
  Widget build(BuildContext context) {
    textStream(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.world), actions: [
        if (world != null)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => modalBottom(
              context,
              worldDetailsModalBottom(context, world!),
            ),
          )
      ]),
      drawer: Navigator.of(context).canPop() ? null : drawer(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 0, right: 30, left: 30),
              child: Column(
                children: [
                  if (world == null) const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator()),
                  if (world != null) ...[
                    worldProfile(context, world!),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
