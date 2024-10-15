import 'dart:io';

import 'package:dio/dio.dart';

import '../model/cats.dart';
import '../network/model_response.dart';
import 'api_exception.dart';
import 'network.dart';

const String _breedsEndpoint = '/breeds';
const String _imagesEndpoint = '/images/search';

typedef CatResponse = Result<List<Breed>>;
typedef CatDetailsResponse = Result<CatBreed>;

/// This class is responsible for making requests to the Cat API.
class CatAPI {
  final Network network;

  CatAPI({
    required this.network,
  });

  /// Fetches a list of cat breeds from the API.
  Future<CatResponse> getCatBreeds({int page = 0, int limit = 10}) async {
    try {
      final breeds = await makeRequest<List<Breed>>(
        _breedsEndpoint,
        (json) => BreedList.fromJson(json).breeds,
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      return Result<List<Breed>>.success(breeds);
    } catch (error) {
      return Result<List<Breed>>.failure(error.toString());
    }
  }

  /// Fetches a specific cat breed by ID.
  Future<CatDetailsResponse> getCatBreed(String breedId) async {
    try {
      final breeds = await makeRequest<List<CatBreed>>(
        _imagesEndpoint,
        (json) => CatList.fromJson(json).breeds,
        queryParameters: {
          'breed_id': breedId
        }, // passing query parameters for breed_id
      );
      if (breeds.isEmpty) {
        throw Exception('No breed found with the given ID');
      }
      return Result<CatBreed>.success(breeds.first);
    } catch (error) {
      return Result<CatBreed>.failure(error.toString());
    }
  }

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
        throw ApiException(
          message: 'Request failed',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw ApiException(
              message: 'Connection timeout',
              statusCode: e.response?.statusCode);
        case DioExceptionType.badResponse:
          throw ApiException(
            message: 'Bad response',
            statusCode: e.response?.statusCode,
            data: e.response?.data,
          );
        case DioExceptionType.cancel:
          throw ApiException(
              message: 'Request cancelled', statusCode: e.response?.statusCode);
        case DioExceptionType.unknown:
          // Internet connectivity check: Specifically catches
          // SocketException for no internet scenarios.
          if (e.error is SocketException) {
            throw ApiException(
                message: 'No internet connection',
                statusCode: e.response?.statusCode);
          }
          throw ApiException(
              message: 'Unexpected error occurred',
              statusCode: e.response?.statusCode);
        default:
          throw ApiException(
              message: 'Error occurred: ${e.message}',
              statusCode: e.response?.statusCode);
      }
    } catch (e) {
      throw ApiException(message: 'Unexpected error: $e');
    }
  }
}
