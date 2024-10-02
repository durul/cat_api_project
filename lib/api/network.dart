import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'custom_interceptor.dart';
import 'endpoint.dart';

/// This class is responsible for making network requests,
/// now with Dio.
class Network {
  static final Network _instance = Network._internal();

  late Dio _dio;

  Network._internal() {
    _dio = _createDio();
  }

  factory Network() {
    return _instance;
  }

  static const receiveTimeout = Duration(seconds: 5);
  static const connectTimeout = Duration(seconds: 5);
  static const sendTimeout = Duration(seconds: 5);

  Dio _createDio() {
    final baseOptions = BaseOptions(
      baseUrl: Endpoint.baseUrl,
      receiveTimeout: receiveTimeout,
      connectTimeout: connectTimeout,
      sendTimeout: sendTimeout,
    );

    return Dio(baseOptions);
  }

  Dio get dio => _dio;

  Future<void> init() async {
    await dotenv.load();
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey != null) {
      _dio.options.headers[Endpoint.headerKey] = apiKey;
    }

    final isDevMode = dotenv.get('DEVELOPMENTMODE', fallback: '').toLowerCase() == 'true';

    if (isDevMode) {
      print('Development mode enabled.');
      _addDevelopmentInterceptors();
    }
  }

  void _addDevelopmentInterceptors() {
    final prettyDioLogger = PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );

    _dio.interceptors.addAll([
      prettyDioLogger,
      CustomInterceptor(),
      CurlLoggerDioInterceptor(),
    ]);
  }
}