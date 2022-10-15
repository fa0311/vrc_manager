// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/anchor.dart';
import 'package:vrc_manager/assets/date.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/assets/vrchat/icon.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/widgets/share.dart';
import 'package:vrc_manager/widgets/status.dart';

Row username(VRChatUser user, {double diameter = 20}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      status(user.state == "offline" ? user.state! : user.status, diameter: diameter - 2),
      Padding(
        padding: const EdgeInsets.only(left: 2, right: 5),
        child: Text(
          user.displayName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: diameter,
          ),
        ),
      ),
    ],
  );
}

Column userProfile(BuildContext context, VRChatUser user) {
  return Column(
    children: <Widget>[
      SizedBox(
        height: 250,
        child: CachedNetworkImage(
          imageUrl: user.profilePicOverride ?? user.currentAvatarImageUrl,
          fit: BoxFit.fitWidth,
          progressIndicatorBuilder: (context, url, downloadProgress) => const SizedBox(
            width: 250,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(
                strokeWidth: 10,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const SizedBox(
            width: 250.0,
            child: Icon(Icons.error),
          ),
        ),
      ),
      Container(padding: const EdgeInsets.only(top: 10)),
      username(user),
      if (user.statusDescription != null) Text(user.statusDescription ?? ""),
      if (user.note != null)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0),
          child: Text(user.note ?? ""),
        ),
      if (user.bio != null)
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                children: textToAnchor(context, user.bio ?? ""),
                style: TextStyle(color: Theme.of(context).textTheme.bodyText2?.color),
              ),
            ),
          ),
        ),
      if (user.bioLinks.isNotEmpty)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: bioLink(context, user.bioLinks),
        ),
      if (user.lastLogin != null)
        Text(
          AppLocalizations.of(context)!.lastLogin(
            generalDateDifference(context, user.lastLogin!),
          ),
        ),
      if (user.dateJoined != null)
        Text(
          AppLocalizations.of(context)!.dateJoined(
            generalDateDifference(context, user.dateJoined!),
          ),
        ),
    ],
  );
}

Future editBio(BuildContext context, TextEditingController controller, VRChatUserSelf user) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: TextField(
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.editBio),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.close),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.save),
            onPressed: () => vrchatLoginSession.changeBio(user.id, user.bio = controller.text).then((VRChatUserSelf response) {
              user.bio = user.bio == "" ? null : user.bio;
              Navigator.pop(context);
            }).catchError((status) {
              apiError(context, status);
            }),
          ),
        ],
      );
    },
  );
}

Future editNote(BuildContext context, TextEditingController controller, VRChatUser user) {
  late VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  return showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.editNote),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.close),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.save),
            onPressed: () => vrchatLoginSession.userNotes(user.id, user.note = controller.text).then((VRChatUserNotes notes) {
              user.note = user.note == "" ? null : user.note;
              Navigator.pop(context);
            }).catchError((status) {
              apiError(context, status);
            }),
          ),
        ],
      );
    },
  );
}

List<Widget> bioLink(BuildContext context, List<Uri> bioLinks) {
  return [
    for (Uri link in bioLinks)
      InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openInBrowser(context, link.toString()),
        onLongPress: () => modalBottom(context, shareUrlListTile(context, link.toString())),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Ink(
            child: SvgPicture.asset(
              "assets/svg/${getVrchatIconContains(link)}.svg",
              width: 20,
              height: 20,
              color: Color(getVrchatIcon()[getVrchatIconContains(link)] ?? 0xFFFFFFFF),
              semanticsLabel: link.toString(),
            ),
          ),
        ),
      ),
  ];
}
