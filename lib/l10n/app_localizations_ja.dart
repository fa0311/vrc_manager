// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get contributor => 'fa0311';

  @override
  String get description => 'VRChatのアシスタントアプリ';

  @override
  String get descriptionDetailed => 'Flutterで構築された直感的なUIが特徴のVRChatアシスタントアプリ';

  @override
  String get ok => 'OK';

  @override
  String get no => 'NO';

  @override
  String get cancel => 'キャンセル';

  @override
  String get send => '送信';

  @override
  String get save => '保存';

  @override
  String get saved => '保存しました';

  @override
  String get success => '成功しました';

  @override
  String get failed => '失敗しました';

  @override
  String get delete => '削除';

  @override
  String get type => '種類';

  @override
  String get vrchatPublic => 'Public';

  @override
  String get vrchatFriendsPlus => 'Friends+';

  @override
  String get vrchatFriends => 'Friends';

  @override
  String get vrchatInvitePlus => 'Invite+';

  @override
  String get vrchatInvite => 'Invite';

  @override
  String get vrchatGroup => 'Group';

  @override
  String get error => 'エラーが発生しました';

  @override
  String get parseError => '構文解析エラー';

  @override
  String get socketException => 'インターネットに接続できませんでした';

  @override
  String get unknownError => '不明なエラー';

  @override
  String get reportMessage1 => '開発者に報告してください';

  @override
  String get reportMessage2 => '報告をタップするとログがクリップボードにコピーされ報告ページにアクセスします';

  @override
  String get tooManyRequests => 'リクエストが多すぎます しばらく待ってから再試行してください';

  @override
  String get invalidLoginInfo => 'ユーザー名/メールアドレスまたはパスワードが無効です';

  @override
  String dateFormat1(Object inDays, Object inHours) {
    return '$inDays日$inHours時間前';
  }

  @override
  String dateFormat2(Object inHours, Object inMinutes) {
    return '$inHours時間$inMinutes分前';
  }

  @override
  String dateFormat3(Object inMinutes) {
    return '$inMinutes分前';
  }

  @override
  String dateFormat4(Object inSeconds) {
    return '$inSeconds秒前';
  }

  @override
  String get share => '共有';

  @override
  String get copy => 'コピー';

  @override
  String get copied => 'クリップボードにコピーしました';

  @override
  String get openInBrowser => 'ブラウザで開く';

  @override
  String get openInExternalBrowser => '外部のブラウザで開く';

  @override
  String get close => '閉じる';

  @override
  String get setting => '設定';

  @override
  String get login => 'ログイン';

  @override
  String get username => 'ユーザー名';

  @override
  String get usernameOrEmail => 'ユーザー名 / メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get rememberPassword => 'パスワードを保存する';

  @override
  String get twoFactorAuthentication => '2段階認証';

  @override
  String get authenticationCode => '認証コード';

  @override
  String get unknown => '名無し';

  @override
  String get loginBrowser => 'ブラウザでログイン';

  @override
  String get incorrectLogin => 'ログイン情報が間違っています';

  @override
  String get home => 'ホーム';

  @override
  String get onlineFriends => 'オンラインのフレンド';

  @override
  String get offlineFriends => 'オフラインのフレンド';

  @override
  String get showOnlyAvailable => '参加可能のみ表示';

  @override
  String get worldDetails => 'ワールドの詳細';

  @override
  String get worldUnfavoriteButton => 'お気に入り解除ボタン';

  @override
  String get sort => '並び替え';

  @override
  String get descending => '降順';

  @override
  String get sortedByDefault => 'デフォルト順';

  @override
  String get sortedByName => '名前順';

  @override
  String get sortedByLastLogin => '最終ログイン順';

  @override
  String get sortedByFriendsInInstance => 'インスタンス内のフレンド数順';

  @override
  String get sortedByUpdatedDate => 'アップデート順';

  @override
  String get sortedByLabsPublicationDate => 'ラボの公開順';

  @override
  String get sortedByHeat => 'ホットなワールド順';

  @override
  String get sortedByCapacity => '最大参加人数順';

  @override
  String get sortedByOccupants => '現在の参加人数順';

  @override
  String get display => '表示';

  @override
  String get normal => 'デフォルト';

  @override
  String get simple => 'シンプル';

  @override
  String get textOnly => '文字のみ';

  @override
  String get search => '検索';

  @override
  String get friendRequest => 'フレンドリクエスト';

  @override
  String get friendManagement => 'フレンド管理';

  @override
  String get favoriteWorlds => 'お気に入りのワールド';

  @override
  String get user => 'ユーザー';

  @override
  String lastLogin(Object data) {
    return '最終ログイン: $data';
  }

  @override
  String dateJoined(Object data) {
    return '登録日: $data';
  }

  @override
  String get openInJsonViewer => 'JSONビューワーで表示';

  @override
  String get joinInstance => '自分を招待';

  @override
  String get addFavoriteWorlds => 'お気に入りのワールドに追加';

  @override
  String get removeFavoriteWorlds => 'お気に入りのワールドから削除';

  @override
  String get editBio => 'Bioを編集';

  @override
  String get editNote => 'ノートを編集';

  @override
  String get sendInvite => '招待を送信しました';

  @override
  String get selfInviteDetails => 'VRChatの招待欄を確認してください';

  @override
  String get unfriend => 'フレンド解除';

  @override
  String get unfriendConfirm => 'フレンドを解除しますか？';

  @override
  String get requestCancel => 'リクエスト解除';

  @override
  String get allowFriends => 'フレンド許可';

  @override
  String get denyFriends => 'フレンド拒否';

  @override
  String get jsonViewer => 'JSONビューワー';

  @override
  String get world => 'ワールド';

  @override
  String get privateWorld => 'プライベートワールド';

  @override
  String get loadingWorld => 'ワールドをロード中';

  @override
  String get onTheWebsite => 'Webサイト上でオンライン';

  @override
  String occupants(Object data) {
    return 'プレイヤー数: $data';
  }

  @override
  String privateOccupants(Object data) {
    return 'プライベートのプレイヤー数: $data';
  }

  @override
  String favorites(Object data) {
    return 'お気に入り: $data';
  }

  @override
  String createdAt(Object data) {
    return '作成: $data';
  }

  @override
  String updatedAt(Object data) {
    return '最終更新: $data';
  }

  @override
  String get launchWorld => 'インスタンス作成';

  @override
  String get openInVrchat => 'VRChatで開く';

  @override
  String get accountSwitch => 'アカウント切り替え';

  @override
  String get accountSwitchSetting => 'アカウント切り替えの設定';

  @override
  String get accountSwitchSettingDetails => '他のアカウントを管理します';

  @override
  String get addAccount => 'アカウントを追加';

  @override
  String get accessibility => 'アクセシビリティ';

  @override
  String get language => '言語';

  @override
  String translatorDetails(Object name) {
    return '$nameによる翻訳';
  }

  @override
  String get deviceLightTheme => '端末がライトテーマの時';

  @override
  String get deviceDarkTheme => '端末がダークテーマの時';

  @override
  String get lightTheme => 'ライトテーマ';

  @override
  String get darkTheme => 'ダークテーマ';

  @override
  String get blackTheme => 'ブラックテーマ';

  @override
  String get trueBlackTheme => '真っ黒テーマ';

  @override
  String get highContrastLightTheme => 'ハイコントラストライトテーマ';

  @override
  String get highContrastDarkTheme => 'ハイコントラストダークテーマ';

  @override
  String get forceExternalBrowser => '外部のブラウザを強制する';

  @override
  String get forceExternalBrowserDetails => 'ブラウザを開く際に外部のブラウザを強制的に開きます';

  @override
  String get debugMode => 'デバッグモード';

  @override
  String get account => 'アカウント';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutDetails => 'ログアウトし端末からセッション情報を削除します';

  @override
  String get logoutConfirm => 'ログアウトしますか？';

  @override
  String get deleteLoginInfo => 'ログイン情報を削除';

  @override
  String get deleteLoginInfoDetails => '記憶しているログイン情報を削除します';

  @override
  String get deleteLoginInfoConfirm => '削除しますか？';

  @override
  String get token => 'Token';

  @override
  String get tokenDetails => '認証情報を確認または変更できます';

  @override
  String get cookie => 'Cookie';

  @override
  String get permissions => '権限';

  @override
  String get domainVerification => 'アプリとドメインの関連付け';

  @override
  String get domainVerificationDetails => 'vrchat.comとアプリを関連付けて下さい';

  @override
  String get notSupported => 'サポートされていません';

  @override
  String get notSupportedDetails => 'このデバイスではこの権限がサポートされていません';

  @override
  String get help => 'ヘルプ';

  @override
  String get contribution => '貢献';

  @override
  String get contributionDetails => 'Githubでの開発に貢献する';

  @override
  String get reportDetails => '開発者にバグの報告や新機能のリクエストをします';

  @override
  String get developerInfo => '開発者情報';

  @override
  String get developerInfoDetails => '開発者の情報を表示';

  @override
  String get rateTheApp => '評価';

  @override
  String get rateTheAppDetails => 'GooglePlayStoreでの評価をお願いします';

  @override
  String get version => 'バージョン';

  @override
  String versionDetails(Object version) {
    return '現在のバージョン: $version';
  }

  @override
  String get license => 'License';

  @override
  String get licenseDetails => 'License情報を確認します';

  @override
  String get report => '報告';

  @override
  String get log => 'ログ';

  @override
  String get viewDetailedLogs => '詳細なログを表示';

  @override
  String get userPolicy => 'ユーザーポリシー';

  @override
  String get agree => '同意';

  @override
  String get disagree => '同意しない';

  @override
  String get lookAtYourBrowser => 'ブラウザを確認してください';
}
