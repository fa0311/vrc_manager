// Dart imports:

// Dart imports:
import 'dart:io';
import 'dart:math';
// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:dio/dio.dart' as dio;
import 'package:vrc_manager/assets.dart';

// Project imports:
import 'package:vrc_manager/assets/flutter/text_stream.dart';
import 'package:vrc_manager/assets/flutter/url_parser.dart';
import 'package:vrc_manager/assets/storage2.dart';
import 'package:vrc_manager/main.dart';
import 'package:vrc_manager/scenes/main/main.dart';
import 'package:vrc_manager/scenes/setting/logger.dart';
import 'package:vrc_manager/scenes/sub/login.dart';
import 'package:vrc_manager/scenes/web/web_view_policies.dart';
import 'package:vrc_manager/storage/accessibility.dart';
import 'package:vrc_manager/storage/account.dart';
import 'package:vrc_manager/storage/grid_modal.dart';
import 'package:vrc_manager/storage/user_policy.dart';
import 'package:vrc_manager/widgets/grid_modal/config.dart';
import 'package:vrc_manager/widgets/scroll.dart';
import 'package:vrchat_dart/vrchat_dart.dart';

final accountConfigProvider = ChangeNotifierProvider<AccountConfigNotifier>((ref) => AccountConfigNotifier());
final accountListConfigProvider = ChangeNotifierProvider<AccountListConfigNotifier>((ref) => AccountListConfigNotifier());
final isFirstProvider = StateProvider<bool>((ref) => true);

enum SplashData {
  home,
  login,
  userPolicy;
}

final splashProvider = FutureProvider<SplashData>((ref) async {
  for (GridModalConfigType id in GridModalConfigType.values) {
    ref.read(gridConfigProvider(id));
  }

  AccountConfigNotifier accountConfig = ref.watch(accountConfigProvider);
  AccountListConfigNotifier accountListConfig = ref.read(accountListConfigProvider);
  UserPolicyConfigNotifier userPolicyConfig = ref.watch(userPolicyConfigProvider);

  if (accountListConfig.isFirst) {
    await accountListConfig.init();
    accountConfig.init(await accountListConfig.getLoggedAccount());
  }

  if (userPolicyConfig.isFirst) {
    await userPolicyConfig.init();
  }

  if (!userPolicyConfig.agree) {
    return SplashData.userPolicy;
  }

  if (accountConfig.isLogout()) {
    return SplashData.login;
  }

  if (!await accountConfig.loggedAccount!.tokenCheck()) {
    return SplashData.login;
  }

  return SplashData.home;
});

// ======================

enum SplashStatus {
  home,
  login,
  userPolicy;
}

final getCurrentUserProvider = FutureProvider<dio.Response<CurrentUser>>((ref) async {
  final session = await ref.watch(getSessionProvider.future);
  final currentUser = await session.rawApi.getAuthenticationApi().getCurrentUser();
  return currentUser;
});

final packageInfoProvider = FutureProvider<PackageInfo>((ref) => PackageInfo.fromPlatform());

final selectedIdProvider = FutureProvider<String>((ref) async {
  final id = await ConfigStorage().get(key: ConfigStorageKey.selectedId);
  if (id != null) return id;
  final newId = genId();
  await ConfigStorage().set(key: ConfigStorageKey.selectedId, value: newId);
  return newId;
});

final vrchatDartProvider = FutureProvider.family<VrchatDart, String>((ref, id) async {
  final packageInfo = await ref.read(packageInfoProvider.future);
  final packageName = packageInfo.packageName;
  final api = VrchatDart(
    cookiePath: "data/data/$packageName/files/$id",
    // cspell:disable-next-line
    userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36',
  );
  return api;
});

final getSessionProvider = FutureProvider<VrchatDart>((ref) async {
  final id = await ref.watch(selectedIdProvider.future);
  final session = await ref.watch(vrchatDartProvider(id).future);
  return session;
});

final splashProviderNew = FutureProvider<SplashStatus>((ref) async {
  try {
    final currentUser = await ref.read(getCurrentUserProvider.future);
    logger.i(currentUser.data);
  } on dio.DioError catch (e) {
    if (e.type == dio.DioErrorType.response) return SplashStatus.login;
    rethrow;
  }
  return SplashStatus.home;
});

String genId([int length = 8]) {
  final Random random = Random.secure();
  return List.generate(length, (_) => Assets.charset[random.nextInt(Assets.charset.length)]).join();
}

class VRChatMobileSplash extends ConsumerWidget {
  final Widget child;
  final Widget login;
  const VRChatMobileSplash({
    Key? key,
    this.child = const VRChatMobileHome(),
    this.login = const VRChatMobileLogin(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(splashProviderNew);
    AccessibilityConfigNotifier accessibilityConfig = ref.watch(accessibilityConfigProvider);
    textStream(context: context, forceExternal: accessibilityConfig.forceExternalBrowser);

    return Scaffold(
      body: SafeArea(
        child: data.when(
          loading: () => const Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(strokeWidth: 8),
            ),
          ),
          error: (e, trace) {
            logger.w(getMessage(e), e, trace);
            return ScrollWidget(
              onRefresh: () => ref.refresh(splashProvider.future),
              child: ErrorPage(loggerReport: ref.read(loggerReportProvider)),
            );
          },
          data: (data) {
            switch (data) {
              case SplashStatus.home:
                () async {
                  if (!Platform.isAndroid && !Platform.isIOS) return;
                  if (!ref.read(isFirstProvider)) return;
                  String? initialText = await ReceiveSharingIntent.getInitialText();
                  if (initialText == null) return;
                  Widget? value = await urlParser(url: Uri.parse(initialText), forceExternal: accessibilityConfig.forceExternalBrowser);
                  if (value == null) return;
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => value));
                  ref.read(isFirstProvider.notifier).state = false;
                }();
                return child;
              case SplashStatus.login:
                return login;
              case SplashStatus.userPolicy:
                return const VRChatMobileWebViewUserPolicy();
            }
          },
        ),
      ),
    );
  }
}
