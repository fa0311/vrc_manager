import 'package:http/http.dart' as http;
import 'dart:convert';

class Session {
  Map<String, String> headers = {};

  Future<Map> get(url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> basic(Uri url, String username, String password) async {
    headers["authorization"] = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> post(Uri url, dynamic data) async {
    http.Response response = await http.post(url, body: data, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] = (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
