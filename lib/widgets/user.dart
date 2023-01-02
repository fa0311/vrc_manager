// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:vrc_manager/api/assets/icon.dart';
import 'package:vrc_manager/api/data_class.dart';
import 'package:vrc_manager/api/main.dart';
import 'package:vrc_manager/assets.dart';
import 'package:vrc_manager/assets/anchor.dart';
import 'package:vrc_manager/assets/date.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/core/splash.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/scenes/sub/self.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/widgets/modal.dart';
import 'package:vrc_manager/widgets/modal/share.dart';
import 'package:vrc_manager/widgets/scroll.dart';
import 'package:vrc_manager/widgets/share.dart';
import 'package:vrc_manager/widgets/status.dart';

class Username extends ConsumerWidget {
  final VRChatUser user;
  final double diameter;
  const Username({super.key, required this.user, this.diameter = 20});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
}

class UserProfile extends ConsumerWidget {
  final VRChatUser user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        Username(user: user),
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
              child: TextToAnchor(text: user.bio ?? ""),
            ),
          ),
        if (user.bioLinks.isNotEmpty) BioLink(bioLinks: user.bioLinks),
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
}

final editBioProvider = StateProvider<bool>((ref) => false);

final bioControllerProvider = StateProvider.family<TextEditingController, VRChatUser>((ref, user) => TextEditingController(text: user.bio));

class EditBio extends ConsumerWidget {
  final VRChatUser user;
  const EditBio({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool wait = ref.watch(editBioProvider);
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "");
    TextEditingController controller = ref.watch(bioControllerProvider(user));

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
          onPressed: () async {
            ref.read(editBioProvider.notifier).state = true;
            await vrchatLoginSession.changeBio(user.id, user.bio = controller.text).catchError((e) {
              logger.e(getMessage(e), e);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
            });
            user.bio = user.bio == "" ? null : user.bio;
            ref.read(vrchatUserCountProvider.notifier).state++;
            ref.read(editBioProvider.notifier).state = false;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

final editNoteProvider = StateProvider<bool>((ref) => false);

final noteControllerProvider = FutureProvider.family<TextEditingController, VRChatUser>((ref, user) async {
  final VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.read(accountConfigProvider).loggedAccount!.cookie ?? "");
  if (user.note == null) {
    await vrchatLoginSession.users(user.id).then((value) => user.note = value.note).catchError((e) {
      logger.e(getMessage(e), e);
    });
  }
  return TextEditingController(text: user.note);
});

class EditNote extends ConsumerWidget {
  final VRChatUser user;
  const EditNote({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool wait = ref.watch(editNoteProvider);
    VRChatAPI vrchatLoginSession = VRChatAPI(cookie: ref.watch(accountConfigProvider).loggedAccount?.cookie ?? "");
    AsyncValue<TextEditingController> data = ref.watch(noteControllerProvider(user));

    return data.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, trace) {
        logger.w(getMessage(e), e, trace);
        return ScrollWidget(
          onRefresh: () => ref.refresh(vrchatMobileSelfProvider.future),
          child: ErrorPage(loggerReport: ref.read(loggerReportProvider)),
        );
      },
      data: (data) => AlertDialog(
        content: TextField(
          controller: data,
          maxLines: null,
          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.editNote),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.close),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: wait ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator()) : Text(AppLocalizations.of(context)!.save),
            onPressed: () async {
              ref.read(editNoteProvider.notifier).state = true;
              await vrchatLoginSession.userNotes(user.id, user.note = data.text).catchError((e) {
                logger.e(getMessage(e), e);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ErrorSnackBar(e)));
              });
              user.note = user.note == "" ? null : user.note;
              ref.read(vrchatUserCountProvider.notifier).state++;
              ref.read(editNoteProvider.notifier).state = false;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class BioLink extends ConsumerWidget {
  final List<Uri> bioLinks;
  const BioLink({super.key, required this.bioLinks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (Uri url in bioLinks)
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              Widget? value = await openInBrowser(
                url: url,
                forceExternal: accessibilityConfig.forceExternalBrowser,
              );
              if (value != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => value),
                );
              }
            },
            onLongPress: () {
              showModalBottomSheetStatelessWidget(
                context: context,
                builder: () => ShareUrlListTile(url: url),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Ink(
                child: SvgPicture.asset(
                  Assets.svg.resolve("${byVrchatExternalServices(url).text}.svg").toFilePath(),
                  width: 20,
                  height: 20,
                  color: Color(byVrchatExternalServices(url).color),
                  semanticsLabel: url.toString(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
