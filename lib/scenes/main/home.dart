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
import 'package:vrc_manager/scenes/sub/json_viewer.dart';
import 'package:vrc_manager/scenes/sub/login.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/profile.dart';
import 'package:vrc_manager/widgets/share.dart';

class VRChatMobileHome extends StatefulWidget {
  const VRChatMobileHome({Key? key}) : super(key: key);
  @override
  State<VRChatMobileHome> createState() => _LoginHomeState();
}

class _LoginHomeState extends State<VRChatMobileHome> {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  VRChatUserSelfOverload? user;
  VRChatWorld? world;
  VRChatInstance? instance;

  TextEditingController bioController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  initState() {
    super.initState();
    get();
  }

  Future get() async {
    await getUser().then((value) => setState(() {}));
    await getWorld().then((value) => setState(() {}));
  }

  Future getUser() async {
    user = await vrchatLoginSession.user().catchError((status) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const VRChatMobileLogin(),
        ),
        (_) => false,
      );
    });
    bioController.text = user!.bio ?? "";
    noteController.text = user!.note ?? "";
  }

  Future getWorld() async {
    if (!["private", "offline", "traveling"].contains(user!.location)) {
      world = await vrchatLoginSession.worlds(user!.location.split(":")[0]).catchError((status) {
        apiError(context, status);
      });
      instance = await vrchatLoginSession.instances(user!.location).catchError((status) {
        apiError(context, status);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    textStream(
      context,
    );
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.home), actions: <Widget>[
        if (user != null)
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => modalBottom(context, shareUrlListTile(context, "https://vrchat.com/home/user/${user!.id}")),
          )
      ]),
      drawer: drawer(context),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 0,
                right: 30,
                left: 30,
              ),
              child: Column(
                children: <Widget>[
                  if (user == null)
                    const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator())
                  else ...[
                    profile(context, user!),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        ),
                        onPressed: () => editBio(context, setState, bioController, user!),
                        child: Text(AppLocalizations.of(context)!.editBio),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        ),
                        onPressed: () => editNote(context, setState, noteController, user!),
                        child: Text(AppLocalizations.of(context)!.editNote),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => VRChatMobileJsonViewer(obj: user!.content),
                          ),
                        ),
                        child: Text(AppLocalizations.of(context)!.viewInJsonViewer),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: () {
                        if (user!.location == "private") return privateWorld(context);
                        if (user!.location == "traveling") return privateWorld(context);
                        if (user!.location == "offline") return null;
                        if (world == null) return const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());
                        return instanceWidget(context, world!, instance!);
                      }(),
                    ),
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