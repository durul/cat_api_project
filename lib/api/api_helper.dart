import 'dart:io';

import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'network.dart';

class ApiHelper {
  final Dio dio;
  final Network network;

  ApiHelper({required this.dio, required this.network});

  /// Using dio to make GET requests now.
  Future<T> makeRequest<T>(
    String endpoint,
    T Function(dynamic json) parseJson, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await network.dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final json = response.data;
        return parseJson(json);
      } else {
        throw _handleError(response);
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  ApiException _handleError(Response? response) {
    return ApiException(
      message: 'Request failed',
      statusCode: response?.statusCode,
      data: response?.data,
    );
  }

  ApiException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
            message: 'Connection timeout', statusCode: e.response?.statusCode);
      case DioExceptionType.badResponse:
        return ApiException(
          message: 'Bad response',
          statusCode: e.response?.statusCode,
          data: e.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiException(
            message: 'Request cancelled', statusCode: e.response?.statusCode);
      case DioExceptionType.unknown:
        // Internet connectivity check: Specifically catches
        // SocketException for no internet scenarios.
        if (e.error is SocketException) {
          return ApiException(
              message: 'No internet connection',
              statusCode: e.response?.statusCode);
        }
        return ApiException(
            message: 'Unexpected error occurred',
            statusCode: e.response?.statusCode);
      default:
        return ApiException(
            message: 'Error occurred: ${e.message}',
            statusCode: e.response?.statusCode);
    }
  }
}
