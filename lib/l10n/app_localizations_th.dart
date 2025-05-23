// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get contributor => 'GoogleTranslate(robot)';

  @override
  String get description => 'VRChat assistant app';

  @override
  String get descriptionDetailed =>
      'VRChat assistant app with intuitive UI built in Flutter';

  @override
  String get ok => 'ok';

  @override
  String get no => 'no';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get send => 'ส่ง';

  @override
  String get save => 'บันทึก';

  @override
  String get saved => 'บันทึกไว้';

  @override
  String get success => 'ความสำเร็จ';

  @override
  String get failed => 'ล้มเหลว';

  @override
  String get delete => 'ลบ';

  @override
  String get type => 'พิมพ์';

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
  String get error => 'ข้อผิดพลาด';

  @override
  String get parseError => 'ข้อผิดพลาดในการแยกวิเคราะห์';

  @override
  String get socketException => 'ไม่มีการเชื่อมต่ออินเทอร์เน็ต';

  @override
  String get unknownError => 'ข้อผิดพลาดที่ไม่ทราบ สาเหตุ';

  @override
  String get reportMessage1 => 'โปรดรายงานไปยังนักพัฒนาซอฟต์แวร์';

  @override
  String get reportMessage2 =>
      'รายงานการแตะจะคัดลอกบันทึกไปยังคลิปบอร์ดและเข้าถึงหน้ารายงาน';

  @override
  String get tooManyRequests => 'คำขอมากเกินไป โปรดรอและลองอีกครั้ง';

  @override
  String get invalidLoginInfo => 'ชื่อผู้ใช้/อีเมล หรือรหัสผ่านไม่ถูกต้อง';

  @override
  String dateFormat1(Object inDays, Object inHours) {
    return '$inDays วัน $inHours ชั่วโมงที่แล้ว';
  }

  @override
  String dateFormat2(Object inHours, Object inMinutes) {
    return '$inHours ชั่วโมง $inMinutes นาทีที่แล้ว';
  }

  @override
  String dateFormat3(Object inMinutes) {
    return '$inMinutes นาทีที่แล้ว';
  }

  @override
  String dateFormat4(Object inSeconds) {
    return '$inSeconds วินาทีที่แล้ว';
  }

  @override
  String get share => 'แบ่งปัน';

  @override
  String get copy => 'สำเนา';

  @override
  String get copied => 'คัดลอกไปยังคลิปบอร์ด เปิดในเบราว์เซอร์';

  @override
  String get openInBrowser => 'เปิดใน';

  @override
  String get openInExternalBrowser => 'เบราว์เซอร์ภายนอก';

  @override
  String get close => 'ปิด';

  @override
  String get setting => 'การตั้งค่า';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get username => 'ชื่อผู้ใช้';

  @override
  String get usernameOrEmail => 'ชื่อผู้ใช้ / ที่อยู่อีเมล';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get rememberPassword => 'บันทึกรหัสผ่าน';

  @override
  String get twoFactorAuthentication => 'การยืนยันแบบสองขั้นตอน รหัส';

  @override
  String get authenticationCode => 'ยืนยัน';

  @override
  String get unknown => 'ไม่ระบุชื่อ ฉันเข้าสู่ระบบ';

  @override
  String get loginBrowser => 'เข้าสู่ระบบโดยใช้เบราว์เซอร์';

  @override
  String get incorrectLogin => 'ข้อมูลการเข้าสู่ระบบ ผิด';

  @override
  String get home => 'หน้าแรก';

  @override
  String get onlineFriends => 'ออนไลน์ เพื่อน';

  @override
  String get offlineFriends => 'ออฟไลน์ เพื่อน';

  @override
  String get showOnlyAvailable => 'แสดงเฉพาะ';

  @override
  String get worldDetails => 'โลกที่เข้าร่วมได้ รายละเอียด';

  @override
  String get worldUnfavoriteButton => 'ปุ่มเลิกชอบ';

  @override
  String get sort => 'เรียงลำดับ จากมาก';

  @override
  String get descending => 'ไปหาน้อย';

  @override
  String get sortedByDefault => 'ตามค่าเริ่มต้น เรียงลำดับตาม';

  @override
  String get sortedByName => 'ชื่อ โดยการ';

  @override
  String get sortedByLastLogin => 'เข้าสู่ระบบครั้งล่าสุด เรียงลำดับ ตาม';

  @override
  String get sortedByFriendsInInstance => 'จำนวนเพื่อนในอินสแตนซ์';

  @override
  String get sortedByUpdatedDate => 'เรียงตามวันที่อัพเดท';

  @override
  String get sortedByLabsPublicationDate => 'เรียงตามวันที่ตีพิมพ์ของ Labs';

  @override
  String get sortedByHeat => 'เรียงตามความร้อน';

  @override
  String get sortedByCapacity => 'จัดเรียงตามความจุ';

  @override
  String get sortedByOccupants => 'จัดเรียงตามผู้อยู่อาศัย';

  @override
  String get display => 'แสดง';

  @override
  String get normal => 'ค่าเริ่มต้น ข้อความ';

  @override
  String get simple => 'ธรรมดา';

  @override
  String get textOnly => 'เท่านั้น';

  @override
  String get search => 'ค้นหา';

  @override
  String get friendRequest => 'คำขอเป็นเพื่อน';

  @override
  String get friendManagement => 'การจัดการเพื่อน';

  @override
  String get favoriteWorlds => 'ผู้ใช้';

  @override
  String get user => 'โลกที่ชื่นชอบ';

  @override
  String lastLogin(Object data) {
    return 'เข้าสู่ระบบครั้งล่าสุด: $data';
  }

  @override
  String dateJoined(Object data) {
    return 'วันที่ลงทะเบียน: $data';
  }

  @override
  String get openInJsonViewer => 'ดูในโปรแกรมดู JSON';

  @override
  String get joinInstance => 'เชิญตัวเอง';

  @override
  String get addFavoriteWorlds => 'เพิ่มโลกที่ชื่นชอบ';

  @override
  String get removeFavoriteWorlds => 'ลบออกจากโลกโปรด';

  @override
  String get editBio => 'แก้ไขประวัติ แก้ไข';

  @override
  String get editNote => 'บันทึก';

  @override
  String get sendInvite => 'ส่งคำเชิญ';

  @override
  String get selfInviteDetails =>
      'แล้ว โปรดตรวจสอบคอลัมน์คำเชิญของ VRChat Unfriend';

  @override
  String get unfriend => 'คุณ ต้องการเลิกเป็นเพื่อน';

  @override
  String get unfriendConfirm => 'หรือไม่?';

  @override
  String get requestCancel => 'ลบคำขอ ยอมรับ';

  @override
  String get allowFriends => 'เพื่อน';

  @override
  String get denyFriends => 'ปฏิเสธเพื่อน';

  @override
  String get jsonViewer => 'JSON Viewer';

  @override
  String get world => 'World โลก';

  @override
  String get privateWorld => 'ส่วนตัว ขณะ';

  @override
  String get loadingWorld => 'กำลังโหลดโลก';

  @override
  String get onTheWebsite => 'จำนวนผู้เล่น';

  @override
  String occupants(Object data) {
    return 'ออนไลน์บนเว็บไซต์ : $data';
  }

  @override
  String privateOccupants(Object data) {
    return 'จำนวนผู้เล่นในส่วนตัว: $data';
  }

  @override
  String favorites(Object data) {
    return 'รายการโปรด: $data';
  }

  @override
  String createdAt(Object data) {
    return 'สร้างแล้ว: $data';
  }

  @override
  String updatedAt(Object data) {
    return 'อัปเดตล่าสุด: $data';
  }

  @override
  String get launchWorld => 'สร้างอินสแตนซ์';

  @override
  String get openInVrchat => 'ที่เปิดใน VRChat';

  @override
  String get accountSwitch => 'บัญชี สลับ';

  @override
  String get accountSwitchSetting => 'การตั้งค่า บัญชี';

  @override
  String get accountSwitchSettingDetails => 'จัดการ';

  @override
  String get addAccount => 'บัญชีอื่น เพิ่มบัญชี';

  @override
  String get accessibility => 'การเข้าถึง';

  @override
  String get language => 'ภาษา สลับ';

  @override
  String translatorDetails(Object name) {
    return 'แปลโดย $name';
  }

  @override
  String get deviceLightTheme => 'หากเครื่องเป็นธีมสีอ่อน';

  @override
  String get deviceDarkTheme => 'ถ้าเครื่องเป็นธีมมืด';

  @override
  String get lightTheme => 'ธีมสว่าง';

  @override
  String get darkTheme => 'ธีมสีเข้ม';

  @override
  String get blackTheme => 'ธีมสีดำ';

  @override
  String get trueBlackTheme => 'ธีมสีดำที่แท้จริง';

  @override
  String get highContrastLightTheme => 'ธีมแสงคอนทราสต์สูง';

  @override
  String get highContrastDarkTheme => 'ธีมสีเข้มที่มีคอนทราสต์สูง';

  @override
  String get forceExternalBrowser => 'เหนือกว่า บังคับเบราว์เซอร์ภายนอก';

  @override
  String get forceExternalBrowserDetails =>
      'บังคับให้เบราว์เซอร์ภายนอกเปิดขึ้นเมื่อเปิดเบราว์เซอร์ ออกจากระบบ';

  @override
  String get debugMode => 'โหมดดีบัก';

  @override
  String get account => 'บัญชี';

  @override
  String get logout => 'ออกจาก';

  @override
  String get logoutDetails => 'ระบบและลบข้อมูลเซสชันออกจากอุปกรณ์ ออกจากระบบ';

  @override
  String get logoutConfirm => 'คุณต้องการที่จะออกจากระบบ?';

  @override
  String get deleteLoginInfo => 'ลบข้อมูลล็อกอิน ลบข้อมูล';

  @override
  String get deleteLoginInfoDetails => 'ล็อกอินที่บันทึกไว้ ลบ';

  @override
  String get deleteLoginInfoConfirm => 'คุณต้องการที่จะลบมัน?';

  @override
  String get token => 'โทเค็น';

  @override
  String get tokenDetails =>
      'คุณสามารถตรวจสอบหรือเปลี่ยนแปลงข้อมูลประจำตัวของคุณ';

  @override
  String get cookie => 'สิทธิ์ การใช้';

  @override
  String get permissions => 'คุกกี้ เชื่อมโยง';

  @override
  String get domainVerification => 'โดเมน';

  @override
  String get domainVerificationDetails =>
      'ของคุณกับแอปของคุณ เชื่อมโยงแอปของคุณกับ vrchat.com';

  @override
  String get notSupported => 'ไม่';

  @override
  String get notSupportedDetails =>
      'รองรับ การอนุญาตนี้ไม่ได้รับการสนับสนุนบนอุปกรณ์นี้';

  @override
  String get help => 'ช่วยเหลือ';

  @override
  String get contribution => 'สนับสนุน การพัฒนาบน';

  @override
  String get contributionDetails => 'จุดบกพร่องของรายงานการพัฒนา';

  @override
  String get reportDetails => 'Github และขอคุณสมบัติใหม่ให้กับ';

  @override
  String get developerInfo => 'นักพัฒนา ข้อมูลนักพัฒนา';

  @override
  String get developerInfoDetails => 'ดูข้อมูลนักพัฒนา';

  @override
  String get rateTheApp => 'ให้คะแนน';

  @override
  String get rateTheAppDetails => 'โปรดให้คะแนนเราบน GooglePlayStore';

  @override
  String get version => 'เวอร์ชัน เวอร์ชัน';

  @override
  String versionDetails(Object version) {
    return 'ปัจจุบัน: $version ตรวจสอบใบ';
  }

  @override
  String get license => 'อนุญาต';

  @override
  String get licenseDetails => 'ตรวจสอบข้อมูลใบอนุญาต';

  @override
  String get report => 'รายงาน';

  @override
  String get log => 'บันทึก';

  @override
  String get viewDetailedLogs => 'ดูบันทึกโดยละเอียด';

  @override
  String get userPolicy => 'นโยบายผู้ใช้';

  @override
  String get agree => 'เห็นด้วย';

  @override
  String get disagree => 'ไม่เห็นด้วย';

  @override
  String get lookAtYourBrowser => 'กรุณาตรวจสอบเบราว์เซอร์ของคุณ';
}
