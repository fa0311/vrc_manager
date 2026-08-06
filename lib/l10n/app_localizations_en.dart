// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get contributor => 'DeepL(robot)';

  @override
  String get description => 'VRChat assistant app';

  @override
  String get descriptionDetailed =>
      'VRChat assistant app with intuitive UI built in Flutter';

  @override
  String get ok => 'OK';

  @override
  String get no => 'NO';

  @override
  String get cancel => 'Cancel';

  @override
  String get send => 'Send';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved';

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get delete => 'Delete';

  @override
  String get type => 'Type';

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
  String get error => 'An error occurred';

  @override
  String get parseError => 'Parse error';

  @override
  String get socketException => 'No Internet connection';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get reportMessage1 => 'Please report this to the developer.';

  @override
  String get reportMessage2 =>
      'Tapping Report will copy the log to the clipboard and access the report page.';

  @override
  String get tooManyRequests =>
      'Too many requests. Please wait a while and try again.';

  @override
  String get invalidLoginInfo => 'Invalid Username/Email or Password.';

  @override
  String dateFormat1(Object inDays, Object inHours) {
    return '$inDays days $inHours hours ago';
  }

  @override
  String dateFormat2(Object inHours, Object inMinutes) {
    return '$inHours hours $inMinutes minutes ago';
  }

  @override
  String dateFormat3(Object inMinutes) {
    return '$inMinutes minutes ago';
  }

  @override
  String dateFormat4(Object inSeconds) {
    return '$inSeconds seconds ago';
  }

  @override
  String get share => 'Share';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied to clipboard.';

  @override
  String get openInBrowser => 'Open in browser';

  @override
  String get openInExternalBrowser => 'Open in external browser';

  @override
  String get close => 'Close';

  @override
  String get setting => 'Setting';

  @override
  String get login => 'Login';

  @override
  String get username => 'Username';

  @override
  String get usernameOrEmail => 'Username / Email';

  @override
  String get password => 'Password';

  @override
  String get rememberPassword => 'Remember password';

  @override
  String get twoFactorAuthentication => 'Two Factor Authentication';

  @override
  String get authenticationCode => 'Authentication Code';

  @override
  String get unknown => 'Unknown';

  @override
  String get loginBrowser => 'Login using a browser';

  @override
  String get incorrectLogin => 'Incorrect login information';

  @override
  String get home => 'Home';

  @override
  String get onlineFriends => 'Online Friends';

  @override
  String get offlineFriends => 'Offline Friends';

  @override
  String get showOnlyAvailable => 'Show only available participants';

  @override
  String get worldDetails => 'World details';

  @override
  String get worldUnfavoriteButton => 'Unfavorite button';

  @override
  String get sort => 'Sort';

  @override
  String get descending => 'Descending order';

  @override
  String get sortedByDefault => 'Sort by Default';

  @override
  String get sortedByName => 'Sort by Name';

  @override
  String get sortedByLastLogin => 'Sort by Last Login';

  @override
  String get sortedByFriendsInInstance =>
      'Sort by Number of friends of the instance';

  @override
  String get sortedByUpdatedDate => 'Sort by Updated date';

  @override
  String get sortedByLabsPublicationDate => 'Sort by Labs publication date';

  @override
  String get sortedByHeat => 'Sort by heat';

  @override
  String get sortedByCapacity => 'Sort by capacity';

  @override
  String get sortedByOccupants => 'Sort by occupants';

  @override
  String get display => 'Display';

  @override
  String get normal => 'Default';

  @override
  String get simple => 'Simple';

  @override
  String get textOnly => 'Text only';

  @override
  String get search => 'Search';

  @override
  String get friendRequest => 'Friend Request ';

  @override
  String get friendManagement => 'Friend management';

  @override
  String get favoriteWorlds => 'Favorite Worlds';

  @override
  String get user => 'User';

  @override
  String lastLogin(Object data) {
    return 'Last login: $data';
  }

  @override
  String dateJoined(Object data) {
    return 'Date joined: $data';
  }

  @override
  String get openInJsonViewer => 'Open in json viewer';

  @override
  String get joinInstance => 'Invite me';

  @override
  String get addFavoriteWorlds => 'Add favorite worlds';

  @override
  String get removeFavoriteWorlds => 'Remove from Favorite Worlds';

  @override
  String get editBio => 'Edit bio';

  @override
  String get editNote => 'Edit note';

  @override
  String get sendInvite => 'Invitation sent.';

  @override
  String get selfInviteDetails =>
      'Please check the invitation field of the VRChat.';

  @override
  String get unfriend => 'Unfriend';

  @override
  String get unfriendConfirm => 'Do you want to unfriend me?';

  @override
  String get requestCancel => 'Unrequested';

  @override
  String get allowFriends => 'Friends allow';

  @override
  String get denyFriends => 'Friends deny';

  @override
  String get jsonViewer => 'JSON Viewer';

  @override
  String get world => 'World';

  @override
  String get privateWorld => 'Private World';

  @override
  String get loadingWorld => 'Loading World';

  @override
  String get onTheWebsite => 'On the website';

  @override
  String occupants(Object data) {
    return 'Number of users: $data';
  }

  @override
  String privateOccupants(Object data) {
    return 'Number of private users: $data';
  }

  @override
  String favorites(Object data) {
    return 'Favorites: $data';
  }

  @override
  String createdAt(Object data) {
    return 'Created at $data';
  }

  @override
  String updatedAt(Object data) {
    return 'Updated at $data';
  }

  @override
  String get launchWorld => 'Launch world';

  @override
  String get openInVrchat => 'Open in VRChat';

  @override
  String get accountSwitch => 'Account switching';

  @override
  String get accountSwitchSetting => 'Account switching settings';

  @override
  String get accountSwitchSettingDetails => 'Manage other accounts.';

  @override
  String get addAccount => 'Add account';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get language => 'Language';

  @override
  String translatorDetails(Object name) {
    return 'Translated by $name';
  }

  @override
  String get deviceLightTheme => 'If the device is light theme';

  @override
  String get deviceDarkTheme => 'If the device is dark theme';

  @override
  String get lightTheme => 'Light theme';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get blackTheme => 'Black theme';

  @override
  String get trueBlackTheme => 'True black theme';

  @override
  String get highContrastLightTheme => 'High contrast light theme';

  @override
  String get highContrastDarkTheme => 'High contrast dark theme';

  @override
  String get forceExternalBrowser => 'Force external browsers';

  @override
  String get forceExternalBrowserDetails =>
      'Force opening of an external browser when opening a browser';

  @override
  String get debugMode => 'Debug mode';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Logout';

  @override
  String get logoutDetails =>
      'Log out and remove session information from the device.';

  @override
  String get logoutConfirm => 'Would you like to log out?';

  @override
  String get deleteLoginInfo => 'Delete login information';

  @override
  String get deleteLoginInfoDetails => 'Delete stored login information.';

  @override
  String get deleteLoginInfoConfirm => 'Do you want to delete it?';

  @override
  String get token => 'Token';

  @override
  String get tokenDetails => 'View or change your credentials.';

  @override
  String get cookie => 'Cookie';

  @override
  String get permissions => 'Permissions';

  @override
  String get domainVerification => 'Associate apps with domains';

  @override
  String get domainVerificationDetails =>
      'Please associate this app with vrchat.com.';

  @override
  String get notSupported => 'Not supported';

  @override
  String get notSupportedDetails =>
      'This permission is not supported on this device.';

  @override
  String get help => 'Help';

  @override
  String get contribution => 'Contribution';

  @override
  String get contributionDetails => 'Contribute to development on Github.';

  @override
  String get reportDetails =>
      'Report bugs and request new features to the developer.';

  @override
  String get developerInfo => 'Developer Information';

  @override
  String get developerInfoDetails => 'View developer information.';

  @override
  String get rateTheApp => 'Rate the app';

  @override
  String get rateTheAppDetails => 'Please rate us on Google PlayStore!';

  @override
  String get version => 'Version';

  @override
  String versionDetails(Object version) {
    return 'Current Version: $version';
  }

  @override
  String get license => 'License';

  @override
  String get licenseDetails => 'Check License information';

  @override
  String get report => 'Report';

  @override
  String get log => 'Log';

  @override
  String get viewDetailedLogs => 'View detailed logs';

  @override
  String get userPolicy => 'User Policy';

  @override
  String get agree => 'Agree';

  @override
  String get disagree => 'Disagree';

  @override
  String get lookAtYourBrowser => 'Please check your browser';
}
