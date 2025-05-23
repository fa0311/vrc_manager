// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get contributor => 'DeepL(robot)';

  @override
  String get description => 'VRChat assistant app';

  @override
  String get descriptionDetailed =>
      'VRChat assistant app with intuitive UI built in Flutter';

  @override
  String get ok => '认可';

  @override
  String get no => '没有';

  @override
  String get cancel => '取消';

  @override
  String get send => '发送';

  @override
  String get save => '拯救';

  @override
  String get saved => '被拯救的';

  @override
  String get success => '成功了';

  @override
  String get failed => '失败';

  @override
  String get delete => '删除';

  @override
  String get type => '类型';

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
  String get error => '发生错误';

  @override
  String get parseError => '解析错误';

  @override
  String get socketException => '无法连接到互联网';

  @override
  String get unknownError => '未知错误';

  @override
  String get reportMessage1 => '请向开发商报告';

  @override
  String get reportMessage2 => '点击报告，将日志复制到剪贴板，并进入报告页面';

  @override
  String get tooManyRequests => '请求过多 请稍等片刻再试';

  @override
  String get invalidLoginInfo => '无效的用户名/电子邮件地址或密码';

  @override
  String dateFormat1(Object inDays, Object inHours) {
    return '$inDays天 $inHours小时前';
  }

  @override
  String dateFormat2(Object inHours, Object inMinutes) {
    return '$inHours小时 $inMinutes分钟前';
  }

  @override
  String dateFormat3(Object inMinutes) {
    return '$inMinutes分钟前';
  }

  @override
  String dateFormat4(Object inSeconds) {
    return '$inSeconds秒前';
  }

  @override
  String get share => '分享';

  @override
  String get copy => '拷贝';

  @override
  String get copied => '复制到剪贴板';

  @override
  String get openInBrowser => '在浏览器中打开';

  @override
  String get openInExternalBrowser => '在外部浏览器中打开';

  @override
  String get close => '关闭';

  @override
  String get setting => '设置';

  @override
  String get login => '登录';

  @override
  String get username => '用户名称';

  @override
  String get usernameOrEmail => '用户名/电子邮件地址';

  @override
  String get password => '密码';

  @override
  String get rememberPassword => '保存密码';

  @override
  String get twoFactorAuthentication => '2步式验证';

  @override
  String get authenticationCode => '认证码';

  @override
  String get unknown => '没有名字';

  @override
  String get loginBrowser => '使用浏览器登录';

  @override
  String get incorrectLogin => '您的登录信息不正确';

  @override
  String get home => '首页';

  @override
  String get onlineFriends => '在线朋友';

  @override
  String get offlineFriends => '离线朋友';

  @override
  String get showOnlyAvailable => '仅供展示';

  @override
  String get worldDetails => '世界的细节';

  @override
  String get worldUnfavoriteButton => '不喜欢的按钮';

  @override
  String get sort => '排序方式';

  @override
  String get descending => '降序排列';

  @override
  String get sortedByDefault => '默认订单';

  @override
  String get sortedByName => '按名称排序';

  @override
  String get sortedByLastLogin => '按最后一次登录的顺序';

  @override
  String get sortedByFriendsInInstance => '按实例中的朋友数量排序';

  @override
  String get sortedByUpdatedDate => '按更新日期排序';

  @override
  String get sortedByLabsPublicationDate => '按实验室出版日期排序';

  @override
  String get sortedByHeat => '按热量排序';

  @override
  String get sortedByCapacity => '按容量排序';

  @override
  String get sortedByOccupants => '按居住者排序';

  @override
  String get display => '显示';

  @override
  String get normal => '默认情况下';

  @override
  String get simple => '简单';

  @override
  String get textOnly => '仅限文本';

  @override
  String get search => '搜索';

  @override
  String get friendRequest => '朋友请求';

  @override
  String get friendManagement => '朋友管理';

  @override
  String get favoriteWorlds => '最喜欢的世界';

  @override
  String get user => '用户';

  @override
  String lastLogin(Object data) {
    return '最后一次登录: $data';
  }

  @override
  String dateJoined(Object data) {
    return '注册日期: $data';
  }

  @override
  String get openInJsonViewer => '在JSON查看器中显示';

  @override
  String get joinInstance => '邀请自己';

  @override
  String get addFavoriteWorlds => '添加喜爱的世界';

  @override
  String get removeFavoriteWorlds => '从喜爱的世界中删除';

  @override
  String get editBio => '编辑生物';

  @override
  String get editNote => '编辑注';

  @override
  String get sendInvite => '邀请函已发出';

  @override
  String get selfInviteDetails => '检查你的VRChat邀请栏';

  @override
  String get unfriend => '解除友谊';

  @override
  String get unfriendConfirm => '你想取消我的好友吗？';

  @override
  String get requestCancel => '解除友谊请求';

  @override
  String get allowFriends => '接受朋友';

  @override
  String get denyFriends => '拒绝朋友';

  @override
  String get jsonViewer => 'JSON查看器';

  @override
  String get world => '世界';

  @override
  String get privateWorld => '私人世界';

  @override
  String get loadingWorld => '载入世界';

  @override
  String get onTheWebsite => '在网站上在线';

  @override
  String occupants(Object data) {
    return '玩家数量: $data';
  }

  @override
  String privateOccupants(Object data) {
    return '私人玩家的数量: $data';
  }

  @override
  String favorites(Object data) {
    return '最爱: $data';
  }

  @override
  String createdAt(Object data) {
    return '创建: $data';
  }

  @override
  String updatedAt(Object data) {
    return '最后更新: $data';
  }

  @override
  String get launchWorld => '实例创建';

  @override
  String get openInVrchat => '在VRChat中打开';

  @override
  String get accountSwitch => '账户转换';

  @override
  String get accountSwitchSetting => '账户切换设置';

  @override
  String get accountSwitchSettingDetails => '管理其他账户';

  @override
  String get addAccount => '添加账户';

  @override
  String get accessibility => '无障碍设施';

  @override
  String get language => '语言';

  @override
  String translatorDetails(Object name) {
    return '译者: $name';
  }

  @override
  String get deviceLightTheme => '如果设备是轻型主题';

  @override
  String get deviceDarkTheme => '如果设备是深色主题';

  @override
  String get lightTheme => '灯光主题';

  @override
  String get darkTheme => '深色主题';

  @override
  String get blackTheme => '黑色主题';

  @override
  String get trueBlackTheme => '真正的黑色主题';

  @override
  String get highContrastLightTheme => '高对比度的灯光主题';

  @override
  String get highContrastDarkTheme => '高对比度的黑暗主题';

  @override
  String get forceExternalBrowser => '强制使用外部浏览器';

  @override
  String get forceExternalBrowserDetails => '打开浏览器时，强制打开一个外部浏览器';

  @override
  String get debugMode => '调试模式';

  @override
  String get account => '帐户';

  @override
  String get logout => '登出';

  @override
  String get logoutDetails => '注销并删除终端上的会话信息';

  @override
  String get logoutConfirm => '你想登出吗？';

  @override
  String get deleteLoginInfo => '删除登录信息';

  @override
  String get deleteLoginInfoDetails => '删除存储的登录信息';

  @override
  String get deleteLoginInfoConfirm => '你想删除吗？';

  @override
  String get token => '代币';

  @override
  String get tokenDetails => '查看或更改您的证书';

  @override
  String get cookie => '饼干';

  @override
  String get permissions => '许可权';

  @override
  String get domainVerification => '将应用程序与域名相关联';

  @override
  String get domainVerificationDetails => '将你的应用程序与 vrchat.com 联系起来';

  @override
  String get notSupported => '不支持';

  @override
  String get notSupportedDetails => '此设备不支持此权限';

  @override
  String get help => '帮助';

  @override
  String get contribution => '贡献';

  @override
  String get contributionDetails => '为Github上的开发做出贡献';

  @override
  String get reportDetails => '报告错误并要求开发人员提供新功能';

  @override
  String get developerInfo => '开发商信息';

  @override
  String get developerInfoDetails => '查看关于开发商的信息';

  @override
  String get rateTheApp => '评级';

  @override
  String get rateTheAppDetails => '请在Google PlayStore为我们评分';

  @override
  String get version => '版本';

  @override
  String versionDetails(Object version) {
    return '当前版本: $version';
  }

  @override
  String get license => '许可证';

  @override
  String get licenseDetails => '检查许可证信息';

  @override
  String get report => '报告';

  @override
  String get log => '纪录';

  @override
  String get viewDetailedLogs => '查看详细日志';

  @override
  String get userPolicy => '用户政策';

  @override
  String get agree => '同意';

  @override
  String get disagree => '不同意';

  @override
  String get lookAtYourBrowser => '请检查您的浏览器';
}
