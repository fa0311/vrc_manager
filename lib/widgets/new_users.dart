import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vrchat_mobile_client/api/data_class.dart';
import 'package:vrchat_mobile_client/api/main.dart';
import 'package:vrchat_mobile_client/assets/error.dart';
import 'package:vrchat_mobile_client/assets/vrchat/instance_type.dart';
import 'package:vrchat_mobile_client/data_class/app_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:vrchat_mobile_client/scenes/world.dart';
import 'package:vrchat_mobile_client/widgets/region.dart';

GridView renderGrid(
  BuildContext context, {
  required int width,
  required int height,
  required List<Widget> children,
}) {
  double screenSize = MediaQuery.of(context).size.width;

  return GridView.count(
    crossAxisCount: screenSize ~/ width + 1,
    crossAxisSpacing: 0,
    mainAxisSpacing: 0,
    childAspectRatio: screenSize / (screenSize ~/ width + 1) / height,
    padding: const EdgeInsets.only(bottom: 30),
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    children: children,
  );
}

List<Text> toTextWidget(List<String> textList, {double fontSize = 15}) {
  return [
    for (String text in textList)
      Text(
        text,
        style: TextStyle(fontSize: fontSize),
      ),
  ];
}

Widget genericTemplate(
  BuildContext context,
  AppConfig appConfig, {
  required List<Widget> children,
  required String imageUrl,
  void Function()? onTap,
  Widget? bottom,
  bool card = true,
  bool half = false,
}) {
  if (half) {
    Widget content = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              SizedBox(
                height: 50,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.fitWidth,
                  progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                    width: 50,
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    width: 50,
                    child: Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
              ),
            ],
          ),
          if (bottom != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: bottom,
            ),
        ],
      ),
    );
    if (card) {
      return Card(elevation: 20.0, child: Container(padding: const EdgeInsets.all(5.0), child: content));
    } else {
      return content;
    }
  } else {
    Widget content = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              SizedBox(
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.fitWidth,
                  progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
                    width: 100,
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    width: 100,
                    child: Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),
                ),
              ),
            ],
          ),
          if (bottom != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: bottom,
            ),
        ],
      ),
    );
    if (card) {
      return Card(elevation: 20.0, child: Container(padding: const EdgeInsets.all(10.0), child: content));
    } else {
      return content;
    }
  }
}

Widget instanceWidget(
  BuildContext context,
  AppConfig appConfig,
  VRChatWorld world,
  VRChatInstance instance, {
  bool card = false,
  bool half = false,
}) {
  return genericTemplate(
    context,
    appConfig,
    imageUrl: world.thumbnailImageUrl,
    card: card,
    half: half,
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => VRChatMobileWorld(appConfig, worldId: world.id),
        )),
    children: [
      Row(children: <Widget>[
        region(instance.region, size: half ? 12 : 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Icon(Icons.groups, size: half ? 17 : 25),
              Text("${instance.nUsers}/${instance.capacity}",
                  style: TextStyle(
                    fontSize: half ? 10 : 15,
                  )),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Text(getVrchatInstanceType(context)[instance.type] ?? "Error",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: half ? 10 : 15,
                )),
          ),
        )
      ]),
      SizedBox(
        width: double.infinity,
        child: Text(
          world.name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: half ? 10 : 15,
            height: 1,
          ),
        ),
      ),
      if ((instance.shortName ?? instance.secureName) != null) selfInviteButton(context, appConfig, instance, half: half),
    ],
  );
}

Widget privateWorld(
  BuildContext context,
  AppConfig appConfig, {
  bool card = true,
  bool half = false,
}) {
  return genericTemplate(
    context,
    appConfig,
    card: card,
    half: half,
    children: [
      SizedBox(
        width: double.infinity,
        child: Text("Private",
            style: TextStyle(
              fontSize: half ? 10 : 15,
            )),
      ),
      SizedBox(
        width: double.infinity,
        child: Text(
          AppLocalizations.of(context)!.privateWorld,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: half ? 10 : 15,
          ),
        ),
      ),
    ],
    imageUrl: "https://assets.vrchat.com/www/images/default_private_image.png",
  );
}

Widget travelingWorld(
  BuildContext context,
  AppConfig appConfig, {
  bool card = true,
  bool half = false,
}) {
  return genericTemplate(
    context,
    appConfig,
    card: card,
    half: half,
    children: [
      SizedBox(
        width: double.infinity,
        child: Text("Traveling",
            style: TextStyle(
              fontSize: half ? 10 : 15,
            )),
      ),
      SizedBox(
        width: double.infinity,
        child: Text(
          AppLocalizations.of(context)!.privateWorld,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: half ? 10 : 15,
          ),
        ),
      ),
    ],
    imageUrl: "https://assets.vrchat.com/www/images/default_between_image.png",
  );
}

Widget selfInviteButton(
  BuildContext context,
  AppConfig appConfig,
  VRChatInstance instance, {
  bool half = false,
}) {
  late VRChatAPI vrhatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  return SizedBox(
    height: half ? 15 : 30,
    child: TextButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.grey,
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
      onPressed: () => vrhatLoginSession.selfInvite(instance.location, instance.shortName ?? "").then((VRChatNotificationsInvite response) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.sendInvite),
              content: Text(AppLocalizations.of(context)!.selfInviteDetails),
              actions: <Widget>[
                TextButton(
                  child: Text(AppLocalizations.of(context)!.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          },
        );
      }).catchError((status) {
        apiError(context, appConfig, status);
      }),
      child: Text(AppLocalizations.of(context)!.joinInstance, style: TextStyle(fontSize: half ? 8 : 15)),
    ),
  );
}
