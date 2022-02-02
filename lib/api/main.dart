import '../session.dart';

class VRChatAPI {
  final vrchatSession = Session();

  VRChatAPI({String cookie = ""}) {
    vrchatSession.headers["cookie"] = cookie;
  }

  Future<Map> login(username, password) {
    vrchatSession.get(Uri.parse("https://vrchat.com/api/1/config"));
    return vrchatSession.basic(Uri.parse("https://vrchat.com/api/1/auth/user?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"), username, password);
  }

  Future<Map> loginTotp(code) {
    return vrchatSession.post(Uri.parse("https://vrchat.com/api/1/auth/twofactorauth/totp/verify"), {"code": code});
  }

  Future<Map> user() {
    return vrchatSession.get(Uri.parse("https://vrchat.com/api/1/auth/user?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"));
  }
}
