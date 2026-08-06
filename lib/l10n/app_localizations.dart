import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('zh'),
  ];

  /// No description provided for @contributor.
  ///
  /// In en, this message translates to:
  /// **'DeepL(robot)'**
  String get contributor;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'VRChat assistant app'**
  String get description;

  /// No description provided for @descriptionDetailed.
  ///
  /// In en, this message translates to:
  /// **'VRChat assistant app with intuitive UI built in Flutter'**
  String get descriptionDetailed;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get no;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @vrchatPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get vrchatPublic;

  /// No description provided for @vrchatFriendsPlus.
  ///
  /// In en, this message translates to:
  /// **'Friends+'**
  String get vrchatFriendsPlus;

  /// No description provided for @vrchatFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get vrchatFriends;

  /// No description provided for @vrchatInvitePlus.
  ///
  /// In en, this message translates to:
  /// **'Invite+'**
  String get vrchatInvitePlus;

  /// No description provided for @vrchatInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get vrchatInvite;

  /// No description provided for @vrchatGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get vrchatGroup;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @parseError.
  ///
  /// In en, this message translates to:
  /// **'Parse error'**
  String get parseError;

  /// No description provided for @socketException.
  ///
  /// In en, this message translates to:
  /// **'No Internet connection'**
  String get socketException;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// No description provided for @reportMessage1.
  ///
  /// In en, this message translates to:
  /// **'Please report this to the developer.'**
  String get reportMessage1;

  /// No description provided for @reportMessage2.
  ///
  /// In en, this message translates to:
  /// **'Tapping Report will copy the log to the clipboard and access the report page.'**
  String get reportMessage2;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a while and try again.'**
  String get tooManyRequests;

  /// No description provided for @invalidLoginInfo.
  ///
  /// In en, this message translates to:
  /// **'Invalid Username/Email or Password.'**
  String get invalidLoginInfo;

  /// No description provided for @dateFormat1.
  ///
  /// In en, this message translates to:
  /// **'{inDays} days {inHours} hours ago'**
  String dateFormat1(Object inDays, Object inHours);

  /// No description provided for @dateFormat2.
  ///
  /// In en, this message translates to:
  /// **'{inHours} hours {inMinutes} minutes ago'**
  String dateFormat2(Object inHours, Object inMinutes);

  /// No description provided for @dateFormat3.
  ///
  /// In en, this message translates to:
  /// **'{inMinutes} minutes ago'**
  String dateFormat3(Object inMinutes);

  /// No description provided for @dateFormat4.
  ///
  /// In en, this message translates to:
  /// **'{inSeconds} seconds ago'**
  String dateFormat4(Object inSeconds);

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard.'**
  String get copied;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in browser'**
  String get openInBrowser;

  /// No description provided for @openInExternalBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in external browser'**
  String get openInExternalBrowser;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username / Email'**
  String get usernameOrEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember password'**
  String get rememberPassword;

  /// No description provided for @twoFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Two Factor Authentication'**
  String get twoFactorAuthentication;

  /// No description provided for @authenticationCode.
  ///
  /// In en, this message translates to:
  /// **'Authentication Code'**
  String get authenticationCode;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @loginBrowser.
  ///
  /// In en, this message translates to:
  /// **'Login using a browser'**
  String get loginBrowser;

  /// No description provided for @incorrectLogin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect login information'**
  String get incorrectLogin;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @onlineFriends.
  ///
  /// In en, this message translates to:
  /// **'Online Friends'**
  String get onlineFriends;

  /// No description provided for @offlineFriends.
  ///
  /// In en, this message translates to:
  /// **'Offline Friends'**
  String get offlineFriends;

  /// No description provided for @showOnlyAvailable.
  ///
  /// In en, this message translates to:
  /// **'Show only available participants'**
  String get showOnlyAvailable;

  /// No description provided for @worldDetails.
  ///
  /// In en, this message translates to:
  /// **'World details'**
  String get worldDetails;

  /// No description provided for @worldUnfavoriteButton.
  ///
  /// In en, this message translates to:
  /// **'Unfavorite button'**
  String get worldUnfavoriteButton;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending order'**
  String get descending;

  /// No description provided for @sortedByDefault.
  ///
  /// In en, this message translates to:
  /// **'Sort by Default'**
  String get sortedByDefault;

  /// No description provided for @sortedByName.
  ///
  /// In en, this message translates to:
  /// **'Sort by Name'**
  String get sortedByName;

  /// No description provided for @sortedByLastLogin.
  ///
  /// In en, this message translates to:
  /// **'Sort by Last Login'**
  String get sortedByLastLogin;

  /// No description provided for @sortedByFriendsInInstance.
  ///
  /// In en, this message translates to:
  /// **'Sort by Number of friends of the instance'**
  String get sortedByFriendsInInstance;

  /// No description provided for @sortedByUpdatedDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Updated date'**
  String get sortedByUpdatedDate;

  /// No description provided for @sortedByLabsPublicationDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Labs publication date'**
  String get sortedByLabsPublicationDate;

  /// No description provided for @sortedByHeat.
  ///
  /// In en, this message translates to:
  /// **'Sort by heat'**
  String get sortedByHeat;

  /// No description provided for @sortedByCapacity.
  ///
  /// In en, this message translates to:
  /// **'Sort by capacity'**
  String get sortedByCapacity;

  /// No description provided for @sortedByOccupants.
  ///
  /// In en, this message translates to:
  /// **'Sort by occupants'**
  String get sortedByOccupants;

  /// No description provided for @display.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get display;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get normal;

  /// No description provided for @simple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get simple;

  /// No description provided for @textOnly.
  ///
  /// In en, this message translates to:
  /// **'Text only'**
  String get textOnly;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @friendRequest.
  ///
  /// In en, this message translates to:
  /// **'Friend Request '**
  String get friendRequest;

  /// No description provided for @friendManagement.
  ///
  /// In en, this message translates to:
  /// **'Friend management'**
  String get friendManagement;

  /// No description provided for @favoriteWorlds.
  ///
  /// In en, this message translates to:
  /// **'Favorite Worlds'**
  String get favoriteWorlds;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @lastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last login: {data}'**
  String lastLogin(Object data);

  /// No description provided for @dateJoined.
  ///
  /// In en, this message translates to:
  /// **'Date joined: {data}'**
  String dateJoined(Object data);

  /// No description provided for @openInJsonViewer.
  ///
  /// In en, this message translates to:
  /// **'Open in json viewer'**
  String get openInJsonViewer;

  /// No description provided for @joinInstance.
  ///
  /// In en, this message translates to:
  /// **'Invite me'**
  String get joinInstance;

  /// No description provided for @addFavoriteWorlds.
  ///
  /// In en, this message translates to:
  /// **'Add favorite worlds'**
  String get addFavoriteWorlds;

  /// No description provided for @removeFavoriteWorlds.
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorite Worlds'**
  String get removeFavoriteWorlds;

  /// No description provided for @editBio.
  ///
  /// In en, this message translates to:
  /// **'Edit bio'**
  String get editBio;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// No description provided for @sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Invitation sent.'**
  String get sendInvite;

  /// No description provided for @selfInviteDetails.
  ///
  /// In en, this message translates to:
  /// **'Please check the invitation field of the VRChat.'**
  String get selfInviteDetails;

  /// No description provided for @unfriend.
  ///
  /// In en, this message translates to:
  /// **'Unfriend'**
  String get unfriend;

  /// No description provided for @unfriendConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to unfriend me?'**
  String get unfriendConfirm;

  /// No description provided for @requestCancel.
  ///
  /// In en, this message translates to:
  /// **'Unrequested'**
  String get requestCancel;

  /// No description provided for @allowFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends allow'**
  String get allowFriends;

  /// No description provided for @denyFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends deny'**
  String get denyFriends;

  /// No description provided for @jsonViewer.
  ///
  /// In en, this message translates to:
  /// **'JSON Viewer'**
  String get jsonViewer;

  /// No description provided for @world.
  ///
  /// In en, this message translates to:
  /// **'World'**
  String get world;

  /// No description provided for @privateWorld.
  ///
  /// In en, this message translates to:
  /// **'Private World'**
  String get privateWorld;

  /// No description provided for @loadingWorld.
  ///
  /// In en, this message translates to:
  /// **'Loading World'**
  String get loadingWorld;

  /// No description provided for @onTheWebsite.
  ///
  /// In en, this message translates to:
  /// **'On the website'**
  String get onTheWebsite;

  /// No description provided for @occupants.
  ///
  /// In en, this message translates to:
  /// **'Number of users: {data}'**
  String occupants(Object data);

  /// No description provided for @privateOccupants.
  ///
  /// In en, this message translates to:
  /// **'Number of private users: {data}'**
  String privateOccupants(Object data);

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites: {data}'**
  String favorites(Object data);

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created at {data}'**
  String createdAt(Object data);

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at {data}'**
  String updatedAt(Object data);

  /// No description provided for @launchWorld.
  ///
  /// In en, this message translates to:
  /// **'Launch world'**
  String get launchWorld;

  /// No description provided for @openInVrchat.
  ///
  /// In en, this message translates to:
  /// **'Open in VRChat'**
  String get openInVrchat;

  /// No description provided for @accountSwitch.
  ///
  /// In en, this message translates to:
  /// **'Account switching'**
  String get accountSwitch;

  /// No description provided for @accountSwitchSetting.
  ///
  /// In en, this message translates to:
  /// **'Account switching settings'**
  String get accountSwitchSetting;

  /// No description provided for @accountSwitchSettingDetails.
  ///
  /// In en, this message translates to:
  /// **'Manage other accounts.'**
  String get accountSwitchSettingDetails;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get addAccount;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @translatorDetails.
  ///
  /// In en, this message translates to:
  /// **'Translated by {name}'**
  String translatorDetails(Object name);

  /// No description provided for @deviceLightTheme.
  ///
  /// In en, this message translates to:
  /// **'If the device is light theme'**
  String get deviceLightTheme;

  /// No description provided for @deviceDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'If the device is dark theme'**
  String get deviceDarkTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light theme'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark theme'**
  String get darkTheme;

  /// No description provided for @blackTheme.
  ///
  /// In en, this message translates to:
  /// **'Black theme'**
  String get blackTheme;

  /// No description provided for @trueBlackTheme.
  ///
  /// In en, this message translates to:
  /// **'True black theme'**
  String get trueBlackTheme;

  /// No description provided for @highContrastLightTheme.
  ///
  /// In en, this message translates to:
  /// **'High contrast light theme'**
  String get highContrastLightTheme;

  /// No description provided for @highContrastDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'High contrast dark theme'**
  String get highContrastDarkTheme;

  /// No description provided for @forceExternalBrowser.
  ///
  /// In en, this message translates to:
  /// **'Force external browsers'**
  String get forceExternalBrowser;

  /// No description provided for @forceExternalBrowserDetails.
  ///
  /// In en, this message translates to:
  /// **'Force opening of an external browser when opening a browser'**
  String get forceExternalBrowserDetails;

  /// No description provided for @debugMode.
  ///
  /// In en, this message translates to:
  /// **'Debug mode'**
  String get debugMode;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutDetails.
  ///
  /// In en, this message translates to:
  /// **'Log out and remove session information from the device.'**
  String get logoutDetails;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Would you like to log out?'**
  String get logoutConfirm;

  /// No description provided for @deleteLoginInfo.
  ///
  /// In en, this message translates to:
  /// **'Delete login information'**
  String get deleteLoginInfo;

  /// No description provided for @deleteLoginInfoDetails.
  ///
  /// In en, this message translates to:
  /// **'Delete stored login information.'**
  String get deleteLoginInfoDetails;

  /// No description provided for @deleteLoginInfoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete it?'**
  String get deleteLoginInfoConfirm;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// No description provided for @tokenDetails.
  ///
  /// In en, this message translates to:
  /// **'View or change your credentials.'**
  String get tokenDetails;

  /// No description provided for @cookie.
  ///
  /// In en, this message translates to:
  /// **'Cookie'**
  String get cookie;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @domainVerification.
  ///
  /// In en, this message translates to:
  /// **'Associate apps with domains'**
  String get domainVerification;

  /// No description provided for @domainVerificationDetails.
  ///
  /// In en, this message translates to:
  /// **'Please associate this app with vrchat.com.'**
  String get domainVerificationDetails;

  /// No description provided for @notSupported.
  ///
  /// In en, this message translates to:
  /// **'Not supported'**
  String get notSupported;

  /// No description provided for @notSupportedDetails.
  ///
  /// In en, this message translates to:
  /// **'This permission is not supported on this device.'**
  String get notSupportedDetails;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @contribution.
  ///
  /// In en, this message translates to:
  /// **'Contribution'**
  String get contribution;

  /// No description provided for @contributionDetails.
  ///
  /// In en, this message translates to:
  /// **'Contribute to development on Github.'**
  String get contributionDetails;

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'Report bugs and request new features to the developer.'**
  String get reportDetails;

  /// No description provided for @developerInfo.
  ///
  /// In en, this message translates to:
  /// **'Developer Information'**
  String get developerInfo;

  /// No description provided for @developerInfoDetails.
  ///
  /// In en, this message translates to:
  /// **'View developer information.'**
  String get developerInfoDetails;

  /// No description provided for @rateTheApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get rateTheApp;

  /// No description provided for @rateTheAppDetails.
  ///
  /// In en, this message translates to:
  /// **'Please rate us on Google PlayStore!'**
  String get rateTheAppDetails;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @versionDetails.
  ///
  /// In en, this message translates to:
  /// **'Current Version: {version}'**
  String versionDetails(Object version);

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @licenseDetails.
  ///
  /// In en, this message translates to:
  /// **'Check License information'**
  String get licenseDetails;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @log.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get log;

  /// No description provided for @viewDetailedLogs.
  ///
  /// In en, this message translates to:
  /// **'View detailed logs'**
  String get viewDetailedLogs;

  /// No description provided for @userPolicy.
  ///
  /// In en, this message translates to:
  /// **'User Policy'**
  String get userPolicy;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @disagree.
  ///
  /// In en, this message translates to:
  /// **'Disagree'**
  String get disagree;

  /// No description provided for @lookAtYourBrowser.
  ///
  /// In en, this message translates to:
  /// **'Please check your browser'**
  String get lookAtYourBrowser;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'ja',
    'pt',
    'ru',
    'th',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
