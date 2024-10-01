import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'custom_interceptor.dart';
import 'endpoint.dart';

/// This class is responsible for making network requests,
/// now with Dio.
class Network {
  static final Network _dioService = Network._internal();

  late Dio _dio;

  Network._internal();

  factory Network() {
    return _dioService;
  }

  static final receiveTimeout = const Duration(seconds: 5);
  static final connectTimeout = const Duration(seconds: 5);
  static final sendTimeout = const Duration(seconds: 5);

  Dio provideDio() {
    final baseOptions = BaseOptions(
      baseUrl: Endpoint.baseUrl,
      receiveTimeout: receiveTimeout,
      connectTimeout: connectTimeout,
      sendTimeout: sendTimeout,
      headers: {
        Endpoint.headerKey: Endpoint.apiKey,
      },
    );

    _dio = Dio(baseOptions);

    return _dio;
  }

  Future<void> init() async {
    await dotenv.load();
    final isDevMode =
        dotenv.get('DEVELOPMENTMODE', fallback: '').toLowerCase() == 'true';

    if (isDevMode) {
      final prettyDioLogger = PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      );

      print('Development mode enabled.');

      _dio.interceptors.add(prettyDioLogger);

      _dio.interceptors.add(CustomInterceptor()); // Direct instantiation

      _dio.interceptors.add(CurlLoggerDioInterceptor());
    }
  }
}
