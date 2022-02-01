import 'package:flutter/material.dart';
import '../session.dart';

class VRChatMobileAPIHome {
  final vrchatSession = Session();

  VRChatMobileAPIHome(BuildContext _context, String _cookie) {
    vrchatSession.headers["cookie"] = _cookie;
  }

  Future<Map> user() {
    return vrchatSession.get(Uri.parse("https://vrchat.com/api/1/auth/user?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"));
  }
}
