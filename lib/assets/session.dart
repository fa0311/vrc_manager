import 'package:http/http.dart' as http;
import 'dart:convert';

class Session {
  Map<String, String> headers = {'cookie': ''};

  Future<Map> get(Uri url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return json.decode(response.body);
  }

  Future<Map> basic(Uri url, String username, String password) async {
    final headersAuth = Map<String, String>.from(headers)..addAll({'authorization': 'Basic ' + base64Encode(utf8.encode('$username:$password'))});

    http.Response response = await http.get(url, headers: headersAuth);
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
      final String newCookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      headers['cookie'] = (headers['cookie'] == "") ? newCookie : (headers['cookie']! + "; " + newCookie);
    }
  }
}




// https://nobushiueshi.com/flutter%E5%B0%8F%E3%81%95%E3%81%84%E3%83%87%E3%83%BC%E3%82%BF%E3%82%92%E4%BF%9D%E5%AD%98%E3%81%99%E3%82%8B%E3%81%AE%E3%81%AB%E4%BE%BF%E5%88%A9%E3%81%AA%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3/
