// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:http/http.dart' as http;

class Session {
  Map<String, String> headers = <String, String>{'cookie': ''};

  Future<dynamic> get(Uri url) async {
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    final dynamic body = json.decode(response.body);
    return body;
  }

  Future<Map> basic(Uri url, String username, String password) async {
    final headersAuth = Map<String, String>.from(headers)
      ..addAll(
        {
          'authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
        },
      );
    http.Response response = await http.get(url, headers: headersAuth);
    updateCookie(response);
    final body = json.decode(response.body);
    if (body is List) return {for (int i = 0; i < body.length; i++) i: body[i]};
    return body;
  }

  Future<Map> post(Uri url, [Object? data]) async {
    http.Response response = await http.post(url, body: data ?? {}, headers: headers);
    updateCookie(response);
    final body = json.decode(response.body);
    if (body is List) return {for (int i = 0; i < body.length; i++) i: body[i]};
    return body;
  }

  Future<Map> put(Uri url, [Object? data]) async {
    http.Response response = await http.put(url, body: data ?? {}, headers: headers);
    updateCookie(response);
    final body = json.decode(response.body);
    if (body is List) return {for (int i = 0; i < body.length; i++) i: body[i]};
    return body;
  }

  Future<Map> delete(Uri url, [Object? data]) async {
    http.Response response = await http.delete(url, body: data ?? {}, headers: headers);
    updateCookie(response);
    final body = json.decode(response.body);
    return body;
  }

  updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      Map<String, String> cookieMap = decodeCookie(headers['cookie'] ?? "");
      cookieMap.addAll(decodeCookie(rawCookie));
      headers['cookie'] = encodeCookie(cookieMap);
    }
  }

  String encodeCookie(Map<String, String> cookieMap) {
    String rawCookie = "";
    for (String key in cookieMap.keys) {
      rawCookie += "$key=${cookieMap[key]}; ";
    }
    return rawCookie;
  }

  Map<String, String> decodeCookie(String rawCookie) {
    Map<String, String> cookieMap = {};
    for (String row in rawCookie.split(';')) {
      List<String> data = row.trim().replaceFirst('HttpOnly,', '').split('=');
      if (!row.contains('=')) continue;
      if (["Max-Age", "Path", "Expires"].contains(data[0])) continue;
      cookieMap[data[0]] = data[1];
    }
    return cookieMap;
  }

  String getCookie() {
    return headers['cookie'] ?? "";
  }
}
