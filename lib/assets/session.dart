import 'package:http/http.dart' as http;
import 'dart:convert';

class Session {
  Map<String, String> headers = {'cookie': ''};

  Future<Map> get(Uri url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    final body = json.decode(response.body);
    if (body is List) return {for (int i = 0; i < body.length; i++) i: body[i]};
    return body;
  }

  Future<Map> basic(Uri url, String username, String password) async {
    final headersAuth = Map<String, String>.from(headers)..addAll({'authorization': 'Basic ' + base64Encode(utf8.encode('$username:$password'))});
    http.Response response = await http.get(url, headers: headersAuth);
    updateCookie(response);
    final body = json.decode(response.body);
    if (body is List) return {for (int i = 0; i < body.length; i++) i: body[i]};
    return body;
  }

  Future<Map> post(Uri url, [Map<String, dynamic>? data]) async {
    http.Response response = await http.post(url, body: data ?? {}, headers: headers);
    updateCookie(response);
    final body = json.decode(response.body);
    if (body is List) return {for (int i = 0; i < body.length; i++) i: body[i]};
    return body;
  }

  Future<Map> put(Uri url, [Map<String, dynamic>? data]) async {
    http.Response response = await http.put(url, body: data ?? {}, headers: headers);
    updateCookie(response);
    final body = json.decode(response.body);
    if (body is List) return {for (int i = 0; i < body.length; i++) i: body[i]};
    return body;
  }

  Future<Map> delete(Uri url, [Map<String, dynamic>? data]) async {
    http.Response response = await http.delete(url, body: data ?? {}, headers: headers);
    updateCookie(response);
    final body = json.decode(response.body);
    if (body is List) return {for (int i = 0; i < body.length; i++) i: body[i]};
    return body;
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      final String newCookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      headers['cookie'] = (headers['cookie'] == "") ? newCookie : (headers['cookie']! + "; " + newCookie);
    }
  }

  String getCookie() {
    return headers['cookie'] ?? "";
  }
}
