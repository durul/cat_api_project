import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'custom_interceptor.dart';

const String _apiKey =
    'live_vs9El4qaLPFml0kQ3aTvGGVsVjbg8Bb32bBLGLTkp5pQOwUEDeE0dW41CgJKUNl8';

/// This class is responsible for making network requests,
/// now with Dio.
class Network {
  final Dio _dio;

  Interceptor customInterceptor = CustomInterceptor();

  Network()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.thecatapi.com/v1',
          headers: {
            'x-api-key': _apiKey,
          },
        )) {
    // Adding the PrettyDioLogger for clearer logging of requests and responses
    _dio.interceptors.add(customInterceptor);
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      compact: false,
      maxWidth: 90,
    ));
  }

  /// Using dio to make GET requests now.
  Future<T> makeRequest<T>(
    String endpoint,
    T Function(dynamic json) parseJson, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final json = response.data; // Directly using Dio's response data
        return parseJson(json);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error occurred: ${e.message}');
    }
  }
}
