import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

abstract class RequestHelpers {
  Future<http.Response> get({required String url, String? token});
  Future<http.Response> post({required String url, required Map<String, dynamic> body});
  Future<http.Response> del({required String url, Map<String, dynamic>? body, String? token});
  Future<http.Response> put({required String url, Map<String, dynamic>? body, String? token});
}

class RequestHelpersImpl extends RequestHelpers {
  final http.Client httpClient;
  RequestHelpersImpl(this.httpClient);

  @override
  Future<http.Response> get({required String url, String? token}) async {
    if (token != null) {
      return await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
    } else {
      return await http.get(Uri.parse(url), headers: {
        HttpHeaders.acceptHeader: 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      });
    }
  }

  @override
  Future<http.Response> post({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    return await http.post(Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(body));
  }

  @override
  Future<http.Response> del({required String url, Map<String, dynamic>? body, String? token}) async {
    if (token != null) {
      return await http.delete(Uri.parse(url),
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Bearer $token"
          },
          body: json.encode(body));
    } else {
      return await http.post(Uri.parse(url),
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(body));
    }
  }

  @override
  Future<http.Response> put({required String url, Map<String, dynamic>? body, String? token}) async {
    if (token != null) {
      return await http.put(Uri.parse(url),
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Bearer $token"
          },
          body: json.encode(body));
    } else {
      return await http.post(Uri.parse(url),
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(body));
    }
  }
}
