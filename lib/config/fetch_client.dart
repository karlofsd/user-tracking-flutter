import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class FetchClient {
  FetchClient() : _client = Client();

  static String host = dotenv.get('HOST');
  final Client _client;

  Uri _getUrl(String path, [Map<String, dynamic>? extraParameters]) {
    final queryParameters = <String, Object?>{};
    if (extraParameters != null) {
      extraParameters.forEach((key, value) {
        queryParameters[key] = value?.toString();
      });
    }

    final uri = Uri.parse('$host/$path');

    if (queryParameters.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: queryParameters,
    );
  }

  Future get(String path,
      {Map<String, dynamic> queryParameters = const {}}) async {
    final response = await _client.get(_getUrl(path, queryParameters));
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = json.decode(response.body)['data'];
        return data;
      } else {
        throw Exception("Data not found");
      }
    } else {
      throw Exception("Request error");
    }
  }

  Future<Map<String, dynamic>?> post(
    url, {
    Map<String, String>? parameters,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(_getUrl(url, parameters),
        headers: {"Content-Type": "application/json"}, body: json.encode(body));
    return json.decode(response.body)['data'];
  }

  Future<Map<String, dynamic>> patch(
    url, {
    Map<String, String>? parameters,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.patch(_getUrl(url, parameters),
        headers: {"Content-Type": "application/json"}, body: json.encode(body));

    return json.decode(response.body)['data'];
  }

  Future<Map<String, dynamic>> put(
    url, {
    Map<String, String>? parameters,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.put(_getUrl(url, parameters),
        headers: {"Content-Type": "application/json"}, body: json.encode(body));

    return json.decode(response.body)['data'];
  }
}
