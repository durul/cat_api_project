import 'dart:convert';

import 'package:http/http.dart';

const String _apiKey =
    'live_vs9El4qaLPFml0kQ3aTvGGVsVjbg8Bb32bBLGLTkp5pQOwUEDeE0dW41CgJKUNl8';

class Network {

  /// This reduces code duplication and centralizes error handling.
  Future<T> makeRequest<T>(
    Uri uri,
    T Function(dynamic json) parseJson,
  ) async {
    try {
      final response = await get(
        uri,
        headers: {'x-api-key': _apiKey},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return parseJson(json);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}
