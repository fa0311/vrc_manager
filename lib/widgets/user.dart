// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/enum/icon.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets/anchor.dart';
import 'package:vrc_manager/assets/date.dart';
import 'package:vrc_manager/assets/error.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/sub/self.dart';
import 'package:vrc_manager/widgets/modal/main.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/share.dart';
import 'package:vrc_manager/widgets/status.dart';

Row username(VRChatUser user, {double diameter = 20}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      StatusWidget(status: user.status, diameter: diameter - 2),
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

final editBioProvider = StateProvider<bool>((ref) => false);

Widget editBio(VRChatUser user) {
  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  TextEditingController controller = TextEditingController()..text = user.bio ?? "";
  return Consumer(builder: (BuildContext context, WidgetRef ref, _) {
    bool wait = ref.watch(editBioProvider);
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
            child: wait ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : Text(AppLocalizations.of(context)!.save),
            onPressed: () {
              ref.read(editBioProvider.notifier).state = true;
              vrchatLoginSession.changeBio(user.id, user.bio = controller.text).then((VRChatUserSelf response) {
                user.bio = user.bio == "" ? null : user.bio;
                ref.read(vrchatUserCountProvider.notifier).state++;
                ref.read(editBioProvider.notifier).state = false;
                Navigator.pop(context);
              }).catchError((status) {
                apiError(context, status);
              });
            }),
      ],
    );
  });
}

final editNoteProvider = StateProvider<bool>((ref) => false);

Widget editNote(VRChatUser user) {
  VRChatAPI vrchatLoginSession = VRChatAPI(cookie: appConfig.loggedAccount?.cookie ?? "");
  TextEditingController controller = TextEditingController()..text = user.note ?? "";
  return Consumer(builder: (BuildContext context, WidgetRef ref, _) {
    bool wait = ref.watch(editNoteProvider);
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
            child: wait ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : Text(AppLocalizations.of(context)!.save),
            onPressed: () {
              ref.read(editNoteProvider.notifier).state = true;
              vrchatLoginSession.userNotes(user.id, user.note = controller.text).then((VRChatUserNotes response) {
                user.note = user.note == "" ? null : user.note;
                ref.read(vrchatUserCountProvider.notifier).state++;
                ref.read(editNoteProvider.notifier).state = false;
                Navigator.pop(context);
              }).catchError((status) {
                apiError(context, status);
              });
            }),
      ],
    );
  });
}

List<Widget> bioLink(BuildContext context, List<Uri> bioLinks) {
  return [
    for (Uri url in bioLinks)
      InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openInBrowser(context, url),
        onLongPress: () => modalBottom(context, shareUrlListTile(context, url)),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Ink(
            child: SvgPicture.asset(
              "assets/svg/${byVrchatExternalServices(url)}.svg",
              width: 20,
              height: 20,
              color: Color(byVrchatExternalServices(url).color),
              semanticsLabel: url.toString(),
            ),
          ),
        ),
      ),
  ];
}
