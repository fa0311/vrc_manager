// Flutter imports:
import 'dart:io';

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/drawer.dart';
import 'package:vrc_manager/widgets/grid_view/widget/world.dart';
import 'package:vrc_manager/widgets/modal/list_tile/main.dart';
import 'package:vrc_manager/widgets/modal/list_tile/user.dart';
import 'package:vrc_manager/widgets/user.dart';
/*
class VRChatMobileUser extends ConsumerWidget {
  VRChatMobileUser({Key? key, required this.userId}) : super(key: key);
  final String userId;
  late final VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late final VRChatUser? user;
  late final VRChatFriendStatus? status;
  late final VRChatWorld? world;
  late final VRChatInstance? instance;

  Future get(BuildContext context) async {
    await getUser(context);
    // ignore: use_build_context_synchronously
    await getWorld(context);
  }

  Future getUser(BuildContext context) async {
    user = await vrchatLoginSession.users(userId).catchError((status) {
      apiError(context, status);
    });
    if (user == null) return;
    status = await vrchatLoginSession.friendStatus(userId).catchError((status) {
      apiError(context, status);
    });
  }

  Future getWorld(BuildContext context) async {
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
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.user), actions: <Widget>[
        if (user != null && status != null)
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => modalBottom(
              context,
              userDetailsModalBottom(context, ref, user!, status!),
            ),
          ),
      ]),
      drawer: Navigator.of(context).canPop() ? null : drawer(context),
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
                    userProfile(context, user!),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: () {
                        if (user!.location == "private") return privateWorld(context);
                        if (user!.location == "traveling") return privateWorld(context);
                        if (user!.location == "offline") return null;
                        if (world == null) return const Padding(padding: EdgeInsets.only(top: 30), child: CircularProgressIndicator());
                        return instanceWidget(context, VRChatWorldInstance(world!, instance!));
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





*/

class VRChatMobileUserProvider {
  VRChatUser user;
  VRChatFriendStatus status;
  VRChatWorld? world;
  VRChatInstance? instance;

  VRChatMobileUserProvider({
    required this.user,
    required this.status,
    world,
    instance,
  });
}

final worldInstanceProvider = FutureProvider.family<VRChatMobileUserProvider, String>((ref, userId) async {
  final VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late VRChatUser user;
  late VRChatFriendStatus status;
  VRChatWorld? world;
  VRChatInstance? instance;

  await Future.wait([
    vrchatLoginSession.users(userId).then((value) => user = value),
    vrchatLoginSession.friendStatus(userId).then((value) => status = value),
  ]);
  if (user == null) throw const HttpException("user error");
  if (["private", "offline", "traveling"].contains(user.location)) return VRChatMobileUserProvider(user: user, status: status);

  await Future.wait([
    vrchatLoginSession.worlds(user.location.split(":")[0]).then((value) => world = value),
    vrchatLoginSession.instances(user.location).then((value) => instance = value),
  ]);
  return VRChatMobileUserProvider(user: user, status: status, world: world, instance: instance);
});

class VRChatMobileUser extends ConsumerWidget {
  VRChatMobileUser({Key? key, required this.userId}) : super(key: key);
  final String userId;
  late final VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  late final VRChatUser? user;
  late final VRChatFriendStatus? status;
  late final VRChatWorld? world;
  late final VRChatInstance? instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    textStream(context);
    AsyncValue<VRChatMobileUserProvider> data = ref.watch(worldInstanceProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home),
        actions: data.when(
          loading: () => null,
          error: (err, stack) => [Text('Error: $err')],
          data: (data) => [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => modalBottom(
                context,
                userDetailsModalBottom(context, ref, data.user, data.status),
              ),
            ),
          ],
        ),
      ),
      drawer: Navigator.of(context).canPop() ? null : drawer(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 0,
                right: 30,
                left: 30,
              ),
              child: data.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
                data: (data) => Column(
                  children: [
                    userProfile(context, data.user),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      child: () {
                        if (data.user.location == "private") return privateWorld(context);
                        if (data.user.location == "traveling") return privateWorld(context);
                        if (data.user.location == "offline") return null;
                        data.world == null ? null : instanceWidget(context, data.world!, data.instance!);
                      }(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
